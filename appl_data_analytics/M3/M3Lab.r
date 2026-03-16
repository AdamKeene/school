## 4.7.1 The Stock Market Data
library(ISLR2)
names(Smarket)
# [1] "Year"      "Lag1"      "Lag2"      "Lag3"      "Lag4"
# [6] "Lag5"      "Volume"    "Today"     "Direction"
dim(Smarket)
# [1] 1250    9
summary(Smarket)
#       Year           Lag1               Lag2
#  Min.   :2001   Min.   :-4.92200   Min.   :-4.92200
#  1st Qu.:2002   1st Qu.:-0.63950   1st Qu.:-0.63950
#  Median :2003   Median : 0.03900   Median : 0.03900
#  Mean   :2003   Mean   : 0.00383   Mean   : 0.00392
#  3rd Qu.:2004   3rd Qu.: 0.59675   3rd Qu.: 0.59675
#  Max.   :2005   Max.   : 5.73300   Max.   : 5.73300
#       Lag3               Lag4               Lag5
#  Min.   :-4.92200   Min.   :-4.92200   Min.   :-4.92200
#  1st Qu.:-0.64000   1st Qu.:-0.64000   1st Qu.:-0.64000
#  Median : 0.03850   Median : 0.03850   Median : 0.03850
#  Mean   : 0.00172   Mean   : 0.00164   Mean   : 0.00561
#  3rd Qu.: 0.59675   3rd Qu.: 0.59675   3rd Qu.: 0.59700
#  Max.   : 5.73300   Max.   : 5.73300   Max.   : 5.73300
#      Volume           Today          Direction
#  Min.   :0.356   Min.   :-4.92200   Down:602
#  1st Qu.:1.257   1st Qu.:-0.63950   Up  :648
#  Median :1.423   Median : 0.03850
#  Mean   :1.478   Mean   : 0.00314
#  3rd Qu.:1.642   3rd Qu.: 0.59675
#  Max.   :3.152   Max.   : 5.73300
pairs(Smarket)
cor(Smarket)
# Error in cor(Smarket) : `x' must be numeric
cor(Smarket[, -9])
#          Year     Lag1     Lag2     Lag3     Lag4     Lag5   Volume    Today
# Year   1.0000  0.02970  0.03060  0.03319  0.03569  0.02979  0.53900  0.03010
# Lag1   0.0297  1.00000 -0.02629 -0.01080 -0.00299 -0.00567  0.04091 -0.02616
# Lag2   0.0306 -0.02629  1.00000 -0.02590 -0.01085 -0.00356 -0.04338 -0.01025
# Lag3   0.0332 -0.01080 -0.02590  1.00000 -0.02405 -0.01881 -0.04182 -0.00245
# Lag4   0.0357 -0.00299 -0.01085 -0.02405  1.00000 -0.02708 -0.04841 -0.00690
# Lag5   0.0298 -0.00567 -0.00356 -0.01881 -0.02708  1.00000 -0.02200 -0.03486
# Volume 0.5390  0.04091 -0.04338 -0.04182 -0.04841 -0.02200  1.00000  0.01459
# Today  0.0301 -0.02616 -0.01025 -0.00245 -0.00690 -0.03486  0.01459  1.00000
attach(Smarket)
plot(Volume)

## 4.7.2 Logistic Regression
glm.fits <- glm(
  Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
  data = Smarket, family = binomial
)
summary(glm.fits)

# Call:
# glm(formula = Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 +
#     Volume, family = binomial, data = Smarket)

# Deviance Residuals:
#    Min      1Q  Median      3Q     Max
#  -1.45   -1.20    1.07    1.15    1.33

# Coefficients:
#              Estimate Std. Error z value Pr(>|z|)
# (Intercept) -0.12600    0.24074  -0.523    0.601
# Lag1        -0.07307    0.05017  -1.457    0.145
# Lag2        -0.04230    0.05009  -0.845    0.398
# Lag3         0.01109    0.04994   0.222    0.824
# Lag4         0.00936    0.04997   0.187    0.851
# Lag5         0.01031    0.04951   0.208    0.835
# Volume       0.13544    0.15836   0.855    0.392

# (Dispersion parameter for binomial family taken to be 1)

