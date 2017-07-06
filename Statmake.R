###### 
#
#This piece of code creates scatter plot for Avg IAT vs Sample size, Helps to better understand the data
#
######
library(plyr)



# ---------- Set path for a) where this file is and b) where the data is
if(FALSE) {
  setwd("/home/tom/Dropbox/WorldBias") #tom's computer
  dataloc='/home/tom/Dropbox/university/expts/WorldBias/data' #where a folder called /raw is
} else { 
  setwd("/Users/ggeorge/Desktop/WorldBiasNew")
  dataloc='/george/Desktop/RACIAL-IAT/data'
}

#Reading the consolidated stats CSV file for Europe
constat <- read.csv(file.path(dataloc,"Consolidatedstat.2004-2015-white-europe.csv"))

IATScore = constat$D_biep.White_Good_all.mean
freq = constat$n
serr = constat$err

#This doesn't work
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
# library(zoom)
# zm()

### Try this to easly zoom and explore the points
#library(scatterD3)
#scatterD3(x = constat$freq, y = constat$D_biep.White_Good_all[,c("mean")],lab = constat$countrycit, labels_size = 9)