# ----------- Totem Bobbi basic data analysis in R ------------
# ----------- Code: Robin van Emden, http://pavlov.tech  ------
# ----------- Bobbi: http://www.totemopenhealth.com/ ----------

###############################################################
# import bobbi data
###############################################################

# set home directory to this file's directory
setwd("C:\\Users\\robin\\PycharmProjects\\TotemHeartRate")

# import the short sample data file
bobbi.df <- read.table("data\\8-sdataHR_sample.csv", sep=";", header=T)
str(bobbi.df)

###############################################################
# Lets plot the data
###############################################################

# let's see what we've got
tp <- plot(bobbi.df[,c("hart")], type="l", col="blue")
print(tp)