# Author: Anna Bruggeman
# Spring 2017
# Last edit: 25/03/2019
# Rstudio version 1.1453

library(ggplot2)

setwd("/Users/Anna/Desktop/hungtest/")
sylldf <- read.table("syllcontour.txt", header=T)
phrasedf <- read.table("phrasecontour.txt", header=T)

sylldf$ST <- as.numeric(as.character(sylldf$ST))
sylldf$hz <- as.numeric(as.character(sylldf$hz))

phrasedf$ST <- as.numeric(as.character(phrasedf$ST))
phrasedf$hz <- as.numeric(as.character(phrasedf$hz))

## plot all syllable-normalised contours
ggplot(data=sylldf) +
   geom_line(aes(x=point, 
                y=hz, # or ST
                group=filename)) +
  facet_wrap(~filename, scales ="free_x") +
  scale_y_continuous("F0 (Hertz)") + 
  scale_x_continuous("Normalised time (by syllable)") + 
  theme_bw() +
  theme(strip.text = element_text(size=10, face="bold"),
        strip.background = element_rect(fill="white"),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x=element_text(),
        axis.title.x=element_blank(),
        legend.position = "none")

## plot all phrase-normalised contours
ggplot(data=phrasedf) +
  geom_line(aes(x=point, 
                y=hz, # or ST
                group=filename)) +
  facet_wrap(~filename, scales ="free_x") +
  scale_y_continuous("F0 (Hertz)") + 
  scale_x_continuous("Normalised time (by phrase)") + 
  theme_bw() +
  theme(strip.text = element_text(size=10, face="bold"),
        strip.background = element_rect(fill="white"),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x=element_text(),
        axis.title.x=element_blank(),
        legend.position = "none")
