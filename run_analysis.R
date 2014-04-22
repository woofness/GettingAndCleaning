files <- "getdata-projectfiles-UCI HAR Dataset.zip"
activityLabels <- read.table(unz(files,"UCI HAR Dataset/activity_labels.txt"),sep="",stringsAsFactors=FALSE)
features <- read.table(unz(files,"UCI HAR Dataset/features.txt"),sep="",stringsAsFactors=FALSE)
subjectTest <- read.table(unz(files,"UCI HAR Dataset/test/subject_test.txt"),sep="",col.names="ID")
subjectTrain <- read.table(unz(files,"UCI HAR Dataset/train/subject_train.txt"),sep="",col.names="ID")
xTest <- read.table(unz(files,"UCI HAR Dataset/test/X_test.txt"),sep="",col.names = features$V2)
xTrain <- read.table(unz(files,"UCI HAR Dataset/train/X_train.txt"),sep="",col.names=features$V2)
yTest <- read.table(unz(files,"UCI HAR Dataset/test/y_test.txt"),sep="",col.names="activity")
yTrain <- read.table(unz(files,"UCI HAR Dataset/train/y_train.txt"),sep="",col.names="activity")

trainData <- cbind(subjectTrain,xTrain,yTrain)
testData <- cbind(subjectTest,xTest,yTest)
allData <- rbind(trainData,testData)
library(plyr)
allData <- arrange(allData,ID)
allData$activity <- factor(allData$activity,levels=activityLabels$V1,labels=activityLabels$V2)
allData$ID <- as.factor(allData$ID)

stdAndMean <- allData[,c(1,2,grep("std",names(allData)),grep("mean",names(allData)))]
averages <- ddply(stdAndMean,.("ID","activity"),.fun=function(x){colMeans(x[,-c(1:2)])})
colnames(averages)[-c(1:2)] <- paste0(colnames(averages)[-c(1:2)],"Mean")
write.table(averages,"GettingAndCleaning/averages.txt",sep=",",row.names=FALSE)