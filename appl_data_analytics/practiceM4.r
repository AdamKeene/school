library(ISLR2)
library(MASS)
library(randomForest)
install.packages("tree")
library(tree)

df <- na.omit(Auto[, c("horsepower", "weight")])

t1 <- 110
t2 <- 2600
t3 <- 80
t4 <- 3200
t5 <- 3400

xmin <- min(df$horsepower)
xmax <- max(df$horsepower)
ymin <- min(df$weight)
ymax <- max(df$weight)

par(mfrow = c(1, 2), mar = c(4.5, 4.5, 3, 1))

plot(df$horsepower, df$weight, cex = 0.6, xlab = "horsepower", ylab = "weight", main = "Recursive Binary Partition")

segments(t1, ymin, t1, ymax, lwd = 2)
segments(xmin, t2, t1, t2, lwd = 2)
segments(t3, ymin, t3, t2, lwd = 2)
segments(xmin, t4, t1, t4, lwd = 2)
segments(t1, t5, xmax, t5, lwd = 2)

text((xmin + t3) / 2, (ymin + t2) / 2, "R1")
text((t3 + t1) / 2, (ymin + t2) / 2, "R2")
text((xmin + t1) / 2, (t2 + t4) / 2, "R3")
text((xmin + t1) / 2, (t4 + ymax) / 2, "R4")
text((t1 + xmax) / 2, (ymin + t5) / 2, "R5")
text((t1 + xmax) / 2, (t5 + ymax) / 2, "R6")

plot.new()
plot.window(xlim = c(0, 1), ylim = c(0, 1))
title("Decision Tree")

# y-levels
y0 <- 0.88
y1 <- 0.70
y2 <- 0.52
y3 <- 0.34
y4 <- 0.52

# x-positions
x_root <- 0.50
xL <- 0.25
xR <- 0.75
xLL <- 0.12
xLR <- 0.38
xR1 <- 0.06
xR2 <- 0.18
xR3 <- 0.30
xR4 <- 0.46
xR5 <- 0.66
xR6 <- 0.84

# horsepower < t1
segments(xL, y0, xR, y0)
segments(xL, y0, xL, y1)
segments(xR, y0, xR, y1)
text(x_root, y0 + 0.03, expression(horsepower < t[1]~~": 110"))

# weight < t2
segments(xLL, y1, xLR, y1)
segments(xLL, y1, xLL, y2)
segments(xLR, y1, xLR, y2)
text((xLL + xLR) / 2, y1 + 0.03, expression(weight < t[2]~~": 2600"))

# horsepower < t3
segments(xR1, y2, xR2, y2)
segments(xR1, y2, xR1, y3)
segments(xR2, y2, xR2, y3)
text((xR1 + xR2) / 2, y2 + 0.03, expression(horsepower < t[3]~~": 80"))

# weight < t4 -> R3, R4
segments(xR3, y2, xR4, y2)
segments(xR3, y2, xR3, y3)
segments(xR4, y2, xR4, y3)
text((xR3 + xR4) / 2, y2 + 0.03, expression(weight < t[4]~~": 3200"))

# weight < t5 -> R5, R6
segments(xR5, y1, xR6, y1)
segments(xR5, y1, xR5, y4)
segments(xR6, y1, xR6, y4)
text((xR5 + xR6) / 2, y1 + 0.03, expression(weight < t[5]~~": 3400"))

# labels
text(xR1, y3 - 0.03, "R1")
text(xR2, y3 - 0.03, "R2")
text(xR3, y3 - 0.03, "R3")
text(xR4, y3 - 0.03, "R4")
text(xR5, y4 - 0.03, "R5")
text(xR6, y4 - 0.03, "R6")

# 3
prange = seq(0, 1, 0.01)
gini = prange * (1 - prange) * 2
entropy = -(prange * log(prange) + (1 - prange) * log(1 - prange))
class.err = 1 - pmax(prange, 1 - prange)
matplot(prange, cbind(gini, entropy, class.err), type = "l", lty = 1, col = c("red" ,"green", "blue"))

# 7
# Construct the train and test matrices
boston_train = sample(dim(Boston)[1], dim(Boston)[1]/2)
x_train = Boston[boston_train, -14]
x_test = Boston[-boston_train, -14]
y_train = Boston[boston_train, 14]
y_test = Boston[-boston_train, 14]

p = dim(Boston)[2] - 1
p_div = p/2
p_sq = sqrt(p)
rf_p = randomForest(x_train, y_train, xtest = x_test, ytest = y_test, mtry = p, ntree = 500)
rf_div = randomForest(x_train, y_train, xtest = x_test, ytest = y_test, mtry = p_div, ntree = 500)
rf_sq = randomForest(x_train, y_train, xtest = x_test, ytest = y_test, mtry = p_sq, ntree = 500)

plot(1:500, rf_p$test$mse, col = "green", type = "l", xlab = "tree count", ylab = "MSE", ylim = c(10, 19))
lines(1:500, rf_div$test$mse, col = "red", type = "l")
lines(1:500, rf_sq$test$mse, col = "blue", type = "l")
legend("topright", c("m=p", "m=p/2", "m=sqrt(p)"), col = c("green", "red", "blue"), cex = 1, lty = 1)

# 8
# a.
seatsTrain=sample(1:nrow(Carseats),nrow(Carseats)*7/10)
seatsTest=Carseats[-seatsTrain,'Sales']
# b.
seatsTree=tree(Sales~.,Carseats,subset=seatsTrain)
plot(seatsTree)
text(seatsTree, pretty = 0)
