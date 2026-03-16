# 2.3.1
x <- c(1, 3, 2, 5)
x
# 1 3 2 5
x = c(1, 6, 2)
x
# 1 6 2
y = c(1, 4, 3)

length(x)
# 3
length(y)
# 3
ls()
# "x" "y"
rm(x, y)
ls()
# character(0)
rm(list = ls())
?matrix
x <- matrix(data = c(1, 2, 3, 4), nrow = 2, ncol = 2)
x
#       [,1] [,2]
# [1,]    1    3
# [2,]    2    4
x <- matrix(c(1, 2, 3, 4), 2, 2)
matrix(c(1, 2, 3, 4), 2, 2, byrow = TRUE)
#     [,1] [,2]
#[1,]    1    2
#[2,]    3    4
sqrt(x)
#          [,1]     [,2]
# [1,] 1.000000 1.732051
# [2,] 1.414214 2.000000
x <- rnorm (50)
y <- x + rnorm (50, mean = 50, sd = .1)
cor(x, y)
# 0.9957978
set.seed (1303)
rnorm (50)
# [1] -1.1439763145  1.3421293656  2.1853904757  0.5363925179  0.0631929665  0.5022344825
# [7] -0.0004167247  0.5658198405 -0.5725226890 -1.1102250073 -0.0486871234 -0.6956562176
# [13]  0.8289174803  0.2066528551 -0.2356745091 -0.5563104914 -0.3647543571  0.8623550343
# [19] -0.6307715354  0.3136021252 -0.9314953177  0.8238676185  0.5233707021  0.7069214120
# [25]  0.4202043256 -0.2690521547 -1.5103172999 -0.6902124766 -0.1434719524 -1.0135274099
# [31]  1.5732737361  0.0127465055  0.8726470499  0.4220661905 -0.0188157917  2.6157489689
# [37] -0.6931401748 -0.2663217810 -0.7206364412  1.3677342065  0.2640073322  0.6321868074
# [43] -1.3306509858  0.0268888182  1.0406363208  1.3120237985 -0.0300020767 -0.2500257125
# [49]  0.0234144857  1.6598706557
set.seed (3)
y <- rnorm (100)
mean(y)
# 0.01103557
var(y)
# 0.7328675
sqrt(var(y))
# 0.8560768
sd(y)
# 0.8560768
# 2.3.2
x <- rnorm (100)
y <- rnorm (100)
plot(x, y)
plot(x, y, xlab = "this is the x-axis",
   ylab = "this is the y-axis",
   main = "Plot of X vs Y")

pdf("Figure.pdf")
plot(x, y, col = "green")
dev.off()
# resources/M1Lab1.png
# null device 
# 1
x <- seq(1, 10)
x
# 1 2 3 4 5 6 7 8 9 10
x <- 1:10
x
# 1 2 3 4 5 6 7 8 9 10
x <- seq(-pi , pi , length = 50)
y <- x
f <- outer(x, y, function(x, y) cos(y) / (1 + x^2))
contour(x, y, f)
contour(x, y, f, nlevels = 45, add = T)
fa <- (f - t(f)) / 2
contour(x, y, fa , nlevels = 15)
image(x, y, fa)
persp(x, y, fa)
persp(x, y, fa , theta = 30)
persp(x, y, fa , theta = 30, phi = 20)
persp(x, y, fa , theta = 30, phi = 70)
persp(x, y, fa , theta = 30, phi = 40)
# 2.3.3
A <- matrix (1:16 , 4, 4)
A
# [,1] [,2] [,3] [,4]
# [1,] 1 5 9 13
# [2,] 2 6 10 14
# [3,] 3 7 11 15
# [4,] 4 8 12 16
A[2,3]
# 10
A[c(1, 3), c(2, 4)]
# [,1] [,2]
# [1,] 5 13
# [2,] 7 15
A[1:3, 2:4]
# [,1] [,2] [,3]
# [1,] 5 9 13
# [2,] 6 10 14
# [3,] 7 11 15
A[1:2, ]
# [,1] [,2] [,3] [,4]
# [1,] 1 5 9 13
# [2,] 2 6 10 14
A[, 1:2]
# [,1] [,2]
# [1,] 1 5
# [2,] 2 6
# [3,] 3 7
# [4,] 4 8
A[1, ]
#[1] 1 5 9 13
dim(A)
# [1] 4 4
# 2.3.4
Auto <- read.table("Auto.data")
View(Auto)
head(Auto)
# V1 V2 V3 V4 V5
# 1 mpg cylinders displacement horsepower weight
# 2 18.0 8 307.0 130.0 3504.
# 3 15.0 8 350.0 165.0 3693.
# 4 18.0 8 318.0 150.0 3436.
# 5 16.0 8 304.0 150.0 3433.
# 6 17.0 8 302.0 140.0 3449.
# V6 V7 V8 V9
# 1 acceleration year origin name
# 2 12.0 70 1 chevrolet chevelle malibu
# 3 11.5 70 1 buick skylark 320
# 4 11.0 70 1 plymouth satellite
# 5 12.0 70 1 amc rebel sst
# 6 10.5 70 1 ford torino
Auto <- read.table("Auto.data", header = T, na.strings = "?",
                     stringsAsFactors = T)
