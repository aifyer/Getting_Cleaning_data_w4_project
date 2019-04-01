
## My R code for the project of GettingCleaningData week 4--Aifyer 

# check the working directory
downloadDir <- getwd();
# download the zip file
u= "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(u,destfile = "data.zip",method = "curl")
# unzip the file
library(zip)
unzip("data.zip")

# get the directory for test and train data
wd<- paste(downloadDir, "/UCI HAR Dataset",sep="")
testdir <- paste(wd, "/test",sep="")
traindir <- paste(wd, "/train",sep="")
# load library of data.table & dplyr
library(data.table)
library(dplyr)

# read the subject and X files with fread,and y files with read.table
setwd(testdir)
testsub <- fread("subject_test.txt"); testx <- fread("X_test.txt"); testy <- read.table("y_test.txt")
setwd(traindir)
trainsub <- fread("subject_train.txt"); trainx <- fread("X_train.txt"); trainy <- read.table("y_train.txt")
setwd(wd)
# add the set category of "test" and "train" to the subject datas
testsub[,set:="test"]; trainsub[,set:="train"]

##====Step 3: Uses descriptive activity names to name the activities in the data set
activity_lables <- read.table("activity_labels.txt")
testy <- as.data.frame(sapply(testy[,1],function(x){activity_lables[(activity_lables[,1]==x),2]}))
trainy <- as.data.frame(sapply(trainy[,1],function(x){activity_lables[(activity_lables[,1]==x),2]}))

##====Step 4: Appropriately labels the data set with descriptive variable names
feature <- fread("features.txt"); 
fnames <- gsub("[_]{1,}","_",gsub("[-(),]","_",tolower(unlist(feature[,2]))))
colnames(testx) <- colnames(trainx) <- fnames
colnames(testy) <- colnames(trainy) <-"activity"
colnames(testsub) <- colnames(trainsub) <- c("subjectID","groupset")

##====Step 1: Merges the training and the test sets to create one data set
test <- cbind(testsub,testy,testx); train <- cbind(trainsub,trainy,trainx)
har <- rbind(test,train); 

##====Step 2: return "harExt": Extracts only the measurements on the mean and standard deviation for each measurement.
ori <- colnames(har)
ext<- ori[grepl("_mean[$_]|_std[$_]",ori)]; ext <- c(ori[1:3],ext)
harExt <- har[,ext,with=FALSE]

##====Step 5: return "finalTidy" From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.
finalTidy <- harExt %>% group_by(subjectID,activity,groupset) %>%
          summarise_at(vars(fbodygyro_mean_x:fbodybodygyromag_std_),mean)
# write the finalTidy data to "finalTidy.txt"
write.table(finalTidy,file="finalTidy.txt",row.names = F,col.names = T)
# remove all the variables in memory
rm(list=ls(all=TRUE))
