library(ISLR2)
set.seed(1)
# 2
# a.
m = matrix(c(0, 0.3, 0.4, 0.7, 0.3, 0, 0.5, 0.8, 0.4, 0.5, 0., 0.45, 0.7, 0.8, 0.45, 0), ncol = 4)
complete = hclust(as.dist(m))
plot(complete)
# b.
single = hclust(as.dist(m), method = "single")
plot(single)
# c
cutree(complete, k = 2)
# 1 1 2 2
# d
cutree(single, k = 2)
# 1 1 1 2
# e
plot(complete, labels = c(2, 1, 3, 4))

# 3
# a
df = data.frame(
  x1 = c(1, 1, 0, 5, 6, 4),
  x2 = c(4, 3, 4, 1, 2, 0)
)
plot(df)
# b.
clusters = sample(c(1, 2), size = nrow(df), replace = TRUE)
clusters
# 1 2 1 1 2 1
# c.
centroids = sapply(c(1, 2), function(i) colMeans(df[clusters == i, 1:2]))
centroids
# d.
dist1 = sqrt((df$x1 - centroids[1, 1])^2 + (df$x2 - centroids[2, 1])^2)
dist2 = sqrt((df$x1 - centroids[1, 2])^2 + (df$x2 - centroids[2, 2])^2)
new_clusters = ifelse(dist1 < dist2, 1, 2)
new_clusters
# e.
centroider <- function(df, clusters) {
  n = 0
  repeat {
    n=n+1
    centroids = sapply(c(1, 2), function(i) colMeans(df[clusters == i, 1:2]))
    dist1 = sqrt((df$x1 - centroids[1, 1])^2 + (df$x2 - centroids[2, 1])^2)
    dist2 = sqrt((df$x1 - centroids[1, 2])^2 + (df$x2 - centroids[2, 2])^2)
    new_clusters = ifelse(dist1 < dist2, 1, 2)
    
    if (all(new_clusters == clusters)) {
      return(list(centroids = centroids, clusters = new_clusters, attempts = n))
    }
    
    clusters = new_clusters
  }
}
centroider(df, clusters)
# f.
plot(df, col = new_clusters, pch = 19)
# 7
data = t(scale(t(USArrests)))
euclidean = dist(data)^2
correlation = as.dist(1 - cor(t(data)))
plot(euclidean, correlation)
# 9
# a.
clustered = hclust(dist(USArrests))
# b.
cut = cutree(clustered, 3)
split(names(cut), cut)
# c.
clusteredsd = hclust(dist(scale(USArrests)))
# d.
cutsd <- cutree(clusteredsd, 3)
split(names(cutsd), cutsd)

stats <- data.frame(
  variable = colnames(USArrests),
  min = apply(USArrests, 2, min),
  max = apply(USArrests, 2, max),
  range = apply(USArrests, 2, function(x) max(x) - min(x)),
  sd = apply(USArrests, 2, sd)
)
stats

# 10
