###### 
#
#This piece of code creates scatter plot for Avg IAT vs Sample size, Helps to better understand the data
#
######
library(plyr)

# Read the stat file of european countries  (sample size)
df2 <- read.csv("/george/Desktop/RACIAL-IAT/data/cleansedtest/Race.IAT.2004-2015-white-europe-stats.csv")
setwd("/george/Desktop/RACIAL-IAT/data/cleansedtest")

#Reading the consolidated CSV file for Europe
gtd <- read.csv("Race.IAT.2004-2015-white-europe.csv")

# Create a DF with mean IAT and SD for respective country
ag <- aggregate(D_biep.White_Good_all~countrycit, gtd, function(x) c(mean = mean(x), sd = sd(x)))

# Join the stats df and ag df
constat <- join(ag, df2,
                type = "inner")

# Calculate the standard error field
constat$err <- constat$D_biep.White_Good_all[,c("sd")]/sqrt(constat$freq)

# Write the consolidated file with Mean IAT score, country code, SD, SE and sample size (Good file to get Idea of data points)
#write.csv(constat, "Consolidatedstat.2004-2015-white-europe.csv", row.names=FALSE, quote=FALSE)
# TAking out countries with n< 100
constat <- constat[-c(42,27,23,3,29,1,25), ]

IATScore = constat$D_biep.White_Good_all[,c("mean")]
freq = constat$freq
serr = constat$err

plot(freq, IATScore,
     ylim=range(c(IATScore-serr, IATScore+serr)),
     pch=19, xlab="Sample Size", ylab="Mean IAT Score",
     main="Avg IAT vs Sample Size"
)
text(freq, IATScore,
     labels=constat$countrycit, 
     cex= 0.7, pos=2)

# to get the error intervals, Take out the comment if interested in that
#arrows(freq, IATScore-serr, freq, IATScore+serr, length=0.05, angle=90, code=3)

# Use to explore the plot
library(zoom)
zm()

### Try this to easly zoom and explore the points
#library(scatterD3)
#scatterD3(x = constat$freq, y = constat$D_biep.White_Good_all[,c("mean")],lab = constat$countrycit, labels_size = 9)