#     Null deviance: 1731.2  on 1249  degrees of freedom
# Residual deviance: 1727.6  on 1243  degrees of freedom
# AIC: 1741.6
coef(glm.fits)
# (Intercept)        Lag1        Lag2        Lag3        Lag4        Lag5
#    -0.12600    -0.07307    -0.04230     0.01109     0.00936     0.01031
#      Volume
#     0.13544
summary(glm.fits)$coef
#              Estimate Std. Error z value Pr(>|z|)
# (Intercept) -0.12600     0.2407  -0.523    0.601
# Lag1        -0.07307     0.0502  -1.457    0.145
# Lag2        -0.04230     0.0501  -0.845    0.398
# Lag3         0.01109     0.0499   0.222    0.824
# Lag4         0.00936     0.0500   0.187    0.851
# Lag5         0.01031     0.0495   0.208    0.835
# Volume       0.13544     0.1584   0.855    0.392
summary(glm.fits)$coef[, 4]
# (Intercept)        Lag1        Lag2        Lag3        Lag4        Lag5
#       0.601       0.145       0.398       0.824       0.851       0.835
#      Volume
#       0.392
glm.probs <- predict(glm.fits, type = "response")
glm.probs[1:10]
#     1     2     3     4     5     6     7     8     9    10
# 0.507 0.481 0.481 0.515 0.511 0.507 0.493 0.509 0.518 0.489
contrasts(Direction)
#      Up
# Down  0
# Up    1
glm.pred <- rep("Down", 1250)
glm.pred[glm.probs > .5] = "Up"
table(glm.pred, Direction)
#         Direction
# glm.pred Down  Up
#     Down  145 141
#     Up    457 507
(507 + 145) / 1250
# [1] 0.5216
mean(glm.pred == Direction)
# [1] 0.5216
train <- (Year < 2005)
Smarket.2005 <- Smarket[!train, ]
dim(Smarket.2005)
# [1] 252   9
Direction.2005 <- Direction[!train]
glm.fits <- glm(
  Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
  data = Smarket, family = binomial, subset = train
)
glm.probs <- predict(glm.fits, Smarket.2005, type = "response")
glm.pred <- rep("Down", 252)
glm.pred[glm.probs > .5] <- "Up"
table(glm.pred, Direction.2005)
#          Direction.2005
# glm.pred  Down  Up
#     Down    77  97
#     Up      34  44
mean(glm.pred == Direction.2005)
# [1] 0.48
mean(glm.pred != Direction.2005)
# [1] 0.52
glm.fits <- glm(Direction ~ Lag1 + Lag2, data = Smarket,
  family = binomial, subset = train)
glm.probs <- predict(glm.fits, Smarket.2005, type = "response")
glm.pred <- rep("Down", 252)
glm.pred[glm.probs > .5] <- "Up"
table(glm.pred, Direction.2005)
#          Direction.2005
# glm.pred  Down  Up
#     Down    35  35
#     Up      76 106
mean(glm.pred == Direction.2005)
# [1] 0.56
106 / (106 + 76)
# [1] 0.582
predict(glm.fits,
  newdata = data.frame(Lag1 = c(1.2, 1.5), Lag2 = c(1.1, -0.8)),
  type = "response"
)
#        1      2
# 0.4791 0.4961

## 4.7.3 Linear Discriminant Analysis
library(MASS)
lda.fit <- lda(Direction ~ Lag1 + Lag2, data = Smarket,
  subset = train)
lda.fit
# Call:
# lda(Direction ~ Lag1 + Lag2, data = Smarket, subset = train)

# Prior probabilities of groups:
#  Down    Up
# 0.492 0.508

# Group means:
#         Lag1    Lag2
# Down  0.0428  0.0339
# Up   -0.0395 -0.0313

# Coefficients of linear discriminants:
#         LD1
# Lag1 -0.642
# Lag2 -0.514
plot(lda.fit)
lda.pred <- predict(lda.fit, Smarket.2005)
names(lda.pred)
# [1] "class"     "posterior" "x"
lda.class <- lda.pred$class
table(lda.class, Direction.2005)
#           Direction.2005
# lda.class  Down  Up
#      Down    35  35
#      Up      76 106
mean(lda.class == Direction.2005)
# [1] 0.56
sum(lda.pred$posterior[, 1] >= .5)
# [1] 70
sum(lda.pred$posterior[, 1] < .5)
# [1] 182
lda.pred$posterior[1:20, 1]
lda.class[1:20]
sum(lda.pred$posterior[, 1] > .9)
# [1] 0

## 4.7.4 Quadratic Discriminant Analysis
qda.fit <- qda(Direction ~ Lag1 + Lag2, data = Smarket,
  subset = train)
qda.fit
# Call:
# qda(Direction ~ Lag1 + Lag2, data = Smarket, subset = train)

# Prior probabilities of groups:
#  Down    Up
# 0.492 0.508

# Group means:
#         Lag1    Lag2
# Down  0.0428  0.0339
# Up   -0.0395 -0.0313
qda.class <- predict(qda.fit, Smarket.2005)$class
table(qda.class, Direction.2005)
#           Direction.2005
# qda.class  Down  Up
#      Down    30  20
#      Up      81 121
mean(qda.class == Direction.2005)
# [1] 0.599

