ORPRN CHIPRA survey
===================

Last update by Benjamin Chan (<chanb@ohsu.edu>) on 2013-07-31 15:04:35 using R version 3.0.1 (2013-05-16).


Background
----------

Original email from Katrina (emphasis mine):

> From: Katrina Ramsey 
> Sent: Thursday, July 25, 2013 3:04 PM
> To: Benjamin Chan
> Subject: ORPRN Quality measures survey analysis -- suggestions?
> 
> I'm working with ORPRN on a survey of providers about which quality measures they find useful. LJ Fagnan suggested that you might have useful suggestions for how to wrangle this information, and that you might actually find it interesting.
> 
> **If you are interested, would you have a short time slot available to brainstorm with me early next week? Or can you point me in the direction of a similar analysis?
> 
> A brief summary: 
> Two types of questions about a list of about 23 CHIPRA quality measures:
> 1)  Is this measure useful? (check all that apply)
> 2)  Check the five measures that are top priorities (check 5)
> A subset of these measures correspond to CCO incentive measures. **We are interested in some way of expressing their importance relative to non-CCO measures on the list.**
> 
> So far, I have calculated percentages of providers (n= approx 140) who checked measures and ranked the measures by percentages. Also checked differences by specialty type, size of practice, and PCPCH status. 
> 
> Thanks in advance,
> 
> Katrina
> 
> Katrina Ramsey, MPH
> BDP Staff Biostatistician
> OCTRI Biostatistics & Design Program
> Oregon Health & Science University
> Phone: 503-418-9241
> Email: bdp@ohsu.edu

Follow-up email:

> From: Katrina Ramsey 
> Sent: Monday, July 29, 2013 10:27 AM
> To: Benjamin Chan; Ruth Rowland; Aaron Mendelson
> Cc: Lyle Fagnan; LeAnn Michaels
> Subject: Materials for ORPRN Quality Measures Survey meeting this afternoon
> 
> Thanks, everyone, for your willingness to meet today to talk about the ORPRN Quality Measures Survey. I am attaching two files for your information. The pdf file is the questionnaire itself, delivered on SurveyMonkey.com. The Excel file contains a summary of responses to Question 4 on the first tab, and some subgroupings of respondents on the second tab.
> 
> We are looking for a way to summarize/test/talk about how useful and important providers find the quality measures in questions 3 and 4 of the survey. Questions 3 and 4 are similar; question 3 asks about usefulness and question 4 about priorities. Question 3 also has more detail about CAPHS measures.
> 
> Some of these measures are similar to CCO incentive measures - these are identified in the Excel file - and the differences between this group of measures versus others are of particular interest.
> 
> I will bring copies this afternoon. Thanks again!
> 
> Katrina

The key questions from the survey are

Q3. For each measure, check the box if the measure is *USEFUL* for Your Practice. (31 items)

and

Q4. Select the 5 Measures that represent *YOUR TOP 5 PRIORITIES* for measurement for your practice. (23 items)


Proposed model
--------------

The 31 items from Q3 and the 23 items from Q4 can be viewed as binary responses (checked/unchecked) that are clustered within provider. Thus, a hierarchical linear model is proposed using a logistic link function and clustering by provider.

$latex y_i = \beta_0 + \beta_1 x_\text{CCO measure} + \beta_2 x_\text{provider characteristic} + \Gamma Z_\text{provider ID}$


How to fit model using fake data
--------------------------------

The code below walks through fitting the model for Q3 using fake data. The same code can be used to fit the model for Q4. The end goal is to get the ratio of the odds  that a CCO measure would be classified as *useful* versus a non-CCO measure.

Generate the fake data for 100 providers responding to the 31 checkbox items of Q3. Show the top few lines of the data frame.

```r
nProv <- 100
idProv <- factor(rep(seq(1, nProv), each = 31))
idItem <- factor(rep(seq(1, 31), nProv))
isCCOMeasure <- idItem %in% c(1, 4, 8, 12, 18, 20, 21, 22, 23, 24, 25, 26, 27, 
    28, 29, 30, 31)
x <- rep(rnorm(nProv), each = 31)
orNominal <- 1.2
p <- exp(log(orNominal) * isCCOMeasure)/(1 + exp(log(orNominal) * isCCOMeasure))
isUseful <- rbinom(nProv * 31, 1, p)
D <- data.frame(idProv, idItem, isCCOMeasure, x, isUseful)
head(D)
```

