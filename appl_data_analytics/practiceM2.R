#  8, 9, 10 and 15

library(ISLR2)

# 8.
# a.
autompg <- lm(mpg ~ horsepower, data = Auto)
summary(autompg)
# i. The p value of 2.2e-16 indicates a strong correlation between horsepower and mpg
# ii. The multiple R-squared of .6059 indicates that 60.59% of the variance in mpg can be explained by horsepower. This indicates a relatively strong relationship.
# iii. The relationship between horsepower and mpg is negative, as indicated by horsepower's -.15 estimate. This means as horsepower increases mpg is expected to decrease.
# iv.
predict(autompg, data.frame(horsepower = 98), interval = "prediction")
predict(autompg, data.frame(horsepower = 98), interval = "confidence")
# The predicted mpg is 24.48 with a confidence interval of (23.97, 24.96) and a prediction interval of (14.80, 34.12).

# b.
plot(Auto$horsepower, Auto$mpg, xlab = "hp", ylab = "mpg")
abline(autompg)

# c.
par(mfrow=c(2,2))
plot(autompg)
# The strong pattern seen in the residuals indicates non-linearity in the data. Linear relationships shouldn't have any discernible pattern.

# 9.
# a.
pairs(Auto)
# b.
no_name = subset(Auto, select = -name)
cor(no_name)
# c.
c <- lm(mpg ~ ., data = no_name)
summary(c)
# Yes, some predictors have a relationship, particularly displacement, weight, year, and origin. The coefficient for year, .75, suggests mpg increases by .75 every year.

# d.
par(mfrow = c(2, 2))
plot(autompg, cex = .1)
# Yes, there are some outliers in the residuals data and there are some observations with abnormally high leverage. Observation 334 and 323 are the biggest outliers in the residuals data, and 117 has the highest leverage in the data.

# e.
summary(lm(formula = mpg ~ . * ., data = no_name))
# acceleration:origin, displacement:year, and acceleration:year are the most significant relationships.
summary(lm(formula = mpg~acceleration*origin+displacement*year+acceleration*year, data = no_name))

# f.
# I'm going to just use horsepower because it seems to be the most significant variable
par(mfrow = c(2, 2))
plot(Auto$horsepower, Auto$mpg, cex = .1)
plot(log(Auto$horsepower), Auto$mpg, cex = .1)
plot(sqrt(Auto$horsepower), Auto$mpg, cex = .1)
plot(Auto$horsepower^2, Auto$mpg, cex = .1)
# log plot looks the flattest

summary(lm(mpg ~ horsepower, data = Auto))
summary(lm(mpg ~ log(horsepower), data = Auto))
# fitment gives .66 R^2 with log vs .61 without

# 10.
