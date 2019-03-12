# Analiza podatkov s programom R, 2018/19

Avtor: Jani Metež

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2018/19

* [![Shiny](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/janimetez/APPR-2018-19/master?urlpath=shiny/APPR-2018-19/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/janimetez/APPR-2018-19/master?urlpath=rstudio) RStudio

## Analiza transporta v Sloveniji


V svoji projektni nalogi bom analiziral različne načine transporta tako ljudi kot tudi blaga v Sloveniji. 

Raziskal bom s katero vrsto prevoza se ljudje največ prevažajo in kako se le-to spreminja skozi leta. Primerjal bom spremembo v količini cestnih vozil glede na regije v daljšem časovnem obdobju, hkrati pa me bo zanimalo tudi, kako narašča število osebnih avtomobilov na alternativne vire goriva v zadnjih letih. Prav tako bom poskušal poiskati povezavo med povprečno starostjo avtomobila in povprečno bruto plačo po regijah in pogledal kako se plače in povprečna starost spreminjata skozi daljši časovni razpon. 
Zanimala me bo tudi primerjava števila umrlih v prometnih nesrečah preko različnih vrst transporta in preko različnih regij. S pomočjo analize podatkov bom poiskal povezave med številom potnikov in številom nesreč, glede na posamezne vrste transporta. 

Glavni cilji moje analize bodo, da bi ugotovil, kako se različne vrste transporta, število umrlih, povprečno število avtomobilov in njihova povprečna starost spreminjajo skozi leta. Spremembe bom ponekod ponazoril tudi glede na slovenske regije. Hkrati bom trende spreminjanja poskušal razložiti s poenostavljeno razlago. 

#### Tabele:
Tabela 1 (promet: Število potnikov v posamezni vrsti prevoza):

- `Vrsta_prevoza` - spremenljivka: prevozno sredstvo
- `Leto` - spremenljivka: leto
- `Potniki` - meritev: število potnikov v 1000

Tabela 2 (pogon: Število avtomobilov glede na vrsto pogona):

- `Vrsta_pogona` - spremenljivka: Vrsta pogona avtomobila   
- `Leto` - spremenljivka: leto
- `Stevilo_avtomobilov` - meritev: število avtomobilov v prometu 

Tabela 3 (umrli: Število umrlih v cestnoprometnih nesrečah na 10.000 prebivalcev po regijah):

- `Regija` - spremenljivka: regija
- `Leto` - spremenljivka: leto
- `Umrli` - meritev: število umrlih na 10.000 prebivalcev

Tabela 4 (avtomobili: Število osebnih avtomobilov na 1000 prebivalcev po regijah):

- `Regija` - spremenljivka: regija
- `Leto` - spremenljivka: leto
- `Avtomobili` - meritev: število avtomobilov na 1000 prebivalcev

Tabela 5 (starost: Povprečna starost osebnega avtomobila po regijah):

- `Regija` - spremenljivka: regija
- `Leto` - spremenljivka: leto
- `Umrli` - meritev: povprečna starost avtomobila


#### Viri: 
* https://pxweb.stat.si/pxweb/Database/Ekonomsko/22_transport/01_22211_transport_panoge/01_22211_transport_panoge.asp
* https://pxweb.stat.si/pxweb/Database/Ekonomsko/22_transport/08_22221_reg_cestna_vozila/08_22221_reg_cestna_vozila.asp


## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-201819)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem.zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
