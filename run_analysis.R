

#Step 1 Load the Data

#Load Test Data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Load Train Data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")


# Get the features from the second column of features.txt to use as names for measurement data
features <- read.table("./UCI HAR Dataset/features.txt")[,2]


names(X_test) = features
names(X_train) = features


#Step 2 Extracts only the measurements on the mean and standard deviation for each measurement

#Extract the Columns with mean or std from features
extract <- grepl("mean|std",features)

#Gets columns with mean or std
X_test = X_test[,extract]
X_train = X_train[,extract]

#Step 3 Uses descriptive activity names to name the activities in the data set

# Get The Labels from the second column of activity_labels.txt
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

#Match labels to y_test and y_train
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")

y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")

#add names to subject data
names(subject_test) = "subject"
names(subject_train) = "subject"

#Merge Data Together
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
data <- rbind(train, test)

#Step 4 Appropriately labels the data set with descriptive variable names

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
# write the tidy data set to a file
write.table(tidy_data, file = "./tidy.txt",row.name=FALSE)