View(Auto)
Auto <- read.csv("Auto.csv", na.strings = "?", stringsAsFactors =
                   T)
View(Auto)
dim(Auto)
# [1] 397 9
Auto [1:4, ]
Auto <- na.omit(Auto)
dim(Auto)
# [1] 392 9
names(Auto)
# [1] "mpg" " cylinders " " displacement " " horsepower "
# [5] "weight" " acceleration " "year" "origin"
# [9] "name"
# 2.3.5
plot(cylinders , mpg)
# Error in plot(cylinders , mpg) : object `cylinders ' not found
plot(Auto$cylinders , Auto$mpg)
attach(Auto)
plot(cylinders , mpg)
cylinders <- as.factor(cylinders)
plot(cylinders , mpg)
plot(cylinders , mpg , col = "red")
plot(cylinders , mpg , col = "red", varwidth = T)
plot(cylinders , mpg , col = "red", varwidth = T,
       horizontal = T)
plot(cylinders , mpg , col = "red", varwidth = T,
       xlab = "cylinders", ylab = "MPG")
hist(mpg)
hist(mpg , col = 2)
hist(mpg , col = 2, breaks = 15)
pairs(Auto)
pairs(
  ~ mpg + displacement + horsepower + weight + acceleration ,
  data = Auto
)
plot(horsepower , mpg)
identify(horsepower , mpg , name)
summary(Auto)
# mpg cylinders displacement
# Min. : 9.00 Min. :3.000 Min. : 68.0
# 1st Qu .:17.00 1st Qu .:4.000 1st Qu .:105.0
# Median :22.75 Median :4.000 Median :151.0
# Mean :23.45 Mean :5.472 Mean :194.4
# 3rd Qu .:29.00 3rd Qu .:8.000 3rd Qu .:275.8
# Max. :46.60 Max. :8.000 Max. :455.0
# horsepower weight acceleration
# Min. : 46.0 Min. :1613 Min. : 8.00
# 1st Qu.: 75.0 1st Qu .:2225 1st Qu .:13.78
# Median : 93.5 Median :2804 Median :15.50
# Mean :104.5 Mean :2978 Mean :15.54
# 52 2. Statistical Learning
# 3rd Qu .:126.0 3rd Qu .:3615 3rd Qu .:17.02
# Max. :230.0 Max. :5140 Max. :24.80
# year origin name
# Min. :70.00 Min. :1.000 amc matador : 5
# 1st Qu .:73.00 1st Qu .:1.000 ford pinto : 5
# Median :76.00 Median :1.000 toyota corolla : 5
# Mean :75.98 Mean :1.577 amc gremlin : 4
# 3rd Qu .:79.00 3rd Qu .:2.000 amc hornet : 4
# Max. :82.00 Max. :3.000 chevrolet chevette: 4
# (Other) :365
summary(mpg)
# Min. 1st Qu. Median Mean 3rd Qu. Max.
# 9.00 17.00 22.75 23.45 29.00 46.60
