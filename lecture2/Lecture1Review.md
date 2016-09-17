Lecture 1 Review: Data Types and Structures
================
Jeremy Oldfather
September 9, 2016

Let's review the data types introduced in the first lecture and dig a bit deeper. What is the difference between a **data type** and a **data structure**? What values can we represent in R? Are there values we cannot represent?

### Data Types

R data types can be categorized by their modes: *character*, *numeric*, and *logical*.

#### Character

The character mode has only one data type, also called character. Character data may be anything from category names to whole text documents.

**type summary:**

``` r
x<-"hello!"
typeof(x)           # character
class(x)            # character
mode(x)             # character
storage.mode(x)     # character
object.size(x)      # 96 bytes
```

-   **size**: From 8 to 2e9 bytes (about 2GB) in increments of 8 bytes
-   **min/max characters:** *\[0, 2.49999988e8\]*

``` r
object.size("")                 # 96 bytes
object.size("1234567")          # 96 bytes
object.size("12345671")         # 104 bytes
object.size("123456712334567")  # 104 bytes and so on
```

Besides data, characters are useful for many other things like getting feedback from your programs:

``` r
text<-paste("the answer is", 24)
cat(text)       # plain text
message(text)   # highlighted in console
```

``` r
text<-paste("the answer is", 24,"?")
warning(text)   # generates a warning message (also highlighted)
```

``` r
text<-paste("the answer is", 24,"!")
stop(text)      # generates an error message and stops the program
```

#### Numeric

The numeric mode includes the data types: *double* and *integer*. Complex types have their own mode and are not used often.

##### Double

Numeric values (real numbers) are represented in R as doubles by default. What is a *double*? Easy--a double is twice as "large"" as a **single**. But let me dodge the concept of size for a few more minutes.

**type summary:**

``` r
x<-1e-16
typeof(x)           # double
class(x)            # numeric
mode(x)             # numeric
storage.mode(x)     # double
object.size(x)      # 48 bytes
```

-   **size**: 8 bytes
-   **min/max:** *\[-1.7976931348623157081e+308, 1.7976931348623157081e+308\]*

Writing a number in form `1e-16` is short hand: `1e-16 = 10^-16 = .0000000000000001`. Doubles have 16 decimal places of precision, while singles only have 8 decimal places of precision. This does not mean it is impossible to represent numbers smaller than `1e-16` as a double. It does mean that if we want to write a larger numbers, we need to sacrifice some digits on the right-hand side of the decimal point.

Why is this important? Loss of precision means some ideas that are true mathematically, are not true in **floating-point arithmetic**. To demonstrate, we would all agree that `1.0000000000000001` does not equal `1`. However, R (and most other programming languages for that matter) will claim that this is a true statement:

``` r
(1 + 1e-16) == 1
```

    ## [1] TRUE

Why? R reads the statement above from left to right. It recognizes `1` as a double and then `1e-16` as a double, but the sum of the two requires more than 16 digits. So starting from the left-most digit, it continues along the number holding onto the first 16 digits it encounters (the significant digits), and then drops or **truncates** the remaining digits.

Truncation introduces **numerical error** into your work. Combined with **sample error** (does the underlying data accurately represent the population?) and **model error** (does your mathematical description accurately represent the mechanism that generated the data?), there are many opportunities to arrive at the wrong conclusion. So minimizing each type of error is key to convincing yourself and others that your ideas and research are sound.

##### Integer

**type summary:**

``` r
x<-as.integer(1)
typeof(x)           # integer
class(x)            # integer
mode(x)             # numeric
storage.mode(x)     # integer
object.size(x)      # 48 bytes
```

-   **size**: 4 bytes
-   **valid range:** *\[-2147483647, 2147483647\]*

I'm a skeptic. Let's see what happens when we break the "rules".

``` r
x<-2147483647
storage.mode(x)   
```

    ## [1] "double"

Whoops, R stores numeric values as a double by default. We have to force it to treat **x** as an integer by either using `1L` notation to create it or by changing how it is stored after we created it.

