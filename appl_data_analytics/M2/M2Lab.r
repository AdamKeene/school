# 3.6.1
library(MASS)
library(ISLR2)

# 3.6.2
head(Boston)
# crim zn indus chas nox rm age dis rad tax
# 1 0.00632 18 2.31 0 0.538 6.575 65.2 4.0900 1 296
# 2 0.02731 0 7.07 0 0.469 6.421 78.9 4.9671 2 242
# 3 0.02729 0 7.07 0 0.469 7.185 61.1 4.9671 2 242
# 4 0.03237 0 2.18 0 0.458 6.998 45.8 6.0622 3 222
# 5 0.06905 0 2.18 0 0.458 7.147 54.2 6.0622 3 222
# 6 0.02985 0 2.18 0 0.458 6.430 58.7 6.0622 3 222
# ptratio lstat medv
# 1 15.3 4.98 24.0
# 2 17.8 9.14 21.6
# 3 17.8 4.03 34.7
# 4 18.7 2.94 33.4
# 5 18.7 5.33 36.2
# 6 18.7 5.21 28.7
lm.fit <- lm(medv ~ lstat)
# Error in eval(expr , envir , enclos) : Object "medv" not found
lm.fit <- lm(medv ~ lstat , data = Boston)
attach(Boston)
lm.fit <- lm(medv ~ lstat)
lm.fit
# Call:
#   lm(formula = medv ∼ lstat)
# Coefficients:
#   (Intercept) lstat
# 34.55 -0.95
summary(lm.fit)
# Call:
#   lm(formula = medv ∼ lstat)
# Residuals:
#   Min 1Q Median 3Q Max
# -15.17 -3.99 -1.32 2.03 24.50
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)
# (Intercept) 34.5538 0.5626 61.4 <2e-16 ***
#   lstat -0.9500 0.0387 -24.5 <2e-16 ***
#   ---
#   Signif. codes: 0 *** 0.001 ** 0.01 * 0.05 . 0.1 1
# Residual standard error: 6.22 on 504 degrees of freedom
# Multiple R-squared: 0.544 , Adjusted R-squared: 0.543
# F-statistic: 602 on 1 and 504 DF , p-value: < 2e-16
names(lm.fit)
# [1] " coefficients " " residuals " " effects "
# [4] "rank" "fitted.values" "assign"
# [7] "qr" "df. residual " " xlevels "
# [10] "call" "terms" "model"
coef(lm.fit)
# (Intercept) lstat
# 34.55 -0.95
confint(lm.fit)
# 2.5 % 97.5 %
#   (Intercept) 33.45 35.659
# lstat -1.03 -0.874
predict(lm.fit , data.frame(lstat = (c(5, 10, 15))),
          interval = "confidence")
# fit lwr upr
# 1 29.80 29.01 30.60
# 2 25.05 24.47 25.63
# 3 20.30 19.73 20.87
predict(lm.fit , data.frame(lstat = (c(5, 10, 15))),
          interval = "prediction")
# fit lwr upr
# 1 29.80 17.566 42.04
# 2 25.05 12.828 37.28
# 3 20.30 8.078 32.53
plot(lstat , medv)
abline(lm.fit)
abline(lm.fit , lwd = 3)
abline(lm.fit , lwd = 3, col = "red")
plot(lstat , medv , col = "red")
plot(lstat , medv , pch = 20)
plot(lstat , medv , pch = "+")
plot (1:20 , 1:20, pch = 1:20)
par(mfrow = c(2, 2))
plot(lm.fit)
plot(predict(lm.fit), residuals(lm.fit))
plot(predict(lm.fit), rstudent(lm.fit))
plot(hatvalues(lm.fit))
which.max(hatvalues(lm.fit))
# 375
# 375

