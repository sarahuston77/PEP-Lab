Install these packages if you don't have them already
install.packages("psych")
install.packages("readxl")
install.packages("lme4")
install.packages("Matrix")
install.packages("corrr")
install.packages("dplyr")

# Load the libraries we'll need
library(Matrix)   # Matrix stuff
library(lme4)     # For mixed-effects models
library(readxl)   # To read Excel files
library(psych)    # For stats, especially ICC
library(dplyr)    # For data manipulation
library(corrr)    # To work with correlations

# Open a window to pick the Excel file
file_path <- file.choose()

# Get just the file name from the path (useful for emails)
file_name <- basename(file_path)

# Read in the data from the Excel file
coding_reliability <- read_excel(file_path)

# Compute ICC for the relevant columns (change these if your data structure is different)
icc_results <- ICC(coding_reliability[, c(2, 3, 4, 5, 6)])

# Print ICC results so we can see what's going on
print(icc_results)

# Calculate correlations (just because why not)
correlation_matrix <- coding_reliability %>% correlate()

# Print correlation matrix to check it out
print(correlation_matrix)

# List of RAs and their emails (update as needed)
ra_emails <- list(
  Sara = "shuston@unc.edu",
  Josie = "jnavola@unc.edu",
  Ria = "rpatel@ad.unc.edu",
  Lilly = "lmack@unc.edu",
  Jack = "jjohn1@unc.edu"
)

# Only works if you're on Windows with Outlook
if (.Platform$OS.type == "windows") {
  # Uncomment this if you need to install the RDCOMClient package
  # install.packages("RDCOMClient", repos = "http://www.omegahat.net/R", type = "source")
  library(RDCOMClient)

  # Function to send an email via Outlook
  send_email <- function(to, subject, body) {
    OutApp <- COMCreate("Outlook.Application")  # Start Outlook
    outMail <- OutApp$CreateItem(0)  # New email
    outMail[["To"]] <- to
    outMail[["subject"]] <- subject
    outMail[["body"]] <- body
    outMail$Send()  # Send it
  }

  # Loop over the columns for each RA and email if their ICC score is too low
  for (i in 2:6) {
    ra_name <- names(coding_reliability)[i]
    ra_email <- ra_emails[[ra_name]]
    ra_icc <- icc_results$results[i - 1, "ICC"]
    
    if (ra_icc < 0.8) {
      subject <- paste("Low ICC Scores for", ra_name)
      body <- paste(
        "Hey", ra_name, ",\n\n",
        "Just a heads up: Your ICC scores are below 0.8 for the file:", file_name, ".\n",
        "Take a look when you get a chance.\n\n",
        "Thanks,\nSara"
      )
      send_email(ra_email, subject, body)
    }
  }
} else {
  print("Sorry, this email thing only works on Windows with Outlook.")
}
