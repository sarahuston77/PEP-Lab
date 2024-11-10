# Install packages to data wrangle
install.packages("data.table")

# Load libraries
library(data.table)
library(dplyr)

# Read data into a dataframe based on your path (can copy and paste this usally)
df <- read.csv("/Users/sara/Downloads/GPS_filtered_fullmerge.csv")

# Round latitude and longitude coordinates to 4th decimal place
df$lat_rounded <- round(df$Lat, 4)
df$long_rounded <- round(df$Long, 4)

# Merge latitude and longitude coordinates together
df$lat_long_combined <- paste(sprintf("%.4f", df$lat_rounded), sprintf("%.4f", df$long_rounded), sep = "_")

# Create a column with only the hour, making it zero if only the date is present e.g., 12/7/18 (corresponds to 0 o'clock)
df$hour <- suppressWarnings(as.numeric(format(as.POSIXct(df$Timestamp, format="%m/%d/%Y %H:%M"), "%H")))
df$hour[is.na(df$hour)] <- 0

# Filter the time so it between 12:00 AM and 6:00 AM and the latitude/longitude pair exists
time_filtered <- df[df$hour >= 0 & df$hour < 6 & !is.na(df$hour) & !is.na(df$lat_long_combined) & df$lat_long_combined != "NA_NA", ]

# Group by pid to find the most frequent value of latitude and longitude
most_common <- time_filtered %>% group_by(pid) %>% summarize (lat_long_combined = names(which.max(table(lat_long_combined))))

# Add home cluster to df based on pid matching
df <- df %>% left_join(most_common, by = c("pid")) %>% rename(home_coordinate = lat_long_combined.y)

# Renamed the column 
colnames(df)[which(names(df) == "lat_long_combined.x")] <- "lat_long_combined"

# Calculate total time per pid per date using grouping and adding 2 minutes for each match 
total_time_per_pid_date <- df %>% group_by(Day, pid) %>% summarize(total_time_minutes = sum(ifelse(home_coordinate == lat_long_combined, 2, 0)), .groups = 'drop')

# Calculating time spent at most common coordinate pair (each cell is associated with 2 minutes)
df <- df %>% left_join(total_time_per_pid_date, by = c("Day", "pid"))

# Percentage column
df$percent_of_day <- df$total_time_minutes * 100 / 1440 
  
# View final df
View(df)

# Make sure working directly is set correctly for output
getwd()
setwd("/Users/sara/Downloads")

# Save the data frame as the CSV file
write.csv(df, "GPS_filtered_fullmerge.csv")
print("CSV outputted.")
