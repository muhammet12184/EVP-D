"""
Güvenlik Testleri
API'nin güvenlik özelliklerini test eden script
"""

import requests
import time
from colorama import Fore, Style, init

# Colorama başlat
init(autoreset=True)

BASE_URL = "http://localhost:8000"

def print_test(name, status, message=""):
    """Test sonucunu renkli yazdır"""
    if status:
        print(f"{Fore.GREEN}✓ {name}{Style.RESET_ALL}")
    else:
        print(f"{Fore.RED}✗ {name}{Style.RESET_ALL}")
    if message:
        print(f"  {Fore.YELLOW}{message}{Style.RESET_ALL}")

def test_api_online():
    """API'nin çalıştığını kontrol et"""
    try:
        response = requests.get(f"{BASE_URL}/")
        return response.status_code == 200
    except:
        return False

def test_login():
    """Login işlemini test et"""
    try:
        response = requests.post(
            f"{BASE_URL}/login",
            json={
                "username": "admin",
                "password": "Admin123!"
            }
        )
        if response.status_code == 200:
            data = response.json()
            return data.get("access_token") is not None, data.get("access_token")
        return False, None
    except Exception as e:
        return False, None

def test_invalid_login():
    """Geçersiz login denemesini test et"""
    try:
        response = requests.post(
            f"{BASE_URL}/login",
            json={
                "username": "hacker",
                "password": "wrongpass"
            }
        )
        # 401 dönmeli
        return response.status_code == 401
    except:
        return False

def test_rate_limiting():
    """Rate limiting'i test et"""
    try:
        # 10'dan fazla istek gönder
        for i in range(12):
            response = requests.get(f"{BASE_URL}/")
        
        # Son istek rate limit'e takılmalı
        return response.status_code == 429
    except:
        return False

def test_authentication_required():
    """Authentication gerekliliğini test et"""
    try:
        response = requests.get(f"{BASE_URL}/battery-data")
        # 403 veya 401 dönmeli (authentication gerekli)
        return response.status_code in [401, 403]
    except:
        return False

def test_xss_protection(token):
    """XSS korumasını test et"""
    try:
        xss_payload = "<script>alert('xss')</script>"
        response = requests.get(
            f"{BASE_URL}/battery-data",
            params={"vehicle_brand": xss_payload},
            headers={"Authorization": f"Bearer {token}"}
        )
        # Hata dönmeli veya sanitize edilmeli
        return response.status_code in [400, 422]
    except:
        return False

def test_sql_injection_protection(token):
    """SQL injection korumasını test et"""
    try:
        sql_payload = "'; DROP TABLE users; --"
        response = requests.get(
            f"{BASE_URL}/battery-data",
            params={"vehicle_brand": sql_payload},
            headers={"Authorization": f"Bearer {token}"}
        )
        # Hata dönmeli
        return response.status_code in [400, 422]
    except:
        return False

def test_security_headers():
    """Güvenlik header'larını test et"""
    try:
        response = requests.get(f"{BASE_URL}/")
        headers = response.headers
        
        required_headers = [
            "X-Content-Type-Options",
            "X-Frame-Options",
            "X-XSS-Protection",
            "Strict-Transport-Security",
            "Content-Security-Policy"
        ]
        
        missing = []
        for header in required_headers:
            if header not in headers:
                missing.append(header)
        
        return len(missing) == 0, missing
    except:
        return False, []

def test_valid_data_access(token):
    """Geçerli token ile veri erişimini test et"""
    try:
        response = requests.get(
            f"{BASE_URL}/battery-data",
            headers={"Authorization": f"Bearer {token}"}
        )
        return response.status_code == 200
    except:
        return False

def test_invalid_token():
    """Geçersiz token ile erişimi test et"""
    try:
        response = requests.get(
            f"{BASE_URL}/battery-data",
            headers={"Authorization": "Bearer invalid_token_here"}
        )
        return response.status_code in [401, 403]
    except:
        return False

