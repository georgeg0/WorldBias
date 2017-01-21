# Mapping the World's Implicit Bias 
# (c) George Gittu & Tom Stafford 2016

# ----------libraries

if(!require(rgdal)){install.packages('rgdal')} 
#if you are on linux this may not be as straightfoward. This may help:
# https://philmikejones.wordpress.com/2014/07/14/installing-rgdal-in-r-on-linux/
# https://stackoverflow.com/questions/15248815/rgdal-package-installation
library(rgdal)        #for readOGR, see https://cran.r-project.org/package=rgdal

if(!require(ggplot2)){install.packages('ggplot2')} 
library(ggplot2) # graphing package

if(!require(plyr)){install.packages('plyr')} 
library(plyr) # revalue

#library(foreign) #commented because I couldn't see what this was for
#library(raster) #commented because I couldn't see what this was for

# ---------- Setting Path
if(Sys.info()[[4]]=="tom-vaio") {
    setwd("/home/tom/Desktop/WorldBias") #tom's laptop
} else { 
    setwd("/Documents/WorldBias")
}

# ---------- get data
#Reading the consolidated CSV file, IAT scores for individuals and their country codes
gtd <- read.csv("Data/Race.IAT.2004-2015-V1.csv")
cat("total sample size = ", nrow(gtd), "\n")

# ---------- data munging: find average for each country
gtd.recent <- aggregate(D_biep.White_Good_all~countrycit,gtd,mean) #means
gtd.counts <- aggregate(D_biep.White_Good_all~countrycit,gtd,length) #sample size

# --------- draw map
world <- readOGR(dsn=path.expand("WorldMapShapes"),layer="world_country_admin_boundary_shapefile_with_fips_codes")
ggplot() +  geom_polygon(data=world, aes(x=long, y=lat, group=group))
# Reevaluating country codes to match the country code in IAT file
world@data$FIPS_CNTRY <- as.character (revalue(world@data$FIPS_CNTRY, replace=c(AA="AW",AC="AG",AG="DZ",AJ="AZ",AN="AD",AQ="AS",AS="AU",AU="AT",AV="AI",AY="AQ",BA="BH",BC="BW",BD="BM",BF="BS",BG="BD",BH="BZ",BK="BA",BL="BO",BN="BJ",BO="BY",BP="SB",BU="BG",BX="BN",BY="BI",CB="KH",CD="TD",CE="LK",CF="CG",CG="CD",CH="CN",CI="CL",CJ="KY",CK="CC",CN="KM",CQ="MP",CS="CR",CT="CF",CW="CK",DO="DM",DR="DO",DA="DK",EI="IE",EK="GQ",EN="EE",ES="SV",EZ="CZ",FG="GF",FP="PF",FQ="XXX",FS="TF",GA="GM",GB="GA",GG="GE",GJ="GD",GK="XX",GM="DE",GO="XX",GQ="GU",GV="GN",GZ="XX",HA="HT",HO="HN",HQ="XX",IC="IS",IM="XX",IS="XX",IV="CI",IZ="IQ",JA="JP",JE="XX",JN="XX",JQ="XX",JU="XX",KN="KP",KR="KI",KS="KR",KT="CX",KU="KW",LE="LB",LG="LV",LH="LT",LI="LR",LO="SK",LS="LI",LT="LS",MA="MG",MB="MQ",MF="YT",MG="MN",MH="MS",MI="MW",MN="MC",MO="MA",MP="MU",MQ="XX",MU="OM",MW="XXX",NE="NU",NG="NE",NH="VU",NI="NG",NL="NL",NS="SR",NT="XXX",NU="NI",PA="PY",PC="PN",PF="XX",PG="XX",PM="PA",PO="PT",PP="PG",PS="PW",PU="GW",RM="MH",RP="PH",RQ="PR",RS="RU",SB="PM",SC="KN",SE="SC",SF="ZA",SG="SN",SN="SG",SP="ES",SR="XXX",ST="LC",SU="SD",SV="SJ",SW="SE",SX="GS",SZ="CH",TD="TT",TI="TJ",TK="TC",TL="TK",TM="XXX",TN="TO",TO="TG",TP="ST",TS="TN",TU="TR",TX="TM",UP="XXX",UV="BF",VI="VG",VM="VN",VQ="VI",VT="VA",WA="NA",WE="XX",WI="XX",WQ="XX",WZ="SZ",YM="YE",ZA="ZM",ZI="ZW",UP="UA")))
countries <- world@data
countries <- cbind(id=rownames(countries),countries)
countries <- merge(countries,gtd.recent, 
                   by.x="FIPS_CNTRY", by.y="countrycit", all.x=T)
map.df <- fortify(world)
map.df <- merge(map.df,countries, by="id")

ggplot(map.df, aes(x=long,y=lat,group=group)) +
  geom_polygon(aes(fill=D_biep.White_Good_all))

# -------- save as PNG 
ggsave(filename="IATmap.png")
