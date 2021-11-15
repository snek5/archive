library(faraway)
data(ratdrink)
attach(ratdrink)
ratdrink

#qs 1.a
library(lattice)
xyplot(wt~weeks|subject, ratdrink, type="l")
#weights are increasing throughout the week

#qs 1.b
xyplot(wt~weeks|treat, ratdrink, type="l", groups=subject)
#thiouracil has less weight gain over time compared to control and thyroxine

#qs 1.c
library(lme4)
model<-lmer(wt~treat*weeks+treat+weeks+(weeks|subject),ratdrink)
summary(model)
#weeks|subject is the random effect
#cvariable = center

#qs 1.d
confint(model)
#check the interaction's confidence interval, if its significant, then we dont need to check for each variables
#control is the reference variable in this case
#if interaction is significant, do not remove the parent variables. remove any insignificant interaction variable
#Interpretation: 
#For rats in the control group(reference level), weight increases about (estimate in week) a week
#for thiouracil, it increases about (intercept estimate + weekthiouracil estimate) a week
#for thyroxine, it increases about (intercept estimate + weekthyroxine estimate) a week
#for rats in the thiouracil treatment, it is (thiouracil estimate) times greater than the control
#for rats in the throxine treatment, it is (thyroxine estimate) times less than the control

#qs 1.e
#check model goodness of fit
#use LINE to check model goodness of fit
#normality can be tested from qqplot/qqline or shapiro.test(residuals(model))
shapiro.test(residuals(model))
#to check for equal varinace, plot fitted against residuals
plot(fitted(model),residuals(model)
#looks random therefore it is good
#to check for outliers,
plot(residuals(model))
abline(h=NULL)
#qqmath residuals is to check for the random effects
qqmath(~residuals(model)|treat,ratdrink) #per treatment
#or
qqmath(~residuals(model)) #as a whole
#can use xyplot
xyplot(residuals(model)~fitted(model)) #can include |treat as well
