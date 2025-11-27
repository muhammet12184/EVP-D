package com.yourapp

/**
 * ❌ SORUN: Butonlar çalışmıyor / tıklanamıyor
 * 
 * OLASI SEBEPLER VE ÇÖZÜMLER:
 */

// ============================================================
// SEBEP 1: OnClickListener tanımlanmamış
// ============================================================

// ❌ YANLIŞ - Listener yok
class WrongExample1 : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        val button = findViewById<Button>(R.id.connectButton)
        // Listener eksik!
    }
}

// ✅ DOĞRU - Listener tanımla
class CorrectExample1 : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        val button = findViewById<Button>(R.id.connectButton)
        button.setOnClickListener {
            // Buton tıklandığında çalışacak kod
            connectBluetooth()
        }
    }
}

// ============================================================
// SEBEP 2: View Binding kullanıyorsanız ama yanlış
// ============================================================

// ❌ YANLIŞ - binding.root setContentView'da yok
class WrongExample2 : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        // setContentView(binding.root) UNUTULMUŞ!
        
        binding.connectButton.setOnClickListener {
            // ÇALIŞMAZ!
        }
    }
}

// ✅ DOĞRU
class CorrectExample2 : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)  // ← BU ŞART!
        
        binding.connectButton.setOnClickListener {
            connectBluetooth()
        }
    }
}

// ============================================================
// SEBEP 3: Üstte görünmez bir View var (tıklamayı engelliyor)
// ============================================================

// XML'de kontrol edin:
/*
<!-- ❌ YANLIŞ - FrameLayout üstte ve tıklamayı engelliyor -->
<FrameLayout
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:clickable="true">  <!-- BU SATIR SORUNU -->
    
    <Button android:id="@+id/connectButton" ... />
</FrameLayout>

<!-- ✅ DOĞRU -->
<FrameLayout
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:clickable="false">
    
    <Button android:id="@+id/connectButton" ... />
</FrameLayout>
*/

// ============================================================
// SEBEP 4: Button enabled=false veya clickable=false
// ============================================================

// XML'de kontrol edin:
/*
<!-- ❌ YANLIŞ -->
<Button
    android:id="@+id/connectButton"
    android:enabled="false"
    android:clickable="false" />

<!-- ✅ DOĞRU -->
<Button
    android:id="@+id/connectButton"
    android:enabled="true"
    android:clickable="true" />
*/

// Veya kodda:
fun enableButton() {
    val button = findViewById<Button>(R.id.connectButton)
    button.isEnabled = true
    button.isClickable = true
}

// ============================================================
// SEBEP 5: Main Thread bloklanıyor
// ============================================================

// ❌ YANLIŞ - UI thread'i bloklayan kod
class WrongExample5 : AppCompatActivity() {
    fun connectBluetooth() {
        // Bu ana thread'i bloklar, butonlar donmuş gibi görünür
        Thread.sleep(5000)
        val result = heavyOperation()
    }
}

// ✅ DOĞRU - Arka planda çalıştır
class CorrectExample5 : AppCompatActivity() {
    fun connectBluetooth() {
        // Coroutine ile arka planda çalıştır
        lifecycleScope.launch(Dispatchers.IO) {
            val result = heavyOperation()
            
            withContext(Dispatchers.Main) {
                // UI güncelle
                updateUI(result)
            }
        }
    }
}

// ============================================================
// SEBEP 6: Fragment'ta view null
// ============================================================

// ❌ YANLIŞ - onCreateView'da view hazır değil
class WrongFragment : Fragment() {
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val view = inflater.inflate(R.layout.fragment_main, container, false)
        
        // BU SATIR SORUNLU OLABİLİR
        view.findViewById<Button>(R.id.connectButton).setOnClickListener {
            // ...
        }
        
        return view
    }
}

// ✅ DOĞRU - onViewCreated'da yap
class CorrectFragment : Fragment() {
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_main, container, false)
    }
    
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        view.findViewById<Button>(R.id.connectButton).setOnClickListener {
            connectBluetooth()
        }
    }
}

// ============================================================
// ÇÖZÜM: TAM ÇALIŞAN ÖRNEK
// ============================================================

import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : AppCompatActivity() {

    private lateinit var connectButton: Button
    private lateinit var scanButton: Button
    private lateinit var disconnectButton: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // View'ları bul
        initViews()
        
        // Listener'ları ayarla
        setupListeners()
    }

    private fun initViews() {
        connectButton = findViewById(R.id.connectButton)
        scanButton = findViewById(R.id.scanButton)
        disconnectButton = findViewById(R.id.disconnectButton)
        
        // Butonların aktif olduğundan emin ol
        connectButton.isEnabled = true
        scanButton.isEnabled = true
        disconnectButton.isEnabled = true
    }

    private fun setupListeners() {
        connectButton.setOnClickListener {
            Toast.makeText(this, "Bağlanıyor...", Toast.LENGTH_SHORT).show()
            onConnectClicked()
        }

        scanButton.setOnClickListener {
            Toast.makeText(this, "Taranıyor...", Toast.LENGTH_SHORT).show()
            onScanClicked()
        }

        disconnectButton.setOnClickListener {
            Toast.makeText(this, "Bağlantı kesiliyor...", Toast.LENGTH_SHORT).show()
            onDisconnectClicked()
        }
    }

    private fun onConnectClicked() {
        // Arka planda çalıştır - UI donmaz
        lifecycleScope.launch(Dispatchers.IO) {
            try {
                // Bluetooth bağlantı işlemi
                // bluetoothService.connect()
                
                withContext(Dispatchers.Main) {
                    Toast.makeText(this@MainActivity, "Bağlandı!", Toast.LENGTH_SHORT).show()
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    Toast.makeText(this@MainActivity, "Hata: ${e.message}", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }

    private fun onScanClicked() {
        lifecycleScope.launch(Dispatchers.IO) {
            // Tarama işlemi
        }
    }

    private fun onDisconnectClicked() {
        lifecycleScope.launch(Dispatchers.IO) {
            // Bağlantı kesme işlemi
        }
    }
}
