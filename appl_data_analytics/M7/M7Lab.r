## 12.5.1 Principal Components Analysis

states <- row.names(USArrests)
states

names(USArrests)
# [1] "Murder"   "Assault"  "UrbanPop" "Rape"

apply(USArrests, 2, mean)
#   Murder Assault UrbanPop     Rape
#     7.79  170.76    65.54    21.23

apply(USArrests, 2, var)
#   Murder Assault UrbanPop     Rape
#     19.0  6945.2    209.5     87.7

pr.out <- prcomp(USArrests, scale = TRUE)

names(pr.out)
# [1] "sdev"     "rotation" "center"   "scale"    "x"

pr.out$center
#   Murder Assault UrbanPop     Rape
#     7.79  170.76    65.54    21.23
pr.out$scale
#   Murder Assault UrbanPop     Rape
#     4.36   83.34    14.47     9.37

pr.out$rotation
#             PC1    PC2    PC3    PC4
# Murder   -0.536  0.418 -0.341  0.649
# Assault  -0.583  0.188 -0.268 -0.743
# UrbanPop -0.278 -0.873 -0.378  0.134
# Rape     -0.543 -0.167  0.818  0.089

dim(pr.out$x)
# [1] 50  4

biplot(pr.out, scale = 0)

pr.out$rotation <- -pr.out$rotation
pr.out$x <- -pr.out$x
biplot(pr.out, scale = 0)

pr.out$sdev
# [1] 1.575 0.995 0.597 0.416

pr.var <- pr.out$sdev^2
pr.var
# [1] 2.480 0.990 0.357 0.173

pve <- pr.var / sum(pr.var)
pve
# [1] 0.6201 0.2474 0.0891 0.0434

par(mfrow = c(1, 2))
plot(pve, xlab = "Principal Component",
  ylab = "Proportion of Variance Explained", ylim = c(0, 1),
  type = "b")
plot(cumsum(pve), xlab = "Principal Component",
  ylab = "Cumulative Proportion of Variance Explained",
  ylim = c(0, 1), type = "b")

a <- c(1, 2, 8, -3)
cumsum(a)
# [1]  1  3 11  8


## 12.5.2 Matrix Completion

X <- data.matrix(scale(USArrests))
pcob <- prcomp(X)
summary(pcob)
# Importance of components:
#                           PC1    PC2     PC3     PC4
# Standard deviation     1.5749 0.9949 0.59713 0.41645
# Proportion of Variance 0.6201 0.2474 0.08914 0.04336
# Cumulative Proportion  0.6201 0.8675 0.95664 1.00000

sX <- svd(X)
names(sX)
# [1] "d" "u" "v"
round(sX$v, 3)
#        [,1]   [,2]   [,3]   [,4]
# [1,] -0.536  0.418 -0.341  0.649
# [2,] -0.583  0.188 -0.268 -0.743
# [3,] -0.278 -0.873 -0.378  0.134
# [4,] -0.543 -0.167  0.818  0.089

pcob$rotation
#             PC1    PC2    PC3    PC4
# Murder   -0.536  0.418 -0.341  0.649
# Assault  -0.583  0.188 -0.268 -0.743
# UrbanPop -0.278 -0.873 -0.378  0.134
# Rape     -0.543 -0.167  0.818  0.089

t(sX$d * t(sX$u))
#        [,1]     [,2]     [,3]     [,4]
# [1,] -0.976    1.122   -0.440    0.155
# [2,] -1.931    1.062    2.020   -0.434
# [3,] -1.745   -0.738    0.054   -0.826
# [4,]  0.140    1.109    0.113   -0.182
# [5,] -2.499   -1.527    0.593   -0.339
# ...

pcob$x
#                  PC1       PC2       PC3       PC4
# Alabama        -0.976    1.122    -0.440     0.155
# Alaska         -1.931    1.062     2.020    -0.434
# Arizona        -1.745   -0.738     0.054    -0.826
# Arkansas        0.140    1.109     0.113    -0.182
# California     -2.499   -1.527     0.593    -0.339
# ...

nomit <- 20
set.seed(15)
ina <- sample(seq(50), nomit)
inb <- sample(1:4, nomit, replace = TRUE)
Xna <- X
index.na <- cbind(ina, inb)
Xna[index.na] <- NA