## 4.7.5 Naive Bayes
library(e1071)
nb.fit <- naiveBayes(Direction ~ Lag1 + Lag2, data = Smarket,
  subset = train)
nb.fit
# Naive Bayes Classifier for Discrete Predictors

# Call:
# naiveBayes.default(x = X, y = Y, laplace = laplace)

# A-priori probabilities:
# Y
#   Down     Up
# 0.492  0.508

# Conditional probabilities:
#       Lag1
# Y          [,1]  [,2]
#   Down  0.0428  1.23
#   Up   -0.0395  1.23
#       Lag2
# Y          [,1]  [,2]
#   Down  0.0339  1.24
#   Up   -0.0313  1.22
mean(Lag1[train][Direction[train] == "Down"])
# [1] 0.0428
sd(Lag1[train][Direction[train] == "Down"])
# [1] 1.23
nb.class <- predict(nb.fit, Smarket.2005)
table(nb.class, Direction.2005)
#           Direction.2005
# nb.class   Down  Up
#     Down    28   20
#     Up      83  121
mean(nb.class == Direction.2005)
# [1] 0.591
nb.preds <- predict(nb.fit, Smarket.2005, type = "raw")
nb.preds[1:5, ]
#       Down    Up
# [1,] 0.487 0.513
# [2,] 0.476 0.524
# [3,] 0.465 0.535
# [4,] 0.475 0.525
# [5,] 0.490 0.510

## 4.7.6 K-Nearest Neighbors
library(class)
train.X <- cbind(Lag1, Lag2)[train, ]
test.X <- cbind(Lag1, Lag2)[!train, ]
train.Direction <- Direction[train]
set.seed(1)
knn.pred <- knn(train.X, test.X, train.Direction, k = 1)
table(knn.pred, Direction.2005)
#          Direction.2005
# knn.pred  Down  Up
#     Down    43  58
#     Up      68  83
(83 + 43) / 252
# [1] 0.5
knn.pred <- knn(train.X, test.X, train.Direction, k = 3)
table(knn.pred, Direction.2005)
#          Direction.2005
# knn.pred  Down  Up
#     Down    48  54
#     Up      63  87
mean(knn.pred == Direction.2005)
# [1] 0.536
dim(Caravan)
# [1] 5822   86
attach(Caravan)
summary(Purchase)
#   No  Yes
# 5474  348
348 / 5822
# [1] 0.0598
standardized.X <- scale(Caravan[, -86])
var(Caravan[, 1])
# [1] 165
var(Caravan[, 2])
# [1] 0.165
var(standardized.X[, 1])
# [1] 1
var(standardized.X[, 2])
# [1] 1
test <- 1:1000
train.X <- standardized.X[-test, ]
test.X <- standardized.X[test, ]
train.Y <- Purchase[-test]
test.Y <- Purchase[test]
set.seed(1)
knn.pred <- knn(train.X, test.X, train.Y, k = 1)
mean(test.Y != knn.pred)
# [1] 0.118
mean(test.Y != "No")
# [1] 0.059
table(knn.pred, test.Y)
#         test.Y
# knn.pred  No Yes
#       No 873  50
#      Yes  68   9
9 / (68 + 9)
# [1] 0.117
knn.pred <- knn(train.X, test.X, train.Y, k = 3)
table(knn.pred, test.Y)
#         test.Y
# knn.pred  No Yes
#       No 920  54
#      Yes  21   5
5 / 26
# [1] 0.192
knn.pred <- knn(train.X, test.X, train.Y, k = 5)
table(knn.pred, test.Y)
#         test.Y
# knn.pred  No Yes
#       No 930  55
#      Yes  11   4
4 / 15
# [1] 0.267
glm.fits <- glm(Purchase ~ ., data = Caravan,
  family = binomial, subset = -test)
# Warning message:
# glm.fit: fitted probabilities numerically 0 or 1 occurred
glm.probs <- predict(glm.fits, Caravan[test, ], type = "response")
glm.pred <- rep("No", 1000)
glm.pred[glm.probs > .5] <- "Yes"
table(glm.pred, test.Y)
#         test.Y
# glm.pred  No Yes
#       No 934  59
#      Yes   7   0
glm.pred <- rep("No", 1000)
glm.pred[glm.probs > .25] <- "Yes"
table(glm.pred, test.Y)
#         test.Y
# glm.pred  No Yes
#       No 919  48
#      Yes  22  11
11 / (22 + 11)
# [1] 0.333

