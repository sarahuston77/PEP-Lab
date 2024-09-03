# ICC Analysis and Email Notification Script

This R script computes the Intraclass Correlation Coefficient (ICC) for behavioral coding data and automates email notifications if the ICC scores fall below a specified threshold. This tool was developed as part of research efforts at the PEP Lab at UNC to improve coding reliability and streamline communication among research assistants.

## Overview

### Purpose

The script is designed to:
- Calculate ICC for selected columns in an Excel file containing behavioral coding data.
- Generate correlation matrices for the data.
- Automatically send email notifications to research assistants if their ICC scores fall below 0.8, indicating a need for review and improvement.

### Features

- **Automated ICC Calculation**: Computes ICC for multiple columns to assess inter-coder reliability.
- **Correlation Analysis**: Provides a correlation matrix to understand relationships between different coding metrics.
- **Email Notifications**: Sends automated emails to research assistants using Microsoft Outlook, informing them if their coding reliability is below the acceptable threshold.

## Research Context

This script was developed during my tenure as the Research Team Director at the PEP Lab, UNC (August 2022 - Present). Key achievements during this period include:

- **Leadership and Team Management**: Orchestrated a team of six research assistants on behavioral coding, establishing a new leadership position within three months.
- **Code Development**: Created specialized scripts to classify performance levels within extensive binary coding data.
- **Automated Feedback**: Implemented Python-based automation to send detailed emails highlighting areas for improvement, significantly increasing coding accuracy.
- **Reliability Improvement**: Enhanced inter-coder reliability from 0.4 to 0.9 over five weeks and maintained it above 0.85 across three unique datasets.
- **Data Presentation**: Effectively communicated complex data to nationally accredited institutions and contributed as a 2nd author on the paper titled "From Listening to Resonating: Testing Novel Behavioral Coding Schemes of High-Quality Listening and Markers of Social Connection in Conversations with Strangers".
- **Public Engagement**: Presented research findings to over 200 attendees at the UNC poster symposium for undergraduates.

## Usage

1. **Install Required Packages**: Ensure all necessary R packages are installed.
2. **Run the Script**: Execute the script to select your Excel file, compute ICC, and generate notifications.
3. **Email Functionality**: The script uses the `RDCOMClient` package to send emails via Outlook and requires a Windows environment with Outlook installed.

## Prerequisites

- R and RStudio installed on your machine.
- Necessary R packages: `psych`, `readxl`, `lme4`, `Matrix`, `corrr`, `dplyr`, `RDCOMClient` (Windows only).
- Microsoft Outlook installed and configured for email notifications.