fit.svd <- function(X, M = 1) {
  svdob <- svd(X)
  with(svdob,
    u[, 1:M, drop = FALSE] %*%
    (d[1:M] * t(v[, 1:M, drop = FALSE]))
  )
}

Xhat <- Xna
xbar <- colMeans(Xna, na.rm = TRUE)
Xhat[index.na] <- xbar[inb]

thresh <- 1e-7
rel_err <- 1
iter <- 0
ismiss <- is.na(Xna)
mssold <- mean((scale(Xna, xbar, FALSE)[!ismiss])^2)
mss0 <- mean(Xna[!ismiss]^2)

while (rel_err > thresh) {
  iter <- iter + 1
  # Step 2(a)
  Xapp <- fit.svd(Xhat, M = 1)
  # Step 2(b)
  Xhat[ismiss] <- Xapp[ismiss]
  # Step 2(c)
  mss <- mean(((Xna - Xapp)[!ismiss])^2)
  rel_err <- (mssold - mss) / mss0
  mssold <- mss
  cat("Iter:", iter, "MSS:", mss,
    "Rel. Err:", rel_err, "\n")
}
# Iter: 1 MSS: 0.3822 Rel. Err: 0.6194
# Iter: 2 MSS: 0.3705 Rel. Err: 0.0116
# Iter: 3 MSS: 0.3693 Rel. Err: 0.0012
# Iter: 4 MSS: 0.3691 Rel. Err: 0.0002
# Iter: 5 MSS: 0.3691 Rel. Err: 2.1992e-05
# Iter: 6 MSS: 0.3691 Rel. Err: 3.3760e-06
# Iter: 7 MSS: 0.3691 Rel. Err: 5.4651e-07
# Iter: 8 MSS: 0.3691 Rel. Err: 9.2531e-08

cor(Xapp[ismiss], X[ismiss])
# [1] 0.6535


## 12.5.3 Clustering

# K-Means Clustering

set.seed(2)
x <- matrix(rnorm(50 * 2), ncol = 2)
x[1:25, 1] <- x[1:25, 1] + 3
x[1:25, 2] <- x[1:25, 2] - 4

km.out <- kmeans(x, 2, nstart = 20)

km.out$cluster
# [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2
# [29] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2

par(mfrow = c(1, 2))
plot(x, col = (km.out$cluster + 1),
  main = "K-Means Clustering Results with K = 2",
  xlab = "", ylab = "", pch = 20, cex = 2)

set.seed(4)
km.out <- kmeans(x, 3, nstart = 20)
km.out
# K-means clustering with 3 clusters of sizes 17, 23, 10
# Cluster means:
#        [,1]     [,2]
# 1    3.7790  -4.5620
# 2   -0.3820  -0.0874
# 3    2.3002  -2.6962
#
# Clustering vector:
#  [1] 1 3 1 3 1 1 1 3 1 3 1 3 1 3 1 3 1 1 1 1 1 3 1 1 1 2 2 2
# [29] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 2 3 2 2 2 2
#
# Within cluster sum of squares by cluster:
# [1] 25.7409 52.6770 19.5614
#  (between_SS / total_SS = 79.3 %)
#
# Available components:
# [1] "cluster"      "centers"       "totss"
# [4] "withinss"     "tot.withinss"  "betweenss"
# [7] "size"         "iter"          "ifault"

plot(x, col = (km.out$cluster + 1),
  main = "K-Means Clustering Results with K = 3",
  xlab = "", ylab = "", pch = 20, cex = 2)

set.seed(4)
km.out <- kmeans(x, 3, nstart = 1)
km.out$tot.withinss
# [1] 104.3319
km.out <- kmeans(x, 3, nstart = 20)
km.out$tot.withinss
# [1] 97.9793

# Hierarchical Clustering

hc.complete <- hclust(dist(x), method = "complete")
hc.average <- hclust(dist(x), method = "average")
hc.single <- hclust(dist(x), method = "single")

par(mfrow = c(1, 3))
plot(hc.complete, main = "Complete Linkage",
  xlab = "", sub = "", cex = .9)
plot(hc.average, main = "Average Linkage",
  xlab = "", sub = "", cex = .9)
plot(hc.single, main = "Single Linkage",
  xlab = "", sub = "", cex = .9)

