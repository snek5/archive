# Good day to anyone who's reading this. Apparently i could not get the CoxSnellResidual to work and could not get the Cp Mallow
# test value too from my ANOVA



# Loading the libraries
library(KMsurv)
library(survival)
library(MASS)

# Retrieving data from .txt file
halibut <- read.table("halibut.txt")
names(halibut) <- c("No","Time","Censor","TOWD","DELDEPTH","LENGTH","HANDTIME","LOGCAT")
head(halibut)
tail(halibut)
attach(halibut)

## Question 1 : What is the difference, if any, between the survival rates for the two tow durations?
#	Rearrange data > Fit survival curve ~ censor > Plot survival curves > Log Rank test statistics

TOWD1 = as.factor(TOWD) # Between two groups therefore we categorize tow groups as categorical data
hal <- survfit(Surv(Time,Censor) ~ TOWD, data = halibut) # Fitting it into a survival curve
print(hal)

# Plot with confidence intervals and saving it into postscript file
postscript('q1.postscript')
plot(hal, col = 1:2, conf.int = T, lty = c(1,2,2,1,2,2), ylab = ("Survival Rate"), xlab = ("Time (hours)"), main = ("Survival Curves of Halibuts with different towing durations"))
legend(800,1, legend = c("30 minutes tow duration","100 minutes tow duration"), col = 1:2, lty = 1)
dev.off()

# Plotting cumulative hazard with confidence intervals and saving it into postscript file
postscript('q1ch.postscript')
plot(hal, fun = "cumhaz", col = 1:2, conf.int = T, lty = c(1,2,2,1,2,2), ylab = ("Cumulative Hazard"), xlab = ("Time (hours)"), main = ("Hazard Curves of Halibuts with different towing durations"))
legend(800,1, legend = c("30 minutes tow duration","100 minutes tow duration"), col = 1:2, lty = 1)
dev.off()

hali <- survdiff(Surv(Time, Censor) ~ TOWD1, data = halibut) # Performing the Log Rank Statistic
print(hali)

## Question 2 : How other covariates affect the survival rate of Atlantic Halibut?
#	Fit into Cox PH model > AIC > Get the best fitted model > Check Model_2ness of fit > Interpret the results

# Removing the variable No
newhalibut <- subset(halibut, select = -No)
head(newhalibut)
attach(newhalibut)

# Model_1 Model
Model_1 <- coxph(Surv( Time, Censor) ~ ., data = newhalibut, method = "efron")
summary(Model_1)

# Residual Plots (without Interaction)
Model_2 <- stepAIC(Model_1, direction = "both")
summary(Model_2)

mgresi <- residuals(Model_2, type = "martingale")

postscript('Model_2.postscript')
par(mfrow = c(2,2), mgp = c(2,1,0), mar = c(3,3,2,1) + 0.1)
plot(LENGTH, mgresi, xlab = "Fork length of halibut in centimetres", ylab = "Martingale residuals")
lines(lowess(LENGTH,mgresi))

plot(HANDTIME, mgresi, xlab = "Handling time (in minutes)", ylab = "Martingale Residuals") # Martingale Residuals vs HANDTIME
lines(lowess(HANDTIME, mgresi))

plot(LOGCAT, mgresi, xlab = "Natural logarithm of total catch of fish in tow", ylab = "Martingale Residuals") # Martingale Residuals vs LOGCAT
lines(lowess(LOGCAT, mgresi))

dev.off()


# Performing AIC on the interaction model
Model_3 <- stepAIC(Model_1, ~.^2, direction = "both")
summary(Model_3)

# ANOVA Cp Mallow Test on Model_1 model and Model_1 interaction model
anova( Model_1, Model_3, test = "Cp") # !Could not get the output for Cp Mallow!

# Residual Plots
postscript('resplots.postscript')
par ( mfrow = c(2,2), mgp = c(2,1,0), mar = c(3,3,2,1)+.1)
CSres <- Censor-residuals(Model_3, type = "martingale") # Cox-Snell Residuals
# resplot1 <- survfit(Surv(CSres, Censor), type = "fleming-harrington") # !No idea why this does not work!
# plot(resplot1, fun = "cumhaz", conf.int = F, mark.time = F, xlab = "Cox-Snell Residuals", ylab = "Cumulative Hazard")
# abline(0,1)

MGresi <- residuals(Model_3, type = "martingale") 
plot(DELDEPTH, MGresi, xlab = "Difference between maximum and minimum depth observed during tow", ylab = " Martingale Residuals") # Martingale Residuals vs DELDEPTH
lines(lowess(DELDEPTH,MGresi))

plot(LENGTH, MGresi, xlab = "Fork length of halibut in centimetres", ylab = "Matingale Residuals") # Martingale Residuals vs LENGTH
lines(lowess(LENGTH,MGresi))

plot(HANDTIME, MGresi, xlab = "Handling time (in minutes)", ylab = "Martingale Residuals") # Martingale Residuals vs HANDTIME
lines(lowess(HANDTIME, MGresi))

plot(LOGCAT, MGresi, xlab = "Natural logarithm of total catch of fish in tow", ylab = "Martingale Residuals") # Martingale Residuals vs LOGCAT
lines(lowess(LOGCAT, MGresi))

# risk.score <- model.matrix(Model_3)[,-1]%*%Model_3$coef
# plot(risk.score,resid(Model_3,type = "dev"), xlab = "Risk Score", ylab = "Deviance Residuals")
dev.off()

final <- cox.zph(Model_3) # test proportionality assumption, H0 : no violation of assumption
final

