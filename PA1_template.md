# Reproducible Research: Peer Assessment 1
Jorge Ramírez  
Oct, 2015  


## Loading and preprocessing the data
* Load the data (i.e. read.csv())
* Process/transform the data (if necessary) into a format suitable for your analysis


```r
activityData <- read.csv("activity.csv")
activityData$date<-as.Date(activityData$date, "%Y-%m-%d")
activityDataNotNulls <- activityData[!is.na(activityData$steps),]
```

## What is mean total number of steps taken per day?

For this part of the assignment, you can ignore the missing values in the dataset.

* Calculate the total number of steps taken per day

* If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day


* Calculate and report the mean and median of the total number of steps taken per day


```r
stepsPerDay <- aggregate (. ~ date, data=activityDataNotNulls, FUN=sum)
summary(stepsPerDay$steps)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##      41    8841   10760   10770   13290   21190
```

```r
hist(stepsPerDay$steps)
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 


## What is the average daily activity pattern?
* Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

* Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?



```r
stepsPerInterval <- aggregate (. ~ interval, data=activityData, FUN=sum)
plot(stepsPerInterval$interval,stepsPerInterval$steps, type = "l")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 

```r
maxInterval <- stepsPerInterval[which.max(stepsPerInterval$steps),1]
maxInterval
```

```
## [1] 835
```

## Imputing missing values

Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

* Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)


```r
activityDataNulls <- activityData[is.na(activityData$steps),]
nrow(activityDataNulls)
```

```
## [1] 2304
```

* Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.


```r
activityDataNotNulls <- activityData[!is.na(activityData$steps),]
activityDataNulls <- activityData[is.na(activityData$steps),]
meanStepPerInterval <-aggregate (. ~ interval, data=activityDataNotNulls, FUN=mean)
activityDataNullsNoMore <- activityDataNulls
activityDataNullsNoMore$steps <-meanStepPerInterval$steps
```

* Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
activityDataNew <-rbind(activityDataNullsNoMore,activityDataNotNulls)
nrow(activityData)
```

```
## [1] 17568
```

```r
nrow(activityDataNew)
```

```
## [1] 17568
```

* Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?


```r
stepsPerInterval <- aggregate (. ~ interval, data=activityDataNew, FUN=sum)
plot(stepsPerInterval$interval,stepsPerInterval$steps, type = "l")
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png) 

```r
maxInterval <- stepsPerInterval[which.max(stepsPerInterval$steps),1]
maxInterval
```

```
## [1] 835
```

```r
summary(stepsPerInterval$steps)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##     0.0   151.6  2081.0  2280.0  3223.0 12580.0
```
#### There are more steps filling missing data

## Are there differences in activity patterns between weekdays and weekends?

For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

* Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.
isWeekday (activityDataNew$date)


```r
weekdays <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")

activityDataNew$WeekDayIndicator =  as.factor(ifelse(is.element(weekdays(as.Date(activityDataNew$date)),weekdays), "Weekday", "Weekend"))

stepsByWeekDay <- aggregate(steps ~ interval + WeekDayIndicator, activityDataNew, FUN=mean)

head(stepsByWeekDay)
```

```
##   interval WeekDayIndicator      steps
## 1        0          Weekday 2.25115304
## 2        5          Weekday 0.44528302
## 3       10          Weekday 0.17316562
## 4       15          Weekday 0.19790356
## 5       20          Weekday 0.09895178
## 6       25          Weekday 1.59035639
```

* Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.


```r
library(lattice)

xyplot(stepsByWeekDay$steps ~ stepsByWeekDay$interval|stepsByWeekDay$WeekDayIndicator, type="l")
```

![](PA1_template_files/figure-html/unnamed-chunk-9-1.png) 