cutree(hc.complete, 2)
#  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2
# [30] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
cutree(hc.average, 2)
#  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2
# [30] 2 2 2 1 2 2 2 2 2 2 2 2 2 2 1 2 1 2 2 2 2
cutree(hc.single, 2)
#  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 1 1
# [30] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1

cutree(hc.single, 4)
#  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 3 3 3 3
# [30] 3 3 3 3 3 3 3 3 3 3 3 3 4 3 3 3 3 3 3 3 3

xsc <- scale(x)
plot(hclust(dist(xsc), method = "complete"),
  main = "Hierarchical Clustering with Scaled Features")

x <- matrix(rnorm(30 * 3), ncol = 3)
dd <- as.dist(1 - cor(t(x)))
plot(hclust(dd, method = "complete"),
  main = "Complete Linkage with Correlation-Based Distance",
  xlab = "", sub = "")


## 12.5.4 NCI60 Data Example

library(ISLR2)
nci.labs <- NCI60$labs
nci.data <- NCI60$data

dim(nci.data)
# [1]   64 6830

nci.labs[1:4]
# [1] "CNS"   "CNS"   "CNS"   "RENAL"
table(nci.labs)
# nci.labs
#      BREAST           CNS       COLON K562A-repro K562B-repro
#           7             5           7           1           1
#    LEUKEMIA MCF7A-repro MCF7D-repro    MELANOMA       NSCLC
#           6           1           1           8           9
#     OVARIAN     PROSTATE       RENAL     UNKNOWN
#           6           2           9           1

# PCA on the NCI60 Data

pr.out <- prcomp(nci.data, scale = TRUE)

Cols <- function(vec) {
  cols <- rainbow(length(unique(vec)))
  return(cols[as.numeric(as.factor(vec))])
}

par(mfrow = c(1, 2))
plot(pr.out$x[, 1:2], col = Cols(nci.labs), pch = 19,
  xlab = "Z1", ylab = "Z2")
plot(pr.out$x[, c(1, 3)], col = Cols(nci.labs), pch = 19,
  xlab = "Z1", ylab = "Z3")

summary(pr.out)
# Importance of components:
#                           PC1     PC2     PC3     PC4     PC5
# Standard deviation     27.853 21.4814 19.8205 17.0326 15.9718
# Proportion of Variance  0.114  0.0676  0.0575  0.0425  0.0374
# Cumulative Proportion   0.114  0.1812  0.2387  0.2812  0.3185

plot(pr.out)

pve <- 100 * pr.out$sdev^2 / sum(pr.out$sdev^2)
par(mfrow = c(1, 2))
plot(pve, type = "o", ylab = "PVE",
  xlab = "Principal Component", col = "blue")
plot(cumsum(pve), type = "o", ylab = "Cumulative PVE",
  xlab = "Principal Component", col = "brown3")

# Clustering the Observations of the NCI60 Data

sd.data <- scale(nci.data)

par(mfrow = c(1, 3))
data.dist <- dist(sd.data)
plot(hclust(data.dist), xlab = "", sub = "", ylab = "",
  labels = nci.labs, main = "Complete Linkage")
plot(hclust(data.dist, method = "average"),
  labels = nci.labs, main = "Average Linkage",
  xlab = "", sub = "", ylab = "")
plot(hclust(data.dist, method = "single"),
  labels = nci.labs, main = "Single Linkage",
  xlab = "", sub = "", ylab = "")

hc.out <- hclust(dist(sd.data))
hc.clusters <- cutree(hc.out, 4)
table(hc.clusters, nci.labs)

par(mfrow = c(1, 1))
plot(hc.out, labels = nci.labs)
abline(h = 139, col = "red")

hc.out
# Call:
# hclust(d = dist(sd.data))
#
# Cluster method   : complete
# Distance         : euclidean
# Number of objects: 64

set.seed(2)
km.out <- kmeans(sd.data, 4, nstart = 20)
km.clusters <- km.out$cluster
table(km.clusters, hc.clusters)
#             hc.clusters
# km.clusters  1  2  3  4
#           1 11  0  0  9
#           2 20  7  0  0
#           3  9  0  0  0
#           4  0  0  8  0

hc.out <- hclust(dist(pr.out$x[, 1:5]))
plot(hc.out, labels = nci.labs,
  main = "Hier. Clust. on First Five Score Vectors")
table(cutree(hc.out, 4), nci.labs)
