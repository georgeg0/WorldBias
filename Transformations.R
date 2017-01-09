###### Reading raw data files (spss) to convert it to consolidated refined csv file ######

# Citation for data
# Xu, K., Nosek, B., & Greenwald, A. (2014). Psychology data from the race implicit association test on the project implicit demo website. Journal of Open Psychology Data, 2(1).
# openpsychologydata.metajnl.com/articles/10.5334/jopd.ac/ 

# visit https://osf.io/52qxl/ to acquire the following data files
# 'Race IAT.public.2004.sav',
# 'Race IAT.public.2009.sav',
# 'Race IAT.public.2014.sav',
# 'Race IAT.public.2011.sav',
# 'Race IAT.public.2013.sav',
# 'Race IAT.public.2008.sav',
# 'Race IAT.public.2012.sav',
# 'Race IAT.public.2010.sav',
# 'Race IAT.public.2005.sav',
# 'Race IAT.public.2006.sav',
# 'Race IAT.public.2015.sav',
# 'Race IAT.public.2007.sav'

# Specify location of these files below, by setting dataloc variable


library(foreign)

# ---------- Setting Path
if(TRUE) {
  setwd("/home/tom/Dropbox/WorldBias") #tom's laptop
  dataloc='/home/tom/Dropbox/university/expts/WorldBias/data/raw/'
} else { 
  setwd("/george/Desktop/RACIAL-IAT/")
  dataloc='/george/Desktop/RACIAL-IAT/'
}

# ---------- load raw data
#dataset1 = read.spss(file.path(dataloc,'Race IAT.public.2015.sav'), to.data.frame=TRUE)

if(!require(memisc)){install.packages("memisc", repos="http://R-Forge.R-project.org")} 
library("memisc")
fileNames <- Sys.glob(paste("*.", "sav", sep = ""))
fileNumbers <- seq(fileNames)
# Loop for..
# 1) Iteratively get all the raw statistical file from 'raw' folder 
# 2) Generate csv file and put under 'data' folder for further processing
for (fileNumber in fileNumbers)
{
  csvFileName <-  paste(sub(paste("\\.", "sav", sep = ""), "", fileNames[fileNumber]),".", "csv", sep = "")
  dataset1 <- data.frame(as.data.set(spss.system.file(file.path(dataloc,fileNames[fileNumber]))))
  #Get the fields that you are interested in
  #For some reason this first column was not capitalised in my data
  dd <- dataset1[,c("d_biep.white_good_all","countrycit","countryres","raceomb","raceombmulti","ethnicityomb")]
  write.csv(dd, file=file.path('data',csvFileName))
}

#race = White:6, ethnicity = White:5

###### cleaning the file for unwanted entries in countrycit ######

if(!require(plyr)){install.packages("plyr")} 
library(plyr)

#setwd("/Users/george/Desktop/pjt/RACIAL-IAT/CSV/2014-2015/")
#because we are loading a file created by this script, I haven't respected the old data organisation (i.e. I changed the folder names)

df <- read.csv(file.path('data',datafile2015), header=TRUE)
df2 <- df[!df$countrycit %in% c(". ","  ",".",".   ","    "),]
## removing an unwanted column carried over
cols.dont.want <- "X"
df3 <- df2[, ! names(df2) %in% cols.dont.want, drop = F]
write.csv(df3, "data/Race.IAT.public.cleansed.2015.csv", row.names=FALSE, quote=FALSE)
count(df2, 'countrycit')

###### Combining ######

# This code is for merging the csv file
# Make sure to put all the files in a folder specified in variable dataloc
#
# - assumes files are CSV, but they are in .SAV from the OSF page
#
#

setwd("/george/Desktop/pjt/RACIAL-IAT/CSV/cleansed2004-2015")
files <- list.files(path=dataloc, pattern = "\\.csv$")
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
