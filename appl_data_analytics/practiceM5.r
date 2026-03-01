library(ggplot2)

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

#2
# a.
points <- expand.grid(
  X1 = seq(-4, 2, length.out = 100),
  X2 = seq(-1, 5, length.out = 100)
)
p <- ggplot(points, aes(x = X1, y = X2, z = (1 + X1)^2 + (2 - X2)^2 - 4)) +
  geom_contour(breaks = 0, colour = "black") +
  theme_bw()
p
