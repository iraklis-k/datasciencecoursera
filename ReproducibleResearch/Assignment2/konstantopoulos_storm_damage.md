# Coursera Data Science: Reproducible Reaserch: Assignment 2
Iraklis Konstantopoulos  
26 April 2015  
This document presents an analysis of storm data from the National Oceanic and Atmospheric Administration (NOAA) storm database. The desired outcome is to determine the types of events that cause most measurable harm and appreciable financial damage across the United States. It makes use of public NOAA data. 

Before we begin, we will inport some packages. 

```r
# Read some packages before we begin
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(RCurl)
```

```
## Warning: package 'RCurl' was built under R version 3.1.3
```

```
## Loading required package: bitops
```

## Data Preparation
The original NOAA dataset can be found online and read directly through a combination of `read.csv()` and `bzfile()`. To keep the process simple the following code instead expects to find (a link to) the b-zipped file in the working directory. 


```r
df <- read.csv("StormData.csv.bz2")
```

```
## Warning in read.table(file = file, header = header, sep = sep, quote =
## quote, : line 1 appears to contain embedded nulls
```

```
## Warning in read.table(file = file, header = header, sep = sep, quote =
## quote, : line 2 appears to contain embedded nulls
```

```
## Warning in read.table(file = file, header = header, sep = sep, quote =
## quote, : line 3 appears to contain embedded nulls
```

```
## Warning in read.table(file = file, header = header, sep = sep, quote =
## quote, : line 5 appears to contain embedded nulls
```

```
## Warning in scan(file = file, what = what, sep = sep, quote = quote, dec =
## dec, : embedded nul(s) found in input
```

```r
str(df)
```

```
## 'data.frame':	1629 obs. of  1 variable:
##  $ book: Factor w/ 1583 levels "\024\b\003\001",..: 1093 2 1301 1149 397 26 24 280 610 7 ...
```

A full list of events is held in the `EVTYPE` factor. There are too many to list in a sensible format. Specifically: 


```r
eventType <- unique(df$EVTYPE)
paste("Events are divided into", length(eventType), "categories.")
```

```
## [1] "Events are divided into 0 categories."
```

This listing was saved to a variable as it will come in handy later. 

There are two tracers of damage, property damage (`PROPDMG`) and crop damage (`CROPDMG`). In order to assess damage the two tracers are combined into a new column, `TotalDamage`: 


```r
# knitr chokes on dplyr, so go with base operations
#df <- mutate(df, TotalDamage = PROPDMG + CROPDMG)
#df <- cbind(df, TotalDamage = df$PROPDMG + df$CROPDMG)
#str(df$TotalDamage)
```

## Data Analysis
Having prepared our dataset by adding a column for economic damage, we are ready to assess the human and material impact of the storms in the database. 

### Impact on Health
First we treat the human element. There are two relevant tracers, injuries (`INJURIES`) and fatalities (`FATALITIES`) but we did not combine these are they are appreciably distinct events. In order to classify the types of events we will produce an index counting the mean number of injuries and fatalities by event type. We will then bind these results into a new data frame entitled `damage`. 


```r
meanInjuries <- numeric(length(eventType))
meanFatalities <- numeric(length(eventType))

counter <- 0
for(ev in eventType){
    counter = counter + 1
    meanInjuries[counter] <- mean(df$INJURIES[which(df$EVTYPE == ev)])
    meanFatalities[counter] <- mean(df$FATALITIES[which(df$EVTYPE == ev)])
}

damage <- data.frame(cbind(eventType, meanInjuries, 
                    meanFatalities), stringsAsFactors = FALSE)
```

### Impact on Property and Crops
The financial impact is codified in the way described in the appendix of the [code book](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf). In brief, the code book lists a number of events and their quantised moetary worth. For example, a broken windshield incurs an approximate cost in the range of $250-$1000, and hence an entry of 0.25 according to the base value of thousands of US dollars. 

In order to ascertain the most catastrophic type of events in terms of financial impact we will filter the data frame by each type of event and produce a listing of average damage by event type using the newly created `TotalDamage` variable. 


```r
meanDamage <- numeric(length(eventType))
counter <- 0
for(ev in eventType){
    counter = counter + 1
    meanDamage[counter] <- mean(df$TotalDamage[which(df$EVTYPE == ev)])
}
```

And add the data to the damage dataframe: 


```r
damage <- cbind(damage, meanDamage)
```

## Results
The statitical study presented in this work was aimed at understanding which types of events have the highest impact, in terms of

1. Human injury and loss, and
1. Destruction of property and crops. 

In order to draw conclusions we simply need to order the newly created `damage` dataset by the relevant column. Note that the results list the *average* impact of any type of event. The cumulative toll of *individual* events will classify events differently. 


```r
# By Injury: 
damage <- arrange(damage, desc(meanInjuries))
print("The types of events that produce the most injuries are:")
```

```
## [1] "The types of events that produce the most injuries are:"
```

```r
head(eventType[damage$eventType], n=10)
```

```
## NULL
```

```r
# By Fatality: 
damage <- arrange(damage, desc(meanFatalities))
print("The types of events with the highestdeath toll are:")
```

```
## [1] "The types of events with the highestdeath toll are:"
```

```r
head(eventType[damage$eventType], n=10)
```

```
## NULL
```

```r
# By Total Damage: 
damage <- arrange(damage, desc(meanDamage))
print("The ten most damaging types of events are:")
```

```
## [1] "The ten most damaging types of events are:"
```

```r
head(eventType[damage$eventType], n=10)
```

```
## NULL
```
