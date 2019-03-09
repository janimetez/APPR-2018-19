# 2. faza: Uvoz podatkov

library(readr)
library(dplyr)
library(tidyr)
library(reshape2)

#sl <- locale("sl", decimal_mark=",", grouping_mark=".")

# Funkcija, ki uvozi občine iz Wikipedije
uvozi.obcine <- function() {
  link <- "http://sl.wikipedia.org/wiki/Seznam_ob%C4%8Din_v_Sloveniji"
  stran <- html_session(link) %>% read_html()
  tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
    .[[1]] %>% html_table(dec=",")
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
                        "ustanovitev", "pokrajina", "regija", "odcepitev")
  tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
  tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
  tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
  for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
    tabela[[col]] <- parse_number(tabela[[col]], na="-", locale=sl)
  }
  for (col in c("obcina", "pokrajina", "regija")) {
    tabela[[col]] <- factor(tabela[[col]])
  }
  return(tabela)
}

# Funkcija, ki uvozi podatke iz datoteke druzine.csv
uvozi.druzine <- function(obcine) {
  data <- read_csv2("podatki/druzine.csv", col_names=c("obcina", 1:4),
                    locale=locale(encoding="Windows-1250"))
  data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
    strapplyc("([^ ]+)") %>% sapply(paste, collapse=" ") %>% unlist()
  data$obcina[data$obcina == "Sveti Jurij"] <- "Sveti Jurij ob Ščavnici"
  data <- data %>% melt(id.vars="obcina", variable.name="velikost.druzine",
                        value.name="stevilo.druzin")
  data$velikost.druzine <- parse_number(data$velikost.druzine)
  data$obcina <- factor(data$obcina, levels=obcine)
  return(data)
}


#POTNIŠKI PROMET
# TABELA 1
tabela1 <- read_csv2("podatki/potniski_promet.csv", col_names = c("Potniki(1000)", "Vrsta_prevoza", 2001:2017),
                    skip = 4, n_max = 8, na = "...",
                    locale=locale(encoding="Windows-1250"))
tabela1 <- tabela1[,-1]

tabela1 <- melt(tabela1, id.vars = "Vrsta_prevoza", measure.vars = names(tabela1)[-1],
                    variable.name = "Leto", value.name = "Stevilo",
                    na.rm = TRUE)



# ŠTEVILO UMRLIH V PROMETNIH NESREČAH
tabela2.1 <- read_csv2("podatki/stevilo_umrlih_v_prometnih_nesrecah.csv", col_names = c("Število umrlih v cestnoprometnih nesrečah na 10.000 prebivalcev", "Regija", 2001:2017),
                     skip = 5, n_max = 12,
                     locale = locale(encoding = "Windows-1250"))

tabela2.1 <- tabela2.1[,-1]
tabela2.1 <- melt(tabela2.1, id.vars = "Regija", measure.vars = names(tabela2.1)[-1],
                  variable.name = "Leto", value.name = "Stevilo",
                  na.rm = TRUE)

tabela2.2 <- read_csv2("podatki/stevilo_umrlih_v_prometnih_nesrecah.csv", col_names = c("Povprečna starost osebnih avtomobilov","Regija", 2001:2017),
                       skip = 19, n_max = 12,
                       locale = locale(encoding = "Windows-1250"))
tabela2.2 <- tabela2.2[,-1]

tabela2.2[,-1] <- apply(tabela2.2[-1], 2, function(x) {x/10})

tabela2.2 <- melt(tabela2.2, id.vars = "Regija", measure.vars = names(tabela2.2)[-1],
                    variable.name = "Leto", value.name = "Starost_avtomobila",
                    na.rm=TRUE)

#ŠTEVILO POTNIKOV V LINIJSKEM PROMETU
tabela3 <- read_csv2("podatki/cestni_javni_linijski_promet.csv", 
                     col_names = c("Potniki","Cestni javni linijski promet", "Razdalja", 2010:2017),
                     skip = 7, n_max = 5,
                     locale = locale(encoding = "Windows-1250"))
tabela3 <- tabela3[-c(1,2)]

tabela3 <- melt(tabela3,id.vars = "Razdalja", measure.vars = names(tabela3)[-1],
                  variable.name = "Leto", value.name = "Potniki")

#ŠTEVILO VOZIL PO REGIJAH
tabela4 <- read_csv2("podatki/2222104Ss.csv", col_names = c("Vrsta vozila", "Regija", 1992:2017),
                     skip = 6, n_max = 12, na = "...",
                     locale = locale(encoding = "Windows-1250"))
tabela4 <- tabela4[-1]
tabela4 <- melt(tabela4, id.vars = "Regija", measure.vars = names(tabela4)[-1],
                  variable.name = "Leto", value.name = "Stevilo_vozil")


#VRSTA POGONA
tabela5 <- read_csv2("podatki/vrsta_pogona_stara.csv", col_names = c("Osebni avtomobili","Leto", "Vrsta_pogona", "Stevilo_avtomobilov"),
                     skip = 5, n_max=132,
                     locale = locale(encoding = "Windows-1250"))
tabela5 <- tabela5[c(3,2,4)] %>% fill(2)




tabela6 <- read_csv2("podatki/vrsta_pogona.csv", col_names = c("Osebni avtomobili","Leto", "Vrsta_pogona", "Stevilo_avtomobilov"),
                     skip = 6, n_max=36,
                     locale = locale(encoding = "Windows-1250"))
tabela6 <- tabela6[c(3,2,4)] %>% fill(2)

tabela6 <- tabela6[-c(1,10,19,28,37),]