``` r
storage.mode(x)<-"integer"    # could have also used as.integer(x)
x
```

    ## [1] 2147483647

That works. What about the next largest integer?

``` r
y<-2147483647+1
storage.mode(y)<-"integer"    # generates warning
```

    ## Warning in storage.mode(y) <- "integer": NAs introduced by coercion to
    ## integer range

``` r
y                             # now NA
```

    ## [1] NA

Okay, I'm a believer now. We have not verified the lower bound, but I will let you check this on your own.

#### Complex

Complex types have their own mode and are not used often. However, you might see them pop-up in the results of decompositions. For example, the eigenvalues from an eigendecomposition may be complex in some cases.

**type summary:**

``` r
x<-1+3i
typeof(x)           # complex
class(x)            # complex
mode(x)             # complex
storage.mode(x)     # complex
object.size(x)      # 56 bytes
```

To get the real part, we can use `Re()` and for the imaginary part, `Im()`.

``` r
Re(x)
```

    ## [1] 2147483647

``` r
Im(x)
```

    ## [1] 0

If we use `as.double()`, it will work, but warn us if the imaginary part is non-zero.

``` r
as.double(x)
```

    ## [1] 2147483647

#### Logical

The logical mode has only one data type, also called logical. Logical data may be either `TRUE` or `FALSE`. Or in short-hand as `T` and `F`.

``` r
x<-TRUE
typeof(x)           # logical
class(x)            # logical
mode(x)             # logical
storage.mode(x)     # logical
object.size(x)      # 48 bytes
```

We will use logical data extensively for indexing, replacement, and testing the truth of statements.

### Data Structures

Data structures are special objects that act as collections of data types or of other data structures. In fact, all R data types are embedded within a data structure called a **vector**. The data stucture is what accounts for the difference between the output of `object.size()` and the size of the data itself. Even if we create a single value, R still treats this value as a vector of length 1. Since this wrapper around the data contains information (metadata) and provides functionality, it takes up space. However, the size of wrapper stays constant in most cases. So where *n* is the number of data points in the structure, you could think of the equation `object.size(x) = n * data.type.size + wrapper.size`.

R has several built-in data structures and I am going to present a few of them: `vector`, `factor`, `list`, `matrix`,`array`, and `data.frame`. However, you can also create your own data stuctures with object-oriented programming. Many authors take advantage of this feature when they write new packages. A few examples are `data.table` and `tibble`, which are extensions of a `data.frame`, and `Matrix`, which is an extension of `matrix` that allows for sparse representations (does not store zeros).

#### Vector

Since vectors are the most basic data structures, understanding them is the key to understanding R. Here are a few over-arching facts that distinguish vectors from other data structures:

-   Vectors are **homogeneous** with respect to the data type--all values they contain must be of the same data type.
-   Vectors are **dimensionless**. They are neither rows nor columns, but they do have `length()`. The concept of row and column "vectors" do exist, but they are called **arrays** in R.
-   Vectors may be used to **index** other vectors and data structures.
-   Vectors are **recycled** when they are shorter than the expected length (sometimes).
-   Logical and numeric vectors are automatically **coerced** to numeric types `logical -> integer -> double -> complex`, but directly coerced to character `logical - > character` and `numeric -> character`.

##### Creating vectors

Empty vectors may be created with `vector()` and get initialized with a default value.

``` r
vector("logical",5)       # creates a logical vector of length 5 (default=FALSE)
vector("integer",5)       # creates an integer vector of length 5 (default=0)
vector("double",5)        # creates a double vector of length 5 (default=0)
vector("complex",5)       # creates a complex vector of length 5 (default=0+0i)
vector("character",5)     # creates a character vector of length 5 (default="")
```

If we want a different default value, we can use `rep()` (repeat). However, we need to be careful with numeric values since `rep()` does not let us specify a mode.

