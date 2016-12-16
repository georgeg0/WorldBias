###### Reading statistical file to convert it to csv ######

library(foreign)
dataset1 = read.spss('/george/Desktop/RACIAL-IAT/Race IAT.public.2015.sav', to.data.frame=TRUE)
#Get the fields that youa re interested in
dd <- dataset1[,c("D_biep.White_Good_all","countrycit","countryres")]
write.csv(dd, file='/george/Desktop/RACIAL-IAT/Race.IAT.public.2015.csv')

###### cleaning the file for unwanted entries in countrycit ######

library(plyr)
setwd("/Users/george/Desktop/pjt/RACIAL-IAT/CSV/2014-2015/")
df <- read.csv("Race.IAT.public.2015.csv", header=TRUE)
df2 <- df[!df$countrycit %in% c(". ","  ",".",".   ","    "),]
## removing an unwanted column carried over
cols.dont.want <- "X"
df3 <- df2[, ! names(df2) %in% cols.dont.want, drop = F]
write.csv(df3, "cleansed/Race.IAT.public.cleansed.2015.csv", row.names=FALSE, quote=FALSE)
count(df2, 'countrycit')

###### Combining ######

# This code is for merging the csv file
# Make sure to put all the files in a folder
setwd("/george/Desktop/pjt/RACIAL-IAT/CSV/cleansed2004-2015")
files <- list.files(pattern = "\\.csv$")
DF <-  read.csv(files[1])
for (f in files[-1]) DF <- rbind(DF, read.csv(f))   
write.csv(DF, "Race.IAT.2004-2015.csv", row.names=FALSE, quote=FALSE)

###### Getting the stats ######

setwd("/george/Desktop/pjt/RACIAL-IAT/CSV/cleansed2004-2015")
df <- read.csv("Race.IAT.2004-2015.csv", header=TRUE)
count(df, 'countrycit')

###### Remove the white spaces infront of countrycodes ######

setwd("/george/pjt/RACIAL-IAT/CSV/cleansed2004-2015")
df <- read.csv("Race.IAT.2004-2015.csv", header=TRUE)
df <- data.frame(lapply(df, trimws))
write.csv(df, "Race.IAT.2004-2015.cleansed.csv", row.names=FALSE, quote=FALSE)
dff <- count(df, 'countrycit')
write.csv(dff, "FinalStats.csv", row.names=FALSE, quote=FALSE)