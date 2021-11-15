library(KMsurv)
data(btrial)
library(survival)
btrial

#Question 1.a focus on the negative data only, data from 1 to 36
attach(btrial)
data1<-btrial[1:36,]
data1

T3Q1aKM<-survfit(Surv(time,death)~1,data1,error="greenwood",type="kaplan-meier",conf.type="log-log")
summary(T3Q1aKM)

#plot the KM Curve
plot(T3Q1aKM, xlab="Time to death (Months)", ylab="Survival",main="KM Curve")

#then we try fleming harrington type and tsiatis error
T3Q1aFH<-survfit(Surv(time,death)~1,data1,error="tsiatis",type="fleming-harrington",conf.type="log-log")

#compare both KM and FH curve
par(mfrow=c(1,2))
plot(T3Q1aKM, xlab="Time to death (Months)", ylab="Survival", main="KM Curve")
plot(T3Q1aFH, xlab="Time to death (Months)", ylab="Survival", main="FH Curve")

#Find median and the 95% confidence interval
print(T3Q1aKM,show.rmean=T)
print(T3Q1aFH,show.rmean=T)

#both shows NA for the median because the plots are below the 50% mark - we dont have the median

#part b - study both groups
T3Q1b<-survfit(Surv(time,death)~im,btrial,error="greenwood",type="kaplan-meier",conf.type="log-log")


#plot both groups
plot(T3Q1b, xlab="Time to death (months)", ylab="Survival",conf.int=T,col=1:2)
legend(25,0.1,c("negative","positive"),col=c("black","red"),lty=c(3,4))

#perform log-rank test to see significance between the survival curves



###Q2
time<-c(12.3,5.4,8.2,12.2,11.7,10.0,5.7,9.8,2.6,11.0,9.2,12.1,6.6,2.2,1.8,10.2,10.7,11.1,5.3,3.5,9.2,2.5,8.7,3.8,3.0,5.8,2.9,8.4,8.3,9.1,4.2,4.1,1.8,3.1,11.4,2.4,1.4,5.9,1.6,2.8,4.9,3.5,6.5,9.9,3.6,5.2,8.8,7.8,4.7,3.9)
#no need to care about the order, remove the + sign
ded<-c(0,1,1,0,1,1,1,1,1,1,1,0,rep(1,38))
#censored=0, death=1
group<-c(rep(1,25),rep(2,25)) #repeat for 25 times

T3Q2frame<-data.frame(time,ded,group)
print(T3Q2frame)

attach(T3Q2frame)
T3Q2<-survfit(Surv(time,ded)~group,T3Q2frame,error="greenwood",type="kaplan-meier",conf.type="log-log")

plot(T3Q2, xlab="Time", ylab="Survival", conf.int=T, col=1:2)
legend(25,0.1, c("Group 1","Group 2"), col=c("blue","green"), lty=c(3,4))
survdiff(Surv(time,ded)~group,data=T3Q2frame)

#H0: no difference in survival between the group
#H1: there are differences in survival between the two group

#reject H0, therefore there is evidence of differences in survival between the group
