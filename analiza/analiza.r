# 4. faza: Analiza podatkov


#############################################################
#REGRESIJSKA PREMICA ZA ŠTEVILO UMRLIH V CESTNOPROMETNIH NESREČAH V NASLEDNJIH LETIH

grup <- group_by(umrli, Leto)
umrli_slo <- summarise(grup, Stevilo=(sum(Umrli, na.rm = TRUE)))
umrli_slo <- transform(umrli_slo, Stevilo = (Stevilo / 12))
umrli_slo$Stevilo <- round(umrli_slo$Stevilo, digits=2)
prileg <- lm(data = umrli_slo, Stevilo ~ Leto )
m <- data_frame(Leto=seq(2018,2022,1))
napoved <- mutate(m, Stevilo=predict(prileg,m))
napoved$Stevilo <- round(napoved$Stevilo, digits = 2)

graf_regresija_umrli <- ggplot(umrli_slo, aes(x=Leto, y=Stevilo)) +
  geom_smooth(method=lm, fullrange = TRUE, color = 'blue') +
  geom_point(data=napoved, aes(x=Leto, y=Stevilo), color='red', size=2) +
  geom_point() +
  labs(title='Napoved števila smrti v prometu v naslednjih letih', y="Stevilo")



# REGRESIJSKA PREMICA ZA ŠTEVILO OSEBNIH AVTOMOBILOV NA 1000 PREBIVALCEV V PRIHODNOSTI
avti <- group_by(avtomobili,Leto)
avti1 <- summarise(avti, Stevilo=sum(Avtomobili, na.rm=TRUE))
avti_regije <- transform(avti1, Stevilo = Stevilo / 12)
avti_regije$Stevilo <- round(avti_regije$Stevilo, digits=2)
prileg <- lm(data = avti_regije, Stevilo ~ Leto )
napoved_avti <- mutate(m, Stevilo=predict(prileg, m))

graf_regresija_avti <- ggplot(avti_regije, aes(x=Leto, y=Stevilo)) +
  geom_smooth(method=lm, fullrange = TRUE, color = 'blue') +
  geom_point(data=napoved_avti, aes(x=Leto, y=Stevilo), color='red', size=2) +
  geom_point() +
  labs(title='Napoved števila osebnih avtomobilov na 1000 prebivalcev v prometu v naslednjih letih', y="Stevilo")




##################################################################################
# CLUSTER REGIJ ŠTEVILO UMRLIH V CESTNOPROMETNIH NESREČAH

# umrli
grp <- group_by(umrli, Regija)
umrli_sum <- summarise(grp, vsote=sum(Umrli, na.rm = TRUE))

umrli_e <- dcast(umrli, Regija~Leto, value.var = 'Umrli' )
umrli_e <- left_join(umrli_e, umrli_sum, by = 'Regija')
umrli_e <- umrli_e[order(umrli_e$vsote, decreasing = FALSE),]
umrli_b <- umrli_e[,-19]
umrli_b <- umrli_b[,-1]

n <- 5
fit <- hclust(dist(scale(umrli_b)))
skupine4 <- cutree(fit, n)

cluster4 <- mutate(umrli_e, skupine4)
cluster4 <- cluster4[,-2:-19]
colnames(cluster4) <- c("Regija", "Umrli")
# zemljevid

regije <- unique(zemljevid$NAME_1)
regije <- as.data.frame(regije, stringsAsFactors=FALSE) 
names(regije) <- "Regija"
skupaj <- left_join(regije, cluster4, by="Regija")


zemljevid_cluster_umrli <- ggplot() + geom_polygon(data=left_join(zemljevid, skupaj, by=c("NAME_1"="Regija")),
                                              aes(x=long, y=lat, group=group, 
                                                  fill=factor(Umrli))) +
  geom_line() +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  guides(fill=guide_colorbar(title="Skupine")) +
  ggtitle('Razvrstitev regij v skupine glede na število umrlih v cestnoprometnih nesrečah') +
  labs(x = " ") +
  labs(y = " ") +
  scale_fill_brewer(palette="YlOrRd", na.value = "#e0e0d1") 


###################################################################################
# SHINY


graf.regije <- function(regija){
  ggplot(umrli %>% filter(Regija %in% regija)) + aes(x=Leto, y=Umrli, group=Regija, color=Regija) +
    geom_line() + geom_point()+ xlab("Leto") + ylab("Število umrlih") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.3, hjust=1))
}

graf_avto <- function(cifra) {
  ggplot(avtomobili %>% filter(Leto==cifra), aes(x=Regija, y=Avtomobili, fill=factor(Regija))) + 
    ylim(0, 650) + geom_bar(stat = "identity") +
    xlab("Regija") + ylab("Število avtomobilov") +   
    theme(axis.text.x = element_text(angle = 90, size = 8)) 

}





#==================================================================================


