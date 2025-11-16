"""
Güvenli Dosya İşleme Modülü
Dosya okuma/yazma işlemlerini güvenli şekilde yönetir
"""

import os
import csv
from typing import List, Dict, Optional
from security import get_security_manager


class SecureFileHandler:
    """Güvenli dosya işleyici"""
    
    def __init__(self):
        self.security = get_security_manager()
    
    def read_csv_secure(self, file_path: str, user: str) -> Optional[List[Dict]]:
        """CSV dosyasını güvenli şekilde oku"""
        # Dosya yolu validasyonu
        sanitized_path = self.security.sanitize_input(file_path)
        if sanitized_path != file_path:
            self.security._log_security_event("INVALID_PATH", f"{user}:{file_path}")
            return None
        
        # Erişim kontrolü
        if not self.security.validate_file_access(file_path, user):
            self.security._log_security_event("ACCESS_DENIED", f"{user}:{file_path}")
            return None
        
        # Dosya var mı kontrol et
        if not os.path.exists(file_path):
            self.security._log_security_event("FILE_NOT_FOUND", f"{user}:{file_path}")
            return None
        
        try:
            # Şifreli dosya kontrolü
            encrypted_path = f"{file_path}.encrypted"
            if os.path.exists(encrypted_path):
                # Geçici dosyaya çöz
                temp_path = f"{file_path}.temp"
                if self.security.decrypt_file(encrypted_path, temp_path):
                    file_path = temp_path
                else:
                    return None
            
            # CSV okuma
            data = []
            with open(file_path, 'r', encoding='utf-8') as f:
                # CSV delimiter'ı otomatik tespit et
                sample = f.read(1024)
                f.seek(0)
                sniffer = csv.Sniffer()
                delimiter = sniffer.sniff(sample).delimiter
                
                reader = csv.DictReader(f, delimiter=delimiter)
                for row in reader:
                    data.append(row)
            
            # Geçici dosyayı temizle
            if file_path.endswith('.temp'):
                os.remove(file_path)
            
            self.security._log_security_event("FILE_READ_SUCCESS", f"{user}:{file_path}")
            return data
            
        except Exception as e:
            self.security._log_security_event("FILE_READ_ERROR", f"{user}:{file_path}:{str(e)}")
            return None
    
    def write_csv_secure(self, file_path: str, data: List[Dict], user: str) -> bool:
        """CSV dosyasını güvenli şekilde yaz"""
        # Dosya yolu validasyonu
        sanitized_path = self.security.sanitize_input(file_path)
        if sanitized_path != file_path:
            self.security._log_security_event("INVALID_PATH", f"{user}:{file_path}")
            return False
        
        # Erişim kontrolü
        if not self.security.validate_file_access(file_path, user):
            self.security._log_security_event("ACCESS_DENIED", f"{user}:{file_path}")
            return False
        
        try:
            # Geçici dosyaya yaz
            temp_path = f"{file_path}.temp"
            
            if data:
                fieldnames = data[0].keys()
                with open(temp_path, 'w', encoding='utf-8', newline='') as f:
                    writer = csv.DictWriter(f, fieldnames=fieldnames, delimiter=';')
                    writer.writeheader()
                    writer.writerows(data)
            
            # Orijinal dosyayı yedekle
            if os.path.exists(file_path):
                backup_path = f"{file_path}.backup"
                with open(file_path, 'rb') as src, open(backup_path, 'wb') as dst:
                    dst.write(src.read())
            
            # Geçici dosyayı taşı
            os.rename(temp_path, file_path)
            
            # Şifreleme aktifse şifrele
            if self.security.config.get("encrypt_files", True):
                self.security.encrypt_file(file_path)
            
            self.security._log_security_event("FILE_WRITE_SUCCESS", f"{user}:{file_path}")
            return True
            
        except Exception as e:
            self.security._log_security_event("FILE_WRITE_ERROR", f"{user}:{file_path}:{str(e)}")
            return False
    
    def list_files_secure(self, directory: str, user: str) -> List[str]:
        """Dizindeki dosyaları güvenli şekilde listele"""
        sanitized_dir = self.security.sanitize_input(directory)
        if sanitized_dir != directory:
            return []
        
        try:
            files = []
            for item in os.listdir(directory):
                # Gizli dosyaları ve sistem dosyalarını gizle
                if not item.startswith('.') and os.path.isfile(os.path.join(directory, item)):
                    files.append(item)
            return files
        except Exception as e:
            self.security._log_security_event("LIST_FILES_ERROR", f"{user}:{directory}:{str(e)}")
            return []
