library(ISLR2)
library(MASS)
library(randomForest)
library(tree)
library(BART)
set.seed(1)

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
seats = sample(dim(Carseats)[1], dim(Carseats)[1]/2)
seatsTrain = Carseats[seats, ]
seatsTest = Carseats[-seats, ]
# b.
seatsTree = tree(Sales ~ ., data = seatsTrain)
summary(seatsTree)
plot(seatsTree)
text(seatsTree, pretty=0)

seatsPred = predict(seatsTree, seatsTest)
mean((seatsTest$Sales - seatsPred)^2)
# 4.922
# c.
seatsCV = cv.tree(seatsTree, FUN = prune.tree)
par(mfrow = c(1, 2))
plot(seatsCV$size, seatsCV$dev, type = "b")
plot(seatsCV$k, seatsCV$dev, type = "b")

seatsPruned = prune.tree(seatsTree, best = 9)
par(mfrow = c(1, 1))
plot(seatsPruned)
text(seatsPruned, pretty = 0)
seatsPredPruned = predict(seatsPruned, seatsTest)
mean((seatsTest$Sales - seatsPredPruned)^2)
# 4.918, barely improved
# d.
seatsBagging = randomForest(Sales ~ ., data = seatsTrain, mtry = 10, ntree = 500, importance = T)
seatsPred = predict(seatsBagging, seatsTest)
mean((seatsTest$Sales - seatsPred)^2)
# 2.657, significant improvement
importance(seatsBagging)
# Price and ShelveLoc are the most important
# e.
seatsForest = randomForest(Sales ~ ., data = seatsTrain, mtry = 5, ntree = 500, importance = T)
seatsPredForest = predict(seatsForest, seatsTest)
mean((seatsTest$Sales - seatsPredForest)^2)
# 2.701 also good
importance(seatsForest)
# Price and ShelveLoc are still most important
# f.
full_x = rbind(subset(seatsTrain, select = -Sales), subset(seatsTest, select = -Sales))
mm = model.matrix(~ . - 1, data = full_x)
ntrain = nrow(seatsTrain)
bartTrain = mm[1:ntrain, , drop = FALSE]
bartTest  = mm[(ntrain + 1):nrow(mm), , drop = FALSE]
salesTrain = seatsTrain$Sales

seatsBart = gbart(bartTrain, salesTrain, bartTest = bartTest, ntree = 200, ndpost = 2000, nskip = 500)
seatsBartPred = seatsBart$yhat.test.mean
seatsBartMSE = mean((seatsTest$Sales - seatsBartPred)^2)
print(seatsBartMSE)
# 1.409
# significant improvement

# 9
# a.
?OJ
ntrain <- sample(1:nrow(OJ), 800)
ojTrain <- OJ[ntrain, ]
ojTest <- OJ[-ntrain, ]
# b.
orangeTree <- tree(Purchase ~ ., ojTrain)
summary(orangeTree)
# 16.88% error, 10 terminal nodes
# c.
orangeTree
# 2) LoyalCH is one of 8 times LoyalCH appears in the tree. It has a splitting value of .504, there are 365 points below it, the deviance for all points below it is 441.6, and the prediction for this subset is MM at 70.69% compared to 29.32% CH.
# d.
plot(orangeTree)
text(orangeTree, pretty=0)
# LoyalCH is quite important being all over the upper half of the tree, PriceDiff is also important, not much else matters. Loyalty to Citrus Hill matters much more than to Minute Maid, and the only other thing that matters is price.
# e.
ojPred <- predict(orangeTree, ojTest, type="class")
ojTable <- table(ojTest$Purchase, ojPred)
ojTable
1-sum(diag(ojTable)/sum(ojTable))
# f.
ojCV <- cv.tree(orangeTree)
ojCV
# 9 has the smallest standard deviance at 685
# g.
plot(ojCV$size, ojCV$dev, type = "b", xlab = "size", ylab = "deviance")
# h.
# 6, 7, and 9 are tied for the lowest
# i.
prunedOrangeTree <- prune.tree(orangeTree, best = 7)
plot(prunedOrangeTree)
text(prunedOrangeTree, pretty=0)
# j.
summary(prunedOrangeTree)
# The misclassification error rate is 16.25%, which is slightly better than the original 17.04%
# k.
ojPredUnpruned = predict(orangeTree, ojTest, type = "class")
unprunedMisclass = sum(ojTest$Purchase != ojPredUnpruned)
unprunedMisclass/length(ojPredUnpruned)
# .1704
ojPredPruned = predict(prunedOrangeTree, ojTest, type = "class")
prunedMisclass = sum(ojTest$Purchase != ojPredPruned)
prunedMisclass/length(ojPredPruned)
# .1630
# pruned wins with a .0074 improvement

# 10
