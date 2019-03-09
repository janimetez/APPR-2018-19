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



# PREBIVALSTVO PO REGIJAH 
graf_prebivalstvo <- ggplot(data = prebivalstvo, mapping = aes(x=Regija, y=Stevilo, group=Leto)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Prebivalstvo po regijah")

print(graf_prebivalstvo)


# POVPREČNA BRUTO PLAČA PO REGIJAH
graf_placa <- ggplot(data = placa, mapping = aes(x=Regija, y=Placa, group=Leto)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Povprečna bruto plača po regijah")

print(graf_placa)


# ŠTEVILO UMRLNIH V CESTNOPROMETNIH NESREČAH NA 10.000 PREBIVALCEV PO REGIJAH
graf_umrli <- ggplot(data = umrli, mapping = aes(x=Regija, y=Umrli, group=Leto)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Število umrlih v cestnoprometnih nesrečah na 10.000 prebivalcev po regijah")

print(graf_umrli)

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

# ŠTEVILO OSEBNIH AVTOMOBILOV NA 1000 PREBIVALCEV PO REGIJAH
graf_avtomobili <- ggplot(data = avtomobili, mapping = aes(x=Regija, y=Avtomobili, group=Leto)) +
      geom_bar(stat = 'identity', position = 'dodge') +
      theme(axis.text.x = element_text(angle = 90, size = 8)) +
      theme(legend.text = element_text(size=8)) + 
      ggtitle("Število osebnih avtomobilov na 1000 prebivalcev")

print(graf_avtomobili)


# POVPREČNA STAROST OSEBNEGA AVTOMOBILA PO REGIJAH
graf_starost <- ggplot(data = starost, mapping = aes(x=Regija, y=Starost_avtomobila, group=Leto)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Povprečna starost osebnega avtomobila po regijah")

print(graf_starost)


# STEVILO CESTNIH VOZIL PO REGIJAH
graf_vozila <- ggplot(data = vozila, mapping = aes(x=Regija, y=Vozila, group=Leto)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Stevilo cestnih vozil po regijah")

print(graf_vozila)


#####################################################################################


graf_vrsta_prevoza <- ggplot(data = tabela1, mapping = aes(x=Vrsta_prevoza, y=Stevilo, group=Leto)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Vrsta prevoza")

print(graf_vrsta_prevoza)


graf_stevilo_umrlih <- ggplot(data = tabela2.1, mapping = aes(x=Regija, y=Stevilo, group=Leto)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Stevilo umrlih v cestnoprometnih nesrečah na 10000 prebivalcev")

print(graf_stevilo_umrlih)


graf_povprecna_starost_avtomobila <- ggplot(data = tabela2.2, mapping = aes(x=Regija, y=Starost_avtomobila, group=Leto)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Povprečna starost avtomobila")

print(graf_povprecna_starost_avtomobila)


graf_prepotovana_razdalja <- ggplot(data = tabela3, mapping = aes(x=Razdalja, y=Potniki, group=Leto)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Povprečna starost avtomobila")

print(graf_prepotovana_razdalja)


graf_stevilo_vozil <- ggplot(data = tabela4, mapping = aes(x=Regija, y=Stevilo_vozil, group=Leto)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Stevilo vozil po regijah")

print(graf_stevilo_vozil)


graf_vrsta_pogona <- ggplot(data = tabela5, mapping = aes(x=Vrsta_pogona, y=Stevilo_avtomobilov, group=Leto)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Vrsta pogona")

print(graf_vrsta_pogona)

graf_vrsta_pogona <- ggplot(data = tabela6, mapping = aes(x=Vrsta_pogona, y=Stevilo_avtomobilov, group=Leto)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90, size = 8)) +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Vrsta pogona")

print(graf_vrsta_pogona)

# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/SVN_adm_shp.zip",
                             "SVN_adm1", mapa = "zemljevid_Slovenije", encoding = "UTF-8")
zemljevid$NAME_1 <- c("Gorenjska", "Goriška","Jugovzhodna", "Koroška", "Primorsko-notranjska", "Obalno-kraška", "Osrednjeslovenska", "Podravska", "Pomurska", "Savinjska", "Posavska", "Zasavska")

zemljevid <- fortify(zemljevid)         

 #ggplot() + geom_polygon(data=zemljevid,aes(x=long, y=lat, group=group, fill=id)) + guides(fill=FALSE)

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







# Uvozimo zemljevid.
#zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip", "OB",
#                             pot.zemljevida="OB", encoding="Windows-1250")
#levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
#  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
#zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels=levels(obcine$obcina))
#zemljevid <- fortify(zemljevid)

# Izračunamo povprečno velikost družine
#povprecja <- druzine %>% group_by(obcina) %>%
#  summarise(povprecje=sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
