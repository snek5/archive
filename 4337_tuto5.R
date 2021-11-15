> pulp<-c(59.88,59.87,60.83
+ ,61.01,60.12,60.32,60.87,60.87,60.88,60.42,60.56,60.69,60.98,59.99,61,60.53,59.9,60.12,60.5,60.63)
> pulp
 [1] 59.88 59.87 60.83 61.01 60.12 60.32 60.87 60.87 60.88 60.42 60.56 60.69
[13] 60.98 59.99 61.00 60.53 59.90 60.12 60.50 60.63
> pukp<-c(59.88,59.87,60.83,61.01,60.12,60.32,60.87,60.87,60.88,60.42,60.56,60.69,60.98,59.99,61,60.53,59.9,60.12,60.5,60.63)
> pukp
 [1] 59.88 59.87 60.83 61.01 60.12 60.32 60.87 60.87 60.88 60.42 60.56 60.69
[13] 60.98 59.99 61.00 60.53 59.90 60.12 60.50 60.63
> op<-c("A","B","C","D","A","B","C","D","A","B","C","D","A","B","C","D","A","B","C","D")
> op
 [1] "A" "B" "C" "D" "A" "B" "C" "D" "A" "B" "C" "D" "A" "B" "C" "D" "A" "B" "C"
[20] "D"
> is.factor(op)
[1] FALSE
> op<-as.factor(op)
> is.factor(op)
[1] TRUE
> pdata<-data.frame(pulp,op)
> pdata
    pulp op
1  59.88  A
2  59.87  B
3  60.83  C
4  61.01  D
5  60.12  A
6  60.32  B
7  60.87  C
8  60.87  D
9  60.88  A
10 60.42  B
11 60.56  C
12 60.69  D
13 60.98  A
14 59.99  B
15 61.00  C
16 60.53  D
17 59.90  A
18 60.12  B
19 60.50  C
20 60.63  D
> attach(pdata)
The following objects are masked _by_ .GlobalEnv:

    op, pulp

> anova1<-lm(pulp~op,pdata)
> summary(anova1)

Call:
lm(formula = pulp ~ op, data = pdata)

Residuals:
   Min     1Q Median     3Q    Max 
-0.472 -0.220 -0.040  0.194  0.628 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  60.3520     0.1454 415.136   <2e-16 ***
opB          -0.2080     0.2056  -1.012   0.3267    
opC           0.4000     0.2056   1.946   0.0695 .  
opD           0.3940     0.2056   1.916   0.0734 .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3251 on 16 degrees of freedom
Multiple R-squared:  0.4464,    Adjusted R-squared:  0.3426 
F-statistic:   4.3 on 3 and 16 DF,  p-value: 0.02097

> #answer a. there is evidence at 5% level that there are differences among operators in making sheets and reading brightness
> #question 1a, what is the nature of these differences?
> TukeyHSD(aov(pulp~op,pdata))
  Tukey multiple comparisons of means
    95% family-wise confidence level

Fit: aov(formula = pulp ~ op, data = pdata)

$op
      diff         lwr       upr     p adj
B-A -0.208 -0.79621621 0.3802162 0.7450627
C-A  0.400 -0.18821621 0.9882162 0.2489941
D-A  0.394 -0.19421621 0.9822162 0.2603189
C-B  0.608  0.01978379 1.1962162 0.0415316
D-B  0.602  0.01378379 1.1902162 0.0439458
D-C -0.006 -0.59421621 0.5822162 0.9999907

