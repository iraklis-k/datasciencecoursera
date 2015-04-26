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

## Data Preparation
The original NOAA dataset can be found online and read directly through a combination of `read.csv()` and `bzfile()`. To keep the process simple the following code instead expects to find (a link to) the b-zipped file in the working directory. 


```r
df <- read.csv("StormData.csv.bz2")
str(df)
```

```
## 'data.frame':	902297 obs. of  37 variables:
##  $ STATE__   : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_DATE  : Factor w/ 16335 levels "1/1/1966 0:00:00",..: 6523 6523 4242 11116 2224 2224 2260 383 3980 3980 ...
##  $ BGN_TIME  : Factor w/ 3608 levels "00:00:00 AM",..: 272 287 2705 1683 2584 3186 242 1683 3186 3186 ...
##  $ TIME_ZONE : Factor w/ 22 levels "ADT","AKS","AST",..: 7 7 7 7 7 7 7 7 7 7 ...
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME: Factor w/ 29601 levels "","5NM E OF MACKINAC BRIDGE TO PRESQUE ISLE LT MI",..: 13513 1873 4598 10592 4372 10094 1973 23873 24418 4598 ...
##  $ STATE     : Factor w/ 72 levels "AK","AL","AM",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ EVTYPE    : Factor w/ 985 levels "   HIGH SURF ADVISORY",..: 834 834 834 834 834 834 834 834 834 834 ...
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ BGN_AZI   : Factor w/ 35 levels "","  N"," NW",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_LOCATI: Factor w/ 54429 levels ""," Christiansburg",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_DATE  : Factor w/ 6663 levels "","1/1/1993 0:00:00",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_TIME  : Factor w/ 3647 levels ""," 0900CST",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ COUNTY_END: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ COUNTYENDN: logi  NA NA NA NA NA NA ...
##  $ END_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ END_AZI   : Factor w/ 24 levels "","E","ENE","ESE",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_LOCATI: Factor w/ 34506 levels ""," CANTON"," TULIA",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ LENGTH    : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3 ...
##  $ WIDTH     : num  100 150 123 100 150 177 33 33 100 100 ...
##  $ F         : int  3 2 2 2 2 2 2 1 3 3 ...
##  $ MAG       : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ FATALITIES: num  0 0 0 0 0 0 0 0 1 0 ...
##  $ INJURIES  : num  15 0 2 2 2 6 1 0 14 0 ...
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
##  $ PROPDMGEXP: Factor w/ 19 levels "","-","?","+",..: 17 17 17 17 17 17 17 17 17 17 ...
##  $ CROPDMG   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ CROPDMGEXP: Factor w/ 9 levels "","?","0","2",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ WFO       : Factor w/ 542 levels ""," CI","%SD",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ STATEOFFIC: Factor w/ 250 levels "","ALABAMA, Central",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ ZONENAMES : Factor w/ 25112 levels "","                                                                                                                               "| __truncated__,..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ LATITUDE  : num  3040 3042 3340 3458 3412 ...
##  $ LONGITUDE : num  8812 8755 8742 8626 8642 ...
##  $ LATITUDE_E: num  3051 0 0 0 0 ...
##  $ LONGITUDE_: num  8806 0 0 0 0 ...
##  $ REMARKS   : Factor w/ 436781 levels "","\t","\t\t",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ REFNUM    : num  1 2 3 4 5 6 7 8 9 10 ...
```

A full list of events is held in the `EVTYPE` factor. There are too many to list in a sensible format. Specifically: 


```r
eventType <- unique(df$EVTYPE)
paste("Events are divided into", length(eventType), "categories.")
```

```
## [1] "Events are divided into 985 categories."
```

This listing was saved to a variable as it will come in handy later. 

There are two tracers of damage, property damage (`PROPDMG`) and crop damage (`CROPDMG`). In order to assess damage the two tracers are combined into a new column, `TotalDamage`: 


```r
df <- mutate(df, TotalDamage = PROPDMG + CROPDMG)
str(df$TotalDamage)
```

```
##  num [1:902297] 25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
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
##  [1] THUNDERSTORM WINDS 2  TSTM WIND (G45)     HEAVY RAIN EFFECTS  
##  [4] Gusty winds          AVALANCE             TIDAL FLOODING      
##  [7] HURRICANE/TYPHOON    SMALL HAIL           ICE/SNOW            
## [10] LIGHT SNOW          
## 985 Levels:    HIGH SURF ADVISORY  COASTAL FLOOD ... WND
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
##  [1]  LIGHTNING                    LOW TEMPERATURE RECORD       
##  [3]  TSTM WIND (G45)              HEAVY SHOWERS                
##  [5] ICE                           ICE/SNOW                     
##  [7] THUNDERSTORM WINDS.           HEAVY SNOW/BLIZZARD/AVALANCHE
##  [9] STORM SURGE/TIDE              AVALANCE                     
## 985 Levels:    HIGH SURF ADVISORY  COASTAL FLOOD ... WND
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
##  [1]  TSTM WIND (G45)               RIVER FLOOD                   
##  [3] URBAN FLOOD LANDSLIDE          SNOW AND ICE                  
##  [5] HURRICANE GORDON               HIGH WINDS DUST STORM         
##  [7] THUNDERSTORM WINDS/FLASH FLOOD EXTREME/RECORD COLD           
##  [9] THUNDERSTORM WINDS.            FIRST SNOW                    
## 985 Levels:    HIGH SURF ADVISORY  COASTAL FLOOD ... WND
```

### Distribution by Region
One area of interest is the differing economic impact of inclement weather across the United States. The following analysis examines the cumulative cost of the storms recorded in this dataset by State. There is no specific focus on states or regions, instead the plot is meant accentuate the range, so no effort has been made to plot all state labels.


```r
counter <- 0
allStates <- unique(df$STATE)
damageByState <- numeric(length(allStates))
for(st in allStates){
    counter = counter + 1
    damageByState[counter] <- sum(df$TotalDamage[which(df$STATE==st)])
}
```

This new dataset will now be sorted by impact and then plotted as a bar plot for each state in the dataset. 


```r
byState <- data.frame(state = allStates, damage = damageByState)
byState <- arrange(byState, desc(damage))
barplot(byState$damage, horiz=TRUE, ylab='', xlab='Cumulative Storm Damage by State in Thousands of Dollars')
```

![](konstantopoulos_storm_damage_files/figure-html/unnamed-chunk-10-1.png) 