def run_all_tests():
    """Tüm testleri çalıştır"""
    print(f"\n{Fore.CYAN}{'='*60}")
    print(f"🔒 GÜVENLİK TESTLERİ")
    print(f"{'='*60}{Style.RESET_ALL}\n")
    
    tests_passed = 0
    tests_total = 0
    
    # 1. API Online Test
    tests_total += 1
    if test_api_online():
        print_test("API Çalışıyor", True)
        tests_passed += 1
    else:
        print_test("API Çalışıyor", False, "API başlatılmamış olabilir")
        print(f"\n{Fore.RED}API'yi başlatın: python app.py{Style.RESET_ALL}\n")
        return
    
    # 2. Login Test
    tests_total += 1
    success, token = test_login()
    if success:
        print_test("Login Başarılı", True)
        tests_passed += 1
    else:
        print_test("Login Başarılı", False)
    
    # 3. Invalid Login Test
    tests_total += 1
    if test_invalid_login():
        print_test("Geçersiz Login Engellendi", True)
        tests_passed += 1
    else:
        print_test("Geçersiz Login Engellendi", False)
    
    # 4. Authentication Required Test
    tests_total += 1
    if test_authentication_required():
        print_test("Authentication Zorunluluğu", True)
        tests_passed += 1
    else:
        print_test("Authentication Zorunluluğu", False)
    
    # 5. Security Headers Test
    tests_total += 1
    success, missing = test_security_headers()
    if success:
        print_test("Güvenlik Header'ları", True)
        tests_passed += 1
    else:
        print_test("Güvenlik Header'ları", False, f"Eksik: {', '.join(missing)}")
    
    if token:
        # 6. Valid Data Access Test
        tests_total += 1
        if test_valid_data_access(token):
            print_test("Geçerli Token ile Veri Erişimi", True)
            tests_passed += 1
        else:
            print_test("Geçerli Token ile Veri Erişimi", False)
        
        # 7. XSS Protection Test
        tests_total += 1
        if test_xss_protection(token):
            print_test("XSS Koruması", True)
            tests_passed += 1
        else:
            print_test("XSS Koruması", False)
        
        # 8. SQL Injection Protection Test
        tests_total += 1
        if test_sql_injection_protection(token):
            print_test("SQL Injection Koruması", True)
            tests_passed += 1
        else:
            print_test("SQL Injection Koruması", False)
    
    # 9. Invalid Token Test
    tests_total += 1
    if test_invalid_token():
        print_test("Geçersiz Token Engellendi", True)
        tests_passed += 1
    else:
        print_test("Geçersiz Token Engellendi", False)
    
    # 10. Rate Limiting Test (dikkatli, rate limit'e takılabilir)
    print(f"\n{Fore.YELLOW}Rate Limiting testi çalıştırılıyor (biraz zaman alabilir)...{Style.RESET_ALL}")
    time.sleep(2)  # Önceki isteklerin reset olması için bekle
    tests_total += 1
    if test_rate_limiting():
        print_test("Rate Limiting", True)
        tests_passed += 1
    else:
        print_test("Rate Limiting", False, "Rate limit çalışmıyor olabilir")
    
    # Sonuçlar
    print(f"\n{Fore.CYAN}{'='*60}")
    percentage = (tests_passed / tests_total) * 100
    
    if percentage == 100:
        color = Fore.GREEN
        emoji = "🎉"
    elif percentage >= 80:
        color = Fore.YELLOW
        emoji = "✓"
    else:
        color = Fore.RED
        emoji = "⚠️"
    
    print(f"{color}{emoji} SONUÇ: {tests_passed}/{tests_total} test başarılı ({percentage:.1f}%){Style.RESET_ALL}")
    print(f"{'='*60}\n")


if __name__ == "__main__":
    try:
        run_all_tests()
    except KeyboardInterrupt:
        print(f"\n{Fore.YELLOW}Testler iptal edildi.{Style.RESET_ALL}\n")
    except Exception as e:
        print(f"\n{Fore.RED}Hata: {str(e)}{Style.RESET_ALL}\n")
