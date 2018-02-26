library(readr)
library(RCurl)
library(data.table)
library(mapdata)
library(ggplot2)

states <- map_data("state")

ssm <- read_csv(getURL("https://raw.githubusercontent.com/zonination/samesmarriage/master/ssm.csv"))
ssm_pivot <- setNames( melt(ssm, id=c("State","abbrev")), c("State","abbrev","Year","Law") )
ssm_pivot$region <- sapply(ssm_pivot$State,tolower)

ssm_map <- merge(states, ssm_pivot, by="region", allow.cartesian=TRUE)

ggplot() + 
  ggtitle("Same Sex Marriage in the US") +
  geom_polygon(data=ssm_map, aes(long,lat,group=region,fill=Law)) + 
  coord_map("albers", at0=45.5,lat1=29.5) + 
  scale_fill_manual(values=c("red","green","grey","yellow")) + 
  facet_wrap("Year") + 
  theme(axis.text=element_blank(),axis.title=element_blank(),axis.ticks=element_blank()) +
  labs(caption="Source: https://github.com/zonination/samesmarriage/blob/master/ssm.csv")

ggsave("SSM.png")
