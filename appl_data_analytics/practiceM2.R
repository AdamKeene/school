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
# a.
summary(Carseats)
seatsfit <- lm(Sales ~ Price + Urban + US, data = Carseats)
# b.
summary(seatsfit)
# It is statistically proven that price increases lead to a .05 decrease in sales per unit of price, and being in the US leads to an expected increase in sales of 1.2 units.
# The data suggests that being in an urban environment decreases sales by .02, but given the high P value there is no evidence of a correlation.
# c.
# Sales = 13.04 + -0.05 * Price - 0.02 * UrbanYes + 1.20 * USYes
# d.
# We can reject the null hypothesis for Price and USYes, but not for UrbanYes
# e.
seatssmall <- lm(Sales ~ Price + US, data = Carseats)
summary(seatssmall)
# f.
# a: R^2 .2393, adjusted R^2 .2335
# e: R^@ .2393, adjusted R^2 .2354
# both models perform similarly, both had the same R^2 but e had a slightly higher adjusted R^2
# g.
confint(seatssmall, level = .95)
# h.
par(mfrow=c(2,2))
plot(seatssmall)
# There's a few points that could be called outliers or high leverage, but much less so than the outliers in the Auto dataset.

# 15
bostoncrim <- subset(Boston, select = -crim)
summary(bostoncrim)
# a.
linearcrim <- lapply(bostoncrim, function(x) lm(Boston$crim ~ x))
printCoefmat(do.call(rbind, lapply(linearcrim, function(x) coef(summary(x))[2, ])))
# all predictors except for "chas" have a statistically significant association
plot(Boston$chas, Boston$crim)
plot(Boston$indus, Boston$crim)
plot(Boston$nox, Boston$crim)
plot(Boston$dis, Boston$crim)
# plot for chas appears to be less correlated than the first three predictors with the lowest p values
# b.
regcrim <- lm(crim ~ ., data = Boston)
summary(regcrim)
# dis, rad, medv, and zn are the predictors with a statistically significant correlation
plot(Boston$dis, Boston$crim)
plot(Boston$rad, Boston$crim)
plot(Boston$medv, Boston$crim)
plot(Boston$zn, Boston$crim)
# no linear looking relationships but clear correlation
# c.
plot(sapply(fits, function(x) coef(x)[2]), coef(regcrim)[-1], xlab = "univariate regression", ylab = "multiple regression", cex = .2)
# One outlier: nox
# d.
# print fitments of each predictor
qualonly <- setdiff(names(Boston), c("chas", "crim"))
fits <- lapply(qualonly, function(p) {
  lm(crim ~ poly(get(p), 3, raw = TRUE), data = Boston)
})
for (fit in fits) printCoefmat(coef(summary(fit)))
# Yes, the cubic association is significant in indus, nox, age, dis, ptratio, and medv