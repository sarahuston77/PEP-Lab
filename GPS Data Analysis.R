# Install packages to open csv
install.packages("tidyverse")

# Load libraries
library('tidyverse')

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

# Find the max value from the common scores during that time
row_index_2 <- 1
for (pid_value in scores_df$"pid") {
  
  # Find what # they stayed the most at
  max_col <- colnames(scores_df)[which.max(scores_df[row_index_2, ])]
  
  # Put this number into df_with_new_col
  row_index_3 <- 1
  for (pid_og in df_with_new_col$pid) {
    if (pid_value == pid_og) {
      df_with_new_col[row_index_3, ncol(df_with_new_col)] <- max_col
    }
    row_index_3 <- row_index_3 + 1
  }
  row_index_2 <- row_index_2 + 1
}

df <- df_with_new_col

View(df)
