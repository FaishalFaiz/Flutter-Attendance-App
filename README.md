# 📱 Attendance App — Kehadiran Karyawan

Aplikasi **presensi karyawan** modern berbasis Flutter dengan dua peran pengguna: **Karyawan** dan **Admin/HR**. Proyek ini berfokus pada **UI/UX** dan menggunakan **data dummy (mock)** — tidak ada backend, database, atau penyimpanan permanen.

> **Status:** Purwarupa antarmuka (UI prototype). Semua aksi bersifat simulasi.

---

## Daftar Isi

- [Tentang Proyek](#tentang-proyek)
- [Fitur](#fitur)
- [Tech Stack](#tech-stack)
- [Prasyarat](#prasyarat)
- [Instalasi](#instalasi)
- [Menjalankan Aplikasi](#menjalankan-aplikasi)
- [Login Demo](#login-demo)
- [Struktur Proyek](#struktur-proyek)
- [Pendekatan Teknis](#pendekatan-teknis)
- [Tema & Desain](#tema--desain)
- [Data Mock](#data-mock)
- [Lokalisasi](#lokalisasi)
- [Troubleshooting](#troubleshooting)

---

## Tentang Proyek

Attendance App adalah aplikasi manajemen kehadiran karyawan yang mencakup alur kerja utama sebuah perusahaan:

- Karyawan melakukan **presensi masuk/keluar** dengan **selfie** dan validasi **geofence** (radius 100 m dari kantor).
- Karyawan mengajukan **cuti/izin** dan **lembur**.
- Admin/HR mengelola **data karyawan**, **shift kerja**, **persetujuan cuti/lembur**, serta melihat **laporan kehadiran**.

Aplikasi dirancang **mobile-first**, tetapi juga dapat dijalankan di **web** dan **tablet**. Layout kartu bersifat responsif: saat ruang sempit, ikon dan teks otomatis ditata vertikal agar tidak terpotong.

---

## Fitur

### 👤 Karyawan

| Fitur | Deskripsi |
|-------|-----------|
| **Beranda** | Ringkasan status kehadiran (hadir/terlambat/cuti), aksi cepat, dan aktivitas terbaru. |
| **Presensi** | Check-in/check-out dengan mock selfie, mock GPS, dan indikator geofence 100 m. |
| **Aksi Cepat** | Kartu Masuk, Keluar, Cuti, dan Lembur langsung membuka halaman terkait. |
| **Cuti & Izin** | Form pengajuan dengan jenis cuti (tahunan, sakit, pribadi, melahirkan, kawin, izin), tanggal mulai/selesai, dan alasan. |
| **Status Pengajuan** | Daftar riwayat cuti/lembur beserta status (menunggu/disetujui/ditolak). |
| **Lembur** | Form pengajuan lembur dengan jam dan alasan; menunggu persetujuan admin. |
| **Profil** | Data karyawan (NIK, jabatan, departemen, shift, kontak). |
| **Pengaturan** | Toggle notifikasi, pilihan bahasa, UI biometrik, info versi, dan logout. |
| **Notifikasi** | Daftar notifikasi presensi, cuti, dan lembur. |
| **Biometrik** | Antarmuka aktivasi biometrik (simulasi). |

### 🛡️ Admin / HR

| Fitur | Deskripsi |
|-------|-----------|
| **Dasbor** | Statistik total karyawan, hadir, terlambat, cuti, dan tidak hadir; daftar persetujuan tertunda. |
| **Manajemen Karyawan** | Daftar karyawan, pencarian, dan detail data karyawan. |
| **Manajemen Shift** | Pengaturan shift kerja (pagi/siang/malam) beserta jam kerja. |
| **Persetujuan** | Approve/reject pengajuan cuti dan lembur. |
| **Laporan** | Ringkasan kehadiran per karyawan dengan filter status dan tombol **Export PDF (mock)**. |

### 🌐 Umum

- **Login mock** dengan pemilihan peran (Karyawan / Admin-HR).
- **Bilingual** — teks antarmuka tersedia dalam Bahasa Indonesia dan Inggris melalui `AppLocalizations`.
- **Light mode only** dengan brand color modern blue `#2563EB`.
- **Bottom Navigation Bar** sesuai peran.
- **State management sederhana** — hanya `setState`, tanpa package state management.
- **Responsif** — kartu statistik & menu menyesuaikan lebar layar.

---

## Tech Stack

| Komponen | Keterangan |
|----------|------------|
| **Framework** | Flutter (Material 3) |
| **Bahasa** | Dart |
| **Font** | [Google Fonts — Inter](https://fonts.google.com/specimen/Inter) |
| **Format tanggal** | [`intl`](https://pub.dev/packages/intl) |
| **Ikon** | Material Icons + `cupertino_icons` |
| **State** | `StatefulWidget` + `setState` |
| **Data** | Dummy data lokal (`lib/data/dummy_data.dart`) |

Dependensi yang digunakan (lihat `pubspec.yaml`):

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  intl: ^0.20.1
  google_fonts: ^6.1.0
```

> Tidak ada Firebase, HTTP client, database lokal, maupun package state management.

---

## Prasyarat

Pastikan lingkungan pengembangan sudah siap:

1. **Flutter SDK** dengan **Dart `^3.12.2`**.
   - Proyek ini diuji pada **Flutter 3.47.9** dan **Dart 3.13.7**.
   - Cek versi:
     ```bash
     flutter --version
     ```
2. **Git** (opsional, untuk clone repositori).
3. Untuk menjalankan di perangkat:
   - **Android**: Android Studio + Android SDK + emulator/perangkat fisik dengan **USB debugging** aktif.
   - **Web**: browser Chrome/Edge.
   - **iOS/macOS**: Xcode (khusus macOS).
4. Jalankan `flutter doctor` dan pastikan tidak ada masalah kritis:
   ```bash
   flutter doctor
   ```

---

## Instalasi

1. **Clone repositori** (atau ekstrak folder proyek):

   ```bash
   git clone <URL_REPOSITORI> attendance_app
   cd attendance_app
   ```

2. **Ambil dependensi**:

   ```bash
   flutter pub get
   ```

3. **(Opsional) Periksa kode** untuk memastikan tidak ada error kompilasi:

   ```bash
   flutter analyze
   ```

---

## Menjalankan Aplikasi

### 🌐 Web (paling cepat untuk mencoba)

```bash
flutter run -d chrome
```

Atau build versi statis:

```bash
flutter build web
```

Hasil build ada di `build/web/` dan dapat disajikan dengan web server statis apa pun.

### 🤖 Android

1. Hubungkan perangkat atau jalankan emulator:
   ```bash
   flutter devices
   ```
2. Jalankan aplikasi:
   ```bash
   flutter run
   ```
3. Untuk build APK:
   ```bash
   flutter build apk --release
   ```

> Jika perangkat tidak terdeteksi, pastikan **USB debugging** aktif dan izin RSA sudah disetujui di perangkat.

### 🖥️ Desktop (Windows/macOS/Linux)

```bash
flutter run -d windows
```

> Folder platform `android/`, `ios/`, `web/`, `windows/`, `linux/`, dan `macos/` sudah tersedia.

### 📱 Tablet

Tidak perlu konfigurasi khusus. Layout akan menyesuaikan lebar layar; kartu statistik dan menu otomatis beralih ke susunan vertikal saat ruang sempit.

---

## Login Demo

Tidak ada autentikasi sungguhan. Login hanya mensimulasikan peran:

1. Pilih peran pada tombol segmentasi: **Karyawan** atau **Admin / HR**.
2. Isi **username/NIK** dan **password** dengan teks apa pun (tidak divalidasi terhadap data).
3. Tekan **Masuk**.

Setelah ±1 detik, aplikasi akan membuka tampilan sesuai peran yang dipilih.

> Untuk berpindah peran, logout melalui **Profil → Pengaturan → Keluar** (atau menu logout yang tersedia), lalu login kembali.

---

## Struktur Proyek

```
attendance_app/
├── assets/
│   ├── images/                 # Aset gambar (siap pakai)
│   └── raw/                    # Aset mentah
├── lib/
│   ├── main.dart               # Entry point, inisialisasi intl, routing awal
│   ├── core/
│   │   ├── l10n/
│   │   │   └── app_localizations.dart   # Kamus ID/EN + helper t()
│   │   └── theme/
│   │       └── app_theme.dart           # Tema Material 3, warna brand & status
│   ├── data/
│   │   ├── dummy_data.dart              # Seluruh data mock
│   │   └── models/
│   │       ├── employee.dart
│   │       ├── attendance_record.dart
│   │       ├── leave_request.dart
│   │       ├── overtime_request.dart
│   │       └── notification_item.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── splash_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   └── role_wrapper_screen.dart # IndexedStack + bottom nav per peran
│   │   ├── employee/
│   │   │   ├── home_screen.dart
│   │   │   ├── attendance_screen.dart
│   │   │   ├── leave_request_screen.dart
│   │   │   ├── leave_status_screen.dart
│   │   │   ├── overtime_request_screen.dart
│   │   │   ├── profile_screen.dart
│   │   │   ├── settings_screen.dart
│   │   │   └── notifications_screen.dart
│   │   └── admin/
│   │       ├── dashboard_screen.dart
│   │       ├── employee_management_screen.dart
│   │       ├── shift_management_screen.dart
│   │       ├── leave_approval_screen.dart
│   │       ├── reports_screen.dart
│   │       └── admin_profile_screen.dart
│   └── widgets/
│       └── shared/
│           ├── stat_card.dart           # Kartu statistik responsif
│           ├── menu_card.dart           # Kartu menu aksi
│           ├── attendance_card.dart
│           ├── status_chip.dart
│           ├── custom_app_bar.dart
│           ├── bottom_nav_bar.dart
│           └── responsive_wrapper.dart
├── test/
│   └── widget_test.dart        # Boilerplate pengujian Flutter
├── pubspec.yaml
└── README.md
```

---

## Pendekatan Teknis

- **Tanpa backend** — semua data berasal dari `lib/data/dummy_data.dart`.
- **Tanpa state management eksternal** — navigasi dan state lokal menggunakan `setState`.
- **Navigasi**:
  - Rute awal (`/` → splash, `/login` → login) didefinisikan di `main.dart`.
  - Setelah login, `RoleWrapperScreen` menampilkan halaman sesuai peran menggunakan `IndexedStack` + `BottomNavigationBar`.
  - Halaman detail (presensi, cuti, lembur, pengaturan) dibuka dengan `Navigator.push`.
- **Data model** dipisahkan per file di `lib/data/models/` agar mudah diganti dengan model API di masa depan.
- **Helper tanggal** menggunakan `intl`, dengan inisialisasi locale `id_ID` di `main()`:
  ```dart
  await initializeDateFormatting('id_ID', null);
  ```
  Ini mencegah `LocaleDataException` saat memformat tanggal berbahasa Indonesia.

---

## Tema & Desain

Tema terpusat di `lib/core/theme/app_theme.dart`:

| Token | Nilai |
|-------|-------|
| Brand / Primary | `#2563EB` (modern blue) |
| Primary dark | `#1D4ED8` |
| Background | `#F8FAFC` |
| Surface / Card | `#FFFFFF` |
| Text primary | `#0F172A` |
| Text secondary | `#64748B` |
| Hadir | `#10B981` (green) |
| Terlambat | `#F59E0B` (amber) |
| Cuti/Izin | `#3B82F6` (blue) |
| Tidak hadir | `#EF4444` (red) |

Karakteristik UI:

- **Material 3**, sudut membulat (12–24 px), bayangan halus.
- **Font Inter** melalui `google_fonts`.
- **Light mode only** (`themeMode: ThemeMode.light`).
- Kartu statistik (`StatCard`) dan kartu menu (`MenuCard`) memiliki mode **compact/vertikal** saat lebar terbatas, sehingga teks tidak terpotong di layar HP sempit.
- Baris statistik memakai `IntrinsicHeight` agar semua kartu dalam satu baris memiliki tinggi seragam.

---

## Data Mock

Data contoh berada di `lib/data/dummy_data.dart`, meliputi:

- **6 karyawan** dengan NIK, jabatan, departemen, shift, foto (via `pravatar.cc`), email, dan telepon.
- **Riwayat presensi** (hadir, terlambat, cuti, tidak hadir).
- **Pengajuan cuti** dan **lembur** dengan berbagai status.
- **Notifikasi** contoh.
- **Lokasi kantor** dan **radius geofence**:
  ```dart
  static const String officeLocation = 'Gedung Utama, Jl. Sudirman No. 123, Jakarta';
  static const double officeLatitude = -6.2088;
  static const double officeLongitude = 106.8456;
  static const double geofenceRadius = 100; // meter
  ```

Foto karyawan diambil dari URL eksternal (`https://i.pravatar.cc/...`), sehingga **koneksi internet diperlukan** agar avatar tampil. Jika offline, avatar akan menampilkan warna latar fallback.

---

## Lokalisasi

- Kamus teks ID/EN ada di `lib/core/l10n/app_localizations.dart`.
- `AppLocalizations.of(context)` membaca `Localizations.localeOf(context)` dan memilih kamus sesuai `languageCode` (`id` atau `en`).
- Gunakan helper berikut di widget:
  ```dart
  final l10n = AppLocalizations.of(context);
  Text(l10n.t('login'));
  ```
- Bahasa mengikuti **locale perangkat**. Jika perangkat berbahasa Indonesia, UI tampil dalam Bahasa Indonesia; jika tidak, tampil dalam Bahasa Inggris.
- Proyek ini **tidak** memakai package `flutter_localizations`; widget Material bawaan (mis. date picker) tetap menggunakan locale default.

---

## Troubleshooting

| Masalah | Solusi |
|---------|--------|
| `flutter: command not found` | Tambahkan `flutter/bin` ke `PATH`, lalu buka terminal baru. |
| `LocaleDataException` | Pastikan `initializeDateFormatting('id_ID', null)` dipanggil di `main()` sebelum `runApp`. |
| `No MaterialLocalizations found` | Jangan menambahkan `localizationsDelegates`/`supportedLocales` dengan delegate Global tanpa package `flutter_localizations`. |
| Perangkat Android tidak terdeteksi | Aktifkan USB debugging, jalankan `flutter devices`, dan setujui prompt RSA. |
| Build web gagal / cache aneh | Jalankan `flutter clean`, lalu `flutter pub get` dan build ulang. |
| Layout terpotong di layar sempit | Pastikan komponen baru mengikuti pola responsif `StatCard`/`MenuCard` dan hindari tinggi tetap pada konten teks. |
| Dependensi tidak sinkron | Hapus `pubspec.lock` (opsional), lalu `flutter pub get`. |

Perintah pembersihan yang aman:

```bash
flutter clean
flutter pub get
```

---

## Catatan

- Proyek ini dibuat untuk **keperluan pembelajaran / demonstrasi UI**, bukan untuk produksi.
- Semua tombol aksi (presensi, pengajuan, approve/reject, export PDF, biometrik) merupakan **simulasi** dan tidak menyimpan data.
- Untuk menjadikannya aplikasi nyata, langkah berikutnya adalah menambahkan backend/API, autentikasi, penyimpanan lokal, kamera & GPS asli, serta notifikasi push.