> #H0 : mean are equal, H1: not all mean are equal, C-B and D-B are significantly different
> #if there is no p-value, if 0 is in the interval therefore there is no signigicant differences
> #question 2a. make interaction plot for this data
> break<-c(26,18,36,30,21,21,54,29,24,25,17,18,70,12,10,52,18,43,51,35,28,26,30,15,67,36,26,27,42,20,14,26,21,29,19,24,19,16,17,29,39,13,31,28,15,41,21,15,20,39,16,44,29,28)
Error in break <- c(26, 18, 36, 30, 21, 21, 54, 29, 24, 25, 17, 18, 70,  : 
  invalid (NULL) left side of assignment
> loom<-c(26,18,36,30,21,21,54,29,24,25,17,18,70,12,10,52,18,43,51,35,28,26,30,15,67,36,26,27,42,20,14,26,21,29,19,24,19,16,17,29,39,13,31,28,15,41,21,15,20,39,16,44,29,28)
> tension<-c("L","M","T","L","M","T","L","M","T","L","M","T","L","M","T","L","M","T","L","M","T","L","M","T","L","M","T","L","M","T","L","M","T","L","M","T","L","M","T","L","M","T","L","M","T","L","M","T","L","M","T","L","M","T")
> wool<-c("A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","B","B","B","B","B","B","B","B","B","B","B","B","B","B","B","B","B","B","B","B","B","B","B","B","B","B","B")
> woolbreak<-data.frame(loom~tension~wool)
Error in as.data.frame.default(x[[i]], optional = TRUE) : 
  cannot coerce class ""formula"" to a data.frame
> woo<-data.frame(loom~tension~wool)
Error in as.data.frame.default(x[[i]], optional = TRUE) : 
  cannot coerce class ""formula"" to a data.frame
> woo
Error: object 'woo' not found
> is.factor(wool)
[1] FALSE
> is.factor(tension)
[1] FALSE
> wool<-as.factor(wool)
> is.factor(wool)
[1] TRUE
> woolbreak<-data.frame(loom~tension~wool)
Error in as.data.frame.default(x[[i]], optional = TRUE) : 
  cannot coerce class ""formula"" to a data.frame
> tension<-as.factor(tension)
> woolbreak<-data.frame(loom~tension~wool)
Error in as.data.frame.default(x[[i]], optional = TRUE) : 
  cannot coerce class ""formula"" to a data.frame
> woolbreak<-data.frame(tension~wool~loom)
Error in as.data.frame.default(x[[i]], optional = TRUE) : 
  cannot coerce class ""formula"" to a data.frame
> tension
 [1] L M T L M T L M T L M T L M T L M T L M T L M T L M T L M T L M T L M T L
[38] M T L M T L M T L M T L M T L M T
Levels: L M T
> wool
 [1] A A A A A A A A A A A A A A A A A A A A A A A A A A A B B B B B B B B B B
[38] B B B B B B B B B B B B B B B B B
Levels: A B
> loom
 [1] 26 18 36 30 21 21 54 29 24 25 17 18 70 12 10 52 18 43 51 35 28 26 30 15
[25] 67 36 26 27 42 20 14 26 21 29 19 24 19 16 17 29 39 13 31 28 15 41 21 15
[49] 20 39 16 44 29 28
> woolbreak<-data.frame(loom,tension,wool)
> woolbreak
   loom tension wool
1    26       L    A
2    18       M    A
3    36       T    A
4    30       L    A
5    21       M    A
6    21       T    A
7    54       L    A
8    29       M    A
9    24       T    A
10   25       L    A
11   17       M    A
12   18       T    A
13   70       L    A
14   12       M    A
15   10       T    A
16   52       L    A
17   18       M    A
18   43       T    A
19   51       L    A
20   35       M    A
21   28       T    A
22   26       L    A
23   30       M    A
24   15       T    A
25   67       L    A
26   36       M    A
27   26       T    A
28   27       L    B
29   42       M    B
30   20       T    B
31   14       L    B
32   26       M    B
33   21       T    B
34   29       L    B
35   19       M    B
36   24       T    B
37   19       L    B
38   16       M    B
39   17       T    B
40   29       L    B
41   39       M    B
42   13       T    B
43   31       L    B
44   28       M    B
45   15       T    B
46   41       L    B
47   21       M    B
48   15       T    B
49   20       L    B
50   39       M    B
51   16       T    B
52   44       L    B
53   29       M    B
54   28       T    B
> attach(woolbreak)
The following objects are masked _by_ .GlobalEnv:

    loom, tension, wool

> interaction.plot(wool,tension,loom)
> par.cfrow(2,1)
Error in par.cfrow(2, 1) : could not find function "par.cfrow"
> interaction.plot(wool,tension,loom)
> interaction.plot(tension,wool,loom)
> par.mfrow(2,1)
Error in par.mfrow(2, 1) : could not find function "par.mfrow"
> par=mfrow(2,1)
Error in mfrow(2, 1) : could not find function "mfrow"
> par(mfrow,c(2,1))
Error in par(mfrow, c(2, 1)) : object 'mfrow' not found
> interaction.plot(wool,tension,loom)
> interaction.plot(tension,wool,loom)
> par(mfrow=c(1,2))
> interaction.plot(tension,wool,loom)
> interaction.plot(wool,tension,loom)
> #more breaks in woolA for low tension, more breaks in woolB for medium tension, more breaks in woolA with high tension
#answer for question 2.a ^




> anovaqn2<-lm(loom~wool*tension)
> anova(anovaqn2)
#we check the interaction first because it is in the higher order



