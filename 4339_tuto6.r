library(KMsurv)
library(survival)
library(reshape2)
aneuploid<-c(1,3,3,4,10,13,13,16,16,24,26,27,28,30,30,32,41,51,61,65,67,70,72,73,74,77,79,80,81,87,87,88,89,91,93,93,96,97,100,101,104,104,108,109,120,131,150,157,167,231,240,400)
diploid<-c(1,3,4,5,5,8,8,12,13,18,23,26,27,30,42,56,62,67,69,76,104,104,104,112,129,176,181,231)
eventA<-c(rep(1,18),0,rep(1,5),0,1,rep(0,7),1,1,0,1,0,1,0,1,rep(0,6),1,1,rep(0,3))
eventD<-c(rep(1,6),0,rep(1,10),0,1,0,1,1,0,1,1,0,1,0)
q2aA<-data.frame(aneuploid,eventA)
q2aD<-data.frame(diploid,eventD)
print(q2aA)
print(q2aD)

q2aAweibull<-survreg(Surv(aneuploid,eventA) ~ 1)
summary(q2aAweibull)

q2aDweibull<-survreg(Surv(diploid,eventD) ~ 1)
summary(q2aDweibull)


#MLE of alpha=(Scale^-1)
#MLE of lambda = e^(-mu/Scale) where mu is the value for the intercept

#purpose of the MLEs = to put it back into the formula and find the curve

#question 2b
#read p-values of Log(Scale) under H0: alpha = 1, if p-value > 0.05 then do not reject H0
#both has p-value less than 0.05 (Do not reject H0) therefore alpha =1 and exponential distribution is appropriate

#question 2c
#combine both datasets
time<-c(aneuploid,diploid)
event<-c(eventA,eventD)
group<-c(rep(1,52),rep(0,28))
q2c<-data.frame(time,event,group)
print(q2c)

q2ci<-survreg(Surv(time,event)~group)
summary(q2ci)
#H0: no differences, since p-value is more than 0.05, do not reject H0 therefore no effect of ploidy on the survival curve
#LRT check the chisq p-value, wald test check the p-value of group

#q2cii
#to find relative risk between two groups, e^(-mu/scale) where mu is the value for group

#q2ciii
#acceleration factor is e^(-mu)

#q2civ
#acceleration factor = 0.512, interpretation = lifetime of diploid patient is 0.51 times that of the aneuploid patients

#diploid is the reference level in this case
