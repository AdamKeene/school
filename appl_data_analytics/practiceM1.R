# Question 8
college <- read.csv('~/Documents/College.csv')
View(college)
rownames(college) <- college[, 1]
View(college)
college <- college[,-1]
View(college)

# plots
summary(college)
pairs(college[,2:10])
plot(college$Outstate ~ factor(college$Private))

# create variable tracking if most students are top 10
Elite <- rep("No", nrow(college))
Elite[college$Top10perc > 50] <- "Yes"
Elite <- as.factor(Elite)
college <- data.frame(college, Elite)
summary(college$Elite)
plot(college$Outstate ~ factor(college$Elite))

hist(college$F.Undergrad, breaks = 10, main='full time undergrads')
hist(college$Outstate, breaks = 15, main='out of state tuition')
hist(college$Terminal, breaks = 5, main='terminal degree staff')

plot(college$Outstate ~ factor(college$Elite))
plot(college$Grad.Rate ~ factor(college$Elite))
# schools with elite students cost more and have higher graduation rates

# Question 9
auto <- read.csv('~/Documents/Auto.csv', na.strings = '?')
auto <- na.omit(auto)
summary(auto)

#a
names(auto)[sapply(auto, is.numeric)] # Quantitative
names(auto)[!sapply(auto, is.numeric)] # Qualitative

#b
sapply(auto[, 1:7], range)

#c
sapply(auto[, 1:7], mean)
sapply(auto[, 1:7], sd)

#d
auto2 <- auto[-(10:85),]
sapply(auto2[, 1:7], range)
sapply(auto2[, 1:7], mean)
sapply(auto2[, 1:7], sd)

#e
plot(auto$mpg, auto$weight)
plot(auto$mpg, auto$displacement)
plot(auto$mpg, auto$horsepower)
# Higher weight, engine displacement, and horsepower all consistently result in lower mpg
plot(auto$displacement, auto$horsepower)
# Displacement and horsepower are strongly correlated, a majority of cars have low on both
is_gm <- grepl("^(chevrolet|gmc|buick|cadillac)", 
               tolower(auto$name))
gm_mean <- mean(auto$mpg[is_gm])
other_mean <- mean(auto$mpg[!is_gm])
barplot(c(other_mean, gm_mean), names.arg = c("Others", "GM"), ylab = "mpg")
# GM vehicles are less fuel efficient

#f
# all predictors correlate with mpg

# Question 10
#a
# install.packages("ISLR2")
library(ISLR2)
Boston
View(Boston)
?Boston
# 506 rows, 13 columns. The columns represent common statistics about cities, like crime rates, home values, and age of houses, 
# as well as some Boston specific statistics like Charles river adjacency and distance from specific Boston employment centers.

#b
pairs(Boston)
# most categories correlate in some way, some categories like nitrogen oxide concentration and distance to employment centres
# or number of rooms per dwelling and percentage of lower status of the population are strongly correlated

#c
# most predictors have some relationship with crime rates, some like age of homes, property value tax rates, and pupil teacher
# ratios have a strong correlation

#d
hist(Boston[Boston$crim>1,]$crim, breaks=20) #lot of 0s
# drops off quite a bit after the first few
sortbycrime <- Boston[order(Boston$crim, decreasing = TRUE), ]
head(sortbycrime, 20)
# the data points aren't labeled but the top 3 are much higher than the rest, 381 is highest with a rating of 88.9 compared to
# the median 0.26

hist(Boston[Boston$tax>1,]$tax, breaks=20)
sortbytax <- Boston[order(Boston$tax, decreasing = TRUE), ]
head(sortbytax, 20)
# the highest tax rates fall well outside of the normal range, either with a tax rate of 711 or 666 compared to the median 330

hist(Boston[Boston$ptratio>1,]$ptratio, breaks=20)
sortbypt <- Boston[order(Boston$ptratio, decreasing = TRUE), ]
head(sortbypt, 20)
