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
plot(no_name, cex = 0.2)