# 3.6.3
lm.fit <- lm(medv ~ lstat + age , data = Boston)
summary(lm.fit)
# Call:
#   lm(formula = medv ∼ lstat + age , data = Boston)
# Residuals:
# Min 1Q Median 3Q Max
# -15.98 -3.98 -1.28 1.97 23.16
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)
# (Intercept) 33.2228 0.7308 45.46 <2e-16 ***
#   lstat -1.0321 0.0482 -21.42 <2e-16 ***
#   age 0.0345 0.0122 2.83 0.0049 **
#   ---
#   Signif. codes: 0 *** 0.001 ** 0.01 * 0.05 . 0.1 1
# Residual standard error: 6.17 on 503 degrees of freedom
# Multiple R-squared: 0.551 , Adjusted R-squared: 0.549
# F-statistic: 309 on 2 and 503 DF , p-value: < 2e-16
lm.fit <- lm(medv ~ ., data = Boston)
summary(lm.fit)
# Call:
#   lm(formula = medv ∼ ., data = Boston)
# Residuals:
#   Min 1Q Median 3Q Max
# -15.130 -2.767 -0.581 1.941 26.253
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)
# (Intercept) 41.61727 4.93604 8.43 3.8e-16 ***
#   crim -0.12139 0.03300 -3.68 0.00026 ***
#   zn 0.04696 0.01388 3.38 0.00077 ***
#   indus 0.01347 0.06214 0.22 0.82852
# chas 2.83999 0.87001 3.26 0.00117 **
#   nox -18.75802 3.85135 -4.87 1.5e-06 ***
#   rm 3.65812 0.42025 8.70 < 2e-16 ***
#   age 0.00361 0.01333 0.27 0.78659
# dis -1.49075 0.20162 -7.39 6.2e-13 ***
#   rad 0.28940 0.06691 4.33 1.8e-05 ***
#   tax -0.01268 0.00380 -3.34 0.00091 ***
#   ptratio -0.93753 0.13221 -7.09 4.6e-12 ***
#   lstat -0.55202 0.05066 -10.90 < 2e-16 ***
#   ---
#   Signif. codes: 0 *** 0.001 ** 0.01 * 0.05 . 0.1 1
# Residual standard error: 4.8 on 493 degrees of freedom
# Multiple R-squared: 0.734 , Adjusted R-squared: 0.728
# F-statistic: 114 on 12 and 493 DF , p-value: < 2e-16
library(car)
vif(lm.fit)
# crim zn indus chas nox rm age dis
# 1.77 2.30 3.99 1.07 4.37 1.91 3.09 3.95
# rad tax ptratio lstat
# 7.45 9.00 1.80 2.87
lm.fit1 <- lm(medv ~ . - age , data = Boston)
summary(lm.fit1)
lm.fit1 <- update(lm.fit , ~ . - age)
# 3.6.4
summary(lm(medv ~ lstat * age , data = Boston))
# Call:
#   lm(formula = medv ∼ lstat * age , data = Boston)
# Residuals:
#   Min 1Q Median 3Q Max
# -15.81 -4.04 -1.33 2.08 27.55
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)
# (Intercept) 36.088536 1.469835 24.55 < 2e-16 ***
#   lstat -1.392117 0.167456 -8.31 8.8e-16 ***
#   age -0.000721 0.019879 -0.04 0.971
# lstat:age 0.004156 0.001852 2.24 0.025 *
#   ---
#   Signif. codes: 0 *** 0.001 ** 0.01 * 0.05 . 0.1 1
# Residual standard error: 6.15 on 502 degrees of freedom
# Multiple R-squared: 0.556 , Adjusted R-squared: 0.553
# F-statistic: 209 on 3 and 502 DF , p-value: < 2e-16
# 3.6.5

lm.fit2 <- lm(medv ~ lstat + I(lstat ^2))
summary(lm.fit2)
# Call:
#   lm(formula = medv ∼ lstat + I(lstat ^2))
# Residuals:
#   Min 1Q Median 3Q Max
# -15.28 -3.83 -0.53 2.31 25.41
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)
# (Intercept) 42.86201 0.87208 49.1 <2e-16 ***
#   lstat -2.33282 0.12380 -18.8 <2e-16 ***
#   I(lstat ^2) 0.04355 0.00375 11.6 <2e-16 ***
#   ---
#   Signif. codes: 0 *** 0.001 ** 0.01 * 0.05 . 0.1 1
# Residual standard error: 5.52 on 503 degrees of freedom
# Multiple R-squared: 0.641 , Adjusted R-squared: 0.639
# F-statistic: 449 on 2 and 503 DF , p-value: < 2e-16
# The near-zero p-value associated with the quadratic term suggests that
# it leads to an improved model. We use the anova() function to further anova()
# quantify the extent to which the quadratic fit is superior to the linear fit.
lm.fit <- lm(medv ~ lstat)
anova(lm.fit , lm.fit2)
# Analysis of Variance Table
# Model 1: medv ∼ lstat
# Model 2: medv ∼ lstat + I(lstat ^2)
# Res.Df RSS Df Sum of Sq F Pr(>F)
# 1 504 19472
# 2 503 15347 1 4125 135 <2e-16 ***
#   ---
#   Signif. codes: 0 *** 0.001 ** 0.01 * 0.05 . 0.1 1
par(mfrow = c(2, 2))
plot(lm.fit2)
lm.fit5 <- lm(medv ~ poly(lstat , 5))
summary(lm.fit5)
# Call:
#   lm(formula = medv ∼ poly(lstat , 5))
# Residuals:
#   Min 1Q Median 3Q Max
# -13.543 -3.104 -0.705 2.084 27.115
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)
# (Intercept) 22.533 0.232 97.20 < 2e-16 ***
#   poly(lstat , 5)1 -152.460 5.215 -29.24 < 2e -16 ***
#   poly(lstat , 5)2 64.227 5.215 12.32 < 2e -16 ***
#   poly(lstat , 5)3 -27.051 5.215 -5.19 3.1e -07 ***
#   poly(lstat , 5)4 25.452 5.215 4.88 1.4e -06 ***
#   poly(lstat , 5)5 -19.252 5.215 -3.69 0.00025 ***
#   ---
#   Signif. codes: 0 *** 0.001 ** 0.01 * 0.05 . 0.1 1
# Residual standard error: 5.21 on 500 degrees of freedom
# Multiple R-squared: 0.682 , Adjusted R-squared: 0.679
# F-statistic: 214 on 5 and 500 DF , p-value: < 2e-16
summary(lm(medv ~ log(rm), data = Boston))

