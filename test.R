setwd("/Users/jramirez/GitHub/RepData_PeerAssessment1")
activityData <- read.csv("activity.csv")
activityData$date<-as.Date(activityData$date, "%Y-%m-%d")
str(activityData)
head(activityData)
activityData
activityDataNotNulls <- activityData[is.na(activityData$steps),]
stepsPerDay <- aggregate (. ~ date, data=activityDataNotNulls, FUN=sum)
summary(stepsPerDay$steps)
hist(stepsPerDay$steps)

activityDataNotNulls <- activityData[!is.na(activityData$steps),]
activityDataNulls <- activityData[is.na(activityData$steps),]
str(activityDataNulls)
activityDataNotNulls


meanStepPerInterval <-aggregate (. ~ interval, data=activityDataNotNulls, FUN=mean)
meanStepPerInterval$steps
activityDataNullsNoMore <- activityDataNulls
activityDataNullsNoMore$steps <-meanStepPerInterval$steps
head(activityDataNullsNoMore)

activityNotNullData <- c(activityDataNullsNoMore,activityDataNotNulls)
summary(activityNotNullData)
summary(activityData)
