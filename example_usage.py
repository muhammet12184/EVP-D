"""
OBD-II/UDS Entegrasyon Kullanım Örnekleri
"""

from obd_integration import OBDIntegration


def example_1_read_battery_soc():
    """Örnek 1: EV Batarya SOC Okuma"""
    print("=" * 60)
    print("ÖRNEK 1: EV Batarya SOC Okuma")
    print("=" * 60)
    
    # TOGG için örnek
    obd = OBDIntegration(port=None)  # Port otomatik bulunur
    
    try:
        if obd.connect(manufacturer="TOGG"):
            # Battery SOC oku
            result = obd.read_pid("Battery State of Charge", "TOGG")
            
            if result:
                print(f"PID Adı: {result['name']}")
                print(f"Değer: {result['value']}")
                print(f"Formatlanmış: {result['formatted']}")
                print(f"Birim: {result['units']}")
                print(f"ECU: {result['ecu']}")
                print(f"PID Kodu: {result['pid_code']}")
                print(f"Ham Byte'lar: {[hex(b) for b in result['raw_bytes']]}")
            else:
                print("PID okunamadı!")
        else:
            print("Bağlantı başarısız!")
    
    finally:
        obd.disconnect()


def example_2_read_multiple_pids():
    """Örnek 2: Birden Fazla PID Okuma"""
    print("\n" + "=" * 60)
    print("ÖRNEK 2: Birden Fazla PID Okuma")
    print("=" * 60)
    
    obd = OBDIntegration()
    
    try:
        if obd.connect(manufacturer="TESLA"):
            # Birden fazla PID oku
            pid_names = [
                "Battery State of Charge",
                "Battery Voltage",
                "Battery Current",
                "Battery Temperature"
            ]
            
            results = obd.read_multiple_pids(pid_names, "TESLA")
            
            print("\nOkunan PID'ler:")
            for pid_name, data in results.items():
                print(f"  {pid_name}: {data['formatted']}")
    
    finally:
        obd.disconnect()


def example_3_ev_battery_full_status():
    """Örnek 3: EV Batarya Tam Durumu"""
    print("\n" + "=" * 60)
    print("ÖRNEK 3: EV Batarya Tam Durumu")
    print("=" * 60)
    
    obd = OBDIntegration()
    
    try:
        if obd.connect(manufacturer="HYUNDAI"):
            # Tüm batarya durumunu oku
            battery_status = obd.read_ev_battery_status("HYUNDAI")
            
            print("\nEV Batarya Durumu:")
            print("-" * 60)
            for name, data in battery_status.items():
                print(f"{name:40s} : {data['formatted']:>15s}")
    
    finally:
        obd.disconnect()


def example_4_search_and_read():
    """Örnek 4: Arama ve Okuma"""
    print("\n" + "=" * 60)
    print("ÖRNEK 4: Arama ve Okuma")
    print("=" * 60)
    
    obd = OBDIntegration()
    
    try:
        if obd.connect():
            # "temperature" kelimesini ara ve oku
            results = obd.search_and_read("temperature", limit=10)
            
            print(f"\n'{'temperature'}' için bulunan {len(results)} PID:")
            for result in results:
                print(f"  {result['name']:40s} : {result['formatted']:>15s} ({result['ecu']})")
    
    finally:
        obd.disconnect()


def example_5_engine_status():
    """Örnek 5: Motor Durumu"""
    print("\n" + "=" * 60)
    print("ÖRNEK 5: Motor Durumu")
    print("=" * 60)
    
    obd = OBDIntegration()
    
    try:
        if obd.connect():
            engine_status = obd.read_engine_status()
            
            print("\nMotor Durumu:")
            print("-" * 60)
            for name, data in engine_status.items():
                print(f"{name:40s} : {data['formatted']:>15s}")
    
    finally:
        obd.disconnect()


def example_6_custom_pid():
    """Örnek 6: Özel PID Okuma"""
    print("\n" + "=" * 60)
    print("ÖRNEK 6: Özel PID Okuma")
    print("=" * 60)
    
    obd = OBDIntegration()
    
    try:
        if obd.connect(manufacturer="BMW"):
            # BMW i3 için özel PID
            result = obd.read_pid("BMW i3 Battery SOH", "BMW")
            
            if result:
                print(f"\n{result['name']}: {result['formatted']}")
                print(f"Açıklama: {result['description']}")
    
    finally:
        obd.disconnect()


def example_7_list_available_pids():
    """Örnek 7: Mevcut PID'leri Listele"""
    print("\n" + "=" * 60)
    print("ÖRNEK 7: Mevcut PID'leri Listele")
    print("=" * 60)
    
    obd = OBDIntegration()
    
    # BMS PID'lerini listele
    bms_pids = obd.get_available_pids(ecu="BMS")
    print(f"\nBMS PID'leri ({len(bms_pids)} adet):")
    for i, pid_name in enumerate(bms_pids[:20], 1):  # İlk 20'yi göster
        print(f"  {i:2d}. {pid_name}")
    
    if len(bms_pids) > 20:
        print(f"  ... ve {len(bms_pids) - 20} tane daha")
    
    # İstatistikler
    stats = obd.pid_router.get_statistics()
    print(f"\nVeritabanı İstatistikleri:")
    for key, value in stats.items():
        print(f"  {key}: {value}")


if __name__ == "__main__":
    print("\n" + "=" * 60)
    print("OBD-II/UDS ENTEGRASYON KULLANIM ÖRNEKLERİ")
    print("=" * 60)
    
    # Not: Gerçek bağlantı için ELM327 adaptörü gerekli
    # Bu örnekler sadece kod yapısını gösterir
    
    # Örnek 7 çalışır (veritabanı okuma)
    example_7_list_available_pids()
    
    # Diğer örnekler ELM327 adaptörü gerektirir
    print("\n" + "=" * 60)
    print("NOT: Diğer örnekler ELM327 adaptörü gerektirir")
    print("Gerçek kullanım için:")
    print("  1. ELM327 adaptörünü bağlayın")
    print("  2. Port numarasını belirleyin (örn: 'COM3' veya '/dev/ttyUSB0')")
    print("  3. obd = OBDIntegration(port='COM3') şeklinde kullanın")
    print("=" * 60)
