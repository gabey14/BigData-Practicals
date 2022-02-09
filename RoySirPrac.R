library(ggplot2)
library(dplyr)
library(mongolite)
library(lubridate)
library(gridExtra)
# library(devtools) #nolint
library(plotrix)
my_collection <- mongo(collection = "crimedb", db = "crimedb") # create connection #nolint
my_collection$count()

# filtering

domestic <- my_collection$find('{"Domestic":"TRUE"}', fields = '{"_id":0, "Domestic":1, "Date":1}') # nolint
domestic

install.packages("lubridate")
?mdy_hms

domestic$Date <- mdy_hms(domestic$Date) # nolint
head(domestic$Date)

domestic$weekday <- weekdays(domestic$Date)
head(domestic$weekday)

domestic$month <- months(domestic$Date)
head(domestic$month)

domestic$hour <- hours(domestic$Date)
head(domestic)

## How many crimes occur on each day
weekdaycounts <- as.data.frame(table(domestic$weekday))
weekdaycounts


## Ploting graphs
# pie chart
x <- weekdaycounts["Freq"]
stats <- unlist(x)
stats

y <- a <- weekdaycounts["Var1"]
week_day <- unlist(y)
week_day


# Plot the chart.
pie(stats, week_day)

# rainbow
pie(stats, location, col = rainbow(10))


# Bar graph in different way of data fetching
df <- data.frame(weekdaycounts)
stats <- df$Freq
week_day <- df$Var1
barplot(stats, xlab = "No.of Crimes", ylab = "Days of week", names.arg = week_day, col = rainbow(n = 10)) # nolint

## Graph
ggplot(weekdaycounts, aes(x = Var1, y = Freq)) +
  geom_line(aes(group = 1), size = 1, color = "black") +
  xlab("Day of the week") +
  ylab("Total Domestic Crimes") +
  ggtitle("Domestic crimes in the city of chicago")