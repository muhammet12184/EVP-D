"""
Entegrasyon Örneği
Motor analizi, EV analizi ve araç marka tespitini birleştiren örnek
"""

from obd_integration import OBDIntegration
from motor_analysis import MotorAnalysis
from ev_analysis import EVAnalysis
from data_analyzer import DataAnalyzer
from pid_router import PIDRouter


def main():
    """Ana entegrasyon fonksiyonu"""
    
    print("=" * 60)
    print("Motor ve EV Analiz Entegrasyonu")
    print("=" * 60)
    
    # OBD entegrasyonu başlat
    obd = OBDIntegration(port=None)  # Port otomatik bulunacak
    csv_file = "ev_unified_professional.csv"
    
    # PID Router'ı başlat
    pid_router = PIDRouter(csv_file)
    
    # Data Analyzer'ı başlat
    data_analyzer = DataAnalyzer(window_size=100)
    
    # Motor ve EV analiz modüllerini başlat
    motor_analysis = MotorAnalysis(obd, data_analyzer)
    ev_analysis = EVAnalysis(obd, data_analyzer)
    
    try:
        # Bağlan
        print("\n1. ELM327'ye bağlanılıyor...")
        if not obd.connect():
            print("Hata: ELM327'ye bağlanılamadı!")
            return
        
        print("✓ Bağlantı başarılı!")
        
        # Araç marka tespiti
        print("\n2. Araç markası tespit ediliyor...")
        detected_brand = pid_router.detect_vehicle_brand()
        if detected_brand:
            print(f"✓ Tespit edilen marka: {detected_brand}")
            obd.manufacturer = detected_brand
        else:
            print("⚠ Marka otomatik tespit edilemedi, manuel giriş gerekebilir")
            # Varsayılan olarak TOGG dene
            obd.manufacturer = "TOGG"
            detected_brand = "TOGG"
        
        # Yakıt tüketim PID'ini başlat
        print("\n3. Yakıt tüketim PID'i başlatılıyor...")
        if motor_analysis.initialize_fuel_pid(detected_brand):
            print(f"✓ Yakıt tüketim PID'i başarıyla bağlandı: {motor_analysis.current_fuel_pid}")
        else:
            print("⚠ Yakıt tüketim PID'i bulunamadı, placeholder değer kullanılacak")
        
        # Regen PID'ini başlat
        print("\n4. Regen PID'i başlatılıyor...")
        if ev_analysis.initialize_regen_pid(detected_brand):
            print(f"✓ Regen PID'i başarıyla bağlandı: {ev_analysis.current_regen_pid}")
        else:
            print("⚠ Regen PID'i bulunamadı")
        
        # Veri okuma döngüsü
        print("\n5. Veri okuma başlatılıyor...")
        print("-" * 60)
        
        for i in range(10):  # 10 örnek oku
            print(f"\n[Örnek {i+1}]")
            
            # Motor durumu
            motor_status = motor_analysis.get_motor_status()
            fuel_consumption = motor_status['fuel_consumption']['current']
            print(f"  Motor - Yakıt Tüketimi: {fuel_consumption:.2f} {motor_status['fuel_consumption']['unit']}")
            if motor_status['fuel_consumption']['pid_name'] != 'Not Found':
                print(f"    PID: {motor_status['fuel_consumption']['pid_name']}")
            
            # EV durumu
            ev_status = ev_analysis.get_ev_status()
            regen_power = ev_status['regen']['current']
            print(f"  EV - Regen Gücü: {regen_power:.2f} {ev_status['regen']['unit']}")
            if ev_status['regen']['pid_name'] != 'Not Found':
                print(f"    PID: {ev_status['regen']['pid_name']}")
            
            # DataAnalyzer özeti
            summary = data_analyzer.get_summary()
            if summary['fuel']['stats']:
                fuel_stats = summary['fuel']['stats']
                print(f"  Yakıt İstatistikleri:")
                print(f"    Ortalama: {fuel_stats.get('average', 0):.2f} L/h")
                print(f"    Maksimum: {fuel_stats.get('max', 0):.2f} L/h")
            
            if summary['regen']['stats']:
                regen_stats = summary['regen']['stats']
                print(f"  Regen İstatistikleri:")
                print(f"    Ortalama: {regen_stats.get('average', 0):.2f} kW")
                print(f"    Maksimum: {regen_stats.get('max', 0):.2f} kW")
                print(f"    Aktif: {'Evet' if summary['regen']['is_active'] else 'Hayır'}")
        
        print("\n" + "=" * 60)
        print("Entegrasyon tamamlandı!")
        print(f"Tespit edilen marka: {detected_brand}")
        print("=" * 60)
        
    except Exception as e:
        print(f"\nHata: {e}")
        import traceback
        traceback.print_exc()
    
    finally:
        obd.disconnect()
        print("\nBağlantı kapatıldı.")


if __name__ == "__main__":
    main()
