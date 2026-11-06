rm(list=ls())
graphics.off()

# Install package
library(Rssa)

# Memanggil data
data = read.csv(file.choose(), header = TRUE, sep =",")
data
data = data$Suhu.Udara...C.
n = length(data); n
P = round(n*0.2, 0)
insample = data[1:(n-P)]
n1 = length(insample)

outsample = data[(n-P+1):n]
outsample

# Parameter Windown Length (L)
L = n1/2        # Trial and error (L <= N/2)
K = n1 - L + 1

# 1. Dekomposisi
##EMBEDDING##
Z = as.matrix(insample)
Z
x = embed(Z, L) ; x
id = 1:L
y = rbind(id, x)
y
w = as.matrix(y)
sort = w[, order(-w[1,])]

THankel = as.matrix(sort[-1,(1:L)])

Hankel = t(THankel)

## SVD ##
trajectory = Hankel%*%t(Hankel)
dim(trajectory)

# eigen value
e.value = eigen(trajectory)$values
e.value

total = sum(e.value)
propv = e.value/total
kumv = cumsum(propv)

# kumulatif varian data yang bisa dijelaskan dari eigenvektor
kumv

# eigen vector ## untuk penentuan grouping
e.vector = eigen(trajectory)$vectors
e.vector

# plot singular value
S = ssa(insample, L = L, kind = "1d-ssa")
S

# plot tree
plot(S)

# plot eigen vector 1D
plot(S, type = "vectors", plot.method="matplot", idx = 1:10)
# plot eigen vector 2D
plot(S, type = "paired", idx = 1:10) # (1:L-1)

# 2. Rekontruksi
## Grouping ##
r = reconstruct(S, groups = list(Trend = c(1), Season1 = c(2:3), Season2 = c(4:5), Season3 = c(6:7)))
r
plot(wcor(S, groups = list(Trend = c(1), Season1 = c(2:3), Season2 = c(4:5), Season3 = c(6:7)), len = P))

## Diagonal Averaging ##
komponen = cbind(r$Trend, r$Season1, r$Season2, r$Season3)

diagonal.averaging = rowSums(komponen)
diagonal.averaging

# Linear Recurrent Formula (LRF)
lrr.coef = lrr(S, groups = list(Trend = c(1), Season1 = c(2:3), Season2 = c(4:5), Season3 = c(6:7)), len = 12)
lrr.coef1 = lrr.coef$Trend+lrr.coef$Season1 + lrr.coef$Season2 + lrr.coef$Season3
lrr.coef1

## Recurrent Forecasting ##
forecast = rforecast(S, groups = list(Trend = c(1), Season1 = c(2:3), Season2 = c(4:5), Season3 = c(6:7)), , len = P)
forecast

hasil.forecast = as.matrix(forecast$Trend + forecast$Season1 + forecast$Season2 + forecast$Season3)
hasil.forecast

## Akurasi peramalan ##
residu = outsample - hasil.forecast
residu
MAD = (sum(abs(residu))/(length(outsample)))
MAD
MSE = (sum(residu^2)/(length(outsample)))
MSE
PEI = (residu/outsample)*100
MAPE = (sum(abs(PEI)))/(length(outsample))
MAPE

# meramalkan keseluruhan data
S.complete = ssa(data, L = L, kind = "1d-ssa")
r.complete = reconstruct(S.complete, list(Trend = c(1), Season1 = c(2:3), Season2 = c(4:5), Season3 = c(6:7)), len = 12)
komponen.complete = cbind(r.complete$Trend, r.complete$Season1., r.complete$Season2, r.complete$Season3)
diag.avr.complete = rowSums(komponen.complete)
forecast.complete = rforecast(S.complete, list(Trend = c(1), Season1 = c(2:3), Season2 = c(4:5), Season3 = c(6:7)), len = 12)
hasil.forecast.complete = as.matrix(forecast.complete$Trend + forecast.complete$Season1 + forecast.complete$Season2 + forecast.complete$Season3)
hasil.forecast.complete

## Plot
# Data aktual complete:
data.complete = as.matrix(data)
data.comp.kosong = matrix(NA, 12)
data.comp.gab = rbind(data.complete, data.comp.kosong)
dim(data.comp.gab)

# Data prediksi complete
data.pred.comp = as.matrix(diag.avr.complete)
data.pred.kosong = matrix(NA, 12)
data.pred.gab = rbind(data.pred.comp, data.pred.kosong)
dim(data.pred.gab)

# Data forecast menggunakan data aktual complete
forecast.kosong = matrix(NA, n)
forecast.gab = rbind(forecast.kosong, hasil.forecast.complete)
dim(forecast.gab)

# Grafik hasil peramalan
ts.plot(cbind(data.comp.gab, data.pred.gab, forecast.gab), main = paste("Suhu data Aktual, Prediction & Forecasting by SSA"), col = c("blue", "red", "orange"))
legend("bottomright", c("Aktual", "Prediction", "Forecasting"), col = c("blue", "red", "orange"), lty = c(1, 1, 1), cex = 0.7)

