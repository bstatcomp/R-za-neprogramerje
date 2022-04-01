library(rgrass7)
library(rgdal)

#Beremo vzorčni primer iz 

#Lahko si pogledamo metapodatke za svojo lokacijo z:
G <- gmeta()
str(G)

#Prikaže vektorske zemljevide, ki so na voljo:
execGRASS("g.list", parameters = list(type = "vector"))



#Prikaži mrežne zemljevide
execGRASS("g.list", parameters = list(type = "raster"))

#Preberemo dva GRASS mrežna zemljevida (the maps "geology_30m" and "elevation" iz vzorčne podatkovne zbirke 
#North Carolina) v R kot "ncdata" 
use_sp()
ncdata <- read_RAST(c("geology_30m", "elevation"), cat=c(TRUE, FALSE))
#lahko pogledamo kaj smo prebrali
str(ncdata)
#Pogledamo lahko srukturo podatkov:
str(ncdata@data)

summary(ncdata)

#
table(ncdata$geology_30m)

#kako izrišemo mrežne zemljevide
execGRASS("g.region", raster = "elevation", flags = "p")
ncdata <- readRAST("elevation", cat=FALSE)
summary(ncdata)
spplot(ncdata, col = terrain.colors(20))
png(filename = "./myplot.png", width = 250, height = 200, units = "mm", res = 300)

#Izrišemo vektorske zemljevide
use_sf()
library(sf)
execGRASS("v.info", map="hospitals", layer="1")
vInfo("hospitals")
myschools <- readVECT("hospitals")
print(summary(myschools))


#Povzemanje podatkov
#Naredimo tabelo kolikokrat se posamezna vrednost pojavi.
table(ncdata$geology_30m)

#Primerjamo z GRASS izpisom
execGRASS("r.stats", flags=c("c", "l"), parameters=list(input="geology_30m"), ignore.stderr=TRUE)

#
#Lahko narišemo škatle z brki različnih geoloških tipov po višinah
ncdata <- read_RAST(c("geology_30m", "elevation"), cat=c(TRUE, FALSE))
da <- data.frame(elevation = ncdata$elevation, geology_30m = ncdata$geology_30m)
library(ggplot2)
g1 <- ggplot(da, aes(x = geology_30m, y= elevation)) + geom_boxplot()
ggsave(g1, '/home/jana/git/R-za-neprogramerje/Predavanje_08/box.pdf')
