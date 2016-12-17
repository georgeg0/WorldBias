# Initial Cut of World Implicit Bias Project
# (c) George Gittu & Tom Stafford 2016

# ----------libraries

library(rgdal)        #for readOGR
library(ggplot2)
library(foreign)
library(plyr)
library(raster)


# ---------- get data
#You will need to download the RDS file from Git LFS directly
#gtd <- read.spss("/Users/ggittu/Desktop/PjtImplicit/Race IAT.public.2002-2015.sav", to.data.frame=TRUE)
gtd <- readRDS("RaceIAT.public.2002-2015.rds")

# ---------- data munging
gtd.recent <- aggregate(D_biep.White_Good_all~country,gtd,mean)


# --------- draw map
world <- readOGR(dsn=path.expand("/Users/ggittu/Desktop/WorldBiasProject"),layer="world_country_admin_boundary_shapefile_with_fips_codes")
ggplot() +  geom_polygon(data=world, aes(x=long, y=lat, group=group))
countries <- world@data
countries <- cbind(id=rownames(countries),countries)
countries <- merge(countries,gtd.recent, 
                   by.x="FIPS_CNTRY", by.y="country", all.x=T)
map.df <- fortify(world)
map.df <- merge(map.df,countries, by="id")

ggplot(map.df, aes(x=long,y=lat,group=group)) +
  geom_polygon(aes(fill=D_biep.White_Good_all))
