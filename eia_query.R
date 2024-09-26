#install.packages("httr")
#install.packages("tidyverse")
#install.packages("rjson")
library(httr)
library(tidyverse)
library("rjson")

new_dir<-"~/Library/CloudStorage/GoogleDrive-sselvaku@terpmail.umd.edu/Shared drives/2024 FIRE-SA/DATA/EIA"
setwd(new_dir)

raw_json <- fromJSON(file = "2019-01-01.json")
eia_json_df <- raw_json$response$data
eia_df <- as.data.frame(do.call(rbind, eia_json_df))
eia_df$respondent <- unlist(eia_df$respondent)


url1<-"https://api.eia.gov/v2/electricity/rto/region-sub-ba-data/data/?frequency=hourly&data[0]=value&facets[subba][]=AE&facets[subba][]=AEP&facets[subba][]=AP&facets[subba][]=ATSI&facets[subba][]=BC&facets[subba][]=CE&facets[subba][]=DAY&facets[subba][]=DEOK&facets[subba][]=DOM&facets[subba][]=DPL&facets[subba][]=DUQ&facets[subba][]=EKPC&facets[subba][]=JC&facets[subba][]=ME&facets[subba][]=PE&facets[subba][]=PEP&facets[subba][]=PL&facets[subba][]=PN&facets[subba][]=PS&facets[subba][]=RECO&start="
# date = YYYY-MM-DD
url2<- "T00&end="
# date = YYYY-MM-DD
url3<-"T01&sort[0][column]=period&sort[0][direction]=desc&offset=0&length=5000&"
api<-"api_key=5Bh3PIQEvXubBUiu4tCV5IN6Kv2AS885S9GPhpBh"

# link = url1 + date + url2 + date + url3 + api

years<-str_pad(2019:2023, width=4, side="left", pad="0")
months<-str_pad(1:12, width=2, side="left", pad="0")
days_per_month<-c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

#test query
y<-1
m<-1
d<-1

days<-str_pad(1:days_per_month[m], width=2, side="left", pad="0")
md<-paste0(years[y], "-", months[m],"-", days[d])
print(md)
link<-paste0(url1, md, url2, "2019-01-02", url3, api)
print(link)
filename <-  paste0(md, ".json") 

resp <- GET(link, write_disk(filename, overwrite = TRUE), progress()) 

raw_json <- fromJSON(file = "2019-01-01.json")
eia_json_df <- raw_json$response$data
eia_df <- as.data.frame(do.call(rbind, eia_json_df))
eia_df$respondent <- unlist(eia_df$respondent)

for (y in 1:length(years)) {
  for (m in 1:length(months)) {
    days<-str_pad(1:days_per_month[m], width=2, side="left", pad="0")
    
    for (d in 1:length(days)) {
      md<-paste0(years[y], "-", months[m],"-", days[d])
      
      print(md)
      
      link<-paste0(url1, md, url2, md, url3, api)
      
      filename <-  paste0(md, ".json") 
      
      resp <- GET(link, write_disk(filename, overwrite = TRUE), progress()) 
    }
  }
  
  if (years[y] == 2020) {
    md<-"2020-02-29"
    
    print(md)
    
    link<-paste0(url1, md, url2, md, url3, api)
    
    filename <-  paste0(md, ".json") 
    
    resp <- GET(link, write_disk(filename, overwrite = TRUE), progress())
  }
}