## 4.7.7 Poisson Regression
attach(Bikeshare)
dim(Bikeshare)
# [1] 8645   15
names(Bikeshare)
#  [1] "season"      "mnth"        "day"         "hr"
#  [5] "holiday"     "weekday"     "workingday"  "weathersit"
#  [9] "temp"        "atemp"       "hum"         "windspeed"
# [13] "casual"      "registered"  "bikers"
mod.lm <- lm(
  bikers ~ mnth + hr + workingday + temp + weathersit,
  data = Bikeshare
)
summary(mod.lm)

# Call:
# lm(formula = bikers ~ mnth + hr + workingday + temp + weathersit,
#     data = Bikeshare)

# Residuals:
#     Min      1Q  Median      3Q     Max
# -299.00  -45.70   -6.23   41.08  425.29

# Coefficients:
#                Estimate Std. Error t value Pr(>|t|)
# (Intercept)   -68.632      5.307 -12.932  < 2e-16 ***
# mnthFeb         6.845      4.287   1.597  0.110398
# mnthMarch      16.551      4.301   3.848  0.000120 ***
# mnthApril      41.425      4.972   8.331  < 2e-16 ***
# mnthMay        72.557      5.641  12.862  < 2e-16 ***
# [... output truncated ...]
contrasts(Bikeshare$hr) = contr.sum(24)
contrasts(Bikeshare$mnth) = contr.sum(12)
mod.lm2 <- lm(
  bikers ~ mnth + hr + workingday + temp + weathersit,
  data = Bikeshare
)
summary(mod.lm2)

# Call:
# lm(formula = bikers ~ mnth + hr + workingday + temp + weathersit,
#     data = Bikeshare)

# Residuals:
#     Min      1Q  Median      3Q     Max
# -299.00  -45.70   -6.23   41.08  425.29

# Coefficients:
#                 Estimate Std. Error t value Pr(>|t|)
# (Intercept)    73.597      5.132  14.340  < 2e-16 ***
# mnth1         -46.087      4.086 -11.281  < 2e-16 ***
# mnth2         -39.242      3.539 -11.088  < 2e-16 ***
# mnth3         -29.536      3.155  -9.361  < 2e-16 ***
# mnth4          -4.662      2.741  -1.701   0.08895 .
# [... output truncated ...]
sum((predict(mod.lm) - predict(mod.lm2))^2)
# [1] 1.426e-18
all.equal(predict(mod.lm), predict(mod.lm2))
coef.months <- c(coef(mod.lm2)[2:12],
  -sum(coef(mod.lm2)[2:12]))
plot(coef.months, xlab = "Month", ylab = "Coefficient",
  xaxt = "n", col = "blue", pch = 19, type = "o")
axis(side = 1, at = 1:12, labels = c("J", "F", "M", "A",
  "M", "J", "J", "A", "S", "O", "N", "D"))
coef.hours <- c(coef(mod.lm2)[13:35],
  -sum(coef(mod.lm2)[13:35]))
plot(coef.hours, xlab = "Hour", ylab = "Coefficient",
  col = "blue", pch = 19, type = "o")
mod.pois <- glm(
  bikers ~ mnth + hr + workingday + temp + weathersit,
  data = Bikeshare, family = poisson
)
summary(mod.pois)

# Call:
# glm(formula = bikers ~ mnth + hr + workingday + temp + weathersit,
#     family = poisson, data = Bikeshare)

# Deviance Residuals:
#      Min       1Q   Median       3Q      Max
# -20.7574  -3.3441  -0.6549   2.6999  21.9628

# Coefficients:
#                Estimate Std. Error z value Pr(>|z|)
# (Intercept)  4.118245   0.006021  683.964  < 2e-16 ***
# mnth1       -0.670170   0.005907 -113.445  < 2e-16 ***
# mnth2       -0.444124   0.004860  -91.379  < 2e-16 ***
# mnth3       -0.293733   0.004144  -70.886  < 2e-16 ***
# mnth4        0.021523   0.003125    6.888  5.66e-12 ***
# [... output truncated ...]
coef.mnth <- c(coef(mod.pois)[2:12],
  -sum(coef(mod.pois)[2:12]))
plot(coef.mnth, xlab = "Month", ylab = "Coefficient",
  xaxt = "n", col = "blue", pch = 19, type = "o")
axis(side = 1, at = 1:12, labels = c("J", "F", "M", "A", "M", "J",
  "J", "A", "S", "O", "N", "D"))
coef.hours <- c(coef(mod.pois)[13:35],
  -sum(coef(mod.pois)[13:35]))
plot(coef.hours, xlab = "Hour", ylab = "Coefficient",
  col = "blue", pch = 19, type = "o")
plot(predict(mod.lm2), predict(mod.pois, type = "response"))
abline(0, 1, col = 2, lwd = 3)
