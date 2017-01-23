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
  dataset1 = read.spss(fileNames[fileNumber], to.data.frame=TRUE)
  #dataset1 <- data.frame(as.data.set(spss.system.file(file.path(dataloc,fileNames[fileNumber]))))
  #Get the fields that you are interested in
  #For some reason this first column was not capitalised in my data
  #2004 ethnic 2005 ethnic 2006 ethnic ethnicityomb raceomb # ethnic2007 ethnicityomb raceomb
  #Getting raceomb from 2007 file onwards # 2006 have some issues ie if fileNumber>2
  #Ignoring "raceombmulti","ethnicityomb" for now as these fields are not present in all files
  #dd <- dataset1[,c("d_biep.white_good_all","countrycit","countryres","raceomb","raceombmulti","ethnicityomb")]
  if(fileNumber>3) {
    df <- dataset1[,c("D_biep.White_Good_all","countrycit","countryres","raceomb")]
    colnames(df)[which(names(df) == "raceomb")] <- "ethnic"
  } else { 
    df <- dataset1[,c("D_biep.White_Good_all","countrycit","countryres","ethnic")]
  }
  write.csv(dd, file=file.path('data',csvFileName))
}

#race = White:6, ethnicity = White:5

###### cleaning the file for unwanted entries in countrycit ######

if(!require(plyr)){install.packages("plyr")} 
library(plyr)
fileNames <- Sys.glob(paste("*.", "csv", sep = ""))
fileNumbers <- seq(fileNames)

for (fileNumber in fileNumbers)
{
  #csvFileName <-  paste(sub(paste("\\.", "csv", sep = ""), "", fileNames[fileNumber]),".", "csv", sep = "")
  df = read.csv(file.path(fileNames[fileNumber]), header=TRUE)
  df2 <- df[!df$countrycit %in% c(". ","  ",".",".   ","    "),]
###### Remove the white spaces infront of countrycodes ######
  df22 <- data.frame(lapply(df2, trimws))
  ## removing an unwanted column carried over
  cols.dont.want <- "X"
  df3 <- df22[, ! names(df22) %in% cols.dont.want, drop = F]
  xx <- sprintf("cleansed/%s",fileNames[fileNumber])
  write.csv(df3, xx, row.names=FALSE, quote=FALSE)
}

######Additional processing for 2015 file######

## Seperating 2015 file to new format and old format files ##

library(plyr)
setwd("/george/Desktop/RACIAL-IAT/data/cleansed")
df <- read.csv("RaceIAT_public_2015.csv", header=TRUE)
df2 <- df[grepl(pattern="[[:digit:]]", df$countrycit)|grepl(pattern="[[:digit:]]", df$countryres), ]
dfdig <- df2[!grepl(pattern="-9", df2$countrycit), ]
dfalp <- df[grepl(pattern="[[:alpha:]]", df$countrycit) & !grepl(pattern="[[:digit:]]", df$countryres), ]
write.csv(dfdig, "RaceIAT_public_2015_digit.csv", row.names=FALSE, quote=FALSE)
write.csv(dfalp, "RaceIAT_public_2015_alpha.csv", row.names=FALSE, quote=FALSE)
#Deleting the old file to replace with the processed file
fn <- "RaceIAT_public_2015.csv"
if (file.exists(fn)) file.remove(fn)

###### Merging or mapping the files #######

setwd("/george/Desktop/RACIAL-IAT/data/cleansedtest")
library(plyr)
library(dplyr)
# Processing the new format files
datafile2015="RaceIAT_public_2015_digit.csv"
df1 <- read.csv("/Users/ggittu/Desktop/mappers/Mapper.txt",header=T,sep="\t")
df11 <- read.csv("/Users/ggittu/Desktop/mappers/Ethnic.txt",header=T,sep="\t")
dfdig <- read.csv(file.path('/george/Desktop/RACIAL-IAT/data/cleansedtest',datafile2015), header=TRUE)
(map <- setNames(df1$countrycitcode, df1$countrycit))
if (file.exists(fn)) file.remove(datafile2015)
dfdig[c("countrycit", "countryres")] <- lapply(dfdig[c("countrycit", "countryres")],function(x) map[as.character(x)])
#race = White:6, ethnicity = White:5
(map1 <- setNames(df11$ethniccode, df11$ethnic))
dfdig[c("ethnic")] <- lapply(dfdig[c("ethnic")],function(x) map1[as.character(x)])
if (file.exists(datafile2015)) file.remove(datafile2015)

