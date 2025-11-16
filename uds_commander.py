"""
UDS Komut Gönderme Modülü
ELM327 adaptörü ile UDS protokolü üzerinden ECU iletişimi
"""

import serial
import time
import re
from typing import Optional, List, Tuple


class UDSCommander:
    """ELM327 adaptörü üzerinden UDS komutları gönderen sınıf"""
    
    def __init__(self, port: str = None, baudrate: int = 38400, timeout: float = 1.0):
        """
        Args:
            port: Seri port adı (örn: 'COM3', '/dev/ttyUSB0')
            baudrate: Seri port baudrate (38400 ELM327 için standart)
            timeout: Okuma timeout süresi (saniye)
        """
        self.port = port
        self.baudrate = baudrate
        self.timeout = timeout
        self.serial_conn: Optional[serial.Serial] = None
        self.is_connected = False
        
    def connect(self) -> bool:
        """ELM327 adaptörüne bağlan"""
        try:
            if self.port is None:
                # Otomatik port bulma
                self.port = self._find_elm327_port()
                if self.port is None:
                    raise Exception("ELM327 adaptörü bulunamadı")
            
            self.serial_conn = serial.Serial(
                port=self.port,
                baudrate=self.baudrate,
                timeout=self.timeout,
                bytesize=serial.EIGHTBITS,
                parity=serial.PARITY_NONE,
                stopbits=serial.STOPBITS_ONE
            )
            
            # ELM327'yi başlat
            time.sleep(0.1)
            self._send_at_command("Z")  # Reset
            time.sleep(1)
            self._send_at_command("E0")  # Echo kapalı
            self._send_at_command("L0")  # Linefeeds kapalı
            self._send_at_command("SP0")  # Otomatik protokol seçimi
            
            self.is_connected = True
            return True
            
        except Exception as e:
            print(f"Bağlantı hatası: {e}")
            self.is_connected = False
            return False
    
    def disconnect(self):
        """Bağlantıyı kapat"""
        if self.serial_conn and self.serial_conn.is_open:
            self.serial_conn.close()
        self.is_connected = False
    
    def _find_elm327_port(self) -> Optional[str]:
        """Sistemde ELM327 adaptörünü bul"""
        import serial.tools.list_ports
        
        for port in serial.tools.list_ports.comports():
            # ELM327 genellikle FTDI veya CH340 chipset kullanır
            if 'USB' in port.description.upper() or 'Serial' in port.description.upper():
                return port.device
        return None
    
    def _send_at_command(self, command: str) -> str:
        """AT komutu gönder ve cevap al"""
        if not self.serial_conn or not self.serial_conn.is_open:
            raise Exception("Bağlantı yok")
        
        # Komutu gönder
        cmd = f"AT{command}\r\n"
        self.serial_conn.write(cmd.encode())
        time.sleep(0.05)
        
        # Cevabı oku
        response = b""
        start_time = time.time()
        while time.time() - start_time < self.timeout:
            if self.serial_conn.in_waiting > 0:
                response += self.serial_conn.read(self.serial_conn.in_waiting)
                if b">" in response:  # ELM327 prompt karakteri
                    break
            time.sleep(0.01)
        
        return response.decode('utf-8', errors='ignore').strip()
    
    def set_header(self, header: str) -> bool:
        """
        ECU header'ını ayarla (örn: 7E4, 7E0, 7E1)
        
        Args:
            header: Hex formatında header (örn: "7E4")
        
        Returns:
            Başarılı olursa True
        """
        try:
            # ELM327'de header ayarlama
            response = self._send_at_command(f"SH {header}")
            return "OK" in response.upper() or ">" in response
        except Exception as e:
            print(f"Header ayarlama hatası: {e}")
            return False
    
    def send_uds_command(self, service: str, pid: str = None, data: List[int] = None) -> Optional[List[int]]:
        """
        UDS komutu gönder ve cevabı al
        
        Args:
            service: UDS servis kodu (örn: "22" = ReadDataByIdentifier)
            pid: PID kodu hex formatında (örn: "015B")
            data: Ek veri baytları (opsiyonel)
        
        Returns:
            Ham byte listesi veya None (hata durumunda)
        
        Örnek:
            send_uds_command("22", "015B")  # Battery SOH okuma
            send_uds_command("10", "03")    # Extended diagnostic session
        """
        if not self.is_connected:
            raise Exception("Bağlantı yok. Önce connect() çağrılmalı")
        
        try:
            # UDS komutunu oluştur
            cmd_bytes = []
            
            # Servis kodu
            cmd_bytes.append(int(service, 16))
            
            # PID varsa ekle
            if pid:
                # PID 2 byte (big-endian)
                pid_clean = pid.replace(" ", "").replace("0x", "").replace("0X", "")
                if len(pid_clean) == 4:
                    cmd_bytes.append(int(pid_clean[0:2], 16))
                    cmd_bytes.append(int(pid_clean[2:4], 16))
                elif len(pid_clean) == 2:
                    cmd_bytes.append(int(pid_clean, 16))
            
            # Ek veri varsa ekle
            if data:
                cmd_bytes.extend(data)
            
            # Komutu hex string'e çevir
            cmd_hex = " ".join([f"{b:02X}" for b in cmd_bytes])
            
            # ELM327'ye gönder (CAN protokolü)
            # Önce protokolü ayarla
            self._send_at_command("SP0")  # Otomatik protokol
            
            # Komutu gönder
            response = self._send_at_command(f"SH {self._get_current_header()}")
            time.sleep(0.05)
            
            # UDS komutunu gönder
            cmd_line = cmd_hex + "\r\n"
            self.serial_conn.write(cmd_line.encode())
            time.sleep(0.1)
            
            # Cevabı oku
            response_bytes = self._read_uds_response()
            
            return response_bytes
            
        except Exception as e:
            print(f"UDS komut gönderme hatası: {e}")
            return None
    
    def _get_current_header(self) -> str:
        """Mevcut header'ı al (varsayılan 7E4)"""
        # Bu değer set_header() ile ayarlanmalı
        return getattr(self, '_current_header', '7E4')
    
    def _read_uds_response(self) -> Optional[List[int]]:
        """UDS cevabını oku ve byte listesine çevir"""
        try:
            response = b""
            start_time = time.time()
            
            while time.time() - start_time < self.timeout:
                if self.serial_conn.in_waiting > 0:
                    response += self.serial_conn.read(self.serial_conn.in_waiting)
                    if b">" in response:  # ELM327 prompt
                        break
                time.sleep(0.01)
            
            # Hex string'i temizle ve byte listesine çevir
            response_str = response.decode('utf-8', errors='ignore').strip()
            
            # ELM327 formatından temizle (örn: "62 10 5B 8C >")
            response_str = re.sub(r'[^0-9A-Fa-f\s]', '', response_str)
            response_str = response_str.strip()
            
            if not response_str:
                return None
            
            # Hex byte'ları parse et
            bytes_list = []
            hex_parts = response_str.split()
            
            for hex_part in hex_parts:
                if len(hex_part) == 2:
                    try:
                        bytes_list.append(int(hex_part, 16))
                    except ValueError:
                        continue
            
            return bytes_list if bytes_list else None
            
        except Exception as e:
            print(f"UDS cevap okuma hatası: {e}")
            return None
    
    def send_uds_read_data_by_id(self, pid: str) -> Optional[List[int]]:
        """
        UDS Mode 22 (ReadDataByIdentifier) komutu gönder
        
        Args:
            pid: PID kodu hex formatında (örn: "015B")
        
        Returns:
            Ham byte listesi
        """
        return self.send_uds_command("22", pid)
    
    def send_uds_session_control(self, session_type: str = "03") -> bool:
        """
        UDS Mode 10 (DiagnosticSessionControl) komutu gönder
        
        Args:
            session_type: "01"=Default, "02"=Programming, "03"=Extended, "04"=Safety
        
        Returns:
            Başarılı olursa True
        """
        response = self.send_uds_command("10", session_type)
        if response and len(response) >= 2:
            # Cevap formatı: 50 [session_type] (positive response)
            return response[0] == 0x50 and response[1] == int(session_type, 16)
        return False
    
    def send_uds_tester_present(self) -> bool:
        """
        UDS Mode 3E (TesterPresent) komutu gönder (keep-alive)
        
        Returns:
            Başarılı olursa True
        """
        response = self.send_uds_command("3E", "00")
        if response and len(response) >= 1:
            return response[0] == 0x7E  # Positive response
        return False
    
    def __enter__(self):
        """Context manager desteği"""
        self.connect()
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager desteği"""
        self.disconnect()
