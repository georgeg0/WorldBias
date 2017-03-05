# Initial Cut of World Implicit Bias Project
# (c) George Gittu & Tom Stafford 2016

# ----------libraries

library(rgdal)        #for readOGR
library(ggplot2)
library(foreign)
library(plyr)
library(raster)
library(maps)
library(mapdata)
library(modify)

#Give which map to draw WORLD or EUROPE map
whichmap = "EUROPE"

if(whichmap == "EUROPE") {
  # ---------- Setting Path
  setwd("/george/Desktop/RACIAL-IAT/data/cleansedtest")
  Maptitle = "Implicit Bias Europe"
  
  # ---------- get data
  #Reading the consolidated CSV file
  gtd <- read.csv("Race.IAT.2004-2015-white-europe.csv")
  
  # Creating a list of European countries
  eu <- c("Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", "Czech Republic", 
          "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", 
          "Hungary", "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg", 
          "Malta", "Netherlands", "Poland", "Portugal", "Romania", "Slovakia", 
          "Slovenia", "Spain", "Sweden", "UK","Albania","Andorra","Armenia","Azerbaijan","Belarus","Bosnia and Herzegovina",
          "Georgia","Iceland","Kazakhstan","Kosovo","Liechtenstein","Macedonia","Moldova",
          "Monaco","Montenegro","Norway","San Marino","Serbia","Switzerland","Turkey","Ukraine")
  
  # creating a Europe map from the world map
  europe <- map_data('world', region=eu)
  
  # Reevaluating country name to FIPS code to match the country code in IAT file
  europe$region <- as.character (revalue(europe$region, replace=c("Austria"="AT", "Belgium"="BE", "Bulgaria"="BG", "Croatia"="HR", "Cyprus"="CY", "Czech Republic"="CZ", 
                                                                  "Denmark"="DK", "Estonia"="EE", "Finland"="FI", "France"="FR", "Germany"="DE", "Greece"="GR", 
                                                                  "Hungary"="HU", "Ireland"="IE", "Italy"="IT", "Latvia"="LV", "Lithuania"="LT", "Luxembourg"="LU", 
                                                                  "Malta"="MT", "Netherlands"="NL", "Poland"="PL", "Portugal"="PT", "Romania"="RO", "Slovakia"="SK", 
                                                                  "Slovenia"="SI", "Spain"="ES", "Sweden"="SE",
                                                                  "Albania"="AL","Andorra"="AD","Armenia"="AM","Azerbaijan"="AZ","Belarus"="BY","Bosnia and Herzegovina"="BA",
                                                                  "Georgia"="GE","Iceland"="IS","Kazakhstan"="KZ","Liechtenstein"="LI","Macedonia"="MK","Moldova"="MD",
                                                                  "Monaco"="MC","Montenegro"="ME","Norway"="NO","San Marino"="SM","Serbia"="RS","Switzerland"="CH","Turkey"="TR","Ukraine"="UA"))) 
  colnames(europe)[which(names(europe) == "region")] <- "FIPS_CNTRY"
} else { 
  # ---------- Setting Path
  setwd("/george/Desktop/RACIAL-IAT/data/cleansedtest")
  Maptitle = "Implicit Bias World"
  
  # ---------- get data
  #Reading the consolidated CSV file
  gtd <- read.csv("Race.IAT.2004-2015-white.csv")
  world      <- readOGR(dsn=path.expand("/Users/ggittu/Documents/WorldBias/WorldMapShapes"),layer="world_country_admin_boundary_shapefile_with_fips_codes")
  
  # Reevaluating country codes to match the country code in IAT file
  world@data$FIPS_CNTRY <- as.character (revalue(world@data$FIPS_CNTRY, replace=c(AA="AW",AC="AG",AG="DZ",AJ="AZ",AN="AD",AQ="AS",AS="AU",AU="AT",AV="AI",AY="AQ",BA="BH",BC="BW",BD="BM",BF="BS",BG="BD",BH="BZ",BK="BA",BL="BO",BN="BJ",BO="BY",BP="SB",BU="BG",BX="BN",BY="BI",CB="KH",CD="TD",CE="LK",CF="CG",CG="CD",CH="CN",CI="CL",CJ="KY",CK="CC",CN="KM",CQ="MP",CS="CR",CT="CF",CW="CK",DO="DM",DR="DO",DA="DK",EI="IE",EK="GQ",EN="EE",ES="SV",EZ="CZ",FG="GF",FP="PF",FQ="XXX",FS="TF",GA="GM",GB="GA",GG="GE",GJ="GD",GK="XX",GM="DE",GO="XX",GQ="GU",GV="GN",GZ="XX",HA="HT",HO="HN",HQ="XX",IC="IS",IM="XX",IS="XX",IV="CI",IZ="IQ",JA="JP",JE="XX",JN="XX",JQ="XX",JU="XX",KN="KP",KR="KI",KS="KR",KT="CX",KU="KW",LE="LB",LG="LV",LH="LT",LI="LR",LO="SK",LS="LI",LT="LS",MA="MG",MB="MQ",MF="YT",MG="MN",MH="MS",MI="MW",MN="MC",MO="MA",MP="MU",MQ="XX",MU="OM",MW="XXX",NE="NU",NG="NE",NH="VU",NI="NG",NL="NL",NS="SR",NT="XXX",NU="NI",PA="PY",PC="PN",PF="XX",PG="XX",PM="PA",PO="PT",PP="PG",PS="PW",PU="GW",RM="MH",RP="PH",RQ="PR",RS="RU",SB="PM",SC="KN",SE="SC",SF="ZA",SG="SN",SN="SG",SP="ES",SR="XXX",ST="LC",SU="SD",SV="SJ",SW="SE",SX="GS",SZ="CH",TD="TT",TI="TJ",TK="TC",TL="TK",TM="XXX",TN="TO",TO="TG",TP="ST",TS="TN",TU="TR",TX="TM",UV="BF",VI="VG",VM="VN",VQ="VI",VT="VA",WA="NA",WE="XX",WI="XX",WQ="XX",WZ="SZ",YM="YE",ZA="ZM",ZI="ZW",UP="UA")))
}

