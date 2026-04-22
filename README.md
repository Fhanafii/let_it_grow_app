# 🌿 Let It Grow - Smart Plant Monitoring System

**Let It Grow** adalah sistem ekosistem IoT terintegrasi yang memungkinkan pengguna memantau kesehatan tanaman secara real-time.  

Proyek ini mencakup:
- Perangkat keras berbasis **Wemos D1 Mini**
- Server bridge **MQTT → Supabase**
- Aplikasi mobile modern berbasis **Flutter**

---

## 🚀 Fitur Utama

- 🔐 **Google Authentication**  
  Login aman menggunakan akun Google melalui Supabase Auth  

- 📡 **Real-time Monitoring**  
  Grafik kelembapan tanah (soil moisture) diperbarui secara instan via MQTT over WebSockets  

- 🔌 **Dynamic Device Setup**  
  Integrasi perangkat menggunakan WiFiManager dengan pembuatan kredensial MQTT otomatis  

- 🌿 **Interactive Plant Animation**  
  Animasi tanaman (240 frame) yang responsif terhadap interaksi pengguna  

- 🌤️ **Weather Integration**  
  Menampilkan suhu lingkungan menggunakan OpenWeather API & Geolocator  

- 🎮 **Health System (XP)**  
  Sistem progres untuk meningkatkan engagement pengguna  

- 🛠️ **Troubleshooting Guide**  
  Panduan interaktif untuk membantu saat perangkat offline  

---

## 🛠️ Arsitektur Teknologi

### 📱 1. Mobile App (Flutter)

Menggunakan arsitektur **MVVM (Model-View-ViewModel)** untuk pemisahan logic dan UI.

- State Management: Provider & ChangeNotifier  
- Database & Auth: Supabase Flutter  
- Visualisasi: fl_chart  
- UI/UX: Custom Bottom Navigation (CustomPainter + SVG)  

---

### ☁️ 2. Backend & Server (Ubuntu VPS)

- MQTT Broker: Mosquitto v2.0 (Dynamic Security / DynSec)  
- Secure Tunnel: Cloudflare Tunnel (WSS - Port 443)  
- Bridge Script: Python (paho-mqtt & supabase-py) sebagai systemd service  

---

### 🔌 3. Firmware (Wemos D1 Mini)

- Library:
  - WiFiManager  
  - ArduinoJson  
  - WebSocketsClient  
  - MQTTPubSubClient  

- Fitur:
  - Koneksi WSS Secure  
  - Penyimpanan kredensial di LittleFS  
  - Reset fisik via tombol GPIO  

---

## 📦 Dependencies (Flutter)

| Dependency         | Kegunaan                                      |
|------------------|-----------------------------------------------|
| supabase_flutter | Database, Auth, dan Realtime Stream           |
| provider         | State management & dependency injection       |
| fl_chart         | Grafik kelembapan (0–1024)                    |
| flutter_svg      | Rendering ikon berbasis vektor                |
| geolocator       | Mendapatkan lokasi pengguna                   |
| http             | API request ke OpenWeatherMap                 |
| flutter_dotenv   | Manajemen environment variables               |

---

## ⚙️ Cara Instalasi (Development)

### 📋 Prasyarat

- Flutter SDK (versi terbaru)  
- Akun Supabase  
- API Key OpenWeatherMap  

---

### 🚀 Langkah-langkah

1. **Clone Repository**
```bash
git clone https://github.com
cd project-folder
```
2. **Buat file .env di root project**
```bash
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
OPENWEATHER_API_KEY=your_api_key
```
3. **Install Dependencies**
```bash
flutter pub get
```
4. **Jalankan Aplikasi**
```bash
flutter run
```

## 🔒 Keamanan Data
- 🔐 Row Level Security (RLS) : Membatasi akses data hanya untuk pengguna terkait
- 📡 MQTT Access Control (ACL) : Setiap perangkat hanya bisa publish ke topik miliknya sendiri
