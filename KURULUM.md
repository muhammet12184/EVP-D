# 🔵 Bluetooth Tarayıcı - Hızlı Kurulum Kılavuzu

## 📱 Uygulama Hazır!

iOS ve Android için tam fonksiyonel Bluetooth tarama uygulaması oluşturuldu.

## 🚀 Hızlı Başlangıç

### 1. Bağımlılıkları Yükleyin

```bash
npm install
```

veya yarn kullanıyorsanız:

```bash
yarn install
```

### 2. iOS için (Mac gerekli)

```bash
cd ios
pod install
cd ..
npm run ios
```

### 3. Android için

```bash
npm run android
```

## ✨ Özellikler

✅ **Bluetooth Tarama** - "TARA" butonuna basın  
✅ **Cihaz Listesi** - Tüm yakındaki BLE cihazlarını görün  
✅ **Sinyal Gücü** - Her cihazın RSSI değerini gösterir  
✅ **Bağlantı** - Cihazlara dokunarak bağlanın  
✅ **iOS & Android** - Her iki platformda da çalışır  
✅ **Türkçe Arayüz** - Tamamen Türkçe  

## 🔧 Sorun Giderme

### Cihazlar Görünmüyor?

1. ✓ Bluetooth açık mı kontrol edin
2. ✓ Uygulama izinlerini verin (konum + bluetooth)
3. ✓ Android'de konum servislerini açın
4. ✓ İOS'ta gerçek cihaz kullanın (simülatör değil)

### İzinler

**Android:**
- Bluetooth Scan (Android 12+)
- Bluetooth Connect (Android 12+)
- Konum İzni (Tüm versiyonlar)

**iOS:**
- Bluetooth İzni (otomatik sorulur)
- Konum İzni (otomatik sorulur)

## 📝 Kullanım Adımları

1. **Uygulamayı Açın**
2. **🔵 TARA** butonuna basın
3. **10 saniye** tarama yapılacak
4. **Bulunan cihazlar** listede görünür
5. **BAĞLAN** butonuna basarak bağlanın

## 🎨 Arayüz

- **Mavi başlık:** "Bluetooth Cihaz Tarayıcı"
- **Yeşil banner:** Bağlı cihaz gösterimi
- **Büyük mavi buton:** Tarama butonu
- **Cihaz kartları:** İsim, ID, sinyal gücü ve bağlan butonu

## 📦 Teknik Detaylar

- **Framework:** React Native 0.72.6
- **BLE Kütüphanesi:** react-native-ble-plx
- **Minimum SDK:** Android 21 (5.0), iOS 13
- **Dil:** JavaScript

## 🔐 Güvenlik

- Tüm izinler AndroidManifest.xml'de tanımlı
- iOS Info.plist'te açıklamalar mevcut
- Runtime izin kontrolleri yapılıyor

## 💡 Önemli Notlar

- **Android 12+** yeni Bluetooth izinleri kullanır
- **iOS Simülatör** Bluetooth desteklemez
- **Konum servisi** Android'de BLE için zorunlu
- **BLE (Bluetooth Low Energy)** cihazları taranır

## 📞 Destek

Sorun yaşarsanız:
1. Node modüllerini tekrar yükleyin: `rm -rf node_modules && npm install`
2. Cache'i temizleyin: `npm start -- --reset-cache`
3. iOS: `cd ios && pod install && cd ..`

## 🎯 Başarı!

Uygulama kullanıma hazır. "TARA" butonuna basın ve Bluetooth cihazlarınızı keşfedin! 🎉
