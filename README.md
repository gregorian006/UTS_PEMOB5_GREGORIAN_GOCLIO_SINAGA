# Kuis Nusantara

Aplikasi kuis pilihan ganda seputar wawasan Indonesia, dibuat dengan Flutter untuk UTS Lab Pemrograman Mobile.

## Identitas Mahasiswa

| | |
|---|---|
| Nama | Gregorian Goclio Sinaga |
| NIM | 241401087 |
| Lab | PM _(isi nomor lab)_ |

## Informasi Aplikasi

### Nama Aplikasi
Kuis Nusantara

### Deskripsi Singkat
Kuis Nusantara mengajak pengguna menguji wawasan tentang Indonesia. Pengguna memasukkan nama, memilih kategori (Sejarah, Geografi, atau Budaya & Kuliner), menjawab 5 soal pilihan ganda, lalu melihat skor akhir beserta pembahasan setiap soal.

### Fitur
- **Input nama pemain** dengan validasi (nama wajib diisi).
- **3 kategori kuis** dengan bank 10 soal per kategori (total 30). Setiap permainan mengambil 5 soal acak, jadi soal berganti tiap kali "Main Lagi".
- **Navigasi soal**: tombol Sebelumnya/Berikutnya dan nomor soal untuk melompat langsung, dengan penanda soal yang sudah dijawab.
- **Progres tersimpan**: jawaban tidak hilang saat layar dirotasi atau saat kembali ke beranda. Beranda menampilkan kartu "Lanjutkan kuis".
- **Timer 20 detik per soal**: hitung mundur berubah merah saat tersisa 5 detik. Jika habis, soal dikunci dan otomatis pindah ke soal berikutnya. Sisa waktu tersimpan saat rotasi dan berhenti saat kembali ke beranda.
- **Konfirmasi** sebelum menyelesaikan kuis bila masih ada soal kosong, dan sebelum menimpa kuis yang belum selesai.
- **Halaman hasil** dengan konfeti saat skor sempurna, animasi skor, jumlah benar/salah/kosong, serta pesan sesuai nilai.
- **Saran belajar**: di halaman hasil, daftar topik yang perlu dipelajari lagi berdasarkan soal yang salah atau kosong.
- **Halaman pembahasan**: jawaban benar dan salah ditandai warna, lengkap dengan penjelasan.
- **Papan skor** berisi 5 skor tertinggi selama aplikasi berjalan.
- **Ikon aplikasi & splash screen** kustom (mendukung mode gelap).
- **Dark & light mode** (mengikuti sistem, bisa diganti lewat tombol di AppBar).
- **Responsif & adaptif**: ukuran elemen proporsional terhadap layar; tablet, landscape, dan web memakai tata letak dua kolom.

### Penerapan Kriteria

| Kriteria | Implementasi |
|---|---|
| StatelessWidget & StatefulWidget | Stateful: `HomeScreen` (form + `TextEditingController`), `QuizScreen` (mulai/jeda timer), `ResultScreen` (`ConfettiController`). Stateless: `ReviewScreen` dan semua widget reusable |
| Minimal 2 halaman + navigasi | 4 halaman (Beranda, Kuis, Hasil, Pembahasan) dengan named routes |
| Reusable widget | `lib/widgets/` (`OptionTile`, `CategoryCard`, `AppButton`, `StatTile`, dll.) |
| Aset gambar/ikon | Ilustrasi SVG di `assets/images/` + Material Icons |
| Font kustom | Poppins via `google_fonts` |
| UI dinamis | `lib/utils/responsive.dart`: ukuran dihitung dari ukuran layar (`context.rs(...)`) |
| State management | `provider` (`QuizProvider`, `ThemeProvider`) diletakkan di atas `MaterialApp` |
| Tanpa database | Data soal lokal di `lib/data/quiz_data.dart` |

### Struktur Proyek

```
lib/
├── main.dart              # entry point, provider, tema, routes
├── data/quiz_data.dart    # bank soal (dummy)
├── models/                # Question, QuizCategory, ScoreRecord
├── providers/             # QuizProvider, ThemeProvider
├── screens/               # home, quiz, result, review
├── theme/app_theme.dart   # tema terang & gelap
├── utils/responsive.dart  # helper ukuran responsif
└── widgets/               # widget reusable
```

## Menjalankan

```bash
flutter pub get
flutter run            # emulator / perangkat
flutter run -d chrome  # web
flutter test           # unit test QuizProvider
```

## Dokumentasi

### Credit Aset
- **Font**: [Poppins](https://fonts.google.com/specimen/Poppins) oleh Indian Type Foundry, lisensi SIL Open Font License, melalui paket [google_fonts](https://pub.dev/packages/google_fonts).
- **Ikon**: [Material Icons](https://fonts.google.com/icons) oleh Google, lisensi Apache 2.0.
- **Ilustrasi** (`logo.svg`, `trophy.svg`, `sejarah.svg`, `geografi.svg`, `budaya.svg`): dibuat sendiri.
- **Ikon aplikasi & splash** (`assets/icon/`): dibuat sendiri.
- **Paket**: [provider](https://pub.dev/packages/provider), [flutter_svg](https://pub.dev/packages/flutter_svg), [confetti](https://pub.dev/packages/confetti), [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons), [flutter_native_splash](https://pub.dev/packages/flutter_native_splash).

### Screenshot

| Beranda | Kuis | Hasil | Pembahasan |
|---|---|---|---|
| ![Beranda](screenshots/home.png) | ![Kuis](screenshots/quiz.png) | ![Hasil](screenshots/result.png) | ![Pembahasan](screenshots/review.png) |

### Mockup / Prototype
_(tambahkan link Figma di sini)_
