Coding Challenge #1: OLS
========================================================

The bulk of this code is from [Stpehanie Renfro's](mailtto:renfro@ohsu.edu) file `Challenge1R.R`.

Details
-------
> From: John McConnell  
> Sent: Tuesday, December 03, 2013 9:18 AM  
> To: Aaron Mendelson; Benjamin Chan; Hyunjee Kim; Jonah Todd-Geddes; Lorie Jacob; Margaret Sarna-Wojcicki; Peter Graven; Ruth Rowland; Stephanie Renfro  
> Subject: Developing programming examples for R, Stata, SAS
> 
> Group
>                                                                                                        
> Following up on our discussion last week, I propose the following exercise. I have tried to keep this very simple. We can get more involved if we think that would help. This is a baby step.
> 
> Let's have these people take the lead:
> 
> Stata -- Peter  
> R -- Stephanie  
> SAS -- Ben  
> 
> Let's work off this directory  
> X:\OHSU Shared\Restricted\OCHSER\PROJECTS\Code_Sharing  
> Using the file "Inpatient_Claims_Sample_1." (I have SAS, Stata, and R versions there).
> 
> Please create a word document and a statistical code file (e.g., a Stata "do" file or analog in SAS or R). The word document should describe, briefly
> a.  How you start the program  
> b.	How you locate the file Inpatient_Claims_Sample_1 within your program (or perhaps reference this in the code file).  
> c.	How you run your code  
> d.	How you view your results  
> 
> It is ok if the word file is only 4 sentences! I prefer to err on the side of keeping it simple at this point. We can always go back and add more detail later. This is not a manual.
> 
> The code file should be commented and describe how to do the following  
> a.	Load the dataset  
> b.	Describe the variables that exist in the data set (i.e., print out the names of the variables)  
> c.	Take the mean of CLM_PMT_AMT  
> d.	Run an OLS regression of CM_PMT_AMT  on CLM_UTLZTN_DAY_CNT and CLM_PASS_THRU_PER_DIEM_AMT (coefficient on  CLM_UTLZTN_DAY_CNT  should be about 489 and R-squared should be about 0.11)  
> e.	Save the output (the coefficient estimates, standard errors, p-values) in a text file or other file that can be opened up easily in Word or Notepad or a browser.  
> 
> When you're ready, send your Word doc and Code file to the group
> 
> WHEN?
> 
> By January 3, 2014
> 
> Ben, Peter, Stephanie: let me know by the end of the week if you'd like to change this plan (I.e., if it seems confusing, useless, or you're too busy).
> 
> Also, Ben made the following observations, which I agree with -- but I thought they might add to the complexity and so I thought we could revisit these at some point in the future, and for now just keep it very very simple.
> 
> COMMENTS FROM BEN
> 
> I think it might actually be instructive to see how to get the data from CSV to a native format for analysis (how easy/hard it is, how much can be automated, how much needs to be programmed). That might be a big enough task just to make it the first "project".
> 
> We'll want to put data on the X-drive. Probably a subfolder in the PROJECTS folder called "CodeSharing" or something like that and further organized with the following folders  
> 1.	Data  
> 2.	Task01ImportingData  
> 3.	Task02ComputingUnivariateStats  
> 4.	Task03ModelingOLS  
> 5.	Etc  


A. Load the dataset
-------------------
First set the working directory. The data file is 2 folders up from this Markdown file.

```r
# setwd('X:/OHSU Shared/Restricted/OCHSER/PROJECTS/Code_Sharing')
pathData <- file.path("..", "..")
```

Then read in the .csv file.

```r
f <- file.path(pathData, "DE1_0_2008_to_2010_Inpatient_Claims_Sample_1.csv")
sample <- read.csv(f)
```

Get the number of rows and columns in the data.

```r
dim(sample)
```

```
## [1] 66773    81
```



B. Print the names of the variables in the data
-----------------------------------------------

```r
names(sample)
```

