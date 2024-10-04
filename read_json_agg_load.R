# PUT PATH TO GOOGLE DRIVE HERE

# init packages
library("rjson")
library("tidyverse")


setwd("~/Library/CloudStorage/GoogleDrive-sselvaku@terpmail.umd.edu/Shared drives/2024 FIRE-SA/DATA/EIA")

date_seq_base <- seq(as.Date("2019-01-02"),
                     as.Date("2020-01-01"),
                     by = "days")
url2<- "T00"

date_del<-paste0(date_seq_base, url2)

filelist <-  list.files(pattern = "2019")

output<-c()

for (i in 1:length(filelist)) {
  print(i)
  
  # read in eia json
  raw_json <- fromJSON(file = filelist[i])

  # convert json to a spreadsheet
  eia_json_df <- raw_json$response$data
  eia_df <- as.data.frame(do.call(rbind, eia_json_df))
  #eia_df$respondent <- unlist(eia_df$respondent)
  
  eia_df2<- eia_df %>%
    filter(period!=date_del[i]) %>%
    select(-parent, -`parent-name`, -`value-units`) %>%
    mutate(period=as.character(period)) %>%
    mutate(value=as.numeric(value)) %>%
    mutate(subba=as.character(subba)) %>%
    mutate(`subba-name`=as.character(`subba-name`)) 
  
  output<-rbind(output, eia_df2)
}

write.csv(output, 
          "~/Library/CloudStorage/GoogleDrive-sselvaku@terpmail.umd.edu/Shared drives/2024 FIRE-SA/DATA/EIA2/eia_2019.csv",
          row.names = F)

##2020
#skip i = 270, i = 273
date_seq_base <- seq(as.Date("2020-01-02"),
                     as.Date("2021-01-01"),
                     by = "days")
url2<- "T00"

date_del<-paste0(date_seq_base, url2)
filelist <-  list.files(pattern = "2020")

output<-c()

for (i in 274:length(filelist)) {
  print(i)
  
  # read in eia json
  raw_json <- fromJSON(file = filelist[i])
  
  # convert json to a spreadsheet
  eia_json_df <- raw_json$response$data
  eia_df <- as.data.frame(do.call(rbind, eia_json_df))
  #eia_df$respondent <- unlist(eia_df$respondent)
  
  eia_df2<- eia_df %>%
    filter(period!=date_del[i]) %>%
    select(-parent, -`parent-name`, -`value-units`) %>%
    mutate(period=as.character(period)) %>%
    mutate(value=as.numeric(value)) %>%
    mutate(subba=as.character(subba)) %>%
    mutate(`subba-name`=as.character(`subba-name`)) 
  
  output<-rbind(output, eia_df2)
}

write.csv(output, 
          "~/Library/CloudStorage/GoogleDrive-sselvaku@terpmail.umd.edu/Shared drives/2024 FIRE-SA/DATA/EIA2/eia_2020.csv",
          row.names = F)

##2021
date_seq_base <- seq(as.Date("2021-01-02"),
                     as.Date("2022-01-01"),
                     by = "days")
url2<- "T00"

date_del<-paste0(date_seq_base, url2)
filelist <-  list.files(pattern = "2021")

output<-c()
#skip i = 259
for (i in 260:length(filelist)) {
  print(i)
  
  # read in eia json
  raw_json <- fromJSON(file = filelist[i])
  
  # convert json to a spreadsheet
  eia_json_df <- raw_json$response$data
  eia_df <- as.data.frame(do.call(rbind, eia_json_df))
  #eia_df$respondent <- unlist(eia_df$respondent)
  
  eia_df2<- eia_df %>%
    filter(period!=date_del[i]) %>%
    select(-parent, -`parent-name`, -`value-units`) %>%
    mutate(period=as.character(period)) %>%
    mutate(value=as.numeric(value)) %>%
    mutate(subba=as.character(subba)) %>%
    mutate(`subba-name`=as.character(`subba-name`)) 
  
  output<-rbind(output, eia_df2)
}

write.csv(output, 
          "~/Library/CloudStorage/GoogleDrive-sselvaku@terpmail.umd.edu/Shared drives/2024 FIRE-SA/DATA/EIA2/eia_2021.csv",
          row.names = F)

##2022
date_seq_base <- seq(as.Date("2022-01-02"),
                     as.Date("2023-01-01"),
                     by = "days")
url2<- "T00"

date_del<-paste0(date_seq_base, url2)
filelist <-  list.files(pattern = "2022")

output<-c()

for (i in 1:length(filelist)) {
  print(i)
  
  # read in eia json
  raw_json <- fromJSON(file = filelist[i])
  
  # convert json to a spreadsheet
  eia_json_df <- raw_json$response$data
  eia_df <- as.data.frame(do.call(rbind, eia_json_df))
  #eia_df$respondent <- unlist(eia_df$respondent)
  
  eia_df2<- eia_df %>%
    filter(period!=date_del[i]) %>%
    select(-parent, -`parent-name`, -`value-units`) %>%
    mutate(period=as.character(period)) %>%
    mutate(value=as.numeric(value)) %>%
    mutate(subba=as.character(subba)) %>%
    mutate(`subba-name`=as.character(`subba-name`)) 
  
  output<-rbind(output, eia_df2)
}

write.csv(output, 
          "~/Library/CloudStorage/GoogleDrive-sselvaku@terpmail.umd.edu/Shared drives/2024 FIRE-SA/DATA/EIA2/eia_2022.csv",
          row.names = F)
##2023
date_seq_base <- seq(as.Date("2023-01-02"),
                     as.Date("2024-01-01"),
                     by = "days")
url2<- "T00"

date_del<-paste0(date_seq_base, url2)
filelist <-  list.files(pattern = "2023")

output<-c()

for (i in 1:length(filelist-1)) {
  print(i)
  
  # read in eia json
  raw_json <- fromJSON(file = filelist[i])
  
  # convert json to a spreadsheet
  eia_json_df <- raw_json$response$data
  eia_df <- as.data.frame(do.call(rbind, eia_json_df))
  #eia_df$respondent <- unlist(eia_df$respondent)
  
  eia_df2<- eia_df %>%
    filter(period!=date_del[i]) %>%
    select(-parent, -`parent-name`, -`value-units`) %>%
    mutate(period=as.character(period)) %>%
    mutate(value=as.numeric(value)) %>%
    mutate(subba=as.character(subba)) %>%
    mutate(`subba-name`=as.character(`subba-name`)) 
  
  output<-rbind(output, eia_df2)
}

raw_json <- fromJSON(file = filelist[365])

# convert json to a spreadsheet
eia_json_df <- raw_json$response$data
eia_df <- as.data.frame(do.call(rbind, eia_json_df))
#eia_df$respondent <- unlist(eia_df$respondent)

eia_df2<- eia_df %>%
  select(-parent, -`parent-name`, -`value-units`) %>%
  mutate(period=as.character(period)) %>%
  mutate(value=as.numeric(value)) %>%
  mutate(subba=as.character(subba)) %>%
  mutate(`subba-name`=as.character(`subba-name`)) 

output<-rbind(output, eia_df2)

write.csv(output, 
          "~/Library/CloudStorage/GoogleDrive-sselvaku@terpmail.umd.edu/Shared drives/2024 FIRE-SA/DATA/EIA2/eia_2023.csv",
          row.names = F)
