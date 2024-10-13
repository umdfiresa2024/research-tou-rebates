# Research Question


Step 1. Install necessary packages.

``` r
#install.packages("tidyverse")
#install.packages("kableExtra")
```

Step 2. Declare that you will use these packages in this session.

``` r
library("tidyverse")
```

    ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
    ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
    ✔ purrr     1.0.2     
    ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()
    ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
library("kableExtra")
```


    Attaching package: 'kableExtra'

    The following object is masked from 'package:dplyr':

        group_rows

Step 3. Upload the dataframe that you have created in Spring 2024 into
the repository.

Step 4. Open the dataframe into the RStudio Environment.

``` r
df<-read.csv("panel.csv")
```

Step 5. Use the **head** and **kable** function showcase the first 10
rows of the dataframe to the reader.

``` r
kable(head(df))
```

| period | subba | subba.name | value | hour | month | year | date |
|:---|:---|:---|---:|---:|---:|---:|:---|
| 2019-01-01T23 | AE | Atlantic Electric zone - PJM | 1222 | 3 | 1 | 2019 | 2019-01-01 |
| 2019-01-01T23 | AEP | American Electric Power zone - PJM | 14246 | 3 | 1 | 2019 | 2019-01-01 |
| 2019-01-01T23 | AP | Allegheny Power zone - PJM | 6071 | 3 | 1 | 2019 | 2019-01-01 |
| 2019-01-01T23 | ATSI | American Transmission Systems, Inc. zone - PJM | 7541 | 3 | 1 | 2019 | 2019-01-01 |
| 2019-01-01T23 | BC | Baltimore Gas null zone - PJM | 3644 | 3 | 1 | 2019 | 2019-01-01 |
| 2019-01-01T23 | CE | Commonwealth Edison zone - PJM | 10832 | 3 | 1 | 2019 | 2019-01-01 |

## Question 1: What is the frequency of this data frame?

Answer:hourly

## Question 2: What is the cross-sectional (geographical) unit of this data frame?

Answer:Electric company

Step 6. Use the **names** function to display all the variables (column)
in the dataframe.

``` r
names(df) 
```

    [1] "period"     "subba"      "subba.name" "value"      "hour"      
    [6] "month"      "year"       "date"      

``` r
intsub<-c("Baltimore Gas null zone - PJM", 
          "Delmarva Power null zone - PJM", 
          "Potomac Electric Power zone - PJM")

df2<-df %>%
   mutate(date=as.Date(date), dow=weekdays(date)) %>%
  mutate(BGE_rebate=ifelse(subba.name=="Baltimore Gas null zone - PJM" & year>=2021 & (month>=6 & month<=9) & (hour>=10 & hour<=20),
                            1, 0)) %>%
    mutate(BGE_rebate=ifelse(subba.name=="Baltimore Gas null zone - PJM" & year>=2021 & (month>=10) & (hour>=7 & hour<=11),1, BGE_rebate)) %>%
      mutate(BGE_rebate=ifelse(subba.name=="Baltimore Gas null zone - PJM" & year>=2021 & (month<=5) & (hour>=7 & hour<=11),1, BGE_rebate)) %>%
      mutate(BGE_rebate=ifelse(subba.name=="Baltimore Gas null zone - PJM" & year>=2021 & (month>=10) & (hour>=17 & hour<=21),1, BGE_rebate)) %>%
    mutate(BGE_rebate=ifelse(subba.name=="Baltimore Gas null zone - PJM" &year>=2021 & (month<=5) & (hour>=17 & hour<=21),1, BGE_rebate)) %>%
   mutate(Delmarva_rebate=ifelse(subba.name=="Delmarva Power null zone - PJM" &date>as.Date("2019-11-01") & (hour>=12 & hour<=20) & (dow == "Monday" | dow == "Tuesday" | dow == "Wednesday" |dow == "Thursday" | dow=="Friday"),1, 0)) %>%
   mutate(Potomac_rebate=ifelse(subba.name=="Potomac Electric Power zone - PJM" & year>=2020  & (hour>=7 & hour<=20),1, 0)) %>%
  mutate(subba.name=ifelse(subba.name %in% intsub, subba.name, "Other")) %>%
  group_by(subba.name, hour, month, year, date, dow, BGE_rebate, Delmarva_rebate, Potomac_rebate) %>%
