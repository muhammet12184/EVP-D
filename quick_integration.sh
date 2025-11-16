#!/bin/bash

# Hızlı Entegrasyon Script'i
# Kullanım: ./quick_integration.sh YOUR_PACKAGE_NAME YOUR_APP_PATH

PACKAGE_NAME=${1:-"com.obd.diagnostics"}
APP_PATH=${2:-"app/src/main/java"}

echo "🚀 OBD Diagnostics - Entegrasyon Script'i"
echo "========================================"
echo "Package: $PACKAGE_NAME"
echo "Hedef: $APP_PATH"
echo ""

# Package path oluştur
PACKAGE_PATH=$(echo $PACKAGE_NAME | tr '.' '/')

# Dizinleri oluştur
echo "📁 Dizinler oluşturuluyor..."
mkdir -p "$APP_PATH/$PACKAGE_PATH/analyzer"
mkdir -p "$APP_PATH/$PACKAGE_PATH/router"
mkdir -p "$APP_PATH/$PACKAGE_PATH/pid"
mkdir -p "$APP_PATH/$PACKAGE_PATH/ui"

# Dosyaları kopyala ve package isimlerini değiştir
echo "📄 Dosyalar kopyalanıyor ve düzenleniyor..."

files=(
    "MotorAnalyzer.kt:analyzer"
    "DataAnalyzer.kt:analyzer"
    "PIDRouter.kt:router"
    "PIDType.kt:pid"
    "PIDReader.kt:pid"
    "VehicleDebugUI.kt:ui"
)

for item in "${files[@]}"; do
    IFS=':' read -r file dir <<< "$item"
    if [ -f "$file" ]; then
        echo "  ✓ $file -> $dir/"
        sed "s/package com\.obd\.diagnostics\.$dir/package $PACKAGE_NAME.$dir/" "$file" > "$APP_PATH/$PACKAGE_PATH/$dir/$file"
    fi
done

echo ""
echo "✅ Entegrasyon tamamlandı!"
echo ""
echo "📝 Sonraki adımlar:"
echo "1. Import'ları düzeltin (IDE otomatik yapabilir)"
echo "2. build.gradle'ı kontrol edin (Coroutines + Compose)"
echo "3. ./gradlew build ile derleyin"
echo ""
