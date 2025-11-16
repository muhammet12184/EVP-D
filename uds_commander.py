"""
UDS Komut Gönderme Modülü
ELM327 adaptörü ile UDS (Unified Diagnostic Services) komutları gönderir.
"""

import serial
import time
import re
from typing import Optional, List, Tuple


class UDSCommander:
    """ELM327 ile UDS komutları gönderen sınıf"""
    
    def __init__(self, port: str = None, baudrate: int = 38400, timeout: float = 2.0):
        """
        Args:
            port: Serial port (örn: 'COM3', '/dev/ttyUSB0')
            baudrate: Baud rate (varsayılan 38400)
            timeout: Timeout süresi (saniye)
        """
        self.port = port
        self.baudrate = baudrate
        self.timeout = timeout
        self.serial_conn: Optional[serial.Serial] = None
        self.current_header = None
        
    def connect(self) -> bool:
        """ELM327 adaptörüne bağlan"""
        try:
            if not self.port:
                raise ValueError("Port belirtilmedi")
                
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
            self.serial_conn.reset_input_buffer()
            self.serial_conn.reset_output_buffer()
            
            # ATZ - Reset
            self._send_command("ATZ")
            time.sleep(1)
            
            # ATE0 - Echo kapalı
            self._send_command("ATE0")
            
            # ATL0 - Linefeeds kapalı
            self._send_command("ATL0")
            
            # ATSP0 - Auto protocol
            self._send_command("ATSP0")
            
            return True
            
        except Exception as e:
            print(f"Bağlantı hatası: {e}")
            return False
    
    def disconnect(self):
        """Bağlantıyı kapat"""
        if self.serial_conn and self.serial_conn.is_open:
            self.serial_conn.close()
            self.serial_conn = None
            self.current_header = None
    
    def _send_command(self, command: str) -> str:
        """ELM327'ye komut gönder ve cevap al"""
        if not self.serial_conn or not self.serial_conn.is_open:
            raise ConnectionError("Serial port açık değil")
        
        # Komutu gönder
        cmd_bytes = (command + '\r').encode('ascii')
        self.serial_conn.write(cmd_bytes)
        
        # Cevabı bekle
        response = ""
        start_time = time.time()
        
        while (time.time() - start_time) < self.timeout:
            if self.serial_conn.in_waiting > 0:
                data = self.serial_conn.read(self.serial_conn.in_waiting).decode('ascii', errors='ignore')
                response += data
                
                # ELM327 cevabı '>' ile bitirir
                if '>' in response:
                    break
            
            time.sleep(0.01)
        
        # Temizle ve döndür
        response = response.strip()
        response = response.replace('\r', '').replace('\n', '')
        response = response.replace('>', '').strip()
        
        return response
    
    def set_header(self, header: str) -> bool:
        """
        CAN header ayarla (AT SH komutu)
        
        Args:
            header: CAN ID (örn: '7E4', '7E0', '7B0')
        
        Returns:
            Başarılı ise True
        """
        try:
            # Header'ı 4 haneli hex formatına çevir
            if len(header) == 3:
                header = '0' + header.upper()
            elif len(header) == 4:
                header = header.upper()
            else:
                raise ValueError(f"Geçersiz header formatı: {header}")
            
            # AT SH komutu gönder
            cmd = f"AT SH {header}"
            response = self._send_command(cmd)
            
            if "OK" in response.upper() or ">" in response:
                self.current_header = header
                return True
            else:
                print(f"Header ayarlama hatası: {response}")
                return False
                
        except Exception as e:
            print(f"Header ayarlama hatası: {e}")
            return False
    
    def send_uds_command(self, did: str, header: str = None) -> Optional[List[int]]:
        """
        UDS Mode 22 (Read Data By Identifier) komutu gönder
        
        Args:
            did: Data Identifier (örn: '015B', '015C', '105B')
            header: CAN header (opsiyonel, önceki header kullanılır)
        
        Returns:
            Ham byte listesi (örn: [0x62, 0x10, 0x5B, 0x8C]) veya None
        """
        try:
            # Header ayarla
            if header:
                if not self.set_header(header):
                    return None
            elif not self.current_header:
                raise ValueError("Header belirtilmedi ve önceki header yok")
            
            # DID'i formatla (4 haneli hex)
            if len(did) == 2:
                did = '00' + did.upper()
            elif len(did) == 4:
                did = did.upper()
            else:
                raise ValueError(f"Geçersiz DID formatı: {did}")
            
            # UDS Mode 22 komutu: 22 [DID]
            # ELM327 formatı: 22 [DID byte1] [DID byte2]
            did_bytes = [did[i:i+2] for i in range(0, len(did), 2)]
            uds_cmd = f"22 {did_bytes[0]} {did_bytes[1]}"
            
            # Komutu gönder
            response = self._send_command(uds_cmd)
            
            # Cevabı parse et
            # Örnek cevap: "62 10 5B 8C" veya "7E8 06 62 10 5B 8C"
            raw_bytes = self._parse_response(response)
            
            return raw_bytes
            
        except Exception as e:
            print(f"UDS komut hatası: {e}")
            return None
    
    def send_obd_command(self, mode: str, pid: str, header: str = None) -> Optional[List[int]]:
        """
        OBD-II komutu gönder (Mode 01, 09, vb.)
        
        Args:
            mode: OBD mode (örn: '01', '09')
            pid: PID kodu (örn: '0C', '0D')
            header: CAN header (opsiyonel)
        
        Returns:
            Ham byte listesi veya None
        """
        try:
            # Header ayarla
            if header:
                if not self.set_header(header):
                    return None
            elif not self.current_header:
                raise ValueError("Header belirtilmedi")
            
            # OBD komutu: [Mode] [PID]
            obd_cmd = f"{mode} {pid}"
            
            # Komutu gönder
            response = self._send_command(obd_cmd)
            
            # Cevabı parse et
            raw_bytes = self._parse_response(response)
            
            return raw_bytes
            
        except Exception as e:
            print(f"OBD komut hatası: {e}")
            return None
    
    def _parse_response(self, response: str) -> Optional[List[int]]:
        """
        ELM327 cevabını parse et ve byte listesine çevir
        
        Args:
            response: ELM327 cevabı (örn: "62 10 5B 8C" veya "7E8 06 62 10 5B 8C")
        
        Returns:
            Byte listesi (örn: [0x62, 0x10, 0x5B, 0x8C]) veya None
        """
        try:
            # Hata kontrolü
            if not response or "ERROR" in response.upper() or "NO DATA" in response.upper():
                return None
            
            # Hex byte'ları bul
            # Örnek: "7E8 06 62 10 5B 8C" -> [0x62, 0x10, 0x5B, 0x8C]
            hex_pattern = r'[0-9A-Fa-f]{2}'
            hex_bytes = re.findall(hex_pattern, response)
            
            if not hex_bytes:
                return None
            
            # UDS cevabı genelde şu formatta gelir:
            # 7E8 06 62 10 5B 8C
            # 7E8 = CAN ID (response)
            # 06 = Data length
            # 62 = UDS response (22 + 0x40)
            # 10 5B = DID (echo)
            # 8C = Data byte
            
            # İlk byte'ı kontrol et (UDS response: 62, 63, 67, vb.)
            # Eğer ilk byte UDS response değilse, onu atla
            bytes_list = [int(b, 16) for b in hex_bytes]
            
            # UDS response byte'ını bul (62, 63, 67, 6F, vb.)
            uds_response_bytes = [0x62, 0x63, 0x67, 0x6F, 0x7F]
            
            # İlk UDS response byte'ını bul
            start_idx = 0
            for i, byte_val in enumerate(bytes_list):
                if byte_val in uds_response_bytes:
                    start_idx = i
                    break
            
            # UDS response byte'ından sonraki byte'ları al
            # Format: [UDS_RESPONSE] [DID_BYTE1] [DID_BYTE2] [DATA...]
            if start_idx < len(bytes_list):
                # UDS response ve DID'i atla, sadece data byte'larını al
                data_bytes = bytes_list[start_idx + 3:]  # 62 + DID (2 byte) = 3 byte atla
                return data_bytes
            
            # Eğer UDS response bulunamazsa, tüm byte'ları döndür
            return bytes_list
            
        except Exception as e:
            print(f"Response parse hatası: {e}")
            return None
    
    def __enter__(self):
        """Context manager giriş"""
        self.connect()
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager çıkış"""
        self.disconnect()


# Örnek kullanım
if __name__ == "__main__":
    # Test için
    commander = UDSCommander(port="COM3")  # Port'u kendi cihazınıza göre ayarlayın
    
    if commander.connect():
        # Header ayarla
        commander.set_header("7E4")
        
        # UDS komutu gönder
        result = commander.send_uds_command("015B", "7E4")
        print(f"UDS cevabı: {result}")
        
        commander.disconnect()
