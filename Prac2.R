# NOTE Shubash Sir Practical


library(ggplot2)
library(dplyr)
library(mongolite)
library(lubridate)
library(gridExtra)
# library(devtools) #nolint
library(plotrix)

ds <- mongolite::mongo(collection = "crimedb", db = "crimedb")

ds$count()

locdes <- ds$find(fields = '{"_id":false,"Location Description":true}')
# locdes

# tbl = table(locdes) #nolint
# tblsorted = sort(tbl,descending = TRUE) #nolint

# tblsorted%>%head(10) #nolint




tbl <- table(locdes)
tblsorted <- sort(tbl)

result <- tblsorted %>% head(10)
# result

df <- data.frame(result)
desc <- df$locdes
count <- df$Freq

pie(count, desc)

# par(mar=c(1,1,1,1)) #nolint
pie(count, desc, col = rainbow(9))
# x11() #nolint
