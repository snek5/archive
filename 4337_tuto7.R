install.packages("psych")
library(psych)
data(bfi)
attach(bfi)
bfi2<-na.omit(bfi[1:25])

bfi.pca<-prcomp(bfi2,center=TRUE,scale=TRUE)
summary(bfi.pca)
plot(bfi.pca,type="l")

#look for the biggest drop
#cumulative proportion from 5 components

print(bfi.pca)
#to look at the rotations/loadings
#look at the biggest |rotation| value in PC5
#interpretations<-PC5 has higher loadings in A, which means it corresponds to A
#PC4 has higher loadings in O
#PC3 has higher loadings in C
#PC2 has higher loadings in N
#PC1 has higher loadings in E

#question 2
library(faraway)
data(iris)
#no missing data in iris
#to check for factorability, use bartlett
cortest.bartlett(iris[1:4])
#[1:4] because values can only be numeric, and we can omit the 5th column because it is not numeric and not continuous
#p-value of Bartlett test is less than 0.05, therefore we reject null hypothesis
#check KMO
KMO(iris[1:4])
#check overall MSA
#check scree plot
scree(iris[1:4])
#biggest drop after PC <- between 2 and 3
#check parallel analysis
fa.parallel(iris[1:4])
#interpretation of parallel

install.packages("GPArotation")
pa2<-fa(iris[1:4],nfactors=2,max.iter=100)
#max.iter - maximum iterations
fa.diagram(pa2)
pa3<-fa(iris[1:4],nfactors=3,max.iter=100)
fa.diagram(pa3)
#interpretation <- in pa3, MR3 has no loading so there's no need for the third factor
#curve = correlation between the factors
#straight line = loadings
print(pa2)
#for interpretations
#MR1 has higher loading on petal length, sepal length and petal width
