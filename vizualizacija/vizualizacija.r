# 3. faza: Vizualizacija podatkov

library(ggplot2)
library(ggvis)
library(dplyr)
library(rgdal)
library(mosaic)
library(maptools)
library(ggmap)
library(mapproj)
library(munsell)

#linijski graf POTNIŠKI PREVOZ IN PROMET
graf_promet <- ggplot(data = promet, mapping = aes(x=Leto, y=Stevilo, group=Vrsta_prevoza, color=Vrsta_prevoza)) +
  geom_line(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  labs(y='Potniki(1000)') +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Potniški prevoz in promet")

print(graf_promet)


# točkasti graf ŠTEVILO UMRLNIH V CESTNOPROMETNIH NESREČAH NA 10.000 PREBIVALCEV PO REGIJAH

graf_umrli1 <- ggplot(data = filter(umrli, Regija == 'Pomurska' | Regija == 'Podravska' |
                                     Regija == 'Koroška' | Regija == 'Savinjska' | Regija == 'Zasavska' |
                                     Regija == 'Posavska' | Regija == 'Jugovzhodna' | Regija == 'Osrednjeslovenska' |
                                     Regija == 'Gorenjska' | Regija == 'Primorsko-notranjska' |
                                     Regija == 'Goriška' | Regija == 'Obalno-kraška'),
                     mapping = aes(x=Leto, y=Umrli, group=Leto)) +
                     ggtitle('Število umrlih v cestnoprometnih nesrečah na 10.000 prebivalcev') +
                     geom_point() +
                     facet_wrap(Regija~., ncol=3) +
                     theme(axis.text.x = element_text(angle = 90, size = 6))


print(graf_umrli1)




# stolpični diagram POVPREČNA STAROST OSEBNEGA AVTOMOBILA PO REGIJAH
graf_starost <- ggplot(data = starost, mapping = aes(x=Regija, y=Starost_avtomobila, fill=factor(Leto))) +
  geom_bar(stat = 'identity', position = 'dodge') +
  labs(y = 'Starost avtomobila', fill='Leto') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  ggtitle("Povprečna starost osebnega avtomobila po regijah")

print(graf_starost)



# linijski graf INDEKS ŠTEVILA AVTOMOBILOV GLEDE NA VRSTO POGONA

graf_vrsta_pogona <- ggplot(data=indeksi, mapping = aes(x=Leto, y=Indeks, group=Vrsta_pogona, color=Vrsta_pogona))+
  geom_line(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Indeks števila avtomobilov glede na vrsto pogona")


print(graf_vrsta_pogona)


#########################################################################################
# Uvozimo zemljevid.

zemljevid <- uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/SVN_adm_shp.zip",
                             "SVN_adm1", mapa = "zemljevid_Slovenije", encoding = "UTF-8")
zemljevid$NAME_1 <- c("Gorenjska", "Goriška","Jugovzhodna", "Koroška", "Primorsko-notranjska", "Obalno-kraška", "Osrednjeslovenska", "Podravska", "Pomurska", "Savinjska", "Posavska", "Zasavska")

zemljevid <- fortify(zemljevid)         


# ZEMLJEVID POVPREČNA BRUTO PLAČA V LETU 2015

zemljevid_placa <- ggplot() + geom_polygon(data=left_join(zemljevid, placa_2010, by=c("NAME_1"="Regija")),
                                           aes(x=long, y=lat, group=group, fill=Placa)) +
  geom_line() + 
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  guides(fill=guide_colorbar(title="Plača")) +
  ggtitle("Povprečna bruto plača po regijah leta 2015") +
  labs(x = " ") +
  labs(y = " ") +
  scale_fill_gradient(low = "white", high = "red",
                      space = "Lab", na.value = "#e0e0d1", guide = "black",
                      aesthetics = "fill")

print(zemljevid_placa)

# ZEMLJEVID STAROST OSEBNEGA AVTOMOBILA GLEDE NA REGIJO

zemljevid_starost <- ggplot() + geom_polygon(data=left_join(zemljevid, starost2015, by=c("NAME_1"= "Regija")),
                                             aes(x=long, y=lat, group=group, fill=Starost_avtomobila)) +
  geom_line() + 
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  guides(fill=guide_colorbar(title="Povprečna starost avtomobila")) +
  ggtitle("Povprečna starost avtomobila po regijah leta 2015") +
  labs(x = " ") +
  labs(y = " ") +
  scale_fill_gradient(low = "white", high = "red",
                      space = "Lab", na.value = "#e0e0d1", guide = "black",
                      aesthetics = "fill")


print(zemljevid_starost)

