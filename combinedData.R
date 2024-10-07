d19<-read.csv("~/Library/CloudStorage/GoogleDrive-sselvaku@terpmail.umd.edu/Shared drives/2024 FIRE-SA/DATA/EIA2/eia_2019.csv")
d20<-read.csv("~/Library/CloudStorage/GoogleDrive-sselvaku@terpmail.umd.edu/Shared drives/2024 FIRE-SA/DATA/EIA2/eia_2020.csv")
d21<-read.csv("~/Library/CloudStorage/GoogleDrive-sselvaku@terpmail.umd.edu/Shared drives/2024 FIRE-SA/DATA/EIA2/eia_2021.csv")
d22<-read.csv("~/Library/CloudStorage/GoogleDrive-sselvaku@terpmail.umd.edu/Shared drives/2024 FIRE-SA/DATA/EIA2/eia_2022.csv")
d23<-read.csv("~/Library/CloudStorage/GoogleDrive-sselvaku@terpmail.umd.edu/Shared drives/2024 FIRE-SA/DATA/EIA2/eia_2023.csv")

df<-rbind(d19,d20,d21,d22)


library("tidyverse")
df2 <- df %>%
  mutate(hour = substr(period, 13, 14)) %>%
  mutate(month = substr(period, 6, 7)) %>%
  mutate(year = substr(period, 1, 4)) %>%
  mutate(date = substr(period, 1, 10))

write.csv(df2, "panel.csv", row.names = F)  
  
  