## 5.3.1 The Validation Set Approach

library(ISLR2)
set.seed(1)
train <- sample(392, 196)

lm.fit <- lm(mpg ~ horsepower, data = Auto, subset = train)

attach(Auto)
mean((mpg - predict(lm.fit, Auto))[-train]^2)
# [1] 23.27

lm.fit2 <- lm(mpg ~ poly(horsepower, 2), data = Auto,
  subset = train)
mean((mpg - predict(lm.fit2, Auto))[-train]^2)
# [1] 18.72
lm.fit3 <- lm(mpg ~ poly(horsepower, 3), data = Auto,
  subset = train)
mean((mpg - predict(lm.fit3, Auto))[-train]^2)
# [1] 18.79

set.seed(2)
train <- sample(392, 196)
lm.fit <- lm(mpg ~ horsepower, subset = train)
mean((mpg - predict(lm.fit, Auto))[-train]^2)
# [1] 25.73
lm.fit2 <- lm(mpg ~ poly(horsepower, 2), data = Auto,
  subset = train)
mean((mpg - predict(lm.fit2, Auto))[-train]^2)
# [1] 20.43
lm.fit3 <- lm(mpg ~ poly(horsepower, 3), data = Auto,
  subset = train)
mean((mpg - predict(lm.fit3, Auto))[-train]^2)
# [1] 20.39


## 5.3.2 Leave-One-Out Cross-Validation

glm.fit <- glm(mpg ~ horsepower, data = Auto)
coef(glm.fit)
# (Intercept) horsepower
#      39.936      -0.158

lm.fit <- lm(mpg ~ horsepower, data = Auto)
coef(lm.fit)
# (Intercept) horsepower
#      39.936      -0.158

library(boot)
glm.fit <- glm(mpg ~ horsepower, data = Auto)
cv.err <- cv.glm(Auto, glm.fit)
cv.err$delta
#     1     1
# 24.23 24.23

cv.error <- rep(0, 10)
for (i in 1:10) {
  glm.fit <- glm(mpg ~ poly(horsepower, i), data = Auto)
  cv.error[i] <- cv.glm(Auto, glm.fit)$delta[1]
}
cv.error
# [1] 24.23 19.25 19.33 19.42 19.03 18.98 18.83 18.96 19.07 19.49


## 5.3.3 k-Fold Cross-Validation

set.seed(17)
cv.error.10 <- rep(0, 10)
for (i in 1:10) {
  glm.fit <- glm(mpg ~ poly(horsepower, i), data = Auto)
  cv.error.10[i] <- cv.glm(Auto, glm.fit, K = 10)$delta[1]
}
cv.error.10
# [1] 24.27 19.27 19.35 19.29 19.03 18.90 19.12 19.15 18.87 20.96


## 5.3.4 The Bootstrap

alpha.fn <- function(data, index) {
  X <- data$X[index]
  Y <- data$Y[index]
  (var(Y) - cov(X, Y)) / (var(X) + var(Y) - 2 * cov(X, Y))
}

alpha.fn(Portfolio, 1:100)
# [1] 0.576

set.seed(7)
alpha.fn(Portfolio, sample(100, 100, replace = TRUE))
# [1] 0.539

boot(Portfolio, alpha.fn, R = 1000)
# ORDINARY NONPARAMETRIC BOOTSTRAP
#
# Call:
# boot(data = Portfolio, statistic = alpha.fn, R = 1000)
#
# Bootstrap Statistics :
#      original      bias    std. error
# t1* 0.5758        0.001        0.0897

boot.fn <- function(data, index)
  coef(lm(mpg ~ horsepower, data = data, subset = index))
boot.fn(Auto, 1:392)
# (Intercept) horsepower
#      39.936      -0.158

set.seed(1)
boot.fn(Auto, sample(392, 392, replace = TRUE))
# (Intercept) horsepower
#      40.341      -0.164

boot.fn(Auto, sample(392, 392, replace = TRUE))
# (Intercept) horsepower
#      40.119      -0.158

boot(Auto, boot.fn, 1000)
# ORDINARY NONPARAMETRIC BOOTSTRAP
#
# Call:
# boot(data = Auto, statistic = boot.fn, R = 1000)
#
# Bootstrap Statistics :
#     original    bias    std. error
# t1* 39.936    0.0545        0.8413
# t2* -0.158   -0.0006        0.0073

summary(lm(mpg ~ horsepower, data = Auto))$coef
#              Estimate Std. Error t value   Pr(>|t|)
# (Intercept)   39.936    0.71750     55.7 1.22e-187
# horsepower    -0.158    0.00645    -24.5  7.03e-81

boot.fn <- function(data, index)
  coef(
    lm(mpg ~ horsepower + I(horsepower^2),
      data = data, subset = index)
  )
set.seed(1)
boot(Auto, boot.fn, 1000)
# ORDINARY NONPARAMETRIC BOOTSTRAP
#
# Call:
# boot(data = Auto, statistic = boot.fn, R = 1000)
#
# Bootstrap Statistics :
#      original      bias    std. error
# t1* 56.9001    3.51e-02      2.0300
# t2* -0.4661   -7.08e-04      0.0324
# t3*  0.0012    2.84e-06      0.0001

summary(
  lm(mpg ~ horsepower + I(horsepower^2), data = Auto)
)$coef
#                   Estimate Std. Error t value  Pr(>|t|)
# (Intercept)       56.9001    1.8004       32 1.7e-109
# horsepower        -0.4662    0.0311      -15  2.3e-40
# I(horsepower^2)    0.0012    0.0001       10  2.2e-21