``` r
rep(T,5)                  # creates a logical vector of length 5 (default=TRUE)
rep(as.integer(1),5)      # creates an integer vector of length 5 (default=1)
rep(1,5)                  # creates a double vector of length 5 (default=1)
rep(1+0i,5)               # creates a complex vector of length 5 (default=1+0i)
rep("hello!",5)           # creates a double vector of length 5 (default="hello!")
```

##### Creating patterns and sequences

We can also use `rep()` to create patterns by repeating longer vectors.

``` r
rep(c(T,F),3)             # a logical vector of length 6 with the pattern T,F,T,F...
```

    ## [1]  TRUE FALSE  TRUE FALSE  TRUE FALSE

Like sequences are generated with `seq(from,to,by)`, or its short-hand `from:to`, which assumes `by=1` or `by=-1` depending on the direction.

``` r
seq(0,1,.2)               # 0.0 0.2 0.4 0.6 0.8 1.0
seq(1,0,-.2)              # 1.0 0.8 0.6 0.4 0.2 0.0
(0:5)/5                   # 0.0 0.2 0.4 0.6 0.8 1.0
(5:0)/5                   # 1.0 0.8 0.6 0.4 0.2 0.0
```

##### Indexing

Every element in a vector is associated with a numeric index. For example, a vector of length `n>0` will have elements associated with `1:n`. By referencing these indexes, we can subset, expand, or replace values in the vector in myrad ways.

To demonstrate, let's play with a vector built-in to R called `letters`. This is just a character vector listing the alphabet, `a` to `z`.

I do not know what the 15th letter in the alphabet is off the top of my head, but I can find it easily:

``` r
letters[15]             # o
```

    ## [1] "o"

Or maybe we would like to know `which()` number corresponds to `q`:

``` r
which(letters=="q")     # 17
```

    ## [1] 17

The expression `letters=="q"` is a conditional that returns a logical vector the same length as `letters`. The function `which()` then returns the indices of the `TRUE` values in that vector.

##### Indexing to Select

We can also repeat indexes to retrieve a value multiple times.

``` r
letters[c(8,5,12,12,15)]     # "h" "e" "l" "l" "o"
```

    ## [1] "h" "e" "l" "l" "o"

##### Indexing to Order

Or to re-order elements.

``` r
letters[26:20]     # "z" "y" "x" "w" "v" "u" "t"
```

    ## [1] "z" "y" "x" "w" "v" "u" "t"

R has two functions to formalize ordering elements, `order()` and `sort()`.

``` r
order(letters,decreasing=T)[1:5]            # 26 25 24 23 22
```

    ## [1] 26 25 24 23 22

``` r
sort(letters,decreasing=T)[1:5]             # "z" "y" "x" "w" "v"
```

    ## [1] "z" "y" "x" "w" "v"

``` r
letters[order(letters,decreasing=T)[1:5]]   # "z" "y" "x" "w" "v"
```

    ## [1] "z" "y" "x" "w" "v"

##### Indexing to Exclude

We can also select elements by excluding the ones we do not want. To do this, we simply pass the negative of the indices that we do not want.

``` r
letters[-(1:19)]     # "t" "u" "v" "w" "x" "y" "z"
```

    ## [1] "t" "u" "v" "w" "x" "y" "z"

##### Indexing to Replace

Anything we can index, we can also replace.

``` r
y<-letters->z
y[letters <= "c"]<-c("x","y","z")
z[letters %in% c("a","e","i","o","u")]<-"vowel"
y
```

    ##  [1] "x" "y" "z" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q"
    ## [18] "r" "s" "t" "u" "v" "w" "x" "y" "z"

``` r
z
```

    ##  [1] "vowel" "b"     "c"     "d"     "vowel" "f"     "g"     "h"    
    ##  [9] "vowel" "j"     "k"     "l"     "m"     "n"     "vowel" "p"    
    ## [17] "q"     "r"     "s"     "t"     "vowel" "v"     "w"     "x"    
    ## [25] "y"     "z"

The latter example is an instance of **recycling**. R recycles the values of the shorter vector to fill the length of the ones selected for replacement. The only criteria is that the number of values to be replaced should be a multiple of the shorter replacement vector.

