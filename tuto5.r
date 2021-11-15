library(KMsurv)
library(survival)

#question 2 dataframe
untreated<-c(20,21,23,24,24,26,26,27,28,30)
radiated<-c(26,28,29,29,30,30,31,31,32,35)
radiatedBPA<-c(31,32,34,35,36,38,38,39,42,42)
event<-c(rep(1,19),0,rep(1,8),0,0)
q2<-data.frame(time=c(untreated,radiated,radiatedBPA),cens=event,group=c(rep(1,10),rep(2,10),rep(3,10)))
attach(q2)
print(q2)

#question 2a
survivalcurves<-survfit(Surv(time,cens)~group,data=q2,conf.type="log-log")

pdf("~/Documents/UBD/SM-4339/q2a.pdf")
plot(survivalcurves,conf.int=F,col=1:3,lty=1:3,xlab="Time (in days)",ylab="Survival")
legend(0,0.4,c("Untreated","Radiated","Radiated + BPA"),lty=1:3,col=1:3)
dev.off()
system('open ~/Documents/UBD/SM-4339/q2a.pdf')
