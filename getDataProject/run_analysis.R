# Coursera JHU Data Science Specialisation
# 
# Getting Data: Course Project
# 

# You will be required to submit: 
#  1) a tidy data set as described below, 
# 
#  2) a link to a Github repository with your script for 
#     performing the analysis, and 
# 
#  3) a code book that describes the variables, the data, 
#     and any transformations or work that you performed to 
#     clean up the data called CodeBook.md. You should also 
#     include a README.md in the repo with your scripts. This 
#     repo explains how all of the scripts work and how they 
#     are connected.  
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


# In order to simplify this procedure I have written it as a script
#  and not a set of functions. As such, the script is meant to be 
#  executed from a directory that includes the 'UCI HAR Dataset' 
#  folder, unzipped, in its entirety. 

# Each file within the test directory contains a set of 2946 data.
#  First I will combine all the individual measurements into a 
#  data frame, one each for 'train' and 'test', so that effort is 
#  not duplicated. Then I will append one to the end of the other. 

stripName <- function(str, sub){
    # Strip the descriptor of a measurement from the filename

    library(tools) # for stripping file extensions
    
    # First strip path
    str <- tail(strsplit(str, '/')[[1]], n=1)
    
    # Now strip filename
    str <- file_path_sans_ext(str)

    # And now strip the '_test' etc to normalise names
    str <- gsub(paste('_', sub, sep=''), '', str)

    str
}

makeDF <- function(dir){
    # This function collates all data into a single data frame

    # Scan directory
    listing <- list.files(dir, full.names = TRUE)

    # Initialise a data frame with a running index
    nData <- dim(read.csv(listing[2]))[1]
    df <- data.frame(index = 1:nData)
    
    # Loop over all files, ignoring directory at top of 'listing'
    for(i in 2:length(listing)){

        # Column-bind each file (dataset)
        print(paste('Adding contents of', listing[i]))
        df <- cbind(df, read.csv(listing[i]))
        
        # Name each variable after the filename; remove test/train
        names(df)[i] <- stripName(listing[i], dir)
    }
    # Now stop ignoring that directory and get into it
    # *** Following the instruction on the community forum I am 
    #     not including the 'Inertial' folder. Commented out. 
#     count <- i
#     for(j in list.files(listing[1], full.names = TRUE)){
#         # Increment counter seeing as 'j' is str for convenience
#         count = count + 1
#         print(paste('Adding contents of', j))
#         df <- cbind(df, read.csv(j))
#         names(df)[count] <- stripName(j, dir)
#     }
    return(df)
}

# Invoke makeDF twice and create a data frame for each set
test <- makeDF('test')
train <- makeDF('train')

# And tack one data frame onto the end of the other
# *** This fulfils steps [1], [3], and [4] of the project ***
allData <- rbind(test, train)

