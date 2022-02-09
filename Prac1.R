# NOTE Roy Sir Practical

library(ggplot2)
library(dplyr)
library(mongolite)
library(lubridate)
library(gridExtra)
# library(devtools) #nolint
library(plotrix)

ds <- mongolite::mongo(collection = "crimedb", db = "crimedb")

ds$count()

# options(max.print=10000000) #nolint

c(1:10) %>% sum()
# iterate
ds$iterate()$one()

length(ds$distinct("Primary Type"))


ds$distinct("Primary Type") %>% head(10)

# find primary type as assault
ds$count('{"Domestic":"TRUE","Primary Type":"THEFT"}')
ds$count('{"Domestic":"FALSE","Primary Type":"BATTERY"}')
ds$count('{"Domestic":"TRUE","Primary Type":"ASSAULT"}')


# m$aggregate('[{"$group":{"_id":"$carrier", "count": {"$sum":1}, "average":{"$avg":"$distance"}}}]') #nolint

# > SIR solution
# a <- ds$aggregate('[{"$group":{"_id":"$Location Description", "count": {"$sum":1}}}]')%>%na.omit()%>%arrange(desc(count))%>%head(10) #nolint
# a

# ans <- ds$aggregate('[{"$group":{"_id":"$Location Description", "count": {"$sum":1}}}]') #nolint
# ans


ans <- ds$aggregate('[{"$group":{"_id":"$Location Description", "count": {"$sum":1}}}, {"$sort":{"count":-1}}, {"$limit":10}]') %>% na.omit() # nolint
ans

x <- ans["count"]
xls <- ans["_id"]
m <- unlist(x)
n <- unlist(xls)
pie(m, n, col = rainbow(length(m)))



df <- data.frame(ans)
desc <- df$X_id
count <- df$count
pie(count, desc, radius = 1, col = rainbow(n = 10))

# x11() #nolint
barplot(count, names.arg = desc, col = rainbow(n = 10))


# > Subash Sir
# ds$aggregate('[{"$group":{"_id":"$Location Description", "Count": {"$sum":1}}}]')%>%na.omit()%>%arrange(desc(Count))%>%head(10)  #nolint


# ds$aggregate('[{"$group":{"_id":"$Location Description", "Count": {"$sum":1}}}]')%>%na.omit()%>%arrange(desc(Count))%>%head(10)%>%ggplot(aes(x=reorder(`_id`,Count),y=Count))+geom_bar(stat="identity",color="skyblue",fill="#b35900")+geom_text(aes(label = Count),color="blue") #nolint

ds$aggregate('[{"$group":{"_id":"$Location Description", "Count": {"$sum":1}}}]') %>% # nolint
  na.omit() %>%
  arrange(desc(Count)) %>%
  head(10) %>%
  ggplot(aes(x = reorder(`_id`, Count), y = Count)) +
  geom_bar(stat = "identity", color = "skyblue", fill = "#b35900") +
  geom_text(aes(label = Count), color = "blue") +
  coord_flip() +
  xlab("Location Description") # nolint