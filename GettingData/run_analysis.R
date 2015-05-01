# Coursera JHU Data Science Specialisation
# 
# Getting Data: Course Project
# 

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

# For step [5] let's filter the data by activity and then subject
library(dplyr)

# Loop over the distinct set of activities (integer-coded)
nActivities <- length(unique(allData$activity))
byActivity <- numeric(nActivities)

for(j in 1:nActivities){
    # dplyr-Filter and get averages
    byActivity[j] <- mean(filter(allData, activity==j)$mean)
}

# Now that activiry codes are no longer required, replace them 
# with descriptive names
actNames <- read.csv('activity_labels.txt', as.is=TRUE, 
                     sep=' ', header=FALSE)
for(i in actNames$V1){
    allData$activity[allData$activity==i] <- actNames$V2[i]
}

# Loop over the distinct set of subjects (also integer-coded)
nSubjects <- length(unique(allData$subject))
bySubject <- numeric(nSubjects)

for(k in 1:nSubjects){
    # dplyr-Filter and get averages
    bySubject[k] <- mean(filter(allData, subject==k)$mean)
}

# Create a new data frame
df2 <- data.frame(meanBySubject = bySubject, 
                  meanByActivity = byActivity)

# And pad the activity with NA past 6 to wrap this up
df2$meanByActivity[7:dim(df2)[1]] <- NA

# Finally, output the dataset
fname <- "~/Progs/datasciencecoursera/getDataProject/dset.txt"
write.table(df2, file=fname, row.name=FALSE)