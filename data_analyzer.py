"""
Data Analyzer Modülü
EV regen ve motor analiz verilerini işleyen analiz modülü
"""

from typing import Optional, Dict, List, Any
from datetime import datetime, timedelta
from collections import deque
import statistics


class DataAnalyzer:
    """Veri analizi ve işleme sınıfı"""
    
    def __init__(self, window_size: int = 100):
        """
        Args:
            window_size: Hareketli pencere boyutu (son N ölçüm)
        """
        self.window_size = window_size
        
        # EV regen verileri
        self.regen_data: deque = deque(maxlen=window_size)
        self.regen_timestamps: deque = deque(maxlen=window_size)
        
        # Motor yakıt tüketim verileri
        self.fuel_consumption_data: deque = deque(maxlen=window_size)
        self.fuel_timestamps: deque = deque(maxlen=window_size)
        
        # İstatistikler
        self.regen_stats: Dict[str, Any] = {}
        self.fuel_stats: Dict[str, Any] = {}
    
    def add_regen_data(self, regen_power: float, timestamp: Optional[datetime] = None):
        """
        Regen verisi ekle
        
        Args:
            regen_power: Rejeneratif güç (kW)
            timestamp: Zaman damgası (opsiyonel)
        """
        if timestamp is None:
            timestamp = datetime.now()
        
        self.regen_data.append(regen_power)
        self.regen_timestamps.append(timestamp)
        
        # İstatistikleri güncelle
        self._update_regen_stats()
    
    def add_fuel_consumption_data(self, fuel_rate: float, timestamp: Optional[datetime] = None):
        """
        Yakıt tüketim verisi ekle
        
        Args:
            fuel_rate: Anlık yakıt tüketim oranı (L/h veya g/s)
            timestamp: Zaman damgası (opsiyonel)
        """
        if timestamp is None:
            timestamp = datetime.now()
        
        self.fuel_consumption_data.append(fuel_rate)
        self.fuel_timestamps.append(timestamp)
        
        # İstatistikleri güncelle
        self._update_fuel_stats()
    
    def _update_regen_stats(self):
        """Regen istatistiklerini güncelle"""
        if not self.regen_data:
            self.regen_stats = {}
            return
        
        data_list = list(self.regen_data)
        self.regen_stats = {
            'current': data_list[-1] if data_list else 0.0,
            'average': statistics.mean(data_list),
            'max': max(data_list),
            'min': min(data_list),
            'std_dev': statistics.stdev(data_list) if len(data_list) > 1 else 0.0,
            'count': len(data_list),
            'total_energy': sum(data_list) * (self.window_size / 3600.0) if self.regen_timestamps else 0.0,  # kWh (yaklaşık)
        }
    
    def _update_fuel_stats(self):
        """Yakıt tüketim istatistiklerini güncelle"""
        if not self.fuel_consumption_data:
            self.fuel_stats = {}
            return
        
        data_list = list(self.fuel_consumption_data)
        self.fuel_stats = {
            'current': data_list[-1] if data_list else 0.0,
            'average': statistics.mean(data_list),
            'max': max(data_list),
            'min': min(data_list),
            'std_dev': statistics.stdev(data_list) if len(data_list) > 1 else 0.0,
            'count': len(data_list),
            'total_consumption': sum(data_list) * (self.window_size / 3600.0) if self.fuel_timestamps else 0.0,  # L (yaklaşık)
        }
    
    def get_regen_analysis(self) -> Dict[str, Any]:
        """
        Regen analiz sonuçlarını getir
        
        Returns:
            Regen analiz dict'i
        """
        return {
            'stats': self.regen_stats.copy(),
            'recent_data': list(self.regen_data)[-10:] if len(self.regen_data) >= 10 else list(self.regen_data),
            'is_active': self.regen_stats.get('current', 0.0) > 0.1,  # 0.1 kW threshold
        }
    
    def get_fuel_analysis(self) -> Dict[str, Any]:
        """
        Yakıt tüketim analiz sonuçlarını getir
        
        Returns:
            Yakıt analiz dict'i
        """
        return {
            'stats': self.fuel_stats.copy(),
            'recent_data': list(self.fuel_consumption_data)[-10:] if len(self.fuel_consumption_data) >= 10 else list(self.fuel_consumption_data),
        }
    
    def reset(self):
        """Tüm verileri sıfırla"""
        self.regen_data.clear()
        self.regen_timestamps.clear()
        self.fuel_consumption_data.clear()
        self.fuel_timestamps.clear()
        self.regen_stats = {}
        self.fuel_stats = {}
    
    def get_summary(self) -> Dict[str, Any]:
        """Özet analiz sonuçlarını getir"""
        return {
            'regen': self.get_regen_analysis(),
            'fuel': self.get_fuel_analysis(),
            'timestamp': datetime.now().isoformat(),
        }
