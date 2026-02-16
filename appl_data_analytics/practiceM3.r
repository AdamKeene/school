# 13 16
library(MASS) # for lda()
library(ISLR2)

# 13
# a.
summary(Weekly)
plot(Weekly, cex=.1)
# year and volume have a particularly strong association
plot(Weekly$Year, Weekly$Volume)
# b.
direction_reg <- glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume, data = Weekly, family = binomial)
summary(direction_reg)
# Lag2 is the only significant predictor, Lag1 is the next closest
# c.
cm <- predict(direction_reg, type = "response") > .5
cm
direction_table <- table(cm, Weekly$Direction)
direction_table
sum(diag(direction_table)/sum(direction_table))
# 56.11% predictions correct, slightly better than random, very high false positive rate
# d.
Lag2_train <- Weekly$Year < 2009

lag2_reg <- glm(Direction ~ Lag2, data = Weekly[Lag2_train,], family = binomial)
lag2_pred <- predict(lag2_reg, Weekly[!Lag2_train,], type = "response") > 0.5
lag2_table <- table(lag2_pred, Weekly[!Lag2_train,]$Direction)
lag2_table
sum(diag(lag2_table))/sum(lag2_table)
# .625 is better but still high false positive rate, and the data has more positives in this case
# e.
lag2_lda <- lda(Direction ~ Lag2, data = Weekly[Lag2_train,], family = binomial)
lag2_ldapred <- predict(lag2_lda, Weekly[!Lag2_train,], type = "response")$class
lag2_ldatable <- table(lag2_ldapred, Weekly[!Lag2_train,]$Direction)
lag2_ldatable
sum(diag(lag2_table))/sum(lag2_table)
# same result
# f.
lag2_qda <- qda(Direction ~ Lag2, data = Weekly[Lag2_train,], family = binomial)
lag2_qdapred <- predict(lag2_qda, Weekly[!Lag2_train,], type = "response")$class
lag2_qdatable <- table(lag2_qdapred,  Weekly[!Lag2_train,]$Direction)
lag2_qdatable
sum(diag(lag2_qdatable)/ sum(lag2_qdatable))
# now it's all positives
# g.
lag2_knn <- knn(Weekly[Lag2_train, "Lag2", drop=FALSE], Weekly[!train, "Lag2", drop=FALSE], Weekly$Direction[train])
