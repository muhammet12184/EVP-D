"""
Dosya Şifreleme Modülü
CSV ve diğer hassas dosyaları şifrelemek için araçlar
"""

import os
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2
from cryptography.hazmat.backends import default_backend
import base64
import logging

logger = logging.getLogger(__name__)

class FileEncryptor:
    """Dosya şifreleme ve şifre çözme sınıfı"""
    
    def __init__(self, password: str = None):
        """
        Şifreleme objesi oluştur
        
        Args:
            password: Şifreleme için kullanılacak şifre. None ise çevre değişkeninden alınır.
        """
        if password is None:
            password = os.getenv("ENCRYPTION_PASSWORD", "default-password-change-this")
        
        # Password'den şifreleme anahtarı türet
        self.key = self._derive_key(password)
        self.fernet = Fernet(self.key)
    
    def _derive_key(self, password: str) -> bytes:
        """Password'den güvenli bir şifreleme anahtarı türet"""
        salt = b'ev_battery_data_salt'  # Production'da salt'ı da çevre değişkeni yap
        kdf = PBKDF2(
            algorithm=hashes.SHA256(),
            length=32,
            salt=salt,
            iterations=100000,
            backend=default_backend()
        )
        key = base64.urlsafe_b64encode(kdf.derive(password.encode()))
        return key
    
    def encrypt_file(self, input_file: str, output_file: str = None) -> str:
        """
        Dosyayı şifrele
        
        Args:
            input_file: Şifrelenecek dosya yolu
            output_file: Şifrelenmiş dosyanın kaydedileceği yer. None ise .encrypted uzantısı eklenir.
        
        Returns:
            Şifrelenmiş dosya yolu
        """
        try:
            if not os.path.exists(input_file):
                raise FileNotFoundError(f"Dosya bulunamadı: {input_file}")
            
            if output_file is None:
                output_file = input_file + '.encrypted'
            
            # Dosyayı oku
            with open(input_file, 'rb') as f:
                data = f.read()
            
            # Şifrele
            encrypted_data = self.fernet.encrypt(data)
            
            # Şifrelenmiş veriyi yaz
            with open(output_file, 'wb') as f:
                f.write(encrypted_data)
            
            logger.info(f"Dosya şifrelendi: {input_file} -> {output_file}")
            return output_file
        
        except Exception as e:
            logger.error(f"Dosya şifreleme hatası: {str(e)}")
            raise
    
    def decrypt_file(self, input_file: str, output_file: str = None) -> str:
        """
        Şifrelenmiş dosyayı çöz
        
        Args:
            input_file: Şifrelenmiş dosya yolu
            output_file: Çözülmüş dosyanın kaydedileceği yer. None ise .decrypted uzantısı eklenir.
        
        Returns:
            Çözülmüş dosya yolu
        """
        try:
            if not os.path.exists(input_file):
                raise FileNotFoundError(f"Dosya bulunamadı: {input_file}")
            
            if output_file is None:
                output_file = input_file.replace('.encrypted', '.decrypted')
            
            # Şifrelenmiş veriyi oku
            with open(input_file, 'rb') as f:
                encrypted_data = f.read()
            
            # Şifreyi çöz
            decrypted_data = self.fernet.decrypt(encrypted_data)
            
            # Çözülmüş veriyi yaz
            with open(output_file, 'wb') as f:
                f.write(decrypted_data)
            
            logger.info(f"Dosya çözüldü: {input_file} -> {output_file}")
            return output_file
        
        except Exception as e:
            logger.error(f"Dosya şifre çözme hatası: {str(e)}")
            raise
    
    def encrypt_string(self, text: str) -> str:
        """String'i şifrele"""
        return self.fernet.encrypt(text.encode()).decode()
    
    def decrypt_string(self, encrypted_text: str) -> str:
        """Şifrelenmiş string'i çöz"""
        return self.fernet.decrypt(encrypted_text.encode()).decode()


def backup_and_encrypt_csv(csv_path: str, backup_dir: str = './backups'):
    """
    CSV dosyasını yedekle ve şifrele
    
    Args:
        csv_path: CSV dosya yolu
        backup_dir: Yedekleme dizini
    """
    try:
        # Yedekleme dizinini oluştur
        os.makedirs(backup_dir, exist_ok=True)
        
        # Timestamp ekle
        from datetime import datetime
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_file = os.path.join(backup_dir, f'ev_data_backup_{timestamp}.csv')
        
        # Dosyayı kopyala
        import shutil
        shutil.copy2(csv_path, backup_file)
        
        # Şifrele
        encryptor = FileEncryptor()
        encrypted_file = encryptor.encrypt_file(backup_file)
        
        # Şifrelenmemiş yedeği sil (güvenlik için)
        os.remove(backup_file)
        
        logger.info(f"CSV yedeklendi ve şifrelendi: {encrypted_file}")
        return encrypted_file
    
    except Exception as e:
        logger.error(f"Yedekleme ve şifreleme hatası: {str(e)}")
        raise


if __name__ == "__main__":
    # Test ve örnek kullanım
    logging.basicConfig(level=logging.INFO)
    
    print("Dosya Şifreleme Aracı")
    print("=" * 50)
    
    # CSV dosyasını yedekle ve şifrele
    try:
        encrypted = backup_and_encrypt_csv('/workspace/ev_unified_professional.csv')
        print(f"✓ CSV dosyası yedeklendi ve şifrelendi: {encrypted}")
    except Exception as e:
        print(f"✗ Hata: {str(e)}")
    
    # String şifreleme örneği
    encryptor = FileEncryptor()
    test_data = "Hassas veri örneği"
    encrypted_str = encryptor.encrypt_string(test_data)
    decrypted_str = encryptor.decrypt_string(encrypted_str)
    
    print(f"\nString Şifreleme Testi:")
    print(f"  Orijinal: {test_data}")
    print(f"  Şifreli: {encrypted_str[:50]}...")
    print(f"  Çözülmüş: {decrypted_str}")
    print(f"  ✓ Test başarılı!" if test_data == decrypted_str else "  ✗ Test başarısız!")
