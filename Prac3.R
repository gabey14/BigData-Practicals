# NOTE Shubash Sir Practical


library(ggplot2)
library(dplyr)
library(mongolite)
library(lubridate)
library(gridExtra)
# library(devtools) # nolint
library(plotrix)



ds <- mongolite::mongo(collection = "crimedb", db = "crimedb")

ds$count()


domestic <- ds$find('{"Domestic":"TRUE"}', fields = '{"_id":0,"Domestic":1,"Date":1}') # nolint

domestic$Date <- mdy_hms(domestic$Date) # nolint


domestic$weekday <- weekdays(domestic$Date)


domestic$hour <- hour(domestic$Date)

domestic$month <- month(domestic$Date, label = TRUE)

domestic %>% head(10)

weekdaycounts <- as.data.frame(table(domestic$weekday))
weekdaycounts

weekdaycounts$Var1 <- factor(weekdaycounts$Var1, ordered = TRUE, levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")) # nolint

weekdaycounts

ggplot(weekdaycounts, aes(x = Var1, y = Freq)) +
  geom_line(aes(group = 1), size = 2, color = "red") +
  xlab("Day of the week") +
  ylab("Total Domestic Crimes") +
  ggtitle("Domestic Crimes in the City of Chicago Since 2001") +
  theme(axis.title.x = element_blank(), axis.text.y = element_text(colour = "blue", size = 11, angle = 0, hjust = 1, vjust = 0), axis.title.y = element_text(size = 14), plot.title = element_text(size = 16, colour = "purple", hjust = 0.5)) # nolint