```
##   idProv idItem isCCOMeasure     x isUseful
## 1      1      1         TRUE -1.27        1
## 2      1      2        FALSE -1.27        1
## 3      1      3        FALSE -1.27        1
## 4      1      4         TRUE -1.27        0
## 5      1      5        FALSE -1.27        1
## 6      1      6        FALSE -1.27        0
```


Load the `lme4` package.

```r
require(lme4, quietly = TRUE)
```

```
## Loading required package: lattice
```

```
## Attaching package: 'lme4'
```

```
## The following object is masked from 'package:stats':
## 
## AIC, BIC
```

```r
require(xtable, quietly = TRUE)
```


Fit a random intercept model and then a random slope model to the fake data.

```r
M1 <- lmer(isUseful ~ isCCOMeasure + x + (1 | idProv), data = D, family = binomial)
summary(M1)
```

```
## Generalized linear mixed model fit by the Laplace approximation 
## Formula: isUseful ~ isCCOMeasure + x + (1 | idProv) 
##    Data: D 
##   AIC  BIC logLik deviance
##  4283 4307  -2138     4275
## Random effects:
##  Groups Name        Variance Std.Dev.
##  idProv (Intercept) 0.0289   0.17    
## Number of obs: 3100, groups: idProv, 100
## 
## Fixed effects:
##                  Estimate Std. Error z value Pr(>|z|)   
## (Intercept)       0.00204    0.05622    0.04   0.9710   
## isCCOMeasureTRUE  0.19810    0.07243    2.73   0.0062 **
## x                 0.07483    0.03957    1.89   0.0586 . 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##             (Intr) iCCOMT
## isCCOMsTRUE -0.703       
## x            0.046  0.003
```

```r
M2 <- lmer(isUseful ~ isCCOMeasure + x + (1 + isCCOMeasure | idProv), data = D, 
    family = binomial)
summary(M2)
```

```
## Generalized linear mixed model fit by the Laplace approximation 
## Formula: isUseful ~ isCCOMeasure + x + (1 + isCCOMeasure | idProv) 
##    Data: D 
##   AIC  BIC logLik deviance
##  4285 4321  -2136     4273
## Random effects:
##  Groups Name             Variance Std.Dev. Corr  
##  idProv (Intercept)      0.00261  0.0511         
##         isCCOMeasureTRUE 0.05365  0.2316   1.000 
## Number of obs: 3100, groups: idProv, 100
## 
## Fixed effects:
##                  Estimate Std. Error z value Pr(>|z|)   
## (Intercept)       0.00279    0.05381    0.05   0.9587   
## isCCOMeasureTRUE  0.20046    0.07609    2.63   0.0084 **
## x                 0.08537    0.03955    2.16   0.0309 * 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##             (Intr) iCCOMT
## isCCOMsTRUE -0.670       
## x            0.049  0.002
```


Calculate odds ratios and 95% CIs.

```r
calcOR <- function(M) {
    f <- deparse(formula(M))
    or <- exp(fixef(M)["isCCOMeasureTRUE"])
    se <- sqrt(vcov(M)[2, 2])
    ciLower <- exp(fixef(M)["isCCOMeasureTRUE"] + se * qnorm(0.025))
    ciUpper <- exp(fixef(M)["isCCOMeasureTRUE"] + se * qnorm(0.975))
    data.frame(Formula = f, OddsRatio = or, LowerCI = ciLower, UpperCI = ciUpper)
}
orM1 <- calcOR(M1)
orM2 <- calcOR(M2)
results <- rbind(orM1, orM2)
print(xtable(results, digits = 4), type = "html", include.rownames = FALSE)
```

<!-- html table generated in R 3.0.1 by xtable 1.7-1 package -->
<!-- Wed Jul 31 15:04:41 2013 -->
<TABLE border=1>
<TR> <TH> Formula </TH> <TH> OddsRatio </TH> <TH> LowerCI </TH> <TH> UpperCI </TH>  </TR>
  <TR> <TD> isUseful ~ isCCOMeasure + x + (1 | idProv) </TD> <TD align="right"> 1.2191 </TD> <TD align="right"> 1.0577 </TD> <TD align="right"> 1.4050 </TD> </TR>
  <TR> <TD> isUseful ~ isCCOMeasure + x + (1 + isCCOMeasure | idProv) </TD> <TD align="right"> 1.2220 </TD> <TD align="right"> 1.0527 </TD> <TD align="right"> 1.4185 </TD> </TR>
   </TABLE>

These odds ratios do come close to the nominal OR of 1.2.
