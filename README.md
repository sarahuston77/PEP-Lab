# GPS Data Wrangling and ICC Analysis Scripts

## Overview

This repository includes two key R scripts that showcase my data analysis and automation work in the Positive Psychophysiology and Emotions (PEP) Lab at UNC Chapel Hill. These scripts contribute to large-scale data processing for behavioral research related to sleep, positivity resonance, and coding reliability.

### 1. **GPS Data Wrangling Script**

This script processes and analyzes GPS data, involving over 300,000 lines of data for a comprehensive study on sleep and positivity resonance. Key functionalities include:

- **Data Preparation**: Reads and processes GPS data from a CSV file.
- **Coordinate Rounding and Merging**: Rounds latitude and longitude to the 4th decimal place and merges them for consistency.
- **Time Filtering**: Extracts and filters data between 12:00 AM and 6:00 AM.
- **Grouping and Aggregation**: Groups data by `pid` to find the most common coordinate and calculates total time spent at the most common location.
- **Time Calculation**: Calculates the total time spent per participant per day at the most common location and expresses it as a percentage of the day.
- **Output**: Saves the processed data to a CSV file for further analysis.

### 2. **ICC Analysis and Email Notification Script**

This R script is designed to compute the Intraclass Correlation Coefficient (ICC) automate communication among research assistants to ensure data reliability. Features include:

- **Automated ICC Calculation**: Calculates ICC for multiple columns in an Excel file to assess inter-coder reliability.
- **Correlation Analysis**: Provides a correlation matrix for deeper insights into coding metrics.
- **Email Notifications**: Uses Microsoft Outlook to automatically send notifications when ICC scores fall below 0.8, prompting review and improvement.

## Research Context

These scripts were developed during my tenure as the Research Team Director at the PEP Lab, UNC Chapel Hill (August 2022 - Present), where I contributed significantly to the lab’s research initiatives. My work focused on data analysis, reliability improvement, and coding management.


## Conclusion

These scripts demonstrate my ability to handle complex data sets, develop robust analysis tools, and implement automation for effective research management. My contributions to the PEP Lab highlight my technical skills, leadership, and dedication to advancing behavioral research.
