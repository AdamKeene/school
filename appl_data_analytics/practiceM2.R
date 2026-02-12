#  8, 9, 10 and 15

auto <- read.csv('~/Documents/Auto.csv')

a <- lm(mpg ~ horsepower, data = auto)
summary(a)
# i. The p value of 2.2e-16 indicates a strong correlation between horsepower and mpg
# ii. The RSE is 4.056 on 303 degrees of freedom