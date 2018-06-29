# Download Data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "UCI-HAR-dataset.zip", method="curl")
unzip("./UCI-HAR-dataset.zip")

# 1. Merges the training and the test sets to create one data set.
x.train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x.test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x <- rbind(x.train, x.test)

subj.train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subj.test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subj <- rbind(subj.train, subj.test)

y.train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y.test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y <- rbind(y.train, y.test)
# Because the column names of 'subj' and 'y' are ambiguous, I will merge the data sets all together
# after renaming them

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("./UCI HAR Dataset/features.txt")
mean.sd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2]) # Index of -mean() and -std()
x.mean.sd <- x[, mean.sd] # mean and standard deviation for each measurement

# 3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activities[, 2] <- tolower(as.character(activities[, 2]))
activities[, 2] <- gsub("_", "", activities[, 2])

y[, 1] = activities[y[, 1], 2]
colnames(y) <- "activity"
colnames(subj) <- "subject"

# 4. Appropriately labels the data set with descriptive variable names.
names(x.mean.sd) <- features[mean.sd, 2]
names(x.mean.sd) <- tolower(names(x.mean.sd)) 
names(x.mean.sd) <- gsub("\\(|\\)", "", names(x.mean.sd))

# Merges the training and the test sets to create one data set. (From 1.)
data <- cbind(subj, x.mean.sd, y)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
average.df <- aggregate(x=data, by=list(activities=data$activity, subj=data$subject), FUN=mean)
# Remove columns 'subj' and 'activity'
average.df <- average.df[, !(colnames(average.df) %in% c("subj", "activity"))]
# Data set output 
write.table(average.df, "./average.txt", row.names = F)