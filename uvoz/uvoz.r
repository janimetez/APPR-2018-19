# 2. faza: Uvoz podatkov

library(readr)
library(dplyr)
library(tidyr)
library(reshape2)


# POTNIŠKI PROMET IN PREVOZ
promet <- read_csv2("podatki/potniski_promet.csv", col_names = c("Potniki(1000)", "Vrsta_prevoza", 2001:2017),
                    skip = 4, n_max = 8, na = "...",
                    locale=locale(encoding="Windows-1250"))
promet <- promet[,-1]

promet <- melt(promet, id.vars = "Vrsta_prevoza", measure.vars = names(promet)[-1],
                    variable.name = "Leto", value.name = "Stevilo",
                    na.rm = TRUE)


# ŠTEVILO AVTOMOBILOV GLEDE NA VRSTO POGONA 

pogon <- read_csv2("podatki/vrsta_pogona.csv", col_names = c("Osebni avtomobili","Leto", "Vrsta_pogona", "Stevilo_avtomobilov"),
                     skip = 6, n_max=36,
                     locale = locale(encoding = "Windows-1250"))
pogon <- pogon[c(3,2,4)] %>% fill(2)

pogon <- filter(pogon, Vrsta_pogona !='NA')
pogon <- filter(pogon, Vrsta_pogona !='Vrsta pogona in goriva - SKUPAJ')



indeksi <- dcast(pogon, Vrsta_pogona~Leto, value.var = 'Stevilo_avtomobilov' )
colnames(indeksi) <- c("Vrsta_pogona", "a", "b", "c", "d")
indeksi <- transform(indeksi, Indeks1 = (b-a)*100/a)
indeksi <- transform(indeksi, Indeks2 = (c-b)*100/b)
indeksi <- transform(indeksi, Indeks3 = (d-c)*100/c)
indeksi <- indeksi[c(1,6,7,8)] 
colnames(indeksi) <- c("Vrsta_pogona", 2015:2017)

indeksi <- melt(indeksi, id.vars = "Vrsta_pogona", measure.vars = names(indeksi)[-1],
                            variable.name = "Leto", value.name = "Indeks")


# POVPREČNA BRUTO PLAČA PO REGIJAH

placa <- read_delim("podatki/povprecna_bruto_placa_po_regijah.csv", delim = ";", col_names = c("Regija", 2005:2017),
                  skip=5, n_max=12, locale = locale(encoding = "Windows-1250"))
placa$Regija <- gsub("Jugovzhodna Slovenija", "Jugovzhodna", placa$Regija)

placa <- placa[c(1,2,3,4,5,6,7,9,10,8,11,12),]
placa <- melt(placa, id.vars = "Regija", measure.vars = names(placa)[-1],
     variable.name = "Leto", value.name = "Placa")

placa2015 <- filter(placa, Leto == '2015')
placa2015 <- placa2015[,-2]
placa2010 <- filter(placa, Leto == '2010')
placa2010 <- placa2010[,-1]


# ŠTEVILO UMRLIH V CESTNOPROMETNIH NESREČAH NA 10.000 PREBIVALCEV PO REGIJAH

umrli <- read_delim("podatki/Stevilo_umrlih_v_cestnoprometnih_nesrecah_na_10000_prebivalcev.csv", delim=";", col_names = c("nekaj","Regija", 2001:2017),
                   skip=4, n_max=12, locale = locale(encoding = "Windows-1250"))
umrli <- umrli[,-1]
umrli$Regija <- gsub("Jugovzhodna Slovenija", "Jugovzhodna", umrli$Regija)
umrli$Regija <- gsub("Spodnjeposavska", "Posavska", umrli$Regija)
umrli$Regija <- gsub("Notranjsko-kraška", "Primorsko-notranjska", umrli$Regija)


umrli <- melt(umrli, id.vars = "Regija", measure.vars = names(umrli)[-1],
              variable.name = "Leto", value.name = "Umrli")
umrli$Leto <- as.numeric(levels(umrli$Leto))[umrli$Leto]



# ŠTEVILO OSEBNIH AVTOMOBILOV NA 1000 PREBIVALCEV PO REGIJAH

avtomobili <-read_delim("podatki/Stevilo_osebnih_avtomobilov_na_1000_prebivalcev.csv", delim=";", col_names = c("nekaj","Regija", 2001:2017),
                                 skip=4, n_max=12, locale = locale(encoding = "Windows-1250")) 
avtomobili <- avtomobili[,-1]
avtomobili$Regija <- gsub("Jugovzhodna Slovenija", "Jugovzhodna", avtomobili$Regija)
avtomobili$Regija <- gsub("Notranjsko-kraška", "Primorsko-notranjska", avtomobili$Regija)
avtomobili$Regija <- gsub("Spodnjeposavska", "Posavska", avtomobili$Regija)

avtomobili <- melt(avtomobili, id.vars = "Regija", measure.vars = names(avtomobili)[-1],
              variable.name = "Leto", value.name = "Avtomobili")

avtomobili$Leto <- as.numeric(levels(avtomobili$Leto))[avtomobili$Leto]

# POVPREČNA STAROST OSEBNEGA AVTOMOBILA PO REGIJAH

starost <- read_delim("podatki/Povprecna_starost_osebnega_avtomobila.csv", delim=";", col_names = c("nekaj","Regija", 2001:2017),
                      skip=4, n_max=12, locale = locale(encoding = "Windows-1250"))
starost <- starost[,-1]
starost$Regija <- gsub("Jugovzhodna Slovenija", "Jugovzhodna", starost$Regija)
starost$Regija <- gsub("Notranjsko-kraška", "Primorsko-notranjska", starost$Regija)
starost$Regija <- gsub("Spodnjeposavska", "Posavska", starost$Regija)

starost <- melt(starost, id.vars = "Regija", measure.vars = names(starost)[-1],
                   variable.name = "Leto", value.name = "Starost_avtomobila")

starost2015 <- filter(starost, Leto == '2015')


