library(httr)
library(tidyverse)

current_dir<-dirname(rstudioapi::getSourceEditorContext()$path)
new_dir<-paste0(substr(current_dir, 1, nchar(current_dir) - 5), "/DATA/EIA-by-BA-JSON")
setwd(new_dir)

url1<-"https://api.eia.gov/v2/electricity/rto/region-data/data/?frequency=hourly&data[0]=value&facets[type][]=D&start="
# date = YYYY-MM-DD
url2<- "T00&end="
# date = YYYY-MM-DD
url3<-"T23&sort[0][column]=period&sort[0][direction]=desc&offset=0&length=5000&"
api<-"api_key=E474z8ISoEFVc8q7IlFI3cPVY3ELyBeA9h2AzLUf"

# link = url1 + date + url2 + date + url3 + api

years<-str_pad(2020:2022, width=4, side="left", pad="0")
months<-str_pad(1:12, width=2, side="left", pad="0")
days_per_month<-c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

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