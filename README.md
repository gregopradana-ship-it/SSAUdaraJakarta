# Dashboard SSA untuk suhu udara Jakarta

Dashboard interaktif berisi hasil analisis Singular Spectrum Analysis (SSA) pada data suhu udara bulanan Jakarta, Juli 2013 sampai Juni 2023. Seluruh hasil sudah tertanam di satu file HTML, jadi cukup dibuka di browser tanpa server atau instalasi apa pun.

## Cara membuka

1. Unduh atau clone repositori ini.
2. Buka `index.html` dengan browser modern (Chrome, Firefox, Edge, Safari).

Dashboard memuat Chart.js dan font Plus Jakarta Sans dari CDN, jadi perlu koneksi internet saat pertama kali dibuka. Tanpa internet, grafik tidak akan tampil.

Kalau ingin menampilkannya sebagai halaman web, aktifkan GitHub Pages dari menu Settings > Pages dengan sumber branch utama dan folder root. Halaman akan tersedia di alamat yang ditampilkan GitHub di menu tersebut.

## Parameter analisis

| Parameter | Nilai |
| --- | --- |
| Data | Suhu udara bulanan, Jul 2013 sampai Jun 2023 (n = 120) |
| Data in-sample | 96 bulan |
| Data out-sample | 24 bulan (Jul 2021 sampai Jun 2023) |
| Window length (L) | 48 |
| Jumlah kolom lintasan (K) | 49 |
| Periode peramalan | 12 bulan (Jul 2023 sampai Jun 2024) |

Pengelompokan komponen yang dipakai: Trend = komponen 1, Seasonal 1 = komponen 2 dan 3, Seasonal 2 = komponen 4 dan 5, Seasonal 3 = komponen 6 dan 7. Komponen 8 sampai 10 diperlakukan sebagai noise.

## Ringkasan hasil

- Trend (eigenvalue pertama) menjelaskan sekitar 99,95% varians. Ketiga pasang komponen musiman masing masing di bawah 0,03%.
- Akurasi out-sample 24 bulan: MAPE 3,33%, MAD 0,888 °C, MSE 1,251.
- Korelasi W antar grup sangat kecil (maksimum sekitar 0,05), sehingga keempat grup terpisah dengan baik.
- Ramalan Jul 2023 sampai Jun 2024 berada di rentang 26,20 sampai 27,54 °C, dengan puncak pada September 2023.
- Sebagian besar residu out-sample bernilai negatif, artinya ramalan cenderung lebih tinggi dari data aktual.

## Isi dashboard

Dashboard dibagi menjadi tujuh bagian yang bisa dibuka lewat menu navigasi di bagian atas.

1. Data dan parameter: plot data aktual, statistik deskriptif, dan parameter SSA.
2. Dekomposisi: scree plot, tabel eigenvalue (48 komponen), eigenvector 1D, dan eigenvector 2D berpasangan.
3. Grouping dan W-correlation: matriks korelasi antar grup dan antar komponen 1 sampai 10.
4. Rekonstruksi dan diagonal averaging: komponen hasil grouping, perbandingan dengan data aktual, residu in-sample, dan koefisien Linear Recurrent Formula (LRF).
5. Peramalan: komponen ramalan 12 bulan dan tabel hasilnya.
6. Akurasi out-sample: perbandingan aktual dan ramalan, residu, rincian per bulan, kontribusi tiap komponen, dan temuan utama.
7. Tabel lengkap: aktual, tiap komponen, rekonstruksi, dan residu untuk seluruh 120 bulan.

## Fitur

- Tombol tema di pojok kanan atas untuk berpindah antara mode terang dan gelap. Tema awal mengikuti pengaturan perangkat.
- Menu "Tampilkan grafik" pada setiap grafik untuk menyembunyikan atau menampilkan masing masing seri.
- Menu pilihan komponen dan pasangan pada bagian eigenvector. Tabel di bawah grafik ikut berubah mengikuti pilihan.
- Tampilan menyesuaikan lebar layar, termasuk di ponsel.

## Struktur file

```
.
├── index.html   # dashboard lengkap (HTML, CSS, JavaScript, dan data)
└── README.md
```

Data hasil SSA disimpan sebagai objek JavaScript bernama `D` di dalam tag `<script>` pada `index.html`. Untuk mengganti data atau hasil analisis, ubah isi objek tersebut. Kolom yang dipakai antara lain `x` (data aktual), `fit` (rekonstruksi), `fc` (ramalan), `ev` (eigenvalue), `U` (eigenvector), `lrr` (koefisien LRF), dan `wg` serta `wi` (matriks W-correlation).

## Sumber data dan perhitungan

Hasil dihitung dengan kode R memakai paket Rssa, lalu diekspor ke dashboard ini. Angka di dashboard sudah dicocokkan dengan keluaran R.

## Teknologi

- HTML, CSS, dan JavaScript tanpa framework
- [Chart.js](https://www.chartjs.org/) 4.4.1 untuk grafik
- Font Plus Jakarta Sans dari Google Fonts