``` r
y<-1:10
y[1:6]<-1:2
y
```

    ##  [1]  1  2  1  2  1  2  7  8  9 10

##### Naming, Prefixing, and Selecting by Name

Elements of vectors can be named.

``` r
x<-letters
names(x)<-make.names(1:26)
x
```

    ##  X1  X2  X3  X4  X5  X6  X7  X8  X9 X10 X11 X12 X13 X14 X15 X16 X17 X18 
    ## "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" 
    ## X19 X20 X21 X22 X23 X24 X25 X26 
    ## "s" "t" "u" "v" "w" "x" "y" "z"

Once named, we can also select elements by the name associated with an element, or by its index.

``` r
x[c("X8","X5","X12","X12","X15")]   # "h" "e" "l" "l" "o"
x[c(8,5,12,12,15)]                  # "h" "e" "l" "l" "o"
```

We can also give the elements names as we create them.

``` r
c(a=1,b=2,c=3)
```

    ## a b c 
    ## 1 2 3

If we assign more than one value to a name, this happens.

``` r
c(a=1:3)
```

    ## a1 a2 a3 
    ##  1  2  3

So another way to create incremental names like those above is to think of the name as a prefix.

``` r
c(X=letters[1:5])
```

    ##  X1  X2  X3  X4  X5 
    ## "a" "b" "c" "d" "e"

If you want to include special characters in the name/prefix, you should use quotes.

``` r
c("letter_"=letters[1:5])
```

    ## letter_1 letter_2 letter_3 letter_4 letter_5 
    ##      "a"      "b"      "c"      "d"      "e"

##### Logical Subsetting

We saw above that `which()` operates on logical vectors to return the indices of `TRUE` elements. We could plug this index back into `letters` to get the values. However, a quicker way to this is to use the logical vector itself to select the elements that we want.

``` r
letters[which(letters=="q")]     # returns "q" by indexing
letters[letters=="q"]            # returns "q" by logical subsetting
```

We can also combine any number of logical statements to accomplish complex set operations.

``` r
letters[letters=="q" | letters=="t"]                            #  "q" OR "t" -> c("q","t")
letters[letters>="b" & letters<="d"]                            #  between "b" AND "d" -> c("b","c","d")
letters[letters %in% c("a","b") | letters %in% c("b","c")]      #  UNION of c("a","b") and c("b","c")
letters[letters %in% c("a","b") & letters %in% c("b","c")]      #  INTERSECTION of c("a","b") and c("b","c")
letters[letters %in% c("a","b") & !(letters %in% c("b","c")) ]  #  c("a","b") MINUS c("b","c")
```

Notice in the second example above since we can order character vectors, we can also operate on them with inequalities.

#### Arrays, Matrices, and Tensors

"An array in R can have one, two or more dimensions. It is simply a vector which is stored with additional attributes giving the dimensions (attribute 'dim')." - R Docs

Consider the following.

``` r
x<-1:8          # a vector (dimensionless)
dim(x)          # NULL
dim(x)<-c(1,8)  # make x a 1x8 array (row "vector")
dim(x)<-c(8,1)  # make x an 8x1 array (column "vector")
is.vector(x)    # FALSE
is.array(x)     # TRUE
is.matrix(x)     # TRUE
```

##### Creating Matrices

Starting from a vector again, we can also load matrices of arbitrary shapes. R will automatically load the vector into the matrix in **column-major** format (column by column).

``` r
x<-1:8
dim(x)<-c(2,4)
x
```

    ##      [,1] [,2] [,3] [,4]
    ## [1,]    1    3    5    7
    ## [2,]    2    4    6    8

Using `dim()` to assign the dimensions to a vector forces us give dimension that, when multiplied together, account for the length of the given vector. However, using `matrix()` or the more general `array()` allows us to take avantage of R recycling.

