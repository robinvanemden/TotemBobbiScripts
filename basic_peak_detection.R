# ----------- Totem Bobbi basic data analysis in R ------------
# ----------- Code: Robin van Emden, http://pavlov.tech  ------
# ----------- Bobbi: http://www.totemopenhealth.com/ ----------

library(ggplot2)
library(wavelets)

# ----------------- Load data, set vars  ----------------------

# set home directory to this file's directory
setwd("C:\\Users\\robin\\PycharmProjects\\TotemHeartRate")

# import the short sample data file
bobbi.df <- read.table("data\\8-sdataHR_sample.csv", sep=";", header=T)

# add an index
bobbi.df$idx <- seq.int(nrow(bobbi.df))

# plot the data
ggplot(data = bobbi.df, aes(x = ms, y = hart)) + geom_line()

# create subset df
df <- data.frame(bobbi.df$idx,bobbi.df$hart)
names(df) <- c("idx", "ecg")

# set the sample frequency
SampleFreq <- 500

# threshold
thr <- 12

# -----------------   Do peak detection  ----------------------
# ------- Adapted from: https://tinyurl.com/n3tw7lc -----------


# 4-level decomposition is used with the Daubechie d4 wavelet.
wavelet <- "d4"
level <- 4L

X <- as.numeric(df$ecg)

ecg_wav <- dwt(X, filter=wavelet, n.levels=level, boundary="periodic", fast=TRUE)
str(ecg_wav)

oldpar <- par(mfrow = c(2,2), mar = c(4,4,1.5,1.5) + 0.1)
plot(ecg_wav@W$W1, type = "l")
plot(ecg_wav@W$W2, type = "l")
plot(ecg_wav@W$W3, type = "l")
plot(ecg_wav@W$W4, type = "l")
par(oldpar)

oldpar <- par(mfrow = c(2,2), mar = c(4,4,1.5,1.5) + 0.1)
plot(ecg_wav@V$V1, type = "l")
plot(ecg_wav@V$V2, type = "l")
plot(ecg_wav@V$V3, type = "l")
plot(ecg_wav@V$V4, type = "l")
par(oldpar)

# Coefficients of the second level of decomposition are used for R peak detection.
x <- ecg_wav@W$W2

# Empty vector for detected R peaks
R <- matrix(0,1,length(x))

# While loop for sweeping the L2 coeffs for local maxima.
i <- 2
while (i < length(x)-1) {
  if ((x[i]-x[i-1]>=0) && (x[i+1]-x[i]<0) && x[i]>thr) {
    R[i] <- i
  }
  i <- i+1
}

# Clear all zero values from R vector.
R <- R[R!=0]
Rtrue <- R*4

# Checking results on the original signal
for (k in 1:length(Rtrue)){
  if (Rtrue[k] > 10){
    Rtrue[k] <- Rtrue[k]-10+(which.max(X[(Rtrue[k]-10):(Rtrue[k]+10)]))-1
  } else {
    Rtrue[k] <- which.max(X[1:(Rtrue[k]+10)])
  }
}

Rtrue <- unique(Rtrue)
Rtrue_idx <- df$idx[Rtrue]

# add peaks to df
df$is_peak <- data.frame(df$idx %in% Rtrue_idx)
df$peak_value <- df$is_peak
df$peak_value[df$peak_value == TRUE] <- df$ecg[df$peak_value == TRUE]

rr_dist_total <- Rtrue_idx[length(Rtrue_idx)] - Rtrue_idx[1]
rr_dist_avg <- rr_dist_total/(length(Rtrue_idx)-1)
rr_ms_avg <- rr_dist_avg * 1000/SampleFreq
beats_per_second <- 1000/rr_ms_avg
beats_per_minute <- round(beats_per_second * 60,digits=2)

dev.off()

# plot the data
ggplot(df, aes(x = idx)) + 
  ylim(450, 620) + 
  geom_line(aes(y = ecg), colour="blue") + 
  geom_point(aes(y = peak_value), colour = "red") +
  ggtitle(  paste("Bobbi heart rate", beats_per_minute, "bpm", sep=" ") ) + 
  theme(plot.title = element_text(lineheight=.8, face="bold"))
