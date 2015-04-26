# JHU/Coursera Data Specialisation track

## Getting Data, Course Project

In carrying out this assigment I have avoided tampering with the data. To accomplish that I have taken a few extra steps to clean data during or following input. 

The main engine is the `makeDF()` function, which goes through the structure of each of the two directories (`test`, `train`) and binds all the data together. The process is not purely presciptive as one of the the files is set up differently to the other two. Still, repetition is avoided by coding this into a function and repeating for each directory. 

More specifically, the measuremnets file, `X_test.txt` is the only idiomatic table. In order to result in a sensible `data.frame` structure I summarised the content of that file, as instructed, before binding it to the data frame. 

	> X <- read.csv(listing[3], sep=' ', header=FALSE)
	> cbind(df, mean = rowMeans(X, na.rm=TRUE), 
	          stdev = apply(X, 1, sd, na.rm=TRUE))

...where `df` is the `data.frame` that created by the function.

Another piece of idiomatice behaviour (and file structure) should be noted here. When read with `sep = ' '` the `X` table will feature a leading column full of `NA`, since each of the few thousand distinct rows is separated with a double space. This needn't be removed since only the mean and standard deviation of each row is carried over. By using `na.rm=TRUE` we can avoid the extra step of setting that first column to `NULL`. 

### Running the function, cleaning the data
The script envokes the function once for each directory of interest and then row-binds the two data frames to produce a single dataset containing all `test` and `train` data. 

After this point a few lines of code clean up the data to the requested specification. Since columns are already clearly tagged (as`subject`, `activity`, `mean`, and `stDev`), we only need to replace the coded activity tags with descriptive names. A loop takes care of this once the activity names have been read from the `activity_labels.txt` file. 

###Defining a new data set
The final step in the process is to create a new dataset containing averages by subject and by activity. I chose to make this output tabular, even though the two lists of values will have different lengths: six activities versus 30 subjects. Still, a single data frame with appropriae labelling is cleaner than a collection of lists. This way the column that lists mean by activity is padded with `NA` past the sixth array element. 

###Resources
The code can be found on my [coursera data science](https://github.com/iraklis-k/datasciencecoursera) github repository, under the gettingDataProject directory. The tip of the master  branch can be found at: 

    https://github.com/iraklis-k/datasciencecoursera/tree/master/getDataProject