# Processing the old format files
datafile2015="RaceIAT_public_2015_alpha.csv"
df1 <- read.csv("/Users/ggittu/Desktop/mappers/Mapper.txt",header=T,sep="\t")
df11 <- read.csv("/Users/ggittu/Desktop/mappers/Ethnic.txt",header=T,sep="\t")
dfalp <- read.csv(file.path('/george/Desktop/RACIAL-IAT/data/cleansedtest',datafile2015), header=TRUE)
(map <- setNames(df1$countrycitcode, df1$countrycit))
if (file.exists(fn)) file.remove(datafile2015)
#race = White:6, ethnicity = White:5
(map1 <- setNames(df11$ethniccode, df11$ethnic))
dfalp[c("ethnic")] <- lapply(dfalp[c("ethnic")],function(x) map1[as.character(x)])
df2015 <- rbind(dfdig,dfalp)
write.csv(df2015,"RaceIAT_public_2015.csv",row.names=FALSE, quote=FALSE)
if (file.exists(datafile2015)) file.remove(datafile2015)

###### Combining ######

# This code is for merging the csv file
# Make sure to put all the files in a folder specified in variable dataloc
#
# - assumes files are CSV, but they are in .SAV from the OSF page
#
#
setwd("/george/Desktop/RACIAL-IAT/data/cleansed")
#files <- list.files(path=dataloc, pattern = "\\.csv$")
files <- list.files(pattern = "\\.csv$")
DF <-  read.csv(files[1])
for (f in files[-1]) DF <- rbind(DF, read.csv(f))   
write.csv(DF, "Race.IAT.2004-2015.csv", row.names=FALSE, quote=FALSE)

###### Getting the stats ######

setwd("/george/Desktop/pjt/RACIAL-IAT/CSV/cleansed2004-2015")
df <- read.csv("Race.IAT.2004-2015.csv", header=TRUE)
count(df, 'countrycit')

###### filter the data by white respondants only ######

# Make more sense, allowing better comparison x-country

setwd("/george/Desktop/RACIAL-IAT/data/cleansedtest")
library(plyr)
library(dplyr)
datafile2015="Race.IAT.2004-2015.csv"
df <- read.csv(file.path('/george/Desktop/RACIAL-IAT/data/cleansedtest',datafile2015), header=TRUE)
#df2 <- df[grep("White-Not of Hispanic Origin|Black", df$raceomb), ]
dfwhite <- df[which(df$ethnic == "White-Not of Hispanic Origin"|df$ethnic == "White"), ]
write.csv(dfwhite, "Race.IAT.2004-2015-white.csv", row.names=FALSE, quote=FALSE)

###### filter the Europe ######
setwd("/george/Desktop/RACIAL-IAT/data/cleansed")
library(plyr)
library(dplyr)
datafile2015="Race.IAT.2004-2015-white.csv"
df <- read.csv(file.path('/george/Desktop/RACIAL-IAT/data/cleansed',datafile2015), header=TRUE)
dfeurope <- df[grep("AL|AD|AT|BY|BE|BA|BG|HR|CZ|DK|EE|FI|FR|DE|GR|HU|IS|IE|IT|LV|LI|LT|LU|MT|MD|MC|ME|MK|AN|NL|NO|PL|PT|RO|RU|SM|RS|SK|SI|ES|SE|CH|UA|UK", df$countrycit), ]
write.csv(dfeurope, "Race.IAT.2004-2015-white-europe.csv", row.names=FALSE, quote=FALSE)

############# Finding the stats
library(plyr)
df <- read.csv(file.path('/george/Desktop/RACIAL-IAT/data/cleansed',"Race.IAT.2004-2015-white-europe.csv"), header=TRUE)
dfstats <- count(df,"countrycit")
write.csv(dfstats, "Race.IAT.2004-2015-white-europe-stats.csv", row.names=FALSE, quote=FALSE)

############# Finding aggregate in Europe
setwd("/george/Desktop/RACIAL-IAT/data/cleansed")
gtd <- read.csv("Race.IAT.2004-2015-white-europe.csv")
dfagg <- aggregate(D_biep.White_Good_all~countrycit,gtd,mean)
write.csv(dfagg, "Race.IAT.2004-2015-white-europe-aggregate.csv", row.names=FALSE, quote=FALSE)