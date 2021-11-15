library(readxl)
library(ResourceSelection)
library(faraway)
assignment.data<-read_excel("/home/jim/Documents/UBD/SM-4337/renalv2.xlsx")
attach(assignment.data)

district<-as.factor(district)
gender<-as.factor(gender)
race<-as.factor(race)

assignment.dataframe<-data.frame(age,district,treatment,stage,gender,race,survival)
assignment.cleandata<-na.omit(assignment.dataframe)
attach(assignment.cleandata)
assignment.modelv1<-glm(survival~.,family=binomial,data=assignment.cleandata)
print(assignment.modelv1)

step(assignment.modelv1)
assignment.modelv2<-glm(survival~treatment+stage, family=binomial, data=assignment.cleandata)
print(summary(assignment.modelv2))
library(ResourceSelection)
print(hoslem.test(assignment.modelv2$y,fitted(assignment.modelv2)))

t1s1<-c(1,1,1)
t1s2<-c(1,1,2)
t1s4<-c(1,1,4)
t2s1<-c(1,2,1)
t2s2<-c(1,2,2)
t2s4<-c(1,2,4)
t0s1<-c(1,0,1)
t0s2<-c(1,0,2)
t0s4<-c(1,0,4)

valuet1s1<-ilogit(sum(t1s1*coef(assignment.modelv2)))
print(valuet1s1)

valuet1s2<-ilogit(sum(t1s2*coef(assignment.modelv2)))
print(valuet1s2)

valuet1s4<-ilogit(sum(t1s4*coef(assignment.modelv2)))
print(valuet1s4)

valuet2s1<-ilogit(sum(t2s1*coef(assignment.modelv2)))
print(valuet2s1)

valuet2s2<-ilogit(sum(t2s2*coef(assignment.modelv2)))
print(valuet2s2)

valuet2s4<-ilogit(sum(t2s4*coef(assignment.modelv2)))
print(valuet2s4)

valuet0s1<-ilogit(sum(t0s1*coef(assignment.modelv2)))
print(valuet0s1)

valuet0s2<-ilogit(sum(t0s2*coef(assignment.modelv2)))
print(valuet0s2)

valuet0s4<-ilogit(sum(t0s4*coef(assignment.modelv2)))
print(valuet0s4)