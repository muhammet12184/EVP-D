"""
UDS command toolkit:

1. send_uds_command: Configure an ELM327-compatible adapter, set the proper header,
   and send a raw UDS request.
2. PidRepository / PidRouter: Load PID metadata from CSV and select the right set
   based on a vehicle/ECU hint.
3. FormulaEvaluator: Convert raw hex responses into engineering values by applying
   the stored formulas.

The module is self-contained and can be imported into larger applications.
"""

from __future__ import annotations

import ast
import csv
import re
import textwrap
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Sequence, Tuple

try:
    import serial  # type: ignore
except ImportError:  # pragma: no cover - serial not available in all environments
    serial = None  # type: ignore


# ---------------------------------------------------------------------------
# Transport & ELM327 façade
# ---------------------------------------------------------------------------

class SerialTransport:
    """Thin wrapper around pyserial so we can mock it in tests."""

    def __init__(self, port: str, baudrate: int = 500000, timeout: float = 1.0):
        if serial is None:
            raise RuntimeError("pyserial is required for SerialTransport but is not installed.")
        self._serial = serial.Serial(port=port, baudrate=baudrate, timeout=timeout)

    def write(self, payload: str) -> None:
        self._serial.write((payload + "\r").encode("ascii"))

    def read(self) -> str:
        """Read until prompt (>)."""
        return self._serial.read_until(b">").decode("ascii", errors="ignore")

    def close(self) -> None:
        self._serial.close()


class Elm327Client:
    """Handles ELM327 initialisation and AT command exchange."""

    INIT_SEQUENCE = (
        "ATZ",   # reset
        "ATE0",  # echo off
        "ATL0",  # linefeeds off
        "ATS0",  # spaces off
        "ATH1",  # headers on
        "ATSP6", # ISO 15765-4 (CAN 11/500)
    )

    def __init__(self, transport: SerialTransport):
        self._tx = transport
        self._initialised = False

    def initialise(self) -> None:
        if self._initialised:
            return
        for cmd in self.INIT_SEQUENCE:
            self.send_at(cmd)
        self._initialised = True

    def send_at(self, command: str) -> str:
        self._tx.write(command)
        return self._tx.read()

    def send_payload(self, payload: str) -> str:
        self._tx.write(payload)
        return self._tx.read()


def _normalise_hex(payload: str) -> str:
    clean = payload.replace(" ", "").upper()
    if len(clean) % 2 != 0:
        raise ValueError(f"Payload must contain full bytes, got: {payload}")
    return " ".join(textwrap.wrap(clean, 2))


def send_uds_command(
    port: str,
    header: str,
    service_data: str,
    *,
    baudrate: int = 500000,
    timeout: float = 1.0,
    initialise: bool = True,
) -> str:
    """
    Configure the ELM327 header (AT SH xxxx) and send a raw UDS command.

    Args:
        port: Serial device path (/dev/ttyUSB0, COM3, etc.)
        header: CAN ID header (e.g. "7E4" for HV battery ECU).
        service_data: Hex bytes for the UDS request (e.g. "22 015C").
        baudrate: Serial speed (defaults to 500k for ISO-TP).
        timeout: Serial timeout in seconds.
        initialise: Whether to run the AT init sequence.

    Returns:
        Raw ASCII response from the adapter (headers included).
    """
    transport = SerialTransport(port=port, baudrate=baudrate, timeout=timeout)
    client = Elm327Client(transport)
    try:
        if initialise:
            client.initialise()
        client.send_at(f"AT SH {header.upper()}")
        normalised = _normalise_hex(service_data)
        return client.send_payload(normalised)
    finally:
        transport.close()


# ---------------------------------------------------------------------------
# PID repository & router
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class PidDefinition:
    category: str
    parameter: str
    mode: str
    pid: str
    ecu: str
    description: str
    formula: str
    byte_positions: str
    min_value: str
    max_value: str
    units: str

    @property
    def key(self) -> Tuple[str, str]:
        return self.category.lower(), self.parameter.lower()


class PidRepository:
    """Loads PID rows from a CSV (same format as ev_bms_pids_enriched.csv)."""

    def __init__(self, csv_path: Path):
        self._csv_path = csv_path
        self._definitions: List[PidDefinition] = []
        self._by_category: Dict[str, List[PidDefinition]] = {}
        self._load()

    def _load(self) -> None:
        with self._csv_path.open(newline="") as f:
            reader = csv.DictReader(f)
            for row in reader:
                definition = PidDefinition(
                    category=row["Category"],
                    parameter=row["Parameter"],
                    mode=row["Mode"],
                    pid=row["PID"],
                    ecu=row["ECU"],
                    description=row["Description"],
                    formula=row["Formula"],
                    byte_positions=row["Byte_Positions"],
                    min_value=row["Min"],
                    max_value=row["Max"],
                    units=row["Units"],
                )
                self._definitions.append(definition)
                key = row["Category"].lower()
                self._by_category.setdefault(key, []).append(definition)

    def definitions(self) -> Sequence[PidDefinition]:
        return list(self._definitions)

    def by_category(self, category_hint: str) -> Sequence[PidDefinition]:
        """Case-insensitive category lookup."""
        key = category_hint.lower()
        if key in self._by_category:
            return list(self._by_category[key])
        # fallback: substring search
        matches = [
            definition
            for cat, defs in self._by_category.items()
            if key in cat
            for definition in defs
        ]
        return matches