``` r
matrix(1:8,nrow=2)          # same as above, but only need to state either nrow or ncol since the other is implied
```

    ##      [,1] [,2] [,3] [,4]
    ## [1,]    1    3    5    7
    ## [2,]    2    4    6    8

``` r
matrix(1:4,nrow=2,ncol=4)   # stating both dimensions, we can use recycling
```

    ##      [,1] [,2] [,3] [,4]
    ## [1,]    1    3    1    3
    ## [2,]    2    4    2    4

``` r
array(1:8,dim=c(2,4))       # must say both dimensions when using array()
```

    ##      [,1] [,2] [,3] [,4]
    ## [1,]    1    3    5    7
    ## [2,]    2    4    6    8

``` r
array(1:4,dim=c(2,4))       # using recycling
```

    ##      [,1] [,2] [,3] [,4]
    ## [1,]    1    3    1    3
    ## [2,]    2    4    2    4

##### Indexing arrays

Indexing arrays is just like indexing a vector, except now we have arguments for each dimension in the array.

``` r
x<-matrix(1:24,nrow=4)  # create a 4x6 matrix
x[1,1]                  # returns the 1,1 element of the matrix
x[,c(5,6)]              # returns columns 5 and 6 as a 4x2 matrix
x[c(1,3),]              # returns rows 1 and 3 as a 2x6 matrix
x[1:3,1:3]              # returns the upper left block as a 3x3 matrix
```

##### Pointwise Operations

The same operators that you would use on a vector (`+`,`-`,`*`,`/`,`^`), also work between matrices of the same shape.

``` r
matrix(1:10,ncol=5) / matrix(10,ncol=5,nrow=2)
```

    ##      [,1] [,2] [,3] [,4] [,5]
    ## [1,]  0.1  0.3  0.5  0.7  0.9
    ## [2,]  0.2  0.4  0.6  0.8  1.0

##### Matrix Operations

The most common matrix operation include:

-   `%*%` : multiplication
-   `%o%` : outer product
-   `t()`: transpose
-   `diag()`: get the diagonal / create a diagonal matrix
-   `det()` : determinate
-   `upper.tri()`, `lower.tri()` : get the upper/lower triangle
-   `solve()` : to solve or compute inverse (solves against the identity matrix by default)

Despite being dimensionless, vectors may be multplied against matrices--R will coerce the vector to an array of the correct orientation.

``` r
A<-matrix(rnorm(9),nrow=3)  # generate a 3x3 matrix of standard normals
b<-1:3                      # vector of length 3
A %*% b                     # a 3x1 array 
b %*% A                     # a 1x3 array
solve(A,b)                  # returns the solution x from Ax=b
solve(A)                    # returns the solution x from Ax=1, ie. A inverse.
```

##### Tensors

Tensors are mathematical objects of arbitrary order. Most of the objects that you know from mathematics are types of tensors.

-   **scalars** : 0th order tensor
-   **vectors** : 1st order tensor
-   **matrices** : 2nd order tensors
-   **higher-order tensor** : 3rd order tensor and above

In R, arrays can represent tensors of 2nd order and higher.

``` r
x<-c(1:12,2*1:12)
dim(x)<-c(3,4,2)
x
```

    ## , , 1
    ## 
    ##      [,1] [,2] [,3] [,4]
    ## [1,]    1    4    7   10
    ## [2,]    2    5    8   11
    ## [3,]    3    6    9   12
    ## 
    ## , , 2
    ## 
    ##      [,1] [,2] [,3] [,4]
    ## [1,]    2    8   14   20
    ## [2,]    4   10   16   22
    ## [3,]    6   12   18   24

Or we could generate it with `array()` or by using the outer product `%*%` on the matrix that we want to duplicate across the third dimension.

``` r
array(c(1:12,2*1:12),dim=c(3,4,2))
```

    ## , , 1
    ## 
    ##      [,1] [,2] [,3] [,4]
    ## [1,]    1    4    7   10
    ## [2,]    2    5    8   11
    ## [3,]    3    6    9   12
    ## 
    ## , , 2
    ## 
    ##      [,1] [,2] [,3] [,4]
    ## [1,]    2    8   14   20
    ## [2,]    4   10   16   22
    ## [3,]    6   12   18   24