```
##  [1] "DESYNPUF_ID"                    "CLM_ID"                        
##  [3] "SEGMENT"                        "CLM_FROM_DT"                   
##  [5] "CLM_THRU_DT"                    "PRVDR_NUM"                     
##  [7] "CLM_PMT_AMT"                    "NCH_PRMRY_PYR_CLM_PD_AMT"      
##  [9] "AT_PHYSN_NPI"                   "OP_PHYSN_NPI"                  
## [11] "OT_PHYSN_NPI"                   "CLM_ADMSN_DT"                  
## [13] "ADMTNG_ICD9_DGNS_CD"            "CLM_PASS_THRU_PER_DIEM_AMT"    
## [15] "NCH_BENE_IP_DDCTBL_AMT"         "NCH_BENE_PTA_COINSRNC_LBLTY_AM"
## [17] "NCH_BENE_BLOOD_DDCTBL_LBLTY_AM" "CLM_UTLZTN_DAY_CNT"            
## [19] "NCH_BENE_DSCHRG_DT"             "CLM_DRG_CD"                    
## [21] "ICD9_DGNS_CD_1"                 "ICD9_DGNS_CD_2"                
## [23] "ICD9_DGNS_CD_3"                 "ICD9_DGNS_CD_4"                
## [25] "ICD9_DGNS_CD_5"                 "ICD9_DGNS_CD_6"                
## [27] "ICD9_DGNS_CD_7"                 "ICD9_DGNS_CD_8"                
## [29] "ICD9_DGNS_CD_9"                 "ICD9_DGNS_CD_10"               
## [31] "ICD9_PRCDR_CD_1"                "ICD9_PRCDR_CD_2"               
## [33] "ICD9_PRCDR_CD_3"                "ICD9_PRCDR_CD_4"               
## [35] "ICD9_PRCDR_CD_5"                "ICD9_PRCDR_CD_6"               
## [37] "HCPCS_CD_1"                     "HCPCS_CD_2"                    
## [39] "HCPCS_CD_3"                     "HCPCS_CD_4"                    
## [41] "HCPCS_CD_5"                     "HCPCS_CD_6"                    
## [43] "HCPCS_CD_7"                     "HCPCS_CD_8"                    
## [45] "HCPCS_CD_9"                     "HCPCS_CD_10"                   
## [47] "HCPCS_CD_11"                    "HCPCS_CD_12"                   
## [49] "HCPCS_CD_13"                    "HCPCS_CD_14"                   
## [51] "HCPCS_CD_15"                    "HCPCS_CD_16"                   
## [53] "HCPCS_CD_17"                    "HCPCS_CD_18"                   
## [55] "HCPCS_CD_19"                    "HCPCS_CD_20"                   
## [57] "HCPCS_CD_21"                    "HCPCS_CD_22"                   
## [59] "HCPCS_CD_23"                    "HCPCS_CD_24"                   
## [61] "HCPCS_CD_25"                    "HCPCS_CD_26"                   
## [63] "HCPCS_CD_27"                    "HCPCS_CD_28"                   
## [65] "HCPCS_CD_29"                    "HCPCS_CD_30"                   
## [67] "HCPCS_CD_31"                    "HCPCS_CD_32"                   
## [69] "HCPCS_CD_33"                    "HCPCS_CD_34"                   
## [71] "HCPCS_CD_35"                    "HCPCS_CD_36"                   
## [73] "HCPCS_CD_37"                    "HCPCS_CD_38"                   
## [75] "HCPCS_CD_39"                    "HCPCS_CD_40"                   
## [77] "HCPCS_CD_41"                    "HCPCS_CD_42"                   
## [79] "HCPCS_CD_43"                    "HCPCS_CD_44"                   
## [81] "HCPCS_CD_45"
```

Also display the first few rows

```r
head(sample)
```

