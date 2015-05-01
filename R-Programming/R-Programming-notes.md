### R Programming notes
Define a variable (all numeric vector, an object, except list):

    x <- 1

Define a range: 

    x <- 1:10
- arrays indexed from 1…

Load a package: 
    
    library(package-name)

Set attributes: 

    attr(dummy, 'name') <- 'dummy!’

Delete or edit one: 

    attr(dummy, 'name') <- NULL
    attr(dummy, 'name') <- ‘not a dummy!’

Initialise a vector with concatenate helper (c): 

    myvec <- c(1, 2, 5, 3)

Coercing a logical (boolean) to numeric: 

    x>=1 # becomes TRUE
    x=0  # becomes FALSE

Lists: 

    x <- list(1, “a”, TRUE, 1+1i)

- double brackets for list levels. 

matrices: special dimensional vectors (nrow, ncol): 

    m <- matrix(nrow=2, ncol=3)

- column-wise construction
- `dim()` can be used as a python `reshape()` to coerce. 
factors for categorical data
- unordered, e.g., male/female
- ordered, e.g., an index or roster
- not sure how an unordered factor differs to a list
- Levels of factor are a short listing of all repeated items (e.g., male, female)
- can determine levels at factor creation, get to decide which is the base

###Missing values: 
- NA or NaN; is.na(), is.nan()
- NaN is an NA, but not the other way around
Data Frame
- row.names
- create with read.table() or read.csv()
- convert to matrix with data.matrix()
- nrow(), ncol()

###Names attribute
    > x <- 1:3
    > names(x) <- c(“yanis”, “koula”, “baby”)
    > x <- list(a=1, b=2, c=3) # creates names a, b, c
    > dimnames(m) <- list(c(“row”, “names”), c(“column”, “names”))

###Reading data
`readLines()` us suitable for small files, but for larger files: 

- `read.csv()`; wrapper for read.table() with default comma separator (vs space)
- Lots of optimisation. Ideally figure out memory, don’t just read as default is for R to read everything to RAM. Also go with `comment.char = “”` if no skipping to optimise. 
- If unknown one can read 100 or 1000 lines and run `sapply()` to inform `colClasses()` to understand info before reading properly. 
- memory usage: need twice as much RAM as the size of the dataset

###Textual data
- `dump` and `dput` instead of `write.csv` in order to preserve metadata

Interfaces
- `file()`, `gzfile()`, `bzfile()`, `url()`
- file creates a file buffer
   - but usually do not need this in R 
- `url()` just reads a website

###Subsetting
- single versus double (square) brackets
   - `[` returns like class (returns values and names, if they exist)
   - `[[` returns potentially different class (returns only values, not names)
   - `$` extracts only named objects 
   - `x$bar` returns the values within list/vector named ‘bar’
   - like `x[“bar”]` in Python
- python-like criterion based sets

        x[x > “a”]

- logical index creation: 

        u <- x > “a”

- matrices: Python-like, commas indicate absence

        x[1,], etc. 

- Partial matching
   - type only first letter(s) after dollar sign
   - good for command line operations
- Missing values

        bad <- is.na(x)
        x[!bad] is the good part of the array, but re-indexed.    
   
- `complete.cases()` for data frames; maintains only ‘complete' rows. 

Vectorised operations

- Default is pair-wise operations, like in Python arrays
- element-wise vs matrix multiplication: 

        x * y vs x%*% y

- Swirl

###Control structures

    if (<condition>) {
        # do something
    } else {
        # do something else
    } else if (blah) {
        # blah
    } else {
        blah
    }
    for (i in 1:10) {
        blah
    }

`python range(x)` is `seq_len(x)`

    while(count < x){
    blah
    }

- Conditions evaluated left to right. 
- `repeat` goes on forever until `break`
   - should only really use for converging algorithms, safe iterative functions
- ‘next’ to skip an iteration

        for(i in 1:100) {
            if(i <= 20) {
                next
            }
        }

- a `return` call will terminate a function
   - can return by simply adding the name of the variable to be returned, e.g., `x`, instead of `return x` at the end of the function
- `apply` functions for shell work (control structures not ideal). 

Functions are objects. ‘formal’ args are named in function definition; return with ‘formals’ function

