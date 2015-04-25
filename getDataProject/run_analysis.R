# Coursera JHU Data Science Specialisation
# 
# Getting Data: Course Project
# 

# You should create one R script called run_analysis.R that does 
# the following: 
# 1. Merges the training and the test sets to create one data set. 
# 2. Extracts only the measurements on the mean and standard 
#    deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the 
#    data set. 
# 4. Appropriately labels the data set with descriptive variable 
#    names. 
# 5. From the data set in step 4, creates a second, independent 
#    tidy data set with the average of each variable for each 
#    activity and each subject.
# 
# Good luck!


# The script expects to be executed from a directory that includes 
#  the 'UCI HAR Dataset' folder, unzipped, in its entirety. 

# Each file within the test directory contains a dataset. First I 
#  will combine all the individual measurements into a data frame, 
#  one each for 'train' and 'test', so that no effort is duplicated.
#  Then I will append one data frame to the end of the other. 

makeDF <- function(dir){
    # This function collates all data into a single data frame

    # Scan directory
    listing <- list.files(dir, full.names = TRUE)

    # Initialise a data frame via 'subject_test'
    print(paste('Adding contents of', listing[2]))
    df <- read.table(listing[2], header=FALSE, 
                     col.names = "subject")

    # Column-bind other files (datasets)
    print(paste('Adding contents of', listing[4]))
    df <- cbind(df, read.table(listing[4], header=FALSE, 
                               col.names = "activity"))
    
    # The measurements (X) file is not as simple
    X <- read.csv(listing[3], sep=' ', header=FALSE)

    # No need to delete the leading NA column, just ignore
    print(paste('Adding contents of', listing[3]))
    df <- cbind(df, mean = rowMeans(X, na.rm=TRUE), 
                stDev = apply(X, 1, sd, na.rm=TRUE))
    
    return(df)
}

# Invoke makeDF twice and create a data frame for each set
test <- makeDF('test')
train <- makeDF('train')

# And tack one data frame onto the end of the other
allData <- rbind(test, train)

# *** The above fulfils steps [1] through [4] of the project ***

# For step [5] let's filter the data by activity and then subject
library(dplyr)

#newData <- arrange(allData, allData$activity_code, allData$subject)
# nActivities <- unique(allData$activity_code)
# averages <- data.frame(activity = unique(allData$activity_code))

# a <- filter(allData, activity_code==1)
# b <- a$measurement

# Loop over the distinct set of activities (integer-coded)
# for(i in 1:nActivities){
#     # dplyr-Filter and get averages
#     #averages <- 
# }

# Loop over the distinct set of subjects (also integer-coded)

# Then save those to new df





#setwd('~/Documents/Coursera/getData/CourseProject/UCI HAR Dataset/')





