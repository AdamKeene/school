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