- args can be functions!
- can swap order for named args, obvio.
- BEWARE! of partial name matching… 

Lazy evaluation: weird. 
- If an arg is never actually used, not calling it does not cause an exception. 
- If something can be called it is and then the exception happens. 
- `...` argument: if calling another function can replicate all args! 
- Necessary if not al args are known in advance. 
- e.g., `paste` or `cat`
- lose positional and partial matching after …

Binding values to a symbol:
- first the system searches through `global`
- then through namespaces of all packages 
- loading libs creates a search list sequentially
- R uses lexical (or static) scoping, rather than dynamic scoping (like Py)
- will search maniacally to assign free variable, beware of workspaces
   - this means that all objects need to be stored to memory
- global is a good place to define standards (say, gravitational `g`)
- the environment in which a function exists is the *parent frame* in R
- ls(function()) to list objects within a function

###Coding standards
- use a text editor for access (Rstudio saves ascii)
- indent code (`cmd+I` to apply indenting Rstudio)
- limit width (80 char?)
- limit length of functions (a single basic activity; single page for visibility)

###Dates and times
- Date class, `POSIXct` (`int`) and `POSIXlt` (`list`) classes for time

        x <- as.Date("1970-01-01”)
        unclass(x) # what does this do? 
        
- `Sys.time()`
- `strptime()`... yowza
- algebra possible with date and time objects

###Loop Functions
- (`l`), (`s`), (`m`), (`t`), `apply`
- `lapply()` always returns a list
- it makes use of `...` to pass function args
- `sapply()` simplifies output (vector, matrix, or list if fails)
- `apply()` evaluates a function: 

        apply(x, 1, mean) # get mean of matrix along axis=1

- further shortcuts: `rowSums`, `rowMeans`, `colSums`, `colMeans`—much faster
- `mapply()` is multivariate `apply`; vectorisation for non-vector functions

        mapply(rep, 1:4, 4:1)

- `apply` applies function over segments of a vector
- `split` breaks up a vector (not a loop function)
   - e.g., according to a variable in a data frame. 
   - always returns a list
   - multi-level splits
   - `interaction()` function
   - `drop=TRUE` to not return empty numeric arrays

###Debugging; levels of diagnosis: 
- **message**: just lets you know that something’s fishy
- **warning**: something is wrong but not fatal
- **error**: an exception has occurred and program is exiting (stop)
- **condition**: something unexpected happened
   - `log(-1)` produces a `NaN` and a warning
   - `invisible()` prevents auto printing but returns the object to be returned
- `traceback()` will return a convenient, legible listing of the traceback
- `debug()` will enter a debug browser, returns crashed code first
- `browse()`: hit ’n' for next until end, browser exits
- `options(error = recover)` defines behaviour for current session
   - `recover` enters yet another debug environment; hit 0 to exit

###str function
- == ‘structure'
- alternative to `summary`

###Random numbers
- `rnorm()`: generate Normal (narray, mean, stdev)
- `dnorm()`: evaluate Normal (probability of a distro value being something)
- `pnorm()`: cumulative DF for normal
- `rpois()`: generate Poisson
- `d`, `r`, `p`, `q` prefix for each distro (`Norm`, `Pois`, `Exp`, `Gamma`, `Binom`)
   - density, generate random, cumulative, quantile
- `set.seed(N)`: reproducibility advantage
- random sampling: `sample()`—permutation if sample size not defined 

###Profiling R code
Design, then optimise—otherwise: bugs! 

- measure (or collect data), don’t guess timing etc. 

`system.time()`
- `user` (CPU), `system`, `elapsed` (wall clock, as perceived by human)
   - `elapsed > user` if CPU waits for external processes
   - `elapsed < user` if there are multiple cores or CPUs
   - multi-core usage not by default. (`vecLib`/`Accelerate`)
   - `parallel` package
- `Rprof()` starts profiler—must be compiled with compiler support
   - `summaryRprof()`
   - DO NOT use `system.time()`  and `Rprof()` together! 
   - samples every 0.02 sec (so don’t run if function shorter)
   - `by.total()`, `by.self()` normalisation
   - `by.self()` subtracts the lower level functions a function invokes. 
   - invoked `C` or `fortran` code is not profiled