# Find top 4 primary types
# Type of crime date

library(ggplot2)
library(dplyr)
library(mongolite)
library(lubridate)
library(gridExtra)
# library(devtools) # nolint
library(plotrix)



ds <- mongolite::mongo(collection = "crimedb", db = "crimedb")

ds$count()

crimes <- ds$find("{}", fields = '{"_id":0,"Primary Type":1,"Date":1}') # nolint

# print head of domestic
head(crimes)

# use backticks for column names with spaces
our_most_common <- crimes %>%
  group_by(`Primary Type`) %>%
  summarize(Count = n()) %>%
  arrange(desc(Count)) %>%
  head(4) # nolint

head(our_most_common)

our_most_common <- our_most_common$`Primary Type`
head(our_most_common)

crimes <- filter(crimes, `Primary Type` %in% our_most_common) # nolint

head(crimes)
count(crimes)

crimes$Date <- mdy_hms(crimes$Date) # nolint
crimes$month <- month(crimes$Date, label = TRUE)
crimes$weekdays <- weekdays(crimes$Date)
head(crimes)

# write a function to extract the Primary Type and plot the Date in a bar plot
crime_plot <- function(data) {
  weekdaycounts <- as.data.frame(table(data$weekdays))
  weekdaycounts$Var1 <- factor(weekdaycounts$Var1, ordered = TRUE, levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")) # nolint

  ggplot(weekdaycounts, aes(x = Var1, y = Freq)) +
    geom_line(aes(group = 1), size = 2, color = "red") +
    xlab("Day of the week") +
    ylab("Total Crimes") +
    ggtitle("Crimes in the City of Chicago Since 2001") +
    theme(axis.title.x = element_blank(), axis.text.y = element_text(colour = "blue", size = 11, angle = 0, hjust = 1, vjust = 0), axis.title.y = element_text(size = 14), plot.title = element_text(size = 16, colour = "purple", hjust = 0.5)) # nolint
}

g1 <- crime_plot(filter(crimes, `Primary Type` == "THEFT")) + ggtitle("Theft") + ylab("Total Count") # nolint
g1

g2 <- crime_plot(filter(crimes, `Primary Type` == "BATTERY")) + ggtitle("Battery") + ylab("Total Count") # nolint
g2

g3 <- crime_plot(filter(crimes, `Primary Type` == "CRIMINAL DAMAGE")) + ggtitle("Criminal Damage") + ylab("Total Count") # nolint
g3

g4 <- crime_plot(filter(crimes, `Primary Type` == "NARCOTICS")) + ggtitle("Narcotics") + ylab("Total Count") # nolint
g4

x11()
grid.arrange(g1, g2, g3, g4)