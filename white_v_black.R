## Compare white europeans with black europeans


# set path for where data is

if(TRUE) {
  setwd("/home/tom/Dropbox/WorldBias") #tom's computer
  dataloc='/home/tom/Dropbox/university/expts/WorldBias/data' #where a folder called /raw is
} else { 
  setwd("/george/Desktop/RACIAL-IAT/")
  dataloc='/george/Desktop/RACIAL-IAT/data/cleansedtest'
}


datafile="Race.IAT.2004-2015.csv"
df <- read.csv(file.path(dataloc,datafile), header=TRUE)
#df2 <- df[grep("White-Not of Hispanic Origin|Black", df$raceomb), ]
dfwhite <- df[which(df$ethnic == "White-Not of Hispanic Origin"|df$ethnic == "White"), ]
dfblack <- df[which(df$ethnic == "Black-Not of Hispanic Origin"|df$ethnic == "Black"), ]
dfother <- df[which(df$ethnic != "White-Not of Hispanic Origin"&df$ethnic != "White"), ]

dfeurope_w <- dfwhite[grep("AL|AD|AT|BY|BE|BA|BG|HR|CZ|DK|EE|FI|FR|DE|GR|HU|IS|IE|IT|LV|LI|LT|LU|MT|MD|MC|ME|MK|AN|NL|NO|PL|PT|RO|RU|SM|RS|SK|SI|ES|SE|CH|UA|UK", dfwhite$countrycit), ]
dfeurope_b <- dfblack[grep("AL|AD|AT|BY|BE|BA|BG|HR|CZ|DK|EE|FI|FR|DE|GR|HU|IS|IE|IT|LV|LI|LT|LU|MT|MD|MC|ME|MK|AN|NL|NO|PL|PT|RO|RU|SM|RS|SK|SI|ES|SE|CH|UA|UK", dfblack$countrycit), ]
dfeurope_o <- dfother[grep("AL|AD|AT|BY|BE|BA|BG|HR|CZ|DK|EE|FI|FR|DE|GR|HU|IS|IE|IT|LV|LI|LT|LU|MT|MD|MC|ME|MK|AN|NL|NO|PL|PT|RO|RU|SM|RS|SK|SI|ES|SE|CH|UA|UK", dfother$countrycit), ]

# Write the raw by ethnicity data
write.csv(dfeurope_w, file.path(dataloc,"full-white-europe.csv"), row.names=FALSE, quote=FALSE)
write.csv(dfeurope_b, file.path(dataloc,"full-black-europe.csv"), row.names=FALSE, quote=FALSE)
write.csv(dfeurope_o, file.path(dataloc,"full-other-europe.csv"), row.names=FALSE, quote=FALSE)



dfstats_w <- count(dfeurope_w,countrycit)
dfstats_b <- count(dfeurope_b,countrycit)
dfstats_o <- count(dfeurope_o,countrycit)

###### Finding aggregate in Europe ######

# Create a DF with mean IAT and SD for respective country
ag_w <- aggregate(D_biep.White_Good_all~countrycit, dfeurope_w, function(x) c(mean = mean(x), sd = sd(x)))
ag_b <- aggregate(D_biep.White_Good_all~countrycit, dfeurope_b, function(x) c(mean = mean(x), sd = sd(x)))
ag_o <- aggregate(D_biep.White_Good_all~countrycit, dfeurope_o, function(x) c(mean = mean(x), sd = sd(x)))

# Join the stats df and ag df
constat_w <- join(ag_w, dfstats_w, type = "inner")
constat_b <- join(ag_b, dfstats_b, type = "inner")
constat_o <- join(ag_o, dfstats_o, type = "inner")

# Calculate the standard error field
constat_w$err <- constat_w$D_biep.White_Good_all[,c("sd")]/sqrt(constat_w$n)
constat_b$err <- constat_b$D_biep.White_Good_all[,c("sd")]/sqrt(constat_b$n)
constat_o$err <- constat_o$D_biep.White_Good_all[,c("sd")]/sqrt(constat_o$n)

constat_w[!(constat_w$n<100),]

# Write the consolidated file with Mean IAT score, country code, SD, SE and sample size (Good file to get Idea of data points)
write.csv(constat_w, file.path(dataloc,"stats-white-europe.csv"), row.names=FALSE, quote=FALSE)
write.csv(constat_b, file.path(dataloc,"stats-black-europe.csv"), row.names=FALSE, quote=FALSE)
write.csv(constat_o, file.path(dataloc,"stats-other-europe.csv"), row.names=FALSE, quote=FALSE)


constat_w <- constat_w[(constat_w$countrycit!='SM'),]

white <- constat_w[order(constat_w$D_biep.White_Good_all[,1]),]
not_w <- constat_o[order(constat_w$D_biep.White_Good_all[,1]),]


plot(white$D_biep.White_Good_all[,1],col="red")
points(not_w$D_biep.White_Good_all[,2],col="black")