summarise(value=sum(value, rm.na=TRUE))
```

    `summarise()` has grouped output by 'subba.name', 'hour', 'month', 'year',
    'date', 'dow', 'BGE_rebate', 'Delmarva_rebate'. You can override using the
    `.groups` argument.

``` r
#write.csv(df2, "panel.csv", row.names = F)  
```

## Question 3: Which column represents the treatment variable of interest?

Answer: BGE_rebate, Delmarva_rebate, Potomac_rebate

## Question 4: Which column represents the outcome variable of interest?

Answer: value (which represents energy consumption in Mw)

Step 7: Create a boxplot to visualize the distribution of the outcome
variable under treatment and no treatment.

``` r
ggplot(df, aes(x=nox_emit)) +
  geom_histogram() +
  facet_wrap(~nbp)
```

Step 8: Fit a regression model $y=\beta_0 + \beta_1 x + \epsilon$ where
$y$ is the outcome variable and $x$ is the treatment variable. Use the
**summary** function to display the results.

``` r
model1<-lm(value ~ BGE_rebate + Delmarva_rebate + Potomac_rebate + as.factor(dow) + 
             as.factor(hour) + as.factor(month) + as.factor(month):as.factor(hour), data=df2)

summary(model1)
```


    Call:
    lm(formula = value ~ BGE_rebate + Delmarva_rebate + Potomac_rebate + 
        as.factor(dow) + as.factor(hour) + as.factor(month) + as.factor(month):as.factor(hour), 
        data = df2)

    Residuals:
           Min         1Q     Median         3Q        Max 
      -3402808     -17898      -2741      43874 1523443928 

    Coefficients: (1 not defined because of singularities)
                                          Estimate Std. Error t value Pr(>|t|)    
    (Intercept)                           30704.76  352207.13   0.087  0.93053    
    BGE_rebate                           -49749.91  217080.84  -0.229  0.81873    
    Delmarva_rebate                             NA         NA      NA       NA    
    Potomac_rebate                       -49808.52  150182.55  -0.332  0.74015    
    as.factor(dow)Monday                   1877.54  118524.60   0.016  0.98736    
    as.factor(dow)Saturday                -5756.43  118592.37  -0.049  0.96129    
    as.factor(dow)Sunday                  -5184.93  118780.77  -0.044  0.96518    
    as.factor(dow)Thursday                  454.28  118513.10   0.004  0.99694    
    as.factor(dow)Tuesday                311536.88  118529.38   2.628  0.00858 ** 
    as.factor(dow)Wednesday                3473.46  118376.85   0.029  0.97659    
    as.factor(hour)1                        748.97  485943.87   0.002  0.99877    
    as.factor(hour)2                       2354.01  485943.87   0.005  0.99613    
    as.factor(hour)3                       3941.04  485943.87   0.008  0.99353    
    as.factor(hour)4                     -22816.81  485943.87  -0.047  0.96255    
    as.factor(hour)5                     -24039.52  485943.87  -0.049  0.96055    
    as.factor(hour)6                     -25061.21  485943.87  -0.052  0.95887    
    as.factor(hour)7                     -10240.26  487747.17  -0.021  0.98325    
    as.factor(hour)8                     -10714.54  487747.17  -0.022  0.98247    
    as.factor(hour)9                     -10940.17  487747.17  -0.022  0.98211    
    as.factor(month)2                     -3274.00  497630.28  -0.007  0.99475    
    as.factor(month)3                    -16005.83  485947.64  -0.033  0.97372    
    as.factor(month)4                    -16872.12  489978.49  -0.034  0.97253    
    as.factor(month)5                    -12193.75  485945.76  -0.025  0.97998    
    as.factor(month)6                     -4585.33  489979.45  -0.009  0.99253    
    as.factor(month)7                     10384.92  485944.81   0.021  0.98295    
    as.factor(month)8                      4098.43  485947.63   0.008  0.99327    
    as.factor(month)9                     -4251.39  493161.78  -0.009  0.99312    
    as.factor(month)10                   -13157.69  485944.81  -0.027  0.97840    
    as.factor(month)11                   -14931.05  489980.42  -0.030  0.97569    
    as.factor(month)12                    -6602.20  485945.76  -0.014  0.98916    
    as.factor(hour)1:as.factor(month)2      167.57  703754.29   0.000  0.99981    
    as.factor(hour)2:as.factor(month)2       88.03  703754.29   0.000  0.99990    
    as.factor(hour)3:as.factor(month)2     -338.82  703754.29   0.000  0.99962    
    as.factor(hour)4:as.factor(month)2      980.61  703754.29   0.001  0.99889    
    as.factor(hour)5:as.factor(month)2      938.51  703754.29   0.001  0.99894    
    as.factor(hour)6:as.factor(month)2      898.11  703754.29   0.001  0.99898    
    as.factor(hour)7:as.factor(month)2      842.44  703754.34   0.001  0.99904    
    as.factor(hour)8:as.factor(month)2      811.63  703754.34   0.001  0.99908    
    as.factor(hour)9:as.factor(month)2      776.96  703754.34   0.001  0.99912    
    as.factor(hour)1:as.factor(month)3      895.81  687228.41   0.001  0.99896    
    as.factor(hour)2:as.factor(month)3      307.01  687228.41   0.000  0.99964    
    as.factor(hour)3:as.factor(month)3    -1317.67  687228.41  -0.002  0.99847    
    as.factor(hour)4:as.factor(month)3     3198.40  687228.41   0.005  0.99629    
    as.factor(hour)5:as.factor(month)3     3651.72  687228.41   0.005  0.99576    
    as.factor(hour)6:as.factor(month)3     3290.09  688636.40   0.005  0.99619    
    as.factor(hour)7:as.factor(month)3     3436.43  688636.42   0.005  0.99602    
    as.factor(hour)8:as.factor(month)3     3608.38  688636.42   0.005  0.99582    
    as.factor(hour)9:as.factor(month)3     3806.20  688636.42   0.006  0.99559    
    as.factor(hour)1:as.factor(month)4      998.52  692931.65   0.001  0.99885    
    as.factor(hour)2:as.factor(month)4      -23.99  692931.65   0.000  0.99997    
    as.factor(hour)3:as.factor(month)4    -2148.93  692931.65  -0.003  0.99753    
    as.factor(hour)4:as.factor(month)4     3706.31  692931.65   0.005  0.99573    
    as.factor(hour)5:as.factor(month)4     4088.36  692931.65   0.006  0.99529    
    as.factor(hour)6:as.factor(month)4     4545.77  692931.65   0.007  0.99477    
    as.factor(hour)7:as.factor(month)4     4953.42  692931.65   0.007  0.99430    
    as.factor(hour)8:as.factor(month)4     5273.87  692931.65   0.008  0.99393    
    as.factor(hour)9:as.factor(month)4     5622.40  692931.65   0.008  0.99353    
    as.factor(hour)1:as.factor(month)5      303.88  687228.41   0.000  0.99965    
    as.factor(hour)2:as.factor(month)5     -597.31  687228.41  -0.001  0.99931    
    as.factor(hour)3:as.factor(month)5    -2758.50  687228.41  -0.004  0.99680    
    as.factor(hour)4:as.factor(month)5     1071.34  687228.41   0.002  0.99876    
    as.factor(hour)5:as.factor(month)5     1671.92  687228.41   0.002  0.99806    
    as.factor(hour)6:as.factor(month)5     2354.55  687228.41   0.003  0.99727    
    as.factor(hour)7:as.factor(month)5     2993.73  687228.41   0.004  0.99652    
    as.factor(hour)8:as.factor(month)5     3525.70  687228.41   0.005  0.99591    
    as.factor(hour)9:as.factor(month)5     4037.19  687228.41   0.006  0.99531    
    as.factor(hour)1:as.factor(month)6     -513.83  692931.65  -0.001  0.99941    
    as.factor(hour)2:as.factor(month)6    -1476.92  692931.65  -0.002  0.99830    
    as.factor(hour)3:as.factor(month)6    -3610.05  692931.65  -0.005  0.99584    
    as.factor(hour)4:as.factor(month)6    -5061.05  692931.65  -0.007  0.99417    
    as.factor(hour)5:as.factor(month)6    -4248.35  692931.65  -0.006  0.99511    
    as.factor(hour)6:as.factor(month)6    -3311.94  692931.65  -0.005  0.99619    
    as.factor(hour)7:as.factor(month)6    -8635.29  693462.75  -0.012  0.99006    
    as.factor(hour)8:as.factor(month)6    -7854.93  693462.75  -0.011  0.99096    
    as.factor(hour)9:as.factor(month)6    -7148.25  693462.75  -0.010  0.99178    
    as.factor(hour)1:as.factor(month)7     -983.86  687228.41  -0.001  0.99886    
    as.factor(hour)2:as.factor(month)7    -2369.88  687228.41  -0.003  0.99725    
    as.factor(hour)3:as.factor(month)7    -4640.84  687228.41  -0.007  0.99461    
    as.factor(hour)4:as.factor(month)7   -10047.77  687228.41  -0.015  0.98833    
    as.factor(hour)5:as.factor(month)7    -8966.37  687228.41  -0.013  0.98959    
    as.factor(hour)6:as.factor(month)7    -7785.81  687228.41  -0.011  0.99096    
    as.factor(hour)7:as.factor(month)7   -12933.10  687763.91  -0.019  0.98500    
    as.factor(hour)8:as.factor(month)7   -12075.29  687763.91  -0.018  0.98599    
    as.factor(hour)9:as.factor(month)7   -11378.38  687763.91  -0.017  0.98680    
    as.factor(hour)1:as.factor(month)8     -438.81  687228.41  -0.001  0.99949    
    as.factor(hour)2:as.factor(month)8    -2231.89  687228.41  -0.003  0.99741    
    as.factor(hour)3:as.factor(month)8    -4894.40  687228.41  -0.007  0.99432    
    as.factor(hour)4:as.factor(month)8    -8797.79  687228.41  -0.013  0.98979    
    as.factor(hour)5:as.factor(month)8    -7746.64  687926.75  -0.011  0.99102    
    as.factor(hour)6:as.factor(month)8    -6538.56  687926.75  -0.010  0.99242    
    as.factor(hour)7:as.factor(month)8   -11641.91  688462.13  -0.017  0.98651    
    as.factor(hour)8:as.factor(month)8   -10654.63  688462.13  -0.015  0.98765    
    as.factor(hour)9:as.factor(month)8    -9824.17  688462.13  -0.014  0.98861    
    as.factor(hour)1:as.factor(month)9      542.61  697431.72   0.001  0.99938    
    as.factor(hour)2:as.factor(month)9    -1630.94  697431.72  -0.002  0.99813    
    as.factor(hour)3:as.factor(month)9    -4472.42  697431.72  -0.006  0.99488    
    as.factor(hour)4:as.factor(month)9    -3896.94  697431.72  -0.006  0.99554    
    as.factor(hour)5:as.factor(month)9    -3118.40  697431.72  -0.004  0.99643    
    as.factor(hour)6:as.factor(month)9    -2188.30  697431.72  -0.003  0.99750    
    as.factor(hour)7:as.factor(month)9    -7556.94  697960.83  -0.011  0.99136    
    as.factor(hour)8:as.factor(month)9    -6691.40  697960.83  -0.010  0.99235    
    as.factor(hour)9:as.factor(month)9    -5884.84  697960.83  -0.008  0.99327    
    as.factor(hour)1:as.factor(month)10     327.83  687228.41   0.000  0.99962    
    as.factor(hour)2:as.factor(month)10    -828.01  687228.41  -0.001  0.99904    
    as.factor(hour)3:as.factor(month)10 3075065.89  687228.41   4.475 7.67e-06 ***
    as.factor(hour)4:as.factor(month)10 2095404.79  687228.41   3.049  0.00230 ** 
    as.factor(hour)5:as.factor(month)10    2090.86  687228.41   0.003  0.99757    
    as.factor(hour)6:as.factor(month)10    2763.82  687228.41   0.004  0.99679    
    as.factor(hour)7:as.factor(month)10    3266.91  687228.41   0.005  0.99621    
    as.factor(hour)8:as.factor(month)10    3698.19  687228.41   0.005  0.99571    
    as.factor(hour)9:as.factor(month)10    4138.23  687228.41   0.006  0.99520    
    as.factor(hour)1:as.factor(month)11      49.39  692931.65   0.000  0.99994    
    as.factor(hour)2:as.factor(month)11     -89.47  692931.65   0.000  0.99990    
    as.factor(hour)3:as.factor(month)11    -542.18  692931.65  -0.001  0.99938    
    as.factor(hour)4:as.factor(month)11    2985.09  692931.65   0.004  0.99656    
    as.factor(hour)5:as.factor(month)11    2771.27  694422.71   0.004  0.99682    
    as.factor(hour)6:as.factor(month)11    3080.52  694422.71   0.004  0.99646    
    as.factor(hour)7:as.factor(month)11    3276.57  694422.73   0.005  0.99624    
    as.factor(hour)8:as.factor(month)11    3412.61  694422.73   0.005  0.99608    
    as.factor(hour)9:as.factor(month)11    3544.99  694422.73   0.005  0.99593    
    as.factor(hour)1:as.factor(month)12      30.58  687228.41   0.000  0.99996    
    as.factor(hour)2:as.factor(month)12     213.28  687228.41   0.000  0.99975    
    as.factor(hour)3:as.factor(month)12     220.52  687228.41   0.000  0.99974    
    as.factor(hour)4:as.factor(month)12    1359.08  687228.41   0.002  0.99842    
    as.factor(hour)5:as.factor(month)12    1343.34  687228.41   0.002  0.99844    
    as.factor(hour)6:as.factor(month)12    1255.56  687228.41   0.002  0.99854    
    as.factor(hour)7:as.factor(month)12    1197.25  687228.41   0.002  0.99861    
    as.factor(hour)8:as.factor(month)12    1161.57  687228.41   0.002  0.99865    
    as.factor(hour)9:as.factor(month)12    1167.12  687228.41   0.002  0.99864    
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 7653000 on 58100 degrees of freedom
    Multiple R-squared:  0.00219,   Adjusted R-squared:  8.425e-06 
    F-statistic: 1.004 on 127 and 58100 DF,  p-value: 0.4711

## Question 5: What is the predicted value of the outcome variable when treatment=0?

Answer:

## Question 6: What is predicted value of the outcome variable when treatment=1?

Answer:

## Question 7: What is the equation that describes the linear regression above? Please include an explanation of the variables and subscripts.

Answer:

## Question 8: What fixed effects can be included in the regression? What does each fixed effects control for? Please include a new equation that incorporates the fixed effects.

Answer:

## Question 9: What is the impact of the treatment effect once fixed effects are included?

Answer:

# Questions for Week 5

## Question 10: In a difference-in-differences (DiD) model, what is the treatment GROUP?

Answer:

## Question 11: In a DiD model, what are the control groups?

Answer:

## Question 12: What is the DiD regression equation that will answer your research question?

## Question 13: Run your DiD regressions below. What are the results of the DiD regression?

## Question 14: What are the next steps of your research?

Step 9: Change the document format to gfm

Step 10: Save this document as README.qmd

Step 11: Render the document. README.md file should be created after
this process.

Step 12: Push the document back to GitHub and observe your beautiful
document in your repository!

Step 13: If your team has a complete dataframe that includes both the
treated and outcome variable, you are done with the assignment. If not,
make a research plan in Notion to collect data on the outcome and
treatment variable and combine it into one dataframe.
