# Install packages to data wrangle
install.packages("tidyverse")
install.packages("data.table")

# Load libraries
library('tidyverse')
library(data.table)

# Read data into a dataframe based on your path (can copy and paste this usally)
df <- read.csv("/Users/sara/Downloads/GPS_filtered_fullmerge(in).csv")

# View the dataframe
# View(df)

# Add empty column
df_with_new_col <- df %>%
  add_column(home_cluster = NA)
df_with_new_col

# View updated dataframe
# View(df_with_new_col)

# Create a df to keep track of the frequency of each time cluster
scores_df <- data.frame(pid = character())

# Loop through each PID and create a df with
# the frequency of each cluster between 1:00 AM and 6:00 AM
row_index <- 1  # Initialize row index for accessing other columns
for (timestamp in df_with_new_col$"Timestamp") {
  
  # Extract the hour
  hour <- as.numeric(format(as.POSIXct(timestamp, format="%m/%d/%Y %H:%M"), "%H"))
  
  # Check if the time is between 1:00 AM and 6:00 AM
  if (!is.na(hour) && hour >= 1 && hour < 6) {
    
    # pid in scores
    pid_value <- df_with_new_col$pid[row_index]
    timecluster <- as.character(df_with_new_col$timecluster[row_index])
    
    if (pid_value %in% scores_df[,"pid"]) {
      # Position of pid in scores_df
      position <- which(scores_df[,"pid"] == pid_value)
      
      # pid and time cluster in scores
      if (timecluster %in% colnames(scores_df)) {
        
        # Add to the counter for the time_cluster
        scores_df[position, timecluster] <- as.integer(scores_df[position, timecluster]) + 1
      } else {
      
        # pid in scores, but not time_cluster
        scores_df[, ncol(scores_df) + 1] <- 0
        colnames(scores_df)[ncol(scores_df)] <- timecluster
        scores_df[position, timecluster] <- 1
      }
      
    } else {
      
      # Add pid to the scores df since it is not there
      new_row <- as.list(rep(0, ncol(scores_df)))
      names(new_row) <- colnames(scores_df)
      new_row$pid <- pid_value
      scores_df <- rbind(scores_df, new_row)
      
      # Position of pid in scores_df
      position <- which(scores_df[,"pid"] == pid_value)
      
      # pid and time cluster in scores
      if (timecluster %in% colnames(scores_df)) {
        
        # Add to the counter for the time_cluster
        scores_df[position, timecluster] <- scores_df[position, timecluster] + 1
        
      } else {
        # pid in scores, but not time_cluster
        scores_df[, ncol(scores_df) + 1] <- 0
        colnames(scores_df)[ncol(scores_df)] <- timecluster
        scores_df[position, timecluster] <- 1
      }
    }
  }
  
  # Increment the row index
  row_index <- row_index + 1
}

# See the most common places
View(scores_df)

# Map pids to max columns
row_index_2 <- 1
pid_values <- scores_df$pid
pid_max_col_map <- sapply(1:nrow(scores_df), function(row_index) {
  colnames(scores_df)[which.max(scores_df[row_index, ])]
})
names(pid_max_col_map) <- pid_values

# Match the pid's across dataframes
match_indices <- match(df_with_new_col$pid, pid_values)
max_cols <- pid_max_col_map[match_indices]

# Add the new col with the home data
df_with_new_col[, ncol(df_with_new_col)] <- max_cols

View(df_with_new_col)

getwd()
setwd("/Users/sara/Downloads")

# Save the data frame as the CSV file
write.csv(df_with_new_col, "GPS_filtered_fullmerge(in).csv")

print("CSV file has been written successfully.")