``` r
matrix(1:12,nrow=3) %o% c(1,2)
```

    ## , , 1
    ## 
    ##      [,1] [,2] [,3] [,4]
    ## [1,]    1    4    7   10
    ## [2,]    2    5    8   11
    ## [3,]    3    6    9   12
    ## 
    ## , , 2
    ## 
    ##      [,1] [,2] [,3] [,4]
    ## [1,]    2    8   14   20
    ## [2,]    4   10   16   22
    ## [3,]    6   12   18   24

##### Operations on Rows, Columns, Slices, and Fibers

``` r
# randomly generated instances of moving between states 'good','bad', and 'ugly'
M<-matrix(rpois(3^2,5),nrow=3,
    dimnames=list(c("good","bad","ugly"))[c(1,1)])  
M
```

    ##      good bad ugly
    ## good   10   9    2
    ## bad     2   4    4
    ## ugly    8   5    4

We might want to think about this data in terms of the probability of moving between each state. To do this we can simply normalize each row by its sum.

``` r
M / rowSums(M)
```

    ##           good       bad      ugly
    ## good 0.4761905 0.4285714 0.0952381
    ## bad  0.2000000 0.4000000 0.4000000
    ## ugly 0.4705882 0.2941176 0.2352941

R has `rowSums()` and `rowMeans()` and their column counterparts `colSums()` and `colMeans()` built-in. In addition, we can `apply()` any R function to a row or column of a matrix, or to any slice of a tensor. To demonstrate we could also write the operation above as follows:

``` r
M / apply(M,1,sum)    
```

    ##           good       bad      ugly
    ## good 0.4761905 0.4285714 0.0952381
    ## bad  0.2000000 0.4000000 0.4000000
    ## ugly 0.4705882 0.2941176 0.2352941

`apply()` takes three arguments:

1.  The **array**
2.  The **margin(s)** across which to apply the function.
3.  The **function** to be apply

