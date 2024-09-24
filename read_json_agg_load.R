# PUT PATH TO GOOGLE DRIVE HERE
gdrive_path <-
  "/Users/vsrivastava/Library/CloudStorage/GoogleDrive-vsriv81@terpmail.umd.edu"

# init packages
library("rjson")
library("tidyverse")

# set working directory to /DATA/
data_dir <- paste0(
  gdrive_path,
  "/Shared drives/2023 FIRE-SA/FALL OUTPUT/Team EV Electric Grid/DATA/"
)
setwd(data_dir)

# read in respondent-nerc match csv
nerc_match <- read.csv("respondent-nerc-match.csv")

# set working directory to location of EIA BA JSON
json_dir <- paste0(
  data_dir,
  "/EIA-BA-JSON"
)
setwd(json_dir)

# files to clean+merge
filelist <- c(
  list.files(pattern = "^2020.*\\.json$"),
  list.files(pattern = "^2021.*\\.json$"),
  list.files(pattern = "^2022.*\\.json$")
)

# create empty frame to hold all matched data
eia_nerc_complete <- data.frame(matrix(
  ncol = 9,
  nrow = 0
))

max <- length(filelist)

for (i in 1:max) {
  print(i)

  # read in eia json
  raw_json <- fromJSON(file = filelist[i])

  # convert json to a spreadsheet
  eia_json_df <- raw_json$response$data
  eia_df <- as.data.frame(do.call(rbind, eia_json_df))
  eia_df$respondent <- unlist(eia_df$respondent)

  # merge json with nerc regions
  eia_nerc_df <- merge(
    x = eia_df,
    y = nerc_match,
    by = "respondent",
    all.x = TRUE
  )

  # append to output data frame
  eia_nerc_complete <- rbind(eia_nerc_complete, eia_nerc_df)
}

# aggregate eia data by hour and nerc region
nerc_aggregate <- eia_nerc_complete %>%
  group_by(nerc.region, period) %>%
  summarize(demand.mwh = sum(unlist(value)))

setwd(substr(json_dir, 1, nchar(json_dir) - 15))
nerc_aggregate$period <- unlist(nerc_aggregate$period)
write_csv(nerc_aggregate, "eia_nerc_aggregate.csv")
