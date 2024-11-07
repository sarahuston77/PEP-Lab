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

# Create a column with only the hour
df$hour <- suppressWarnings(as.numeric(format(as.POSIXct(df$Timestamp, format="%m/%d/%Y %H:%M"), "%H")))
df$hour[is.na(df$hour)] <- 0

# Check that time is between 12:00 AM and 6:00 AM
time_filtered <- df[df$hour >= 0 & df$hour < 6 & !is.na(df$hour) & !is.na(df$lat_long_combined) & df$lat_long_combined != "NA_NA", ]

# Extract unique pids
unique_pids <- data.frame(pids = unique(time_filtered$pid))
unique_pids$most_frequent <- NA

# Using unique pids, find most common latitude and longitude pair overall
row <- 1
for (pid in unique_pids$pids) {
  
  # Update the pid with the associated most frequent value
  unique_pids$most_frequent[row] <- names(which.max(table(time_filtered$lat_long_combined[time_filtered$pid == pid])))
  
  print(table(time_filtered$lat_long_combined[time_filtered$pid == pid]))
  row <- row + 1

}

# Insert column with most common coordinate pair
df$home_coordinate <- unique_pids$most_frequent[match(df$pid, unique_pids$pids)]

# Make date the proper format
df$date <- as.Date(df$Timestamp, format="%m/%d/%Y")

# Calculate total time per pid per date using grouping and adding 2 minutes for each match 
total_time_per_pid_date <- df %>% group_by(date, pid) %>% summarize(total_time_minutes = sum(ifelse(home_coordinate == lat_long_combined, 2, 0)), .groups = 'drop')

# Calculating time spent at most common coordinate pair (each cell is associated with 2 minutes)
df <- df %>% left_join(total_time_per_pid_date, by = c("date", "pid"))

# Percentage column
df$percent_of_day <- df$total_time_minutes * 100 / 1440 
  
# View final df
View(df)

# Make sure working directly is set correctly for output
getwd()
setwd("/Users/sara/Downloads")

# Save the data frame as the CSV file
write.csv(df, "GPS_filtered_fullmerge(in).csv")
print("CSV outputted.")
