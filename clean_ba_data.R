library("tidyverse")

d20<-read.csv("G:/Shared drives/2024 FIRE-SA/DATA/EIA CSV/eia_2020.csv") |>
  filter(respondent=="PJM")

d21<-read.csv("G:/Shared drives/2024 FIRE-SA/DATA/EIA CSV/eia_2021.csv") |>
  filter(respondent=="PJM")

d22<-read.csv("G:/Shared drives/2024 FIRE-SA/DATA/EIA CSV/eia_2022.csv") |>
  filter(respondent=="PJM")

df<-rbind(d20, d21, d22) |>
  mutate(date=as.Date(substr(period, 1, 10))) |>
  mutate(hour=as.numeric(substr(period, 12, 13))) |>
  mutate(year=year(date), month=month(date), dayofweek=weekdays(date)) |>
  mutate(BGE_Rebate=ifelse((year>=2021) & (month>=6 & month<=8) & (hour>=10 & hour<=20), 1, 0)) |>
  mutate(BGE_Rebate=ifelse((year>=2021) & (month>=10) & (hour>=7 & hour<=11), 1, BGE_Rebate)) |>
  mutate(BGE_Rebate=ifelse((year>=2021) & (month>=10) & (hour>=17 & hour<=19), 1, BGE_Rebate)) |> 
  mutate(BGE_Rebate=ifelse((year>=2021) & (month<=5) & (hour>=7 & hour<=11), 1, BGE_Rebate)) |>
  mutate(BGE_Rebate=ifelse((year>=2021) & (month<=5) & (hour>=17 & hour<=19), 1, BGE_Rebate)) 

write.csv(df, "panel.csv", row.names=F)
         