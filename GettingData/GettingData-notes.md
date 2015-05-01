# Getting Data notes
Class teaches how to find and process data

Distinguish between: 

- Qualitative vs quantitative data
- Derived vs measured data

Processing (=reduction) of data

- merging, subsetting, transforming, etc. 
- some areas have processing standards
- must report all processing steps, obvio

### Reading local files
Local files read with read.table(), read.csv(), read.csv2()

- some args: ‘quote’, na.strings to set missing value char


### Downloading files
- getwd() and setwd()
- file.exists(dirname), dir.create(dirname)
- download.file(url, destfile, method)
    - for https url on a Mac: method=‘curl’
- Time stamp important: date()

### Excel
- library(xlsx)—there are others (e.g., XLConnect)
    - read.xlsx(file, sheetIndex=, header=, colIndex=, rowIndex=)
    - read.xlsx2() faster but unreliable when subsetting

### XML
- The *Extensible Markup Language*
- Most common method for web scraping
- Markup and content
- HTML-like syntax: 

        <section> Content </section>
        <line-break /> is an empty tag

- Attributes: label components: 

        <img src=‘myImg.jpg’ alt=“My Picture”>

- Access root nodes in a list-like manner. 
    - Read XML, then index. 
    - `[[index]]` vs `[index]`
    - `xmlSApply()` useful for looping through Root Node
- `XPath` language 
- `htmlTreeParse()` in same package if pure HTML. 

###JSON
- Lightweight, common for APIs
- dTypes: Number, string, boolean, array, object
- `jsonlite` package
- `fromJSON(url)` reads a nested data frame: 

        jsonData$lvl1$lvl2

- export with `toJSON()`

###The data.table package
- written in `C`, more efficient version of `data.frame`
- good for grouping, subsetting, updating
- but not identical syntax
- CRASH! 
- subsetting differs to general R
- simultaneous, multiple operations
- `plyr`-like operations
- keys available: `setkey(DT, x)`
    - can join or merge tables based on a common key

###Reading mySQL databases
- database < table < fields < rows < records
- `dbListFields()` etc functions

        dbGetQuery(db, “SELECT…FROM…WHERE”)

- `dbReadTable()` to read into data frame 
- `dbSendQuery()` can be remotely sent and then fetched with `fetch(query)`
- always `dbDisconnect(db)` at the end! 
- never push anything to ensembl—only SELECT

###Reading HDF5
- `rhdf5` package not available through CRAN
- use *BioConductor* (`biocLite`) instead
- `h5dump` with `h5ls("example.h5”)`
- write to specific groups with
 
        h5write(array, “file.h5”, “myGroup”)

- can write `data.frame` with `h5write()` directly, translated to dataset
- `h5read(“file”, “dset”)` produces vector continuing that data set
- writing and reading lists into data-subsets: 

        h5write(c(12, 13, 14)), “example.h5”, “foo/A”, index=list(1:3,1))

###Reading from the Web
- Web scraping, APIs, authentication
- `readLines(URL)` to scrape
- Can instead

        htmlTreeParse(url, useInternalNodes=T)

- `httr` package
- Status: 401 if authentication required

        GET(url, authenticate=(“user”, “passwd”))

- `handle(url)` can provide aliases for URLs and use cookies to authenticate

###Reading from APIs
- twitter example on lecture video
- `oauth_app()` for signing in
- `JSONIO` package

###Other sources
- foreign package for `S`, `SAS`, `SPSS`, other stats package import
- `RPostgreSQL`
- `RODBC`: interfaces to multiple DBs
- `RMongo` and `rmongodb`
- images: jpeg, readbitmap, png, EBImage
- GIS data: `rdgal`, `rgeos`, `raster`
- Music: `tuneR`, `seewave`

###Subsetting and sorting
- `a[,1]` subsets column no.1 
- logical indexing as in python, except add a comma

        a[(x$var1 < b & x$var2 > c),] # | for OR

- `which()` returns indices rather than a boolean matrix
- `sort()`: `decreasing=TRUE`, `na.last=TRUE`
- `order()` useful for sorting according to a specific column

        a[order(a$var1, a$var3),]

`plyr` package: 

- `arrange(a, var)` — equivalent to `sort()`
- to add new row / column: 

        a$var4 <- someVar # (where there was no var4)

    - or `cbind()` to bind column to a specific end of a data frame

###Summarising data
Useful functions: 

- `head()`, `tail()`, `summary()`, `str()`, `quantile(probs=c(my quantiles))`
- `any(is.na(a))` checks for NA
- `all(condition)` quick check for condition
- `colSums()`, `rowSums()`
- `%in%` for python `in`
- perform a table join: 

        tabs(var1 ~ var2 + var3, data=df) 

