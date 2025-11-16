"""
Basit Firewall Kuralları
IP bazlı erişim kontrolü ve filtreleme
"""

import os
import ipaddress
from typing import List, Optional
from security import get_security_manager


class SimpleFirewall:
    """Basit firewall sınıfı"""
    
    def __init__(self):
        self.security = get_security_manager()
        self.blocked_ips = set()
        self.allowed_ips = set(self.security.config.get('allowed_ips', []))
        self.load_blocked_ips()
    
    def load_blocked_ips(self):
        """Engellenmiş IP'leri yükle"""
        blocked_file = ".blocked_ips.txt"
        if os.path.exists(blocked_file):
            try:
                with open(blocked_file, 'r') as f:
                    for line in f:
                        ip = line.strip()
                        if ip:
                            self.blocked_ips.add(ip)
            except:
                pass
    
    def save_blocked_ips(self):
        """Engellenmiş IP'leri kaydet"""
        blocked_file = ".blocked_ips.txt"
        try:
            with open(blocked_file, 'w') as f:
                for ip in self.blocked_ips:
                    f.write(f"{ip}\n")
            os.chmod(blocked_file, 0o600)
        except:
            pass
    
    def is_ip_allowed(self, ip: str) -> bool:
        """IP'nin izinli olup olmadığını kontrol et"""
        try:
            # Engellenmiş IP kontrolü
            if ip in self.blocked_ips:
                return False
            
            # İzinli IP listesi varsa kontrol et
            if self.allowed_ips:
                return ip in self.allowed_ips
            
            # Varsayılan olarak izin ver
            return True
        except:
            return False
    
    def block_ip(self, ip: str) -> bool:
        """IP'yi engelle"""
        try:
            # Geçerli IP adresi kontrolü
            ipaddress.ip_address(ip)
            self.blocked_ips.add(ip)
            self.save_blocked_ips()
            self.security._log_security_event("IP_BLOCKED", ip)
            return True
        except ValueError:
            return False
    
    def unblock_ip(self, ip: str) -> bool:
        """IP engelini kaldır"""
        if ip in self.blocked_ips:
            self.blocked_ips.remove(ip)
            self.save_blocked_ips()
            self.security._log_security_event("IP_UNBLOCKED", ip)
            return True
        return False
    
    def get_blocked_ips(self) -> List[str]:
        """Engellenmiş IP listesini al"""
        return list(self.blocked_ips)
    
    def auto_block_suspicious_ips(self, threshold: int = 10):
        """Şüpheli IP'leri otomatik engelle"""
        from security_monitor import SecurityMonitor
        
        monitor = SecurityMonitor()
        analysis = monitor.analyze_threats()
        
        blocked_count = 0
        for ip, count in analysis['suspicious_ips'].items():
            if count >= threshold and ip not in self.blocked_ips:
                if self.block_ip(ip):
                    blocked_count += 1
        
        return blocked_count


if __name__ == "__main__":
    import os
    firewall = SimpleFirewall()
    
    print("\nFirewall Yönetimi")
    print("="*50)
    print(f"Engellenmiş IP sayısı: {len(firewall.get_blocked_ips())}")
    
    if firewall.get_blocked_ips():
        print("\nEngellenmiş IP'ler:")
        for ip in firewall.get_blocked_ips():
            print(f"  - {ip}")
    
    # Şüpheli IP'leri otomatik engelle
    blocked = firewall.auto_block_suspicious_ips(threshold=10)
    if blocked > 0:
        print(f"\n✓ {blocked} şüpheli IP otomatik olarak engellendi.")
