install.packages("psych")
install.packages("readxl")
install.packages("lme4")
install.packages("Matrix")
install.packages("corrr")
install.packages("dplyr")

library(Matrix)
library(lme4)
library(readxl)
library(psych)
library(dplyr)
library(corrr)

file.choose(V_VV_A5)

coding_reliability<- read_excel("/Users/sara/Downloads/V_VV_A5.xlsx")
ICC(coding_reliability[,c(2,3,4,5,6)])
V_VV_A5%>%correlate()