tabela6 <- tabela6[-9,]
tabela6 <- tabela6[-17,]
tabela6 <- tabela6[-25,]
tabela6 <- tabela6[-32,]

#####################################################################################################

#PREBIVALSTVO PO REGIJAH 

prebivalstvo <- read_csv2("podatki/prebivalstvo_po_regijah.csv", col_names = c("spol","Regija", 2001:2017),
                          skip=4, n_max=12, locale = locale(encoding = "Windows-1250"))
prebivalstvo <- prebivalstvo[,-1]
prebivalstvo$Regija <- gsub("Jugovzhodna Slovenija", "Jugovzhodna", prebivalstvo$Regija)

prebivalstvo <- melt(prebivalstvo, id.vars = "Regija", measure.vars = names(prebivalstvo)[-1],
                                      variable.name = "Leto", value.name = "Stevilo")


# POVPREČNA BRUTO PLAČA PO REGIJAH

placa <- read_delim("podatki/povprecna_bruto_placa_po_regijah.csv", delim = ";", col_names = c("Regija", 2005:2017),
                  skip=5, n_max=12, locale = locale(encoding = "Windows-1250"))
placa$Regija <- gsub("Jugovzhodna Slovenija", "Jugovzhodna", placa$Regija)

placa <- placa[c(1,2,3,4,5,6,7,9,10,8,11,12),]
placa <- melt(placa, id.vars = "Regija", measure.vars = names(placa)[-1],
     variable.name = "Leto", value.name = "Placa")

placa_2015 <- filter(placa, Leto == '2015')
placa_2015 <- placa_2015[,-2]
placa_2010 <- filter(placa, Leto == '2010')
placa2010 <- placa_2010[,-1]
# ŠTEVILO UMRLIH V CESTNOPROMETNIH NESREČAH NA 10.000 PREBIVALCEV PO REGIJAH

umrli <- read_delim("podatki/Stevilo_umrlih_v_cestnoprometnih_nesrecah_na_10000_prebivalcev.csv", delim=";", col_names = c("nekaj","Regija", 2001:2017),
                   skip=4, n_max=12, locale = locale(encoding = "Windows-1250"))
umrli <- umrli[,-1]
umrli$Regija <- gsub("Jugovzhodna Slovenija", "Jugovzhodna", umrli$Regija)
umrli$Regija <- gsub("Spodnjeposavska", "Posavska", umrli$Regija)
umrli$Regija <- gsub("Notranjsko-kraška", "Primorsko-notranjska", umrli$Regija)


umrli <- melt(umrli, id.vars = "Regija", measure.vars = names(umrli)[-1],
              variable.name = "Leto", value.name = "Umrli")
umrli$Leto <- as.numeric(umrli$Leto)
umrli$Leto <- c(2001:2017)

# ŠTEVILO OSEBNIH AVTOMOBILOV NA 1000 PREBIVALCEV PO REGIJAH

avtomobili <-read_delim("podatki/Stevilo_osebnih_avtomobilov_na_1000_prebivalcev.csv", delim=";", col_names = c("nekaj","Regija", 2001:2017),
                                 skip=4, n_max=12, locale = locale(encoding = "Windows-1250")) 
avtomobili <- avtomobili[,-1]
avtomobili$Regija <- gsub("Jugovzhodna Slovenija", "Jugovzhodna", avtomobili$Regija)
avtomobili$Regija <- gsub("Notranjsko-kraška", "Primorsko-notranjska", avtomobili$Regija)
avtomobili$Regija <- gsub("Spodnjeposavska", "Posavska", avtomobili$Regija)

avtomobili <- melt(avtomobili, id.vars = "Regija", measure.vars = names(avtomobili)[-1],
              variable.name = "Leto", value.name = "Avtomobili")

avtomobili$Leto <- as.numeric(avtomobili$Leto)
avtomobili$Leto <- c(2001:2017)
# POVPREČNA STAROST OSEBNEGA AVTOMOBILA PO REGIJAH

starost <- read_delim("podatki/Povprecna_starost_osebnega_avtomobila.csv", delim=";", col_names = c("nekaj","Regija", 2001:2017),
                      skip=4, n_max=12, locale = locale(encoding = "Windows-1250"))
starost <- starost[,-1]
starost$Regija <- gsub("Jugovzhodna Slovenija", "Jugovzhodna", starost$Regija)
starost$Regija <- gsub("Notranjsko-kraška", "Primorsko-notranjska", starost$Regija)
starost$Regija <- gsub("Spodnjeposavska", "Posavska", starost$Regija)

starost <- melt(starost, id.vars = "Regija", measure.vars = names(starost)[-1],
                   variable.name = "Leto", value.name = "Starost_avtomobila")

# STEVILO CESTNIH VOZIL PO REGIJAH

vozila <- read_csv2("podatki/Cestna_vozila.csv", col_names = c("nekaj","Regija", 2001:2017),
                    skip=5, n_max=12, locale = locale(encoding = "Windows-1250"))
vozila <- vozila[,-1]
vozila$Regija <- gsub("Jugovzhodna Slovenija", "Jugovzhodna", vozila$Regija)
vozila$Regija <- gsub("Notranjsko-kraška", "Primorsko-notranjska", vozila$Regija)
vozila$Regija <- gsub("Spodnjeposavska", "Posavska", vozila$Regija)

vozila <- melt(vozila, id.vars = "Regija", measure.vars = names(vozila)[-1],
               variable.name = "Leto", value.name = "Vozila")

# Zapišimo podatke v razpredelnico obcine
#obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
#druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.

