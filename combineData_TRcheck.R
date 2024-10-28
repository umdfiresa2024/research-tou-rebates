library(tidyverse)

Vehicles <- read.csv("Vehicles.csv")
ZipCodes <- read.csv("Zip_Codes.csv") #electric company-zip codes data

#only include zipcodes that fall under one company
unique_ZipCodes <- ZipCodes %>%
  filter(State == "MD") %>%
  group_by(Zip_Code, Company) %>%
  tally() %>%
  mutate(obs = 1) %>%
  group_by(Zip_Code) %>%
  summarize(obs = sum(obs)) %>%
  filter(obs == 1)

#find duplicate values
ZipCodes_df <- ZipCodes %>%
  filter(State == "MD") %>%
  group_by(Zip_Code, Company) %>%
  tally()

#final zipcode df only contains unique values, no duplicate rows
ZipCodes_df2 <- left_join(unique_ZipCodes, ZipCodes_df, by = "Zip_Code") %>%
  select(-c(obs, n))

unique_month <- unique(Vehicles$Year_Month)
unique_zip_car<-unique(Vehicles$Zip_Code)

#select only zip codes that apprea in car sales data
ZipCodes_df3<-ZipCodes_df2 %>% 
  filter(Zip_Code %in% unique_zip_car)

#create a row for each zipcode and year/month
df<- crossing(ZipCodes_df3, unique_month) %>% rename(Year_Month = unique_month)

#combine electric and plug in hybrid values
Vehicles_df <- Vehicles %>%
  group_by(Year_Month, Zip_Code) %>%
  summarize(Count = sum(Count))

merged_data <- merge(df, Vehicles_df, by = c("Zip_Code", "Year_Month"), all.x = TRUE) %>%
  mutate(Count = ifelse(is.na(Count), 0, Count))

merged_data2 <- merged_data %>%
  mutate(Date = paste0(Year_Month, "/01")) %>%
  mutate(Date = as.Date(Date, format = "%Y/%m/%d"))

#https://docs.google.com/spreadsheets/d/11opnOP1Ki-Ukla18Pxs5vhfwssd76AQveW-Uk1up5XE/edit?gid=514201937#gid=514201937
merged_data3 <- merged_data2 %>%
  group_by(Date, Company) %>%
  summarize(EVs=sum(Count)) %>%
  mutate(EVTOURebate = case_when(
    Company == "Southern Maryland Electric Cooperative Inc." ~ ifelse(Date >= as.Date("2022-02-01"), 1, 0),
    Company == "Potomac Electric Power Co" ~ ifelse(Date >= as.Date("2022-11-01"), 1, 0),
    Company == "Baltimore Gas & Electric Co" ~ ifelse(Date >= as.Date("2021-07-01"), 1, 0),
    Company == "The Potomac Edison Company" ~ ifelse(Date >= as.Date("2020-01-01"), 1, 0),
    Company == "Delmarva Power" ~ ifelse(Date >= as.Date("2019-07-01"), 1, 0)
  )) %>%
  arrange(Date, Company)

#remove Delmarva power and Potomac Edison because they implmented TOU rebate before the start of the data
#take out SMECO because their trends are different
data4<-merged_data3 %>%
  filter(Company == "Potomac Electric Power Co" |
           Company == "Baltimore Gas & Electric Co")

ggplot(data4, aes(x=Date, y=EVs, col=Company)) + geom_line() +
  geom_vline(xintercept=as.Date(as.Date("2021-07-01")), col="pink", linetype="dashed", lwd=1) +
  geom_vline(xintercept=as.Date(as.Date("2022-11-01")), col="lightblue", linetype="dashed", lwd=1) +
  theme_bw()
  
write.csv(data4, "panel.csv", row.names = F)


