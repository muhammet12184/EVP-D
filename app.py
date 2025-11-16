"""
Güvenli EV Veri Uygulaması
Hacker saldırılarına karşı korumalı ana uygulama
"""

import os
import sys
import getpass
from security import get_security_manager
from secure_file_handler import SecureFileHandler


class SecureEVApp:
    """Güvenli EV veri uygulaması"""
    
    def __init__(self):
        self.security = get_security_manager()
        self.file_handler = SecureFileHandler()
        self.current_user = None
    
    def login(self) -> bool:
        """Kullanıcı girişi"""
        print("\n" + "="*50)
        print("EV VERİ UYGULAMASI - GÜVENLİ GİRİŞ")
        print("="*50)
        
        username = input("Kullanıcı adı: ").strip()
        password = getpass.getpass("Şifre: ")
        
        if self.security.authenticate(username, password):
            self.current_user = username
            print(f"\n✓ Başarılı giriş! Hoş geldiniz {username}")
            return True
        else:
            print("\n✗ Giriş başarısız! Kullanıcı adı veya şifre hatalı.")
            print("Çok fazla başarısız deneme hesabınızı kilitleyebilir.")
            return False
    
    def show_menu(self):
        """Ana menüyü göster"""
        while True:
            print("\n" + "="*50)
            print("ANA MENÜ")
            print("="*50)
            print("1. CSV Dosyasını Oku")
            print("2. CSV Dosyasını Şifrele")
            print("3. Şifreli Dosyayı Çöz")
            print("4. Güvenlik Durumunu Görüntüle")
            print("5. Dosya Listesi")
            print("6. Çıkış")
            print("="*50)
            
            choice = input("Seçiminiz (1-6): ").strip()
            
            if choice == '1':
                self.read_csv_file()
            elif choice == '2':
                self.encrypt_file()
            elif choice == '3':
                self.decrypt_file()
            elif choice == '4':
                self.show_security_status()
            elif choice == '5':
                self.list_files()
            elif choice == '6':
                print("\nGüvenli çıkış yapılıyor...")
                break
            else:
                print("\nGeçersiz seçim!")
    
    def read_csv_file(self):
        """CSV dosyasını oku"""
        file_path = input("\nDosya yolu: ").strip()
        data = self.file_handler.read_csv_secure(file_path, self.current_user)
        
        if data:
            print(f"\n✓ Dosya başarıyla okundu ({len(data)} satır)")
            # İlk birkaç satırı göster
            if data:
                print("\nİlk 3 satır:")
                for i, row in enumerate(data[:3], 1):
                    print(f"{i}. {row}")
        else:
            print("\n✗ Dosya okunamadı veya erişim reddedildi.")
    
    def encrypt_file(self):
        """Dosyayı şifrele"""
        file_path = input("\nŞifrelenecek dosya yolu: ").strip()
        
        if self.security.encrypt_file(file_path):
            print(f"\n✓ Dosya başarıyla şifrelendi: {file_path}.encrypted")
        else:
            print("\n✗ Şifreleme başarısız!")
    
    def decrypt_file(self):
        """Şifreli dosyayı çöz"""
        encrypted_path = input("\nŞifreli dosya yolu: ").strip()
        output_path = input("Çıktı dosya yolu: ").strip()
        
        if self.security.decrypt_file(encrypted_path, output_path):
            print(f"\n✓ Dosya başarıyla çözüldü: {output_path}")
        else:
            print("\n✗ Şifre çözme başarısız!")
    
    def show_security_status(self):
        """Güvenlik durumunu göster"""
        status = self.security.get_security_status()
        
        print("\n" + "="*50)
        print("GÜVENLİK DURUMU")
        print("="*50)
        print(f"Başarısız Deneme Sayısı: {status['failed_attempts_count']}")
        print(f"Kilitli Hesaplar: {len(status['locked_accounts'])}")
        print(f"Toplam Erişim Logları: {status['total_access_logs']}")
        print(f"Şifreleme Aktif: {'Evet' if status['encryption_enabled'] else 'Hayır'}")
        
        if status['locked_accounts']:
            print("\nKilitli Hesaplar:")
            for account in status['locked_accounts']:
                print(f"  - {account}")
        print("="*50)
    
    def list_files(self):
        """Dosya listesini göster"""
        directory = input("\nDizin yolu (boş = mevcut dizin): ").strip() or "."
        files = self.file_handler.list_files_secure(directory, self.current_user)
        
        if files:
            print(f"\n✓ {len(files)} dosya bulundu:")
            for file in files:
                print(f"  - {file}")
        else:
            print("\n✗ Dosya bulunamadı veya erişim reddedildi.")


def setup_admin_user():
    """Admin kullanıcısı oluştur"""
    security = get_security_manager()
    
    print("\n" + "="*50)
    print("ADMİN KULLANICI KURULUMU")
    print("="*50)
    print("İlk kullanım için admin kullanıcısı oluşturulmalıdır.")
    
    username = input("Admin kullanıcı adı: ").strip()
    password = getpass.getpass("Admin şifresi: ")
    password_confirm = getpass.getpass("Şifre tekrar: ")
    
    if password != password_confirm:
        print("\n✗ Şifreler eşleşmiyor!")
        return False
    
    if security.create_user(username, password):
        print(f"\n✓ Admin kullanıcısı '{username}' başarıyla oluşturuldu!")
        return True
    else:
        print("\n✗ Kullanıcı oluşturulamadı (kullanıcı zaten var olabilir)")
        return False


def main():
    """Ana fonksiyon"""
    app = SecureEVApp()
    
    # Admin kullanıcısı kontrolü
    if not os.path.exists(".users.json"):
        if not setup_admin_user():
            print("\nUygulama kapatılıyor...")
            sys.exit(1)
    
    # Giriş yap
    max_login_attempts = 3
    for attempt in range(max_login_attempts):
        if app.login():
            app.show_menu()
            break
        else:
            remaining = max_login_attempts - attempt - 1
            if remaining > 0:
                print(f"\nKalan deneme hakkı: {remaining}")
            else:
                print("\n✗ Çok fazla başarısız deneme. Uygulama kapatılıyor.")
                sys.exit(1)


if __name__ == "__main__":
    main()
