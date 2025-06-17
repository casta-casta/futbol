install.packages("StatsBombR")
install.packages("devtools")
devtools::install_github("statsbomb/StatsBombR")
devtools::install_github("FCrSTATS/SBpitch")
library (tidyverse)
library(ggplot2)
library(devtools)
library(StatsBombR)
library(SBpitch)

Comp <- FreeCompetitions() %>% 
  filter(competition_id==72 & season_id==107)
Matches <- FreeMatches(Comp)
StatsBombData <- free_allevents (MatchesDF = Matches, Parallel =T)
StatsBombData = allclean(StatsBombData)

passes_map = StatsBombData %>%
  filter(type.name=="Pass" & is.na(pass.outcome.name) & play_pattern.name== "Regular Play" & player.id==15284) %>%
  filter(pass.end_location.x>=102 & pass.end_location.y<=62 & pass.end_location.y>=18) #2


create_Pitch() +
  geom_segment(data = passes_map, aes(x = location.x, y = location.y, xend = pass.end_location.x, yend = pass.end_location.y), lineend = "round", size = 0.6, arrow = arrow(length = unit(0.08, "inches")))+
  labs(title = "Aitana Bonmatí Conca, Pases completados en área rival", subtitle = "Copa del Mundo, 2023")+
  scale_y_reverse() +
  coord_fixed(ratio = 105/100)
