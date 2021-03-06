#---
#  title: 'Reproducible Research: Peer Assessment 1'
#author: "Sai"
#date: "September 18, 2015"
#output: html_document
#---
  
  ##Loading and preprocessing the data
  
#1. Load the data (i.e. read.csv())
#2. Process/transform the data (if necessary) into a format suitable for your analysis

#```{r}
data<- read.csv("./data/activity.csv")
data$date <- as.Date(data$date, '%Y-%m-%d')
# Omitting the rows with NA Values
data1 <- na.omit(data)
#```

##What is mean total number of steps taken per day?

#1. Calculate the total number of steps taken per day
#```{r kable}
#Calculating sum of steps taken per day
sumofsteps <- aggregate(data1$steps,by =list(date = data1$date),sum)
names(sumofsteps)[2] <- "sum"
library(knitr)
#kable(sumofsteps, align = 'c')
#```

#2. Make a histogram of the total number of steps taken each day
#```{r figs, fig.align= 'center',fig.height=4,fig.width=8}
hist(sumofsteps$sum,
     main = "Histogram of Total No of Steps Taken each day",
     xlab = "Sum of Steps",
     col = "red")
#```

#3. Calculate and report the mean and median of the total number of steps taken per day
#```{r kable1}
meanofsteps <- aggregate(data1$steps,by=list(date = data1$date),mean)
names(sumofsteps)[2] <- "mean/median"
#kable(meanofsteps,align = 'c')
#```

##What is the average daily activity pattern?
#1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
#```{r figs1, fig.align= 'center',fig.height=4,fig.width=8}
avgint <- aggregate(data1$steps,by=list(interval = data1$interval),mean)
plot(avgint$interval, avgint$x,type = 'l',
     main = "Average No of Steps taken across all days",
     xlab = "Interval",
     ylab = "Avg No of Steps")
#```
#2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
#```{r include = FALSE}
avgint <- avgint[order(-avgint[,2]),]

#Imputing missing values
#1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
#```{r}
missval <- nrow(data) - nrow(data1)
#```

#**The number of missing values in the data is `r missval`.**
  
#2. filling in all of the missing values in the dataset with the mean for that 5-minute interval
#3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

#```{r}
origdata <- data
for (i in 1:nrow(data))
{
  if(is.na(data[i,1]))
  {
    intrval <- data[i,3]
    data[i,1] <- avgint[avgint$interval==intrval,2]
  }
}
#```

#4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.

#```{r figs2, fig.align= 'center',fig.height=8,fig.width=8}
sumofsteps <- aggregate(data$steps,by =list(date = data$date),sum)
names(sumofsteps)[2] <- "sum"
hist(sumofsteps$sum,
     main = "Histogram of Total No of Steps Taken each day",
     xlab = "Sum of Steps",
     col = "red")
#```

#```{r kable 2}
##Calculating the Mean/Median
meanofsteps1 <- aggregate(data$steps,by=list(date = data$date),mean)
names(meanofsteps1)[2] <- "mean/median"
#kable(meanofsteps1,align = 'c')
#```

#Are there differences in activity patterns between weekdays and weekends?

#1. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

#```{r}
day <- character(length = nrow(data))

for (i in 1:nrow(data))
{
  if (weekdays(data$date[1]) == "Sunday" | weekdays(data$date[i]) == "Saturday")
  {
    day[i] <- "Weekend"
  }
  else
  {
    day[i] <- "Weekday"
  }
}
day <- as.factor(day)
# Combining the factor with the original data
data <- cbind(data,day)
#```

#2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).
#```{r figs3, fig.align= 'center',fig.height=8,fig.width=8}
avgint <- aggregate(data$steps,by=list(interval = data$interval, days = data$day),mean)

library(lattice)
xyplot(log10(avgint$x) ~ avgint$interval|avgint$days,
       layout = c(1,2), type = 'l', xlab = "Interval",
       ylab = "Number of Steps",
       main = "Weekend Vs Weekday")
#```
























