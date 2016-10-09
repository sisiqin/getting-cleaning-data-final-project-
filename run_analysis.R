## get all the data needed 
setwd("/Users/sissiqin/Desktop/Rfiles")
activity_labels <- read.table("/Users/sissiqin/Desktop/Rfiles/UCI HAR Dataset/activity_labels.txt")
features <- read.table("/Users/sissiqin/Desktop/Rfiles/UCI HAR Dataset/features.txt")
subject_test <- read.table("/Users/sissiqin/Desktop/Rfiles/UCI HAR Dataset/test/subject_test.txt")
X_test <-read.table("/Users/sissiqin/Desktop/Rfiles/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("/Users/sissiqin/Desktop/Rfiles/UCI HAR Dataset/test/Y_test.txt")

subject_train <- read.table("/Users/sissiqin/Desktop/Rfiles/UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("/Users/sissiqin/Desktop/Rfiles/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("/Users/sissiqin/Desktop/Rfiles/UCI HAR Dataset/train/Y_train.txt")

## load all the packages needed 
library(plyr)
library(reshape2)


##extract mean and sd 
features2 <- as.numeric(features[, 2])
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names <- gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names <- gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)
head(featuresWanted.names)


## bind the data sets into one dataframe, and add labels 
train <- X_train[featuresWanted]
train <- cbind(subject_train, Y_train, train)
test <- X_test[featuresWanted]
test <- cbind(ubject_test, Y_test, test)
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresWanted.names)


## turn activitiy and subject into factors and melt them 
allData$activity <- factor(allData$activity, levels = activity_labels[,1], labels = activity_labels[,2])
allData$subject <- as.factor(allData$subject)
allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)


## write the table
write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)




tidy <- read.table("tidy.txt")
