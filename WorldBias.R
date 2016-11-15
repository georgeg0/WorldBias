# Initial Cut of World Implicit Bias Project
library(rgdal)        #for readOGR
library(ggplot2)
library(foreign)
library(plyr)
library(raster)
#gtd <- read.spss("/Users/ggittu/Desktop/PjtImplicit/Race IAT.public.2002-2015.sav", to.data.frame=TRUE)
gtd <- readRDS("/Users/ggittu/Desktop/WorldBiasProject/RaceIAT.public.2002-2015.rds")
gtd.recent <- aggregate(D_biep.White_Good_all~country,gtd,mean)
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
