library(ISLR2)
library(boot)
set.seed(1)
# 5
# a.
attach(Default)
fit = glm(default ~ income + balance, data = Default, family = "binomial")
# b.
# i.
train = sample(nrow(Default), nrow(Default) / 2)
test = -train
# ii.
fit = glm(default ~ income + balance, data = Default, family = "binomial", subset = train)
# iii.
pred = ifelse(predict(fit, newdata = Default[test, ]) > 0.5, "Yes", "No")
table(pred, Default$default[test])
# iv.
mean(pred != Default$default[test])
# 0.0254
# c.
anotherone = function() {
  # i.
  train = sample(nrow(Default), nrow(Default) / 2)
  test = -train
  # ii.
  fit = glm(default ~ income + balance, data = Default, family = "binomial", subset = train)
  # iii.
  pred = ifelse(predict(fit, newdata = Default[test, ]) > 0.5, "Yes", "No")
  table(pred, Default$default[test])
  # iv.
  mean(pred != Default$default[test])
}
mean(
  anotherone(),
  anotherone(),
  anotherone()
)
# 0.0284
# d.
logreg = function() {
  train = sample(nrow(Default), nrow(Default) / 2)
  test = -train
  fit = glm(default ~ income + balance + student, data = Default, family = "binomial", subset = train)
  pred = ifelse(predict(fit, newdata = Default[test, ]) > 0.5, "Yes", "No")
  mean(pred != Default$default[test])
}
mean(
  logreg(),
  logreg(),
  logreg()
)
# 0.0286
# student doesn't seem to have an effect
# 6
# a.
fit = glm(default ~ income + balance, data = Default, family = "binomial")
summary(fit)
# b
boot.fn <- function(db, sample) {
  fit <- glm(default ~ income + balance, data = db[sample, ], family = "binomial")
  coef(fit)[-1]
}
# c.
boot(Default, boot.fn, R = 1000)
# d.
# income had a std error of 4.985e-06 in the glm model and 4.866284e-06 in the bootstrap model, balance had 2.274e-04 in glm and 2.298949e-04 in bootstrap. These are very similar results.

# 8 
# a.
x <- rnorm (100)
y <- x - 2 * x^2 + rnorm (100)
# n = 100, p = 1, y = x - 2x^2 + ϵ
# b.
plot(x, y)
# c.
df = data.frame(x, y)
# i.
fit = glm(y ~ x)
cv.glm(df, fit)$delta
# 7.288162 7.284744
# ii.
fit = glm(y ~ poly(x, 2, raw = TRUE))
cv.glm(df, fit)$delta
# 0.9374236 0.9371789
# iii.
fit = glm(y ~ poly(x, 3, raw = TRUE))
cv.glm(df, fit)$delta
# 0.9566218 0.9562538
# iv.
fit = glm(y ~ poly(x, 4, raw = TRUE))
cv.glm(df, fit)$delta
# 0.9539049 0.9534453
# large improvement with degree 2, very similar results after. the data is quadratic so going three and four don't add much.
# d.
set.seed(2)
x <- rnorm (100)
y <- x - 2 * x^2 + rnorm (100)
# i.
fit = glm(y ~ x)
cv.glm(df, fit)$delta
# 12.166870  9.528366
# ii.
fit = glm(y ~ poly(x, 2, raw = TRUE))
cv.glm(df, fit)$delta
# 14.5460205  0.9869664
# iii.
fit = glm(y ~ poly(x, 3, raw = TRUE))
cv.glm(df, fit)$delta
# 14.603789  1.030223
# iv.
fit = glm(y ~ poly(x, 4, raw = TRUE))
cv.glm(df, fit)$delta
# 14.4971034  0.8518971
# very different, raw cv estimate is much worse, more varied results than the first one
# e.
# The degree of 2 produced the best results, which makes sense because the equation used to generate the data was quadratic.
# f.
summary(fit)
# the linear and quadratic terms are the only statistically significant ones, which supports the results of cross validation.