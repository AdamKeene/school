library(ggplot2)
library(e1071)

# 1
xlim <- c(-10, 10)
ylim <- c(-30, 30)

points <- expand.grid(
  X1 = seq(xlim[1], xlim[2], length.out = 80),
  X2 = seq(ylim[1], ylim[2], length.out = 80)
)

points$region1 <- ifelse(1 + 3 * points$X1 - points$X2 > 0, "1 + 3X1 - X2 > 0", "1 + 3X1 - X2 < 0")
points$region2 <- ifelse(-2 + points$X1 + 2 * points$X2 > 0, "-2 + X1 + 2X2 > 0", "-2 + X1 + 2X2 < 0")

ggplot(points, aes(X1, X2)) +
  geom_point(aes(color = region1, shape = region2), size = 1.2, alpha = 0.55) +
  geom_abline(intercept = 1, slope = 3, linewidth = 1) +
  geom_abline(intercept = 1, slope = -0.5, linetype = "dashed", linewidth = 1) +
  scale_color_manual(values = c("1 + 3X1 - X2 > 0" = "tomato", "1 + 3X1 - X2 < 0" = "steelblue")) +
  scale_shape_manual(values = c("-2 + X1 + 2X2 > 0" = 16, "-2 + X1 + 2X2 < 0" = 1)) +
  coord_cartesian(xlim = xlim, ylim = ylim) +
  labs(x = "X1", y = "X2", color = "First inequality", shape = "Second inequality") +
  theme_bw()

# 2
# a.
points <- expand.grid(
  X1 = seq(-4, 2, length.out = 100),
  X2 = seq(-1, 5, length.out = 100)
)
plotb <- ggplot(points, aes(x = X1, y = X2, z = (1 + X1)^2 + (2 - X2)^2 - 4)) + geom_contour(breaks = 0, colour = "black") + theme_bw()
plotb
# b.
plotb + geom_point(aes(color = (1 + X1)^2 + (2 - X2)^2 - 4 > 0), size = 0.1)
# c.
# (0, 0): blue
# (-1, 1): red
# (2, 2): blue
# (3, 8): blue
# d.
# TODO

# 3
# a.
x1 <- c(3, 2, 4, 1, 2, 4, 4)
x2 <- c(4, 2, 4, 4, 1, 3, 1)
y  = c(rep("Red", 4), rep("Blue", 3))

svm_training_data <- data.frame(x1 = x1, x2 = x2, y = y)

svmPoints <- ggplot(svm_training_data, aes(x = x1, y = x2, color = y)) +
  geom_point(size = 3) +
  coord_cartesian(xlim = c(0, 5), ylim = c(0, 5)) +
  scale_color_identity()
svmPoints

# b.
svmModel <- svm(y ~ x1 + x2, data = svm_training_data, kernel = "linear", cost = 1e5, scale = FALSE)
hyperplaneWeights <- drop(t(svmModel$coefs) %*% as.matrix(svm_training_data[svmModel$index, c("x1", "x2")]))
hyperplaneIntercept <- -svmModel$rho

cat(sprintf("%.4f + %.4f*x1 + %.4f*x2 = 0\n", hyperplaneIntercept, hyperplaneWeights[1], hyperplaneWeights[2]))
# 1.0004 + -1.9998*x1 + 1.9997*x2 = 0

svmPoints + geom_abline(intercept = -hyperplaneIntercept / hyperplaneWeights[2], slope = -hyperplaneWeights[1] / hyperplaneWeights[2], linetype = "dashed")
# c.
# Classify to Red if β0 + β1X1 + β2X2 > 0, and classify to Blue otherwise, where β0=1, β1=−2, β2=2
# d.
decisionBoundarySlope <- -hyperplaneWeights[1] / hyperplaneWeights[2]
decisionBoundaryIntercept <- -hyperplaneIntercept / hyperplaneWeights[2]
upperMarginIntercept <- (1 - hyperplaneIntercept) / hyperplaneWeights[2]
lowerMarginIntercept <- (-1 - hyperplaneIntercept) / hyperplaneWeights[2]

supportVectorData <- svm_training_data[svmModel$index, ]

svmWithMMH <- svmPoints +
  geom_abline(intercept = decisionBoundaryIntercept, slope = decisionBoundarySlope, linetype = "dashed") +
  geom_abline(intercept = upperMarginIntercept, slope = decisionBoundarySlope, linetype = "dotted") +
  geom_abline(intercept = lowerMarginIntercept, slope = decisionBoundarySlope, linetype = "dotted")
svmWithMMH
# e.
svmFinal <- svmWithMMH + geom_point(data = supportVectorData, aes(x = x1, y = x2), shape = 1, size = 4, stroke = 1.2, inherit.aes = FALSE)
svmFinal
# f.
# the 7th data point is at (4,1) which is far from the margin making it not a support vector, therefore small changes will not affect the hyperplane calculation
# g.
svmPoints + geom_abline(intercept = -0.1, slope = 1)
# 0.1 - x1 + x2 = 0
# h.
svmPoints + geom_point(aes(x = 3, y = 1), color = "red", size = 3)
# 4
# 5
# 7