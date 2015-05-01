# Exploratory Data Analysis notes

###Principles of analytic graphics
- Tuftee: Beautiful Evidence
   1.	show comparisons—evidence is always relative
   1.	show causality, mechanism, explanation
   1.	show multivariate data—reflect the real world
   1.	integrate evidence—only show plot if possible
   1.	describe and document via labels, etc—preserve code
   1.	content is king—a boring story will be boring
Why use exploratory graphs? 
- understand data, find patterns, form strategy, and debug
Simple one-d summary plots: 
- histogram: hist(); rug() helpful; bins == breaks
- boxplot()
- barplot()
- density plot
- plus the five-number summary (summary) function
- abline() is a vertical line indicator. 

###Two-dimensional data representations
- layering and colouring of variables optimal for human vision
- multiple boxplots or histograms
- scatterplot
- R Graph Gallery and R Bloggers offer good plot resources

Plotting systems: 

- Base Plot: 
    - `plot()`
    - artist’s palette: blank canvas, code layered
    - but since it is a cumulative process: can’t take bit away
    - difficult to translate—no graphical ‘language’
    - graphics and grDevices packages handle plots
- Lattice: 
    - lots of args in call for replicability; 
    - makes panel plots
    - But once call is issued no additions possible
- `ggplot2`: 
    - lays down language/grammar for plot aspects
    - splits the difference; lots of defaults, but customisable
    - `qplot()` for scatterplot
- Can’t mix, obvio. 

### Base Plot: 
Base: (i) initialise a plot and (ii) annotate. 

- e.g., plot() or hist()
- ?par for plot() args

Useful syntax: 

    library(datasets)
    hist(airquality$Ozone)
    with(airquality, plot(Wind, Ozone))

To choose x and y vars: 

    boxplot(Ozone ~ Month, air quality, xlab=‘’, ylab=‘’)

Pars: 

- `pch`: plot symbol—number (mapped) or character
- `lty`: line type
- `lwd`: line width (int)
- `col`: colour—number, string, or hex code; see colors()
- `xlab`, `ylab`: labels
- `par()` can set global graphics parameters
    - `par(“bg”)`
    - individual function call can override
    - `las`: orientation
    - `bg`: bg col
    - `mar`: margin size
    - `oma`: outer margin size
    - `mfrow`: #plots per row, col (row-wise)
    - `mfcol`: #plots per row, col (col-wise)

Base Plot functions: 

- `plot()`
- `lines()`: connect the dots
- `points()`: add data points
- `text()`, `title()` to add text
- `mtext()`: margin text plotting
- `axis()`: axis ticks
- `par`: type=’n’ is an IDL \nodata equivalent
- this whole package is very much like IDL, in fact
- example(points) launches plot demo
- Margin sides count clockwise from bottom: 

        par(mar =c(2, 2, 2, 2))


Graphics devices

- window, PDF, png, jpg, svg
- screen devices—Mac: quartz(), Win: windows(), Unix: x11()
- `?Devices` lists available devices
- normally just one screen device, but many file devices
- file device must be explicitly closed with dev.off()
- vectors: pdf, svg, win.metafile, ps
- and bitmaps: png, jpg, tiff, bmp—these do not resize well
- `dev.cur()` gives current—1 if null, otherwise >=2
- `dev.set()` sets current device
- can copy plots between devices
    - `dev.copy`, `dev.copy2pdf`—but not identical

### `lattice`
- good for multiple, automatically generated plots
    - margins etc handled well
- grid package handles infrastructure (no need to call)
- all plotting and annotation in single call

         xyplot(y ~ x | f * g, data)
    
    - `x`, `y` are axis data
    - `f`, `g` are categorical vectors
    - data is the data frame from which all are drawn
    - can all exist in workspace, df not necessary
- lattice functions return a *trellis* class object; print
- can save/store object although not clear why
- panel function to control each sub-plot
- no base system annotations available
    - but similar functions available

###`ggplot2`
*The Grammar of Graphics* (Leland Wilkinson): 

> Shorten the distance from mind to page

`ggplot2` is an implementation of *gg* by Hadley Wickham. `qplot()` is the quick-plot function

- looks for data in a `data.frame` or in `global`
- aesthetics (size, shape, colour) & geoms (glyph, line)
- factors can be used

`ggplot()` is the heavy function

- colours allocated automatically by factor
- qplot(single-variable) produces histogram
    - qplot(hwy, data=mpg, fill=drv), where d, r, v are factors
- ‘facets’ == panels
    - `facets = . ~ drv` (columns) or `drv ~ .` (rows)
- `ggplot()` is obviously more powerful

        g <- ggplot(…)
        print(g) -> no layers
        p <- g + geom_point()
        print(p)
        geom_smooth(method=“lm”)

- Annotation can be ‘added’ to call with ‘+’ sign: 
  - `xlab()`, `ylab()`, `labs()`, `ggtitle()`
- `theme_gray()`, `theme_bw()`
- `geom_point()` has many options—alpha, size, color, etc
    - color can be assigned to data variable: 
      - `geom_point(aes(color=myVariable))`
- base_family in theme call defines font
- automatic axis scaling differs bet `base` and `ggplot`
    - `plot` covers most data; `ggplot` covers full range
    - `g + geom_line() + ylim(min, max)`
- `cut()` + `quantile()` very handy for discretisation of info

### Clustering analysis
Hierarchical clustering: an agglomerative approach

- requires: defined distance, merging approach
- produces: a dendrogram
    -in terms of any parameter (continuous or discrete, or binary)

R Functions: 

- `dist(df)` produces a matrix of distances
- `hclust()` produces dendrogram data—plot(hclust(dist(df)))
- `myplclust()` available on course website
- `heatmap()`—runs hierarchical clustering on rows & cols separately

K-means clustering: a partitioning approach

- requires: distance metric; N(cluster); initial guess of centroids
- produces: final estimate of centroids, assignment of clusters

R Functions: 

- `kmeans()`

        plot(x, y, col=kmeans$cluster)
        points(kmeans$centers)

- `heatmap()` still useful

Dimension reduction: PCA & SVD

    X = UDV^T
- Principal components are the right singular values if variables scaled
    - i.e., mean is subtracted and data are divided by standard deviation
    
             svd(scale(orderedMatrix)) ~ svd$u/v/d

- principal component 1 \propto first right singular vector
- `impute` package from bioconductor
    - `impute.knn`—take care of missing values for PCA

###Plotting and colour in R
- `heat.colors()`; `too.colors`
- `grDevices` package
- `coloRamp()` and `coloRampPalette()` to interpolate between set of cols 
    
        pal <- colorRamp(c(“red”, “blue"))

- `colors()` lists all available colour names
- `RColorBrewer` package (Python palettes)

        cols <- brewer.pal(3, “BuGn”)

- `smoothscatter()` uses *color brewer*
- `rgb()` for *hex* strings; can get *alpha*