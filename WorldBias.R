# Initial Cut of World Implicit Bias Project
# (c) George Gittu & Tom Stafford 2016

# ----------libraries

library(rgdal)        #for readOGR
library(ggplot2)
library(foreign)
library(plyr)
library(raster)
#Give which map to draw WORLD or EUROPE map
whichmap = "EUROPE"

if(whichmap == "EUROPE") {
  # ---------- Setting Path
  setwd("/george/Desktop/RACIAL-IAT/data/cleansedtest")
  Maptitle = "Implicit Bias Europe"
  
  # ---------- get data
  #Reading the consolidated CSV file
  gtd <- read.csv("Race.IAT.2004-2015-white-europe.csv")
  world      <- readOGR(dsn=path.expand("/Users/ggittu/Downloads/europenew"),layer="Europe")
  
  # Reevaluating country codes to match the country code in IAT file
  world@data$ORGN_NAME <- as.character (revalue(world@data$ORGN_NAME, replace=c("Shqipëria"="AL","Andorra"="AD","Österreich"="AT","België / Belgique"="BE","Bosna i Hercegovina"="BA","Hrvatska"="HR","Cesko"="CZ","Danmark"="DK","Eesti"="EE","Suomi"="FI","France"="FR","Deutschland"="DE","Elláda"="GR","Magyarország"="HU","Éire / Ireland"="IE","Italia"="IT","Latvija"="LV","Liechtenstein"="LI","Lietuva"="LT","Lëtzebuerg / Luxemburg / Luxembourg"="LU","Makedonija"="MK","Malta"="MT","Monaco"="MN","Crna Gora"="ME","Nederland"="NL","Norge"="NO","Polska"="PL","Portugal"="PT","San Marino"="SM","Srbija"="RS","Slovensko"="SK","Slovenija"="SI","España"="ES","Sverige"="SE","Schweiz / Suisse / Svizerra / Svizra"="CH","United Kingdom"="UK","Belarus"="BY","Balgarija"="BG","Ísland"="IS","Moldova"="MD","România"="RO","Ukrajina"="UA","Rossíya"="RU")))
  colnames(world@data)[which(names(world@data) == "ORGN_NAME")] <- "FIPS_CNTRY"
} else { 
  # ---------- Setting Path
  setwd("/george/Desktop/RACIAL-IAT/data/cleansedtest")
  
  Maptitle = "Implicit Bias World"
  # ---------- get data
  #Reading the consolidated CSV file
  gtd <- read.csv("Race.IAT.2004-2015-white.csv")
  world      <- readOGR(dsn=path.expand("/Users/ggittu/Documents/WorldBias/WorldMapShapes"),layer="world_country_admin_boundary_shapefile_with_fips_codes")
  
  # Reevaluating country codes to match the country code in IAT file
  world@data$FIPS_CNTRY <- as.character (revalue(world@data$FIPS_CNTRY, replace=c(AA="AW",AC="AG",AG="DZ",AJ="AZ",AN="AD",AQ="AS",AS="AU",AU="AT",AV="AI",AY="AQ",BA="BH",BC="BW",BD="BM",BF="BS",BG="BD",BH="BZ",BK="BA",BL="BO",BN="BJ",BO="BY",BP="SB",BU="BG",BX="BN",BY="BI",CB="KH",CD="TD",CE="LK",CF="CG",CG="CD",CH="CN",CI="CL",CJ="KY",CK="CC",CN="KM",CQ="MP",CS="CR",CT="CF",CW="CK",DO="DM",DR="DO",DA="DK",EI="IE",EK="GQ",EN="EE",ES="SV",EZ="CZ",FG="GF",FP="PF",FQ="XXX",FS="TF",GA="GM",GB="GA",GG="GE",GJ="GD",GK="XX",GM="DE",GO="XX",GQ="GU",GV="GN",GZ="XX",HA="HT",HO="HN",HQ="XX",IC="IS",IM="XX",IS="XX",IV="CI",IZ="IQ",JA="JP",JE="XX",JN="XX",JQ="XX",JU="XX",KN="KP",KR="KI",KS="KR",KT="CX",KU="KW",LE="LB",LG="LV",LH="LT",LI="LR",LO="SK",LS="LI",LT="LS",MA="MG",MB="MQ",MF="YT",MG="MN",MH="MS",MI="MW",MN="MC",MO="MA",MP="MU",MQ="XX",MU="OM",MW="XXX",NE="NU",NG="NE",NH="VU",NI="NG",NL="NL",NS="SR",NT="XXX",NU="NI",PA="PY",PC="PN",PF="XX",PG="XX",PM="PA",PO="PT",PP="PG",PS="PW",PU="GW",RM="MH",RP="PH",RQ="PR",RS="RU",SB="PM",SC="KN",SE="SC",SF="ZA",SG="SN",SN="SG",SP="ES",SR="XXX",ST="LC",SU="SD",SV="SJ",SW="SE",SX="GS",SZ="CH",TD="TT",TI="TJ",TK="TC",TL="TK",TM="XXX",TN="TO",TO="TG",TP="ST",TS="TN",TU="TR",TX="TM",UP="XXX",UV="BF",VI="VG",VM="VN",VQ="VI",VT="VA",WA="NA",WE="XX",WI="XX",WQ="XX",WZ="SZ",YM="YE",ZA="ZM",ZI="ZW",UP="UA")))
}

# ---------- data munging
gtd.recent <- aggregate(D_biep.White_Good_all~countrycit,gtd,mean)

# --------- draw map

ggplot() +  geom_polygon(data=world, aes(x=long, y=lat, group=group))
countries <- world@data
countries <- cbind(id=rownames(countries),countries)
countries <- merge(countries,gtd.recent, 
                   by.x="FIPS_CNTRY", by.y="countrycit", all.x=T)
map.df <- fortify(world)
map.df <- merge(map.df,countries, by="id")
MapDraw <- ggplot(data = map.df, aes(x=long, y=lat, group = group, fill = D_biep.White_Good_all))+
  geom_polygon()  +
  coord_equal() +
  theme(axis.title = element_blank(), axis.text = element_blank()) + scale_fill_gradient(high = "springgreen4", low= "grey90",limits = c(.29, .45))+
  labs(title = Maptitle, fill = "IAT Score")

print(MapDraw)