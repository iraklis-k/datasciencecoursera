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

stripName <- function(str, sub){
    # Strip the descriptor of a measurement from the filename

    library(tools) # for stripping file extensions
    
    # First strip path
    str <- tail(strsplit(str, '/')[[1]], n=1)
    
    # Now strip filename
    str <- file_path_sans_ext(str)

    # And now strip the '_test' etc to normalise names
    str <- gsub(paste('_', sub, sep=''), '', str)

    return(str)
}

makeDF <- function(dir){
    # This function collates all data into a single data frame

    # Scan directory
    listing <- list.files(dir, full.names = TRUE)

    # Initialise a data frame via 'subject_test'
    #nData <- dim(read.csv(listing[2]))[1]
    #df <- data.frame(index = 1:nData)
    print(paste('Adding contents of', listing[2]))
    df <- read.table(listing[2], header=FALSE)
    
    # Column-bind each file (dataset). Peculiarities do not loop. 
    #df <- cbind(df,read.csv(listing[2], header=FALSE))

    print(paste('Adding contents of', listing[4]))
    df <- cbind(df,read.table(listing[4], header=FALSE))

    print(dim(df))
    
    print(paste('Adding contents of', listing[3]))
    df <- cbind(df,read.csv(listing[3], sep='  ', header=FALSE))        
    
    # Loop and name each variable after the filename
    for(i in 2:length(listing)){
        names(df)[i] <- stripName(listing[i], dir)
    }
    return(df)
}

# Invoke makeDF twice and create a data frame for each set
test <- makeDF('test')
train <- makeDF('train')

# And tack one data frame onto the end of the other
allData <- rbind(test, train)

# Finally, give the data frame some descriptive column names
names(allData)[3] <- "measurement"
names(allData)[4] <- "activity_code"

# *** The above fulfils steps [1] through [4] of the project ***

# For step [5] let's filter the data by activity and then subject
library(dplyr)

#newData <- arrange(allData, allData$activity_code, allData$subject)
nActivities <- unique(allData$activity_code)
averages <- data.frame(activity = unique(allData$activity_code))

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