- `ftable()` produces compact display
- `object.size()` returns file size `(units=“Mb”)`

Creating new variables

- `seq()` for sequence: min value, max value, `by` or `length`, or `along`

        seq(1, 10, by=2); seq(along=x)

- `ifelse()` returns one of two prescribed outcomes (e.g., TRUE, FALSE)
- `cut()` to produce a frequency distribution
- `cut2()` in `library(Hmisc)` more automated (no need to define quantiles)
- `factor()` to create a factor variable out of a specified value
- `as.numeric()` can convert booleans to (1,2) list

Misc functions: 

- `abs()`, `sqrt()`, `ceiling()`, `floor()`, `round()`, `cos()`, `sin()`, `log()`, `log10()`, `exp()`

### Reshaping data
- `melt()` a data frame: specify ID vars and measurement vars
- `dcast()` to cast into a particular shape and optionally apply a function
- *split, apply, combine*: `split()` by factor; `lapply()` a function (or `ddply()` in `library(plyr)`)

`dplyr`: working with data frames, but C++, so very fast. Written by Hadley Wickham of Studio. 

Functions: `select`, `filter`, `arrange`, `rename`, `mutate`, `summarise` (equivalent to `unique()`), and `print`. 

    select(myData, var1:var5)—to select only those cols
    select(myData, -(var1:var5)—to omit those cols
    subset.f <- filter(myData, condition)
    myData <- arrange(myData, var1)—desc for descending order
    myData <- rename(myData, var1=variable1, var2= blah)
    myData <- mutate(myData, 'arithmetics for new column’)
    newArray <- group_by(myData, var1)
    
Functions can be combined by using a special pipeline operator `%>%. This daisy-chains operations into a readable sequence without assigning intermediate variables: 

    myData %>% mutate() %>% summarise()
    
### Merging data
To join tables according to some identifier: 

    merge(dset1, dset1, by.x=“ID”)
    # `all=TRUE` adds new rows with NA if no match

Intersection: 

    intersect(names(dset1), names(dset2))

`join()` in plyr mimics SQL join, but need commonly named ID col. Useful for joining >2 data frames: 

    dflist = list(df1, df2, df3); join_all(dflist)

###Editing Text Variables
- `tolower()`
- `strsplit(var, ‘char’)`—`‘\\'` to escape characters

        sub(’find’, ‘replace_with’, var)
        gsub(’find’, ‘replace_with’, var) # for multiple instances

- `grep(’str’, var)` returns index of occurrences; 
    - `value=T` to return all occurrences
    - `grepl()`: return F/T sums tables
- `nchar()`: number of chars in string
- `substr()`: subset; paste()—add strings
    - `paste0()` sets `sep=“”`
- `str_trim(’str   ‘)` to strip excess whitespace

Some tips about text vars: 
- Names of variables should ideally be lowercase if possible
- Must be descriptive
- Should probably be made into factors 

###Regular Expressions
- literals: exactly match all characters in string, including case
- metacharacters: more general search terms to detect variations
    - `^str`: match all lines beginning with `^str`
    - `str$` for end of line
    - list, eg: `[Bb][Uu][Ss]`
    - combinations, eg: `^[Ii] am`
    - ranges: `[a-z]`, `[a-zA-Z]`, `[0-9]`, or `[Ww]`
    - negation, eg all lines not ending in ‘?' or ‘.': `[^?.]$`
    - `.` is a wildcard separator
    - `|` is an OR metacharacter
    - brackets constrain expressions
    - `‘)?’` is an optional expression
    - backslash to escape the specials
    - `*` is a wildcard
    - plus sign is a combination of containing expressions
    - `{}` are an interval qualifier for the number of repetitions
    - `\1` can be used for repetition (obi number of reps)

###Working with Dates
- `Sys.Date()`: returns a `Date` class variable
- Formatting: `format(myDate, “%a %b %d”)` etc
- `as.Date()` to coerce  

Numerical operations with `Date` objects: 

    > myDate1 - myDate2
    Time difference is 1 day
    > as.numeric(myDate1 - myDate2)
    [-1]

- `weekdays(myDates)`, `months(myDates)`
- `julian(myDates)`: time in julian days since origin

`Lubridate` package

- `ymd(“20140108”)` returns `"2014-01-08 UTC”`
- also `mdy()`, `dmy()`
- `wday()` equivalent to weekday()

### Some Data Resources
- Many national databases (see lecture snapshots)
- gapminder.org, asdfree.com, infochimps.com, kaggle.com
