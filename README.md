# Peramalan Suhu Udara Jakarta dengan Singular Spectrum Analysis (SSA)

Analisis dan peramalan suhu udara bulanan Jakarta menggunakan metode **Singular Spectrum Analysis (SSA)** dengan pendekatan *Recurrent Forecasting*, lengkap dengan dashboard interaktif untuk menampilkan seluruh tahapan dan hasilnya.

## Isi Repositori

| File | Deskripsi |
|------|-----------|
| `SSA.r` | Kode R: dekomposisi, grouping, rekonstruksi, peramalan, dan perhitungan akurasi |
| `DataUdaraJakarta.csv` | Data suhu udara bulanan Jakarta (Jul 2013 – Jun 2023, 120 observasi) |
| `Dashboard_SSA___Suhu_Udara_Jakarta_v4.html` | Dashboard interaktif hasil analisis (cukup dibuka di browser) |

## Data

- **Kolom:** `Entity`, `Tanggal`, `Suhu Udara (°C)`
- **Periode:** Juli 2013 – Juni 2023 (data bulanan, n = 120)
- **Pembagian data:** 96 observasi *in-sample* (80%) dan 24 observasi *out-sample* (20%)
- Data sudah dikoreksi dan tidak mengandung nilai tidak wajar.

## Metode

1. **Embedding**: membentuk matriks lintasan (trajectory matrix) dengan *window length* L = 48 (K = 49).
2. **Dekomposisi (SVD)**: eigenvalue dan eigenvector dari matriks lintasan.
3. **Grouping** berdasarkan eigenvector dan W-correlation:

   | Grup | Eigentriple |
   |------|-------------|
   | Trend | 1 |
   | Season 1 | 2–3 |
   | Season 2 | 4–5 |
   | Season 3 | 6–7 |

4. **Rekonstruksi** dengan *diagonal averaging*.
5. **Peramalan** dengan *Linear Recurrent Formula* (LRF) dan *recurrent forecasting*.
6. **Evaluasi** menggunakan MAD, MSE, dan MAPE pada data out-sample.
7. **Peramalan 12 bulan ke depan** (Juli 2023 – Juni 2024) menggunakan seluruh data.

## Hasil Utama

| Metrik (out-sample) | Nilai |
|---------------------|-------|
| MAPE | 3,33% |
| MAD | 0,888 °C |
| MSE | 1,251 |

- Komponen **Trend** menjelaskan sekitar **99,95%** varians data.
- Ramalan Juli 2023 – Juni 2024 berkisar **26,20 – 27,54 °C**.

## Cara Menjalankan

### Kode R

Prasyarat: R dan paket [`Rssa`](https://cran.r-project.org/package=Rssa).

```r
install.packages("Rssa")
```

1. Buka `SSA.r` di RStudio.
2. Jalankan skrip dari baris pertama. Skrip membuka jendela pemilihan file, lalu pilih `DataUdaraJakarta.csv`.
3. Pastikan pemisah kolom sesuai dengan file CSV. File ini memakai koma, jadi gunakan:

   ```r
   data = read.csv(file.choose(), header = TRUE, sep = ",")
   ```

> **Catatan:** jika muncul error `$ operator is invalid for atomic vectors`, artinya baris `data = data$Suhu.Udara...C.` dijalankan lebih dari sekali. Jalankan ulang skrip dari awal (`rm(list=ls())`).

> **Catatan:** pada bagian peramalan keseluruhan data, tulis `r.complete$Season1` (tanpa titik di akhir). Jika ada titik (`Season1.`), komponen Season 1 tidak ikut dijumlahkan pada garis *Prediction*.

### Dashboard

Buka `Dashboard_SSA___Suhu_Udara_Jakarta_v4.html` langsung di browser, tanpa instalasi.

Fitur dashboard:
- Ringkasan KPI, statistik deskriptif, dan tabel eigenvalue.
- Grafik eigenvector 1D dan 2D dengan tabel nilai eigen.
- Grouping, W-correlation, dan kontribusi komponen.
- Rekonstruksi, koefisien LRF, dan peramalan 12 bulan.
- Menu **Tampilkan grafik** pada setiap grafik untuk memilih seri yang ditampilkan.
- Mode terang dan gelap.

Untuk membagikan dashboard secara online, aktifkan **GitHub Pages** (Settings → Pages) lalu pilih branch utama.

## Struktur Folder

```
.
├── README.md
├── SSA.r
├── DataUdaraJakarta.csv
└── Dashboard_SSA___Suhu_Udara_Jakarta_v4.html
```

## Referensi

- Golyandina, N., Nekrutkin, V., & Zhigljavsky, A. (2001). *Analysis of Time Series Structure: SSA and Related Techniques*. Chapman & Hall/CRC.
- Korobeynikov, A. *Rssa: A Collection of Methods for Singular Spectrum Analysis*. R package.

## Penulis

`Gregorius Adiyatma Pradana`