class PidRouter:
    """
    Chooses the most appropriate PID definitions for a vehicle context.

    Example:
        router = PidRouter(repo)
        pids = router.route(make="Hyundai", model="Kona", ecu="BMS")
    """

    def __init__(self, repository: PidRepository):
        self._repo = repository

    def route(
        self,
        *,
        make: str,
        model: Optional[str] = None,
        ecu: Optional[str] = None,
    ) -> Sequence[PidDefinition]:
        category_hint = make
        if model:
            category_hint = f"{make} {model}"
        matches = self._repo.by_category(category_hint)
        if matches:
            return matches
        # fallback by ECU text hint
        if ecu:
            return [
                definition
                for definition in self._repo.definitions()
                if ecu.lower() in definition.ecu.lower()
            ]
        return self._repo.definitions()


# ---------------------------------------------------------------------------
# Formula evaluator / response parser
# ---------------------------------------------------------------------------

class FormulaEvaluator:
    """
    Safely evaluates expressions like "(A*256+B)/100".

    Usage:
        evaluator = FormulaEvaluator()
        value = evaluator.evaluate("(A*256+B)/100", [0x10, 0x5B])
    """

    _allowed_nodes = {
        ast.Expression,
        ast.BinOp,
        ast.UnaryOp,
        ast.Num,
        ast.Load,
        ast.Name,
        ast.Add,
        ast.Sub,
        ast.Mult,
        ast.Div,
        ast.Mod,
        ast.Pow,
        ast.USub,
        ast.UAdd,
        ast.Call,
    }

    _allowed_funcs = {"min": min, "max": max, "abs": abs}

    def evaluate(self, formula: str, data_bytes: Sequence[int]) -> float:
        if not formula or formula.upper() == "N/A":
            raise ValueError("No formula provided.")

        env = {
            chr(ord("A") + idx): byte
            for idx, byte in enumerate(data_bytes)
        }
        tree = ast.parse(formula, mode="eval")
        self._validate_ast(tree)
        return float(self._eval_node(tree.body, env))

    def _validate_ast(self, node: ast.AST) -> None:
        if type(node) not in self._allowed_nodes:
            raise ValueError(f"Disallowed expression node: {type(node).__name__}")
        for child in ast.iter_child_nodes(node):
            self._validate_ast(child)

    def _eval_node(self, node: ast.AST, env: Dict[str, int]):
        match node:
            case ast.Num(n):
                return n
            case ast.BinOp(left=left, op=op, right=right):
                left_val = self._eval_node(left, env)
                right_val = self._eval_node(right, env)
                return self._apply_operator(op, left_val, right_val)
            case ast.UnaryOp(op=op, operand=operand):
                val = self._eval_node(operand, env)
                if isinstance(op, ast.USub):
                    return -val
                if isinstance(op, ast.UAdd):
                    return +val
                raise ValueError("Unsupported unary operator.")
            case ast.Name(id=name):
                if name not in env:
                    raise KeyError(f"Byte {name} missing from payload.")
                return env[name]
            case ast.Call(func=func, args=args, keywords=keywords):
                if keywords:
                    raise ValueError("Keyword arguments are not allowed in formulas.")
                func_obj = self._allowed_funcs.get(func.id)  # type: ignore
                if func_obj is None:
                    raise ValueError(f"Function {getattr(func, 'id', '?')} not allowed.")
                values = [self._eval_node(arg, env) for arg in args]
                return func_obj(*values)
            case _:
                raise ValueError(f"Unsupported AST node: {type(node).__name__}")

    @staticmethod
    def _apply_operator(op: ast.operator, left: float, right: float) -> float:
        if isinstance(op, ast.Add):
            return left + right
        if isinstance(op, ast.Sub):
            return left - right
        if isinstance(op, ast.Mult):
            return left * right
        if isinstance(op, ast.Div):
            return left / right
        if isinstance(op, ast.Mod):
            return left % right
        if isinstance(op, ast.Pow):
            return left ** right
        raise ValueError(f"Unsupported operator {type(op).__name__}")


def decode_iso_tp_payload(raw_response: str) -> List[int]:
    """
    Extracts payload bytes from an ISO-TP response like:
        "62 01 5C 8C"
    Strips whitespace and headers.
    """
    tokens = re.findall(r"[0-9A-Fa-f]{2}", raw_response)
    return [int(token, 16) for token in tokens]


def apply_pid_formula(definition: PidDefinition, response_bytes: Sequence[int]) -> float:
    """
    Removes the UDS positive response prefix (mode + 0x40 + PID echo),
    then applies the stored formula.
    """
    if len(response_bytes) < 3:
        raise ValueError("UDS response too short.")
    # For Mode 0x22, response is 0x62 + hi + lo + data...
    data_payload = response_bytes[3:]
    evaluator = FormulaEvaluator()
    return evaluator.evaluate(definition.formula, data_payload)


# ---------------------------------------------------------------------------
# Example usage (manual test)
# ---------------------------------------------------------------------------

def example_usage():
    """Demonstrates routing + evaluation with the bundled CSV."""
    repo = PidRepository(Path("ev_bms_pids_enriched.csv"))
    router = PidRouter(repo)
    pids = router.route(make="Hyundai", model="Kona")
    battery_soc = next(pid for pid in pids if pid.parameter == "Battery SOC")

    # Fake raw response for demonstration (22 015C -> 62 01 5C <SOC>)
    fake_response = "62 01 5C 50"
    response_bytes = decode_iso_tp_payload(fake_response)
    value = apply_pid_formula(battery_soc, response_bytes)
    print(f"{battery_soc.parameter}: {value:.1f}{battery_soc.units}")


if __name__ == "__main__":
    example_usage()

