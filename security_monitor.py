"""
Güvenlik İzleme Modülü
Güvenlik olaylarını izler ve raporlar
"""

import json
import os
from datetime import datetime, timedelta
from collections import defaultdict
from security import get_security_manager


class SecurityMonitor:
    """Güvenlik izleme sınıfı"""
    
    def __init__(self):
        self.security = get_security_manager()
        self.log_file = "security.log"
    
    def read_logs(self, hours: int = 24) -> list:
        """Son N saatteki logları oku"""
        logs = []
        cutoff_time = datetime.now() - timedelta(hours=hours)
        
        if not os.path.exists(self.log_file):
            return logs
        
        try:
            with open(self.log_file, 'r') as f:
                for line in f:
                    if line.strip():
                        try:
                            log_entry = json.loads(line)
                            log_time = datetime.fromisoformat(log_entry['timestamp'])
                            if log_time >= cutoff_time:
                                logs.append(log_entry)
                        except:
                            continue
        except Exception as e:
            print(f"Log okuma hatası: {e}")
        
        return logs
    
    def analyze_threats(self) -> dict:
        """Tehdit analizi yap"""
        logs = self.read_logs(24)
        
        analysis = {
            'total_events': len(logs),
            'failed_auth_attempts': 0,
            'rate_limit_exceeded': 0,
            'locked_accounts': 0,
            'file_access_denied': 0,
            'suspicious_ips': defaultdict(int),
            'event_types': defaultdict(int),
            'most_accessed_files': defaultdict(int)
        }
        
        for log in logs:
            event_type = log.get('event', '')
            analysis['event_types'][event_type] += 1
            
            if event_type == 'FAILED_AUTH':
                analysis['failed_auth_attempts'] += 1
                ip = log.get('ip', 'unknown')
                analysis['suspicious_ips'][ip] += 1
            
            elif event_type == 'RATE_LIMIT_EXCEEDED':
                analysis['rate_limit_exceeded'] += 1
            
            elif event_type == 'ACCOUNT_LOCKED':
                analysis['locked_accounts'] += 1
            
            elif event_type == 'ACCESS_DENIED':
                analysis['file_access_denied'] += 1
            
            elif event_type == 'FILE_ACCESS':
                details = log.get('details', '')
                if ':' in details:
                    file_path = details.split(':', 1)[1]
                    analysis['most_accessed_files'][file_path] += 1
        
        return analysis
    
    def generate_report(self) -> str:
        """Güvenlik raporu oluştur"""
        analysis = self.analyze_threats()
        
        report = []
        report.append("="*60)
        report.append("GÜVENLİK RAPORU")
        report.append(f"Tarih: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report.append("="*60)
        report.append("")
        
        report.append("GENEL İSTATİSTİKLER:")
        report.append(f"  Toplam Olay: {analysis['total_events']}")
        report.append(f"  Başarısız Giriş Denemeleri: {analysis['failed_auth_attempts']}")
        report.append(f"  Rate Limit Aşımları: {analysis['rate_limit_exceeded']}")
        report.append(f"  Kilitli Hesaplar: {analysis['locked_accounts']}")
        report.append(f"  Reddedilen Dosya Erişimleri: {analysis['file_access_denied']}")
        report.append("")
        
        if analysis['suspicious_ips']:
            report.append("ŞÜPHELİ IP ADRESLERİ:")
            sorted_ips = sorted(
                analysis['suspicious_ips'].items(),
                key=lambda x: x[1],
                reverse=True
            )
            for ip, count in sorted_ips[:10]:
                report.append(f"  {ip}: {count} deneme")
            report.append("")
        
        if analysis['most_accessed_files']:
            report.append("EN ÇOK ERİŞİLEN DOSYALAR:")
            sorted_files = sorted(
                analysis['most_accessed_files'].items(),
                key=lambda x: x[1],
                reverse=True
            )
            for file_path, count in sorted_files[:10]:
                report.append(f"  {file_path}: {count} erişim")
            report.append("")
        
        report.append("OLAY TİPLERİ:")
        for event_type, count in sorted(
            analysis['event_types'].items(),
            key=lambda x: x[1],
            reverse=True
        ):
            report.append(f"  {event_type}: {count}")
        
        report.append("")
        report.append("="*60)
        
        return "\n".join(report)
    
    def check_alerts(self) -> list:
        """Uyarıları kontrol et"""
        alerts = []
        analysis = self.analyze_threats()
        
        # Çok fazla başarısız deneme
        if analysis['failed_auth_attempts'] > 20:
            alerts.append({
                'level': 'HIGH',
                'message': f"Yüksek sayıda başarısız giriş denemesi: {analysis['failed_auth_attempts']}"
            })
        
        # Rate limit aşımları
        if analysis['rate_limit_exceeded'] > 10:
            alerts.append({
                'level': 'MEDIUM',
                'message': f"Rate limit aşımları tespit edildi: {analysis['rate_limit_exceeded']}"
            })
        
        # Kilitli hesaplar
        if analysis['locked_accounts'] > 0:
            alerts.append({
                'level': 'HIGH',
                'message': f"Kilitli hesap sayısı: {analysis['locked_accounts']}"
            })
        
        # Şüpheli IP'ler
        suspicious_ips = [
            ip for ip, count in analysis['suspicious_ips'].items()
            if count > 10
        ]
        if suspicious_ips:
            alerts.append({
                'level': 'HIGH',
                'message': f"Şüpheli IP adresleri tespit edildi: {', '.join(suspicious_ips)}"
            })
        
        return alerts


def main():
    """Ana fonksiyon"""
    monitor = SecurityMonitor()
    
    print("\nGüvenlik İzleme Modülü")
    print("="*60)
    
    # Rapor oluştur
    report = monitor.generate_report()
    print(report)
    
    # Uyarıları kontrol et
    alerts = monitor.check_alerts()
    if alerts:
        print("\n" + "="*60)
        print("UYARILAR:")
        print("="*60)
        for alert in alerts:
            level_icon = "🔴" if alert['level'] == 'HIGH' else "🟡"
            print(f"{level_icon} [{alert['level']}] {alert['message']}")
    else:
        print("\n✓ Kritik uyarı bulunamadı.")


if __name__ == "__main__":
    main()