# 3.6.6
head(Carseats)
# Sales CompPrice Income Advertising Population Price
# 1 9.50 138 73 11 276 120
# 2 11.22 111 48 16 260 83
# 3 10.06 113 35 10 269 80
# 4 7.40 117 100 4 466 97
# 5 4.15 141 64 3 340 128
# 6 10.81 124 113 13 501 72
# ShelveLoc Age Education Urban US
# 1 Bad 42 17 Yes Yes
# 2 Good 65 10 Yes Yes
# 3 Medium 59 12 Yes Yes
# 4 Medium 55 14 Yes Yes
# 5 Bad 38 13 Yes No
# 6 Bad 78 16 No Yes
lm.fit <- lm(Sales ~ . + Income:Advertising + Price:Age ,
               data = Carseats)
summary(lm.fit)
# Call:
#   lm(formula = Sales ∼ . + Income:Advertising + Price:Age , data =
#        Carseats)
# Residuals:
#   Min 1Q Median 3Q Max
# 120 3. Linear Regression
# -2.921 -0.750 0.018 0.675 3.341
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)
# (Intercept) 6.575565 1.008747 6.52 2.2e-10 ***
#   CompPrice 0.092937 0.004118 22.57 < 2e-16 ***
#   Income 0.010894 0.002604 4.18 3.6e-05 ***
#   Advertising 0.070246 0.022609 3.11 0.00203 **
#   Population 0.000159 0.000368 0.43 0.66533
# Price -0.100806 0.007440 -13.55 < 2e-16 ***
#   ShelveLocGood 4.848676 0.152838 31.72 < 2e-16 ***
#   ShelveLocMedium 1.953262 0.125768 15.53 < 2e-16 ***
#   Age -0.057947 0.015951 -3.63 0.00032 ***
#   Education -0.020852 0.019613 -1.06 0.28836
# UrbanYes 0.140160 0.112402 1.25 0.21317
# USYes -0.157557 0.148923 -1.06 0.29073
# Income:Advertising 0.000751 0.000278 2.70 0.00729 **
#   Price:Age 0.000107 0.000133 0.80 0.42381
# ---
#   Signif. codes: 0 *** 0.001 ** 0.01 * 0.05 . 0.1 1
# Residual standard error: 1.01 on 386 degrees of freedom
# Multiple R-squared: 0.876 , Adjusted R-squared: 0.872
# F-statistic: 210 on 13 and 386 DF , p-value: < 2e-16
# The contrasts() function returns the coding that R uses for the dummy contrasts()
# variables.
# > attach(Carseats)
# > contrasts(ShelveLoc)
# Good Medium
# Bad 0 0
# Good 1 0
# Medium 0 1

# 3.6.7
LoadLibraries
# Error: object `LoadLibraries ' not found
LoadLibraries ()
# Error: could not find function " LoadLibraries "
LoadLibraries <- function () {
 library(ISLR2)
 library(MASS)
 print("The libraries have been loaded.")
 }
LoadLibraries
function () {
library (ISLR2)
library (MASS)
print (" The libraries have been loaded .")
}
LoadLibraries ()
# [1] "The libraries have been loaded ."