# ---------- data munging
gtd.recent <- aggregate(D_biep.White_Good_all~countrycit,gtd,mean)
# Renaming for merging
colnames(gtd.recent)[which(names(gtd.recent) == "countrycit")] <- "FIPS_CNTRY"

# --------- draw map
ggplot() +  geom_polygon(data=europe, aes(x=long, y=lat, group=group))
map.df = merge(europe, gtd.recent, by = "FIPS_CNTRY")
map.df = map.df[order(map.df$order),]

# ---------- Creating and centering labels
CountryLabel <- ddply(map.df,"FIPS_CNTRY", summarise, long = mean(long), lat = mean(lat))
CountryLabelIat <- merge(CountryLabel,gtd.recent)

# ---------- Minor adjustment of labels that dint align to centre
#library(devtools)
#install_github(repo = "modify", username = "skranz") ## Making using of a custom repo make sure to have devtools
# 
modify(CountryLabel,FIPS_CNTRY=="SE", long=long-2)
modify(CountryLabelIat,FIPS_CNTRY=="SE", long=long-2)
modify(CountryLabel,FIPS_CNTRY=="FI", long=long+2)
modify(CountryLabelIat,FIPS_CNTRY=="FI", long=long+2)
modify(CountryLabel,FIPS_CNTRY=="EE", long=long+1.5)
modify(CountryLabelIat,FIPS_CNTRY=="EE", long=long+1.5)
modify(CountryLabel,FIPS_CNTRY=="IT", long=long+2)
modify(CountryLabelIat,FIPS_CNTRY=="IT", long=long+2)
modify(CountryLabel,FIPS_CNTRY=="GR", long=long-2)
modify(CountryLabelIat,FIPS_CNTRY=="GR", long=long-2)
modify(CountryLabel,FIPS_CNTRY=="HR", lat=lat+1)
modify(CountryLabelIat,FIPS_CNTRY=="HR", lat=lat+1)
modify(CountryLabel,FIPS_CNTRY=="NO", lat=lat-8)
modify(CountryLabelIat,FIPS_CNTRY=="NO", lat=lat-8)
modify(CountryLabel,FIPS_CNTRY=="NO", long=long-6)
modify(CountryLabelIat,FIPS_CNTRY=="NO", long=long-6)
modify(CountryLabel,FIPS_CNTRY=="IS", long=long+1.5)
modify(CountryLabelIat,FIPS_CNTRY=="IS", long=long+1.5)

MapDraw <- ggplot(data = map.df)+ 
  geom_polygon(aes(x=long, y=lat, group = group, fill = D_biep.White_Good_all),color = "gray30",size=.05) +
  coord_equal() +
  #barbit to fit output guide_colorbar(barwidth=40,barheight = .5) #values for full view guide_colorbar(barwidth=72,barheight = .8)
  #legend.position=c(.5, 1)
  theme(axis.title = element_blank(),plot.title=element_text(vjust=-40,hjust=.1,size=25,face="bold"), axis.text = element_blank(),legend.position=c(.5, 1),legend.direction="horizontal")+guides(fill = guide_colorbar(barwidth=46,barheight = .8)) +
  scale_fill_gradientn(colours=c("steelblue4","steelblue3","steelblue1","snow3","firebrick1","firebrick3","firebrick4"), limits = c(.29, .45),breaks= c(.29, .37,.45))+
  geom_text(aes(x=long, y=lat-.5, label=round(D_biep.White_Good_all,digits = 3)), data=CountryLabelIat, col="black", cex=2.75,fontface = "bold")+
  geom_text(aes(x=long, y=lat, label=FIPS_CNTRY), data=CountryLabel, col="black", cex=3.75,fontface = "bold")+
  labs(title = "Mean IAT Scores of \nWhite Participants", fill = "") +
  coord_map(xlim = c(-25, 40),ylim = c(33, 72))

print(MapDraw)