```
##        DESYNPUF_ID    CLM_ID SEGMENT CLM_FROM_DT CLM_THRU_DT PRVDR_NUM
## 1 00013D2EFD8E45D1 1.967e+14       1    20100312    20100313    2600GD
## 2 00016F745862898F 1.962e+14       1    20090412    20090418    3900MB
## 3 00016F745862898F 1.967e+14       1    20090831    20090902    3900HM
## 4 00016F745862898F 1.961e+14       1    20090917    20090920    3913XU
## 5 00016F745862898F 1.963e+14       1    20100626    20100701    3900MB
## 6 00052705243EA128 1.970e+14       1    20080912    20080912    1401HG
##   CLM_PMT_AMT NCH_PRMRY_PYR_CLM_PD_AMT AT_PHYSN_NPI OP_PHYSN_NPI
## 1        4000                        0    3.139e+09           NA
## 2       26000                        0    6.477e+09           NA
## 3        5000                        0    6.120e+08    6.120e+08
## 4        5000                        0    4.972e+09           NA
## 5       16000                        0    6.408e+09    1.961e+09
## 6       14000                        0    6.132e+09           NA
##   OT_PHYSN_NPI CLM_ADMSN_DT ADMTNG_ICD9_DGNS_CD CLM_PASS_THRU_PER_DIEM_AMT
## 1           NA     20100312                4580                          0
## 2           NA     20090412                7866                          0
## 3           NA     20090831                6186                          0
## 4    1.119e+09     20090917               29590                          0
## 5           NA     20100626                5849                          0
## 6           NA     20080912               78079                          0
##   NCH_BENE_IP_DDCTBL_AMT NCH_BENE_PTA_COINSRNC_LBLTY_AM
## 1                   1100                              0
## 2                   1068                              0
## 3                   1068                              0
## 4                   1068                              0
## 5                   1100                              0
## 6                   1024                              0
##   NCH_BENE_BLOOD_DDCTBL_LBLTY_AM CLM_UTLZTN_DAY_CNT NCH_BENE_DSCHRG_DT
## 1                              0                  1           20100313
## 2                              0                  6           20090418
## 3                              0                  2           20090902
## 4                              0                  3           20090920
## 5                              0                  5           20100701
## 6                              0                  1           20080912
##   CLM_DRG_CD ICD9_DGNS_CD_1 ICD9_DGNS_CD_2 ICD9_DGNS_CD_3 ICD9_DGNS_CD_4
## 1        217           7802          78820          V4501           4280
## 2        201           1970           4019           5853           7843
## 3        750           6186           2948          56400               
## 4        883          29623          30390          71690          34590
## 5        983           3569           4019           3542          V8801
## 6        201            486           3004          42731          42830
##   ICD9_DGNS_CD_5 ICD9_DGNS_CD_6 ICD9_DGNS_CD_7 ICD9_DGNS_CD_8
## 1           2720           4019          V4502          73300
## 2           2768          71590           2724          19889
## 3                                                            
## 4          V1581          32723                              
## 5          78820           2639           7840           7856
## 6           2724          V4581           4019               
##   ICD9_DGNS_CD_9 ICD9_DGNS_CD_10 ICD9_PRCDR_CD_1 ICD9_PRCDR_CD_2
## 1          E9330                              NA                
## 2           5849                              NA                
## 3                                           7092            6186
## 4                                             NA                
## 5           4271                              NA           E8889
## 6                                             NA                
##   ICD9_PRCDR_CD_3 ICD9_PRCDR_CD_4 ICD9_PRCDR_CD_5 ICD9_PRCDR_CD_6
## 1                                                                
## 2                                                                
## 3           V5866                                                
## 4                                                                
## 5                                                                
## 6                                                                
##   HCPCS_CD_1 HCPCS_CD_2 HCPCS_CD_3 HCPCS_CD_4 HCPCS_CD_5 HCPCS_CD_6
## 1         NA         NA         NA         NA         NA         NA
## 2         NA         NA         NA         NA         NA         NA
## 3         NA         NA         NA         NA         NA         NA
## 4         NA         NA         NA         NA         NA         NA
## 5         NA         NA         NA         NA         NA         NA
## 6         NA         NA         NA         NA         NA         NA
##   HCPCS_CD_7 HCPCS_CD_8 HCPCS_CD_9 HCPCS_CD_10 HCPCS_CD_11 HCPCS_CD_12
## 1         NA         NA         NA          NA          NA          NA
## 2         NA         NA         NA          NA          NA          NA
## 3         NA         NA         NA          NA          NA          NA
## 4         NA         NA         NA          NA          NA          NA
## 5         NA         NA         NA          NA          NA          NA
## 6         NA         NA         NA          NA          NA          NA
##   HCPCS_CD_13 HCPCS_CD_14 HCPCS_CD_15 HCPCS_CD_16 HCPCS_CD_17 HCPCS_CD_18
## 1          NA          NA          NA          NA          NA          NA
## 2          NA          NA          NA          NA          NA          NA
## 3          NA          NA          NA          NA          NA          NA
## 4          NA          NA          NA          NA          NA          NA
## 5          NA          NA          NA          NA          NA          NA
## 6          NA          NA          NA          NA          NA          NA
##   HCPCS_CD_19 HCPCS_CD_20 HCPCS_CD_21 HCPCS_CD_22 HCPCS_CD_23 HCPCS_CD_24
## 1          NA          NA          NA          NA          NA          NA
## 2          NA          NA          NA          NA          NA          NA
## 3          NA          NA          NA          NA          NA          NA
## 4          NA          NA          NA          NA          NA          NA
## 5          NA          NA          NA          NA          NA          NA
## 6          NA          NA          NA          NA          NA          NA
##   HCPCS_CD_25 HCPCS_CD_26 HCPCS_CD_27 HCPCS_CD_28 HCPCS_CD_29 HCPCS_CD_30
## 1          NA          NA          NA          NA          NA          NA
## 2          NA          NA          NA          NA          NA          NA
## 3          NA          NA          NA          NA          NA          NA
## 4          NA          NA          NA          NA          NA          NA
## 5          NA          NA          NA          NA          NA          NA
## 6          NA          NA          NA          NA          NA          NA
##   HCPCS_CD_31 HCPCS_CD_32 HCPCS_CD_33 HCPCS_CD_34 HCPCS_CD_35 HCPCS_CD_36
## 1          NA          NA          NA          NA          NA          NA
## 2          NA          NA          NA          NA          NA          NA
## 3          NA          NA          NA          NA          NA          NA
## 4          NA          NA          NA          NA          NA          NA
## 5          NA          NA          NA          NA          NA          NA
## 6          NA          NA          NA          NA          NA          NA
##   HCPCS_CD_37 HCPCS_CD_38 HCPCS_CD_39 HCPCS_CD_40 HCPCS_CD_41 HCPCS_CD_42
## 1          NA          NA          NA          NA          NA          NA
## 2          NA          NA          NA          NA          NA          NA
## 3          NA          NA          NA          NA          NA          NA
## 4          NA          NA          NA          NA          NA          NA
## 5          NA          NA          NA          NA          NA          NA
## 6          NA          NA          NA          NA          NA          NA
##   HCPCS_CD_43 HCPCS_CD_44 HCPCS_CD_45
## 1          NA          NA          NA
## 2          NA          NA          NA
## 3          NA          NA          NA
## 4          NA          NA          NA
## 5          NA          NA          NA
## 6          NA          NA          NA
```