The margins corresponds to the order of the array. See here for a visual description of [slices and fibers](http://buzzard.pugetsound.edu/courses/2014spring/420projects/ueltschi-html/3rd_order_slice_visual.png).

``` r
S<-array(1:(3*4*2),dim=c(3,4,2))    # a 3x4x2 tensor (two 3x4 matrices stacked front to back)
M<-S[,,1]                           # 3x4 matrix (the first frontal slice)
apply(M,1,sum)                      # sums over the rows 
apply(M,2,sum)                      # sums over the columns
apply(S,3,sum)                      # sums over the 2 frontal slices (returns length 2)
apply(S,2,sum)                      # sums over the 4 lateral slices (returns length 4)
apply(S,1,sum)                      # sums over the 3 horizontal slices (returns length 3)
apply(S,c(2,3),sum)                 # sums over column fibers (returns 4x2 matrix)
apply(S,c(1,3),sum)                 # sums over row fibers (returns 3x2 matrix)
apply(S,c(1,2),sum)                 # sums over tube fibers (returns 3x4 matrix)
```

It is well worth your time to study how `apply()` works on matrices, even if you do not end up using higher order tensors.

#### List

A **list** is a type of vector that can hold other data structures including other lists.

``` r
x<-list(letters[1:3],
        letters[4:6],
        letters[7:9])
x
```

    ## [[1]]
    ## [1] "a" "b" "c"
    ## 
    ## [[2]]
    ## [1] "d" "e" "f"
    ## 
    ## [[3]]
    ## [1] "g" "h" "i"

##### Indexing a list of elements

Since a list is a vector, selecting a list from a list is just like selecting a vector from a vector.

``` r
x[c(2,2,3)]     # a list containing elements 2, 2, and 3 from x
```

    ## [[1]]
    ## [1] "d" "e" "f"
    ## 
    ## [[2]]
    ## [1] "d" "e" "f"
    ## 
    ## [[3]]
    ## [1] "g" "h" "i"

##### Indexing a list of elements by name

If we name the elements, we can select by name as well.

``` r
names(x)<-c("one","two","three")
x[c("two","two","three")]
```

    ## $two
    ## [1] "d" "e" "f"
    ## 
    ## $two
    ## [1] "d" "e" "f"
    ## 
    ## $three
    ## [1] "g" "h" "i"

##### Indexing a child data structure

However, unlike vectors, since lists contain other data structures, accessing those individual data structures requires a slight tweek to the vector syntax syntax.

``` r
x[[1]]        # returns by index the vector inside the first element of x
```

    ## [1] "a" "b" "c"

``` r
x[["one"]]    # returns by name the vector inside the first element of x
```

    ## [1] "a" "b" "c"

List also have one additional way of indexing by name that is very convenient. If that name does not contain special character, we can also access it with `$`.

``` r
x$one
```

    ## [1] "a" "b" "c"

##### Flattening

Flattening is the process of taking a list and coercing it back into a single vector. To flatten in R, we use `unlist()`.

``` r
unlist(x)
```

    ##   one1   one2   one3   two1   two2   two3 three1 three2 three3 
    ##    "a"    "b"    "c"    "d"    "e"    "f"    "g"    "h"    "i"

Notice that flattening a named list creates the appropriate prefixes.

#### Factor

Factor is a data structure that is useful for organizing categories or items in a dataset and assigning each one a unique id.

**stucture summary:**

``` r
x<-factor("red")
typeof(x)           # integer
class(x)            # factor
mode(x)             # numeric
storage.mode(x)     # integer
object.size(x)      # 464 bytes
```

Above we gave `factor()` a character value that it stored as an integer but its object size is much larger than that of the integer type we used previously. What is going on?

To see the usefulness of a factor, we need to use `factor()` on a vector of more than a single value.

``` r
x<-factor(c("red","red","green","blue"))
x
```

    ## [1] red   red   green blue 
    ## Levels: blue green red

`factor()` took the vector of characters that we fed it, found the unique values (called **levels**) in the vector and created a map between those levels and vector of indices that correspond to the levels. We can retrieve both the indices and the levels from the factor.

``` r
levels(x)                 # gets the vector with the unique values
```

    ## [1] "blue"  "green" "red"

``` r
as.character(x)           # reassembles the original character vector that we factored
```

    ## [1] "red"   "red"   "green" "blue"

``` r
as.integer(x)             # gets the vector of IDs it assigned to each level
```

    ## [1] 3 3 2 1

Notice that R automatically arranged the levels in alphabetical order before assigning IDs--"red" maps to 3 even though it came first in the character vector.

An alternate way to reassemble the original character vector is with indexing.

``` r
levels(x)[as.integer(x)]
```

    ## [1] "red"   "red"   "green" "blue"

#### Data Frame

Data frames are the magic sweet spot of data structures. They will feel the most familiar to those who have previously used Stata, Excel, or some type of spreadsheet. A **data frame** shares the properties of both a **list** and a **matrix**. Like a list, the columns of a data frame may be of different data structures. And like a matrix, each column must be the same length.

**stucture summary:**

``` r
x<-data.frame()
typeof(x)           # integer
class(x)            # factor
mode(x)             # numeric
storage.mode(x)     # integer
object.size(x)      # 2016 bytes
```

##### Indexing

Because a data frame shares the properties of both a list and matrix, we can index using the notation from either data structure. The following examples behave the way we would expect.

``` r
x<-data.frame(x=letters[1:3],y=1:3,z=factor(c("do","re","mi")),stringsAsFactors=F)
x$x    
x[["y"]]
x[,"y"]
x[[3]]
x[,3]
x[c(1,3),]
```

One of the complaints that many people have with `data.frame()` is that it automatically factors character vectors unless we explicitly tell it otherwise. This can be done by setting `stringsAsFractors=F`. See the example above.

##### Data Frames with dplyr

The package [dplyr](https://github.com/hadley/dplyr) provides