C. Take the mean of `CLM_PMT_AMT`
---------------------------------
There are several ways to do this in R...
* Reference the desired data frame column by where it appears in the data. We know `CLM_PMT_AMT` is the 7th column based on the `names` output above.

```r
mean(sample[[7]])
```

```
## [1] 9574
```

* Reference the desired data frame column by name. Note R variable names are **case-sensitive** (as are functions/commands/etc).

```r
mean(sample[["CLM_PMT_AMT"]])
```

```
## [1] 9574
```

* Similar to 2. but uses the single square bracket operator. The empty space before the comma signifies a wildcard match for the row position; i.e., return **all** the rows in `sample` but only the `CLM_PMT_AMT` column, then take the mean.

```r
mean(sample[, "CLM_PMT_AMT"])
```

```
## [1] 9574
```

* Use the dollar sign ($) to retrieve the desired data frame column. Note quotation marks aren't needed with this syntax.

```r
mean(sample$CLM_PMT_AMT)
```

```
## [1] 9574
```



D. Run an OLS regression
------------------------
Model `CLM_PMT_AMT` on `CLM_UTLZTN_DAY_CNT` and `CLM_PASS_THRU_PER_DIEM_AMT`.

Assign the name `results` to the outcome.

```r
results <- lm(CLM_PMT_AMT ~ CLM_UTLZTN_DAY_CNT + CLM_PASS_THRU_PER_DIEM_AMT, 
    data = sample)
```

Print a summary of the results.

```r
summary(results)
```

```
## 
## Call:
## lm(formula = CLM_PMT_AMT ~ CLM_UTLZTN_DAY_CNT + CLM_PASS_THRU_PER_DIEM_AMT, 
##     data = sample)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -73096  -4585  -2096   1949  50393 
## 
## Coefficients:
##                            Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                6606.944     47.278   139.8   <2e-16 ***
## CLM_UTLZTN_DAY_CNT          488.890      5.397    90.6   <2e-16 ***
## CLM_PASS_THRU_PER_DIEM_AMT    7.865      0.449    17.5   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 8760 on 66702 degrees of freedom
##   (68 observations deleted due to missingness)
## Multiple R-squared:  0.113,	Adjusted R-squared:  0.113 
## F-statistic: 4.24e+03 on 2 and 66702 DF,  p-value: <2e-16
```



E. Save the output
------------------
Save the output (coefficient estimates, standard errors, and p-values) in a text file.

Convert the output to a text string with the assigned name `out`.

```r
out <- capture.output(summary(results))
```

Write the output to a text file called `Output_R.txt`. Note, `write.csv` is similar to the `read.csv` function used earlier.

```r
write.csv(out, file = "Output_R.txt")
```

