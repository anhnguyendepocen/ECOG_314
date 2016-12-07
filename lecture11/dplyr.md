Topics
------

In this lecture we will cover some of the main features of dplyr, a popular package for manipulating data frames. The package is Hadley Wickham's re-imagined plyr package (with underlying C++ secret sauce co-written by Romain Francois). plyr 2.0 if you will. It does less than plyr, but what it does it does more elegantly and much more quickly.

dplyr provides:

-   a set of functions for efficiently manipulating data sets, and
-   a grammar of data manipulation

Let's load the package.

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
help(dplyr)
```

Example data
------------

We will use these data sets to demonstrate the use of the dplyr tools

``` r
library(Lahman)
help(Lahman)
```

Each row in the Master data set represents one player

``` r
str(Master)
```

    ## 'data.frame':    18846 obs. of  26 variables:
    ##  $ playerID    : chr  "aardsda01" "aaronha01" "aaronto01" "aasedo01" ...
    ##  $ birthYear   : int  1981 1934 1939 1954 1972 1985 1854 1877 1869 1866 ...
    ##  $ birthMonth  : int  12 2 8 9 8 12 11 4 11 10 ...
    ##  $ birthDay    : int  27 5 5 8 25 17 4 15 11 14 ...
    ##  $ birthCountry: chr  "USA" "USA" "USA" "USA" ...
    ##  $ birthState  : chr  "CO" "AL" "AL" "CA" ...
    ##  $ birthCity   : chr  "Denver" "Mobile" "Mobile" "Orange" ...
    ##  $ deathYear   : int  NA NA 1984 NA NA NA 1905 1957 1962 1926 ...
    ##  $ deathMonth  : int  NA NA 8 NA NA NA 5 1 6 4 ...
    ##  $ deathDay    : int  NA NA 16 NA NA NA 17 6 11 27 ...
    ##  $ deathCountry: chr  NA NA "USA" NA ...
    ##  $ deathState  : chr  NA NA "GA" NA ...
    ##  $ deathCity   : chr  NA NA "Atlanta" NA ...
    ##  $ nameFirst   : chr  "David" "Hank" "Tommie" "Don" ...
    ##  $ nameLast    : chr  "Aardsma" "Aaron" "Aaron" "Aase" ...
    ##  $ nameGiven   : chr  "David Allan" "Henry Louis" "Tommie Lee" "Donald William" ...
    ##  $ weight      : int  220 180 190 190 184 220 192 170 175 169 ...
    ##  $ height      : int  75 72 75 75 73 73 72 71 71 68 ...
    ##  $ bats        : Factor w/ 3 levels "B","L","R": 3 3 3 3 2 2 3 3 3 2 ...
    ##  $ throws      : Factor w/ 2 levels "L","R": 2 2 2 2 1 1 2 2 2 1 ...
    ##  $ debut       : chr  "2004-04-06" "1954-04-13" "1962-04-10" "1977-07-26" ...
    ##  $ finalGame   : chr  "2015-08-23" "1976-10-03" "1971-09-26" "1990-10-03" ...
    ##  $ retroID     : chr  "aardd001" "aaroh101" "aarot101" "aased001" ...
    ##  $ bbrefID     : chr  "aardsda01" "aaronha01" "aaronto01" "aasedo01" ...
    ##  $ deathDate   : Date, format: NA NA "1984-08-16" NA ...
    ##  $ birthDate   : Date, format: "1981-12-27" "1934-02-05" "1939-08-05" "1954-09-08" ...

Each row in Batting represents one year of data for one player

``` r
str(Batting)
```

    ## 'data.frame':    101332 obs. of  22 variables:
    ##  $ playerID: chr  "abercda01" "addybo01" "allisar01" "allisdo01" ...
    ##  $ yearID  : int  1871 1871 1871 1871 1871 1871 1871 1871 1871 1871 ...
    ##  $ stint   : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ teamID  : Factor w/ 149 levels "ALT","ANA","ARI",..: 136 111 39 142 111 56 111 24 56 24 ...
    ##  $ lgID    : Factor w/ 7 levels "AA","AL","FL",..: 4 4 4 4 4 4 4 4 4 4 ...
    ##  $ G       : int  1 25 29 27 25 12 1 31 1 18 ...
    ##  $ AB      : int  4 118 137 133 120 49 4 157 5 86 ...
    ##  $ R       : int  0 30 28 28 29 9 0 66 1 13 ...
    ##  $ H       : int  0 32 40 44 39 11 1 63 1 13 ...
    ##  $ X2B     : int  0 6 4 10 11 2 0 10 1 2 ...
    ##  $ X3B     : int  0 0 5 2 3 1 0 9 0 1 ...
    ##  $ HR      : int  0 0 0 2 0 0 0 0 0 0 ...
    ##  $ RBI     : int  0 13 19 27 16 5 2 34 1 11 ...
    ##  $ SB      : int  0 8 3 1 6 0 0 11 0 1 ...
    ##  $ CS      : int  0 1 1 1 2 1 0 6 0 0 ...
    ##  $ BB      : int  0 4 2 0 2 0 1 13 0 0 ...
    ##  $ SO      : int  0 0 5 2 1 1 0 1 0 0 ...
    ##  $ IBB     : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ HBP     : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ SH      : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ SF      : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ GIDP    : int  NA NA NA NA NA NA NA NA NA NA ...

Each row in Batting represents one year of data for one player

``` r
str(Salaries)
```

    ## 'data.frame':    25575 obs. of  5 variables:
    ##  $ yearID  : int  1985 1985 1985 1985 1985 1985 1985 1985 1985 1985 ...
    ##  $ teamID  : Factor w/ 35 levels "ANA","ARI","ATL",..: 3 3 3 3 3 3 3 3 3 3 ...
    ##  $ lgID    : Factor w/ 2 levels "AL","NL": 2 2 2 2 2 2 2 2 2 2 ...
    ##  $ playerID: chr  "barkele01" "bedrost01" "benedbr01" "campri01" ...
    ##  $ salary  : int  870000 550000 545000 633333 625000 800000 150000 483333 772000 250000 ...

dplyr verbs
-----------

dplyr is built around 5 main functions.

Each function takes a data set as input, and returns a data set as output. Each function name is a "verb" that describes the specific action being performed on the data set

These verbs cover the most common data manipulation tasks

-   Select certain columns of data.
-   Filter your data to select specific rows.
-   Arrange the rows of your data into an order.
-   Mutate your data frame to contain new columns.
-   Summarize chunks of you data in some way.

Let's look at how those work.

Verb 1: Select
--------------

Include or exclude specific variables

The master table has 26 columns

``` r
dim(Master)
```

    ## [1] 18846    26

Include only a few variables by listing their names. Do not quote the variable names.

``` r
df <- select(Master, playerID, nameFirst, nameLast, birthYear, birthCountry, weight, height, bats, throws)

dim(df)
```

    ## [1] 18846     9

``` r
head(df)
```

    ##    playerID nameFirst nameLast birthYear birthCountry weight height bats throws
    ## 1 aardsda01     David  Aardsma      1981          USA    220     75    R      R
    ## 2 aaronha01      Hank    Aaron      1934          USA    180     72    R      R
    ## 3 aaronto01    Tommie    Aaron      1939          USA    190     75    R      R
    ## 4  aasedo01       Don     Aase      1954          USA    190     75    R      R
    ## 5  abadan01      Andy     Abad      1972          USA    184     73    L      L
    ## 6  abadfe01  Fernando     Abad      1985         D.R.    220     73    L      L

Exclude unwanted variables using a minus sign

``` r
df <- select(df, -playerID, -birthYear, -birthCountry)

dim(df)
```

    ## [1] 18846     6

``` r
head(df)
```

    ##   nameFirst nameLast weight height bats throws
    ## 1     David  Aardsma    220     75    R      R
    ## 2      Hank    Aaron    180     72    R      R
    ## 3    Tommie    Aaron    190     75    R      R
    ## 4       Don     Aase    190     75    R      R
    ## 5      Andy     Abad    184     73    L      L
    ## 6  Fernando     Abad    220     73    L      L

Verb 2: Filter
--------------

Include or exclude specific observations

The master table has 18846 rows

``` r
dim(Master)
```

    ## [1] 18846    26

Include only a few rows by writing a condition. Again do not quote the variable names.

``` r
df <- select(Master, playerID, nameFirst, nameLast, birthYear, birthCountry, weight, height, bats, throws)

dim(df)
```

    ## [1] 18846     9

``` r
df <- filter(df, birthYear >= 1990 & bats == "L")

dim(df)
```

    ## [1] 104   9

``` r
head(df)
```

    ##    playerID nameFirst nameLast birthYear birthCountry weight height bats throws
    ## 1 araujel01     Elvis   Araujo      1991    Venezuela    270     79    L      L
    ## 2 arciaos01   Oswaldo    Arcia      1991    Venezuela    225     72    L      R
    ## 3 ascheco01      Cody    Asche      1990          USA    200     73    L      R
    ## 4 averyxa01    Xavier    Avery      1990          USA    190     72    L      L
    ## 5  birdgr01      Greg     Bird      1992          USA    220     76    L      R
    ## 6  boydma01      Matt     Boyd      1991          USA    215     75    L      L

Verb 3: Arrange
---------------

Change the order of the observations

The Salaries data set comes sorted by year, team, and playerID

``` r
head(Salaries)
```

    ##   yearID teamID lgID  playerID salary
    ## 1   1985    ATL   NL barkele01 870000
    ## 2   1985    ATL   NL bedrost01 550000
    ## 3   1985    ATL   NL benedbr01 545000
    ## 4   1985    ATL   NL  campri01 633333
    ## 5   1985    ATL   NL ceronri01 625000
    ## 6   1985    ATL   NL chambch01 800000

Sort observations in ascending order by salary and year

``` r
df <- arrange(Salaries, salary, yearID)
head(df)
```

    ##   yearID teamID lgID  playerID salary
    ## 1   1993    NYA   AL jamesdi01      0
    ## 2   1999    PIT   NL martija02      0
    ## 3   1993    NYA   AL silveda01  10900
    ## 4   1994    CHA   AL  carych01  50000
    ## 5   1997    FLO   NL  penaal01  50000
    ## 6   1985    BAL   AL sheetla01  60000

Sort observations in descending order by salary and year

``` r
df <- arrange(Salaries, -salary, -yearID)
head(df)
```

    ##   yearID teamID lgID  playerID   salary
    ## 1   2010    NYA   AL rodrial01 33000000
    ## 2   2009    NYA   AL rodrial01 33000000
    ## 3   2015    LAN   NL kershcl01 32571000
    ## 4   2011    NYA   AL rodrial01 32000000
    ## 5   2012    NYA   AL rodrial01 30000000
    ## 6   2013    NYA   AL rodrial01 29000000

Verb 4: Mutate
--------------

Add new columns to a data set. Create a new value for every row

Compute one new variable: runs per game

``` r
df <- select(Batting, playerID, yearID, R, G)
dim(df)
```

    ## [1] 101332      4

``` r
df <- mutate(df, RPG = R/G)
dim(df)
```

    ## [1] 101332      5

``` r
head(df)
```

    ##    playerID yearID  R  G       RPG
    ## 1 abercda01   1871  0  1 0.0000000
    ## 2  addybo01   1871 30 25 1.2000000
    ## 3 allisar01   1871 28 29 0.9655172
    ## 4 allisdo01   1871 28 27 1.0370370
    ## 5 ansonca01   1871 29 25 1.1600000
    ## 6 armstbo01   1871  9 12 0.7500000

Add several new variables

-   runs per game for each player
-   home runs per game
-   bases stolen per game

And, change an existing variable

-   Make Runs negative

``` r
df <- select(Batting, playerID, yearID, HR, SB, R, G)
dim(df)
```

    ## [1] 101332      6

``` r
df <- mutate(df, 
                 RPG  = R/G,
                 HRPG = HR/G,
                 SBPG = SB/G,
                 R    = -1 * R)
dim(df)
```

    ## [1] 101332      9

``` r
head(df)
```

    ##    playerID yearID HR SB   R  G       RPG       HRPG       SBPG
    ## 1 abercda01   1871  0  0   0  1 0.0000000 0.00000000 0.00000000
    ## 2  addybo01   1871  0  8 -30 25 1.2000000 0.00000000 0.32000000
    ## 3 allisar01   1871  0  3 -28 29 0.9655172 0.00000000 0.10344828
    ## 4 allisdo01   1871  2  1 -28 27 1.0370370 0.07407407 0.03703704
    ## 5 ansonca01   1871  0  6 -29 25 1.1600000 0.00000000 0.24000000
    ## 6 armstbo01   1871  0  0  -9 12 0.7500000 0.00000000 0.00000000

Notice that the change to the Runs variable took effect last, otherwise the other variables we created would have been negative.

Verb 5: Summarise
-----------------

Create a new variable using data from multiple observations, reduce the number observations

Compute average height of players

``` r
df <- select(Master, height, weight)
dim(df)
```

    ## [1] 18846     2

``` r
df <- summarise(df, avg_height = mean(height, na.rm = TRUE))
dim(df)
```

    ## [1] 1 1

``` r
print(df)
```

    ##   avg_height
    ## 1   72.25575

Compute average height (in feet) and weight of players, along with standard deviation

``` r
df <- select(Master, height, weight)
dim(df)
```

    ## [1] 18846     2

``` r
df <- summarise(df, 
                   avg_height = mean(height, na.rm = TRUE) / 12,
                    sd_height = sd(height, na.rm = TRUE),
                   avg_weight = mean(weight, na.rm = TRUE),
                    sd_weight = sd(weight, na.rm = TRUE))
dim(df)
```

    ## [1] 1 4

``` r
print(df)
```

    ##   avg_height sd_height avg_weight sd_weight
    ## 1   6.021313  2.599121   185.9936  21.24189

Pipes
-----

dplyr provides another innovation over plyr: the ability to chain operations together in sequence with the pipe (%&gt;%) operator

The following examples are equivalent.

### Example Without pipes

Repeatedly input and output a data frame for each step

``` r
df <- select(Master, birthYear, bats, height, weight)
df <- filter(df, birthYear >= 1990 & bats == "L")
df <- summarise(df, avg_height = mean(height, na.rm = TRUE))
print(df)
```

    ##   avg_height
    ## 1   73.74038

### Example With pipes

The output from each step is used as the input for the next step

``` r
Master %>% 
    select(birthYear, bats, height, weight) %>%
    filter(birthYear >= 1990 & bats == "L") %>%
    summarise(avg_height = mean(height, na.rm = TRUE))
```

    ##   avg_height
    ## 1   73.74038

### Pipes explained

The "." is a special object that represents the output from the prior step

``` r
Master %>% 
    select(., birthYear, bats, height, weight) %>%
    filter(., birthYear >= 1990 & bats == "L") %>%
    summarise(., avg_height = mean(height, na.rm = TRUE)) 
```

    ##   avg_height
    ## 1   73.74038

Pipes replace nested function calls -- without them this would be the only way to avoid explicitly creating a temporary data set for each step.

``` r
summarise( 
          filter( 
                 select(
                        Master, 
                        birthYear, bats, height, weight), 
                 birthYear >= 1990 & bats == "L"), 
          avg_height = mean(height, na.rm = TRUE) 
        )
```

    ##   avg_height
    ## 1   73.74038

Now that we've seen how pipes work, we can use multiple "verbs" to get more useful results

Aggregate data
--------------

*group\_by* allows you to summarize data separately for subgroups of observations.

Aggregate by batter type: left handed, right handed, both, and unknown hitters

``` r
Master %>%
  group_by(bats) %>%
  summarise(player_count = n(),
              avg_height = mean(height, na.rm = TRUE) / 12,
              avg_weight = mean(weight, na.rm = TRUE))
```

    ## # A tibble: 4 × 4
    ##     bats player_count avg_height avg_weight
    ##   <fctr>        <int>      <dbl>      <dbl>
    ## 1      B         1163   5.970228   181.6837
    ## 2      L         4879   6.018697   185.7706
    ## 3      R        11614   6.038146   187.3638
    ## 4     NA         1190   5.796347   167.3507

Aggregate by year

``` r
Salaries %>%
  filter(yearID >= 2000) %>%
  group_by(yearID) %>%
  summarize(avg_salary = mean(salary, na.rm = TRUE),
             sd_salary = sd(salary, na.rm = TRUE),
            lowest = min(salary),
            highest = max(salary)) %>%
  data.frame()
```

    ##    yearID avg_salary sd_salary lowest  highest
    ## 1    2000    1992985   2517295 200000 15714286
    ## 2    2001    2279841   2907710 200000 22000000
    ## 3    2002    2392527   3070387 200000 22000000
    ## 4    2003    2573473   3481943 165574 22000000
    ## 5    2004    2491776   3545170 300000 22500000
    ## 6    2005    2633831   3631631 300000 26000000
    ## 7    2006    2834521   3778385 327000 21680727
    ## 8    2007    2941436   3810572 380000 23428571
    ## 9    2008    3136517   4193269 390000 28000000
    ## 10   2009    3277647   4371688 400000 33000000
    ## 11   2010    3278747   4461190 400000 33000000
    ## 12   2011    3318838   4541140 414000 32000000
    ## 13   2012    3458421   4710311 480000 30000000
    ## 14   2013    3723344   4963773 480000 29000000
    ## 15   2014    3980446   5155339 500000 26000000
    ## 16   2015    4301276   5506178 507000 32571000

How do I save output from a pipe?
---------------------------------

Assign it to an object

``` r
df <- Master %>%
          group_by(bats) %>%
          summarise(player_count = n(),
                      avg_height = mean(height, na.rm = TRUE) / 12,
                      avg_weight = mean(weight, na.rm = TRUE)) 

print(df)
```

    ## # A tibble: 4 × 4
    ##     bats player_count avg_height avg_weight
    ##   <fctr>        <int>      <dbl>      <dbl>
    ## 1      B         1163   5.970228   181.6837
    ## 2      L         4879   6.018697   185.7706
    ## 3      R        11614   6.038146   187.3638
    ## 4     NA         1190   5.796347   167.3507

Joins
-----

Let's look at players born in 1990 or later and compare the salaries of left vs right-handed hitters

``` r
players <- Master %>% 
               select(playerID, nameFirst, nameLast, birthYear, bats) %>%
               filter(birthYear >= 1990)

pay <- Salaries %>%
           select(playerID, yearID, salary) %>%
           mutate(salary = round(salary / 1000000, digits = 2)) %>%
           group_by(playerID) %>%
           summarize(avg_salary = mean(salary, na.rm= TRUE),
                     min_salary = min(salary),
                     max_salary = max(salary))
               
dim(players)
```

    ## [1] 368   5

``` r
dim(pay)           
```

    ## [1] 4963    4

``` r
df <- left_join(players, pay, by = "playerID") 
dim(df)
```

    ## [1] 368   8

``` r
head(df)
```

    ##    playerID nameFirst  nameLast birthYear bats avg_salary min_salary max_salary
    ## 1 adamecr01 Cristhian    Adames      1991    B         NA         NA         NA
    ## 2 aguilje01     Jesus   Aguilar      1990    R         NA         NA         NA
    ## 3 ahmedni01      Nick     Ahmed      1990    R       0.51       0.51       0.51
    ## 4 alberha01    Hanser   Alberto      1992    R         NA         NA         NA
    ## 5 alcanar01 Arismendy Alcantara      1991    B       0.51       0.51       0.51
    ## 6 almonmi01    Miguel   Almonte      1993    R         NA         NA         NA

``` r
left_join(players, pay, by = "playerID") %>%
    group_by(bats) %>%
    summarize(avg_high_salary = mean(max_salary, na.rm= TRUE))
```

    ## # A tibble: 3 × 2
    ##     bats avg_high_salary
    ##   <fctr>           <dbl>
    ## 1      B       0.5558333
    ## 2      L       0.6090476
    ## 3      R       1.0881707

Other functions
---------------

dplyr also provides a function glimpse() that makes it easy to look at our data in a transposed view. It's similar to the str() (structure) function, but has a few advantages (see ?glimpse).

``` r
glimpse(Salaries)
```

    ## Observations: 25,575
    ## Variables: 5
    ## $ yearID   <int> 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985, 1985...
    ## $ teamID   <fctr> ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, ATL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BAL, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, BOS, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CAL, CHA,...
    ## $ lgID     <fctr> NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, AL, NL, NL, NL, NL, N...
    ## $ playerID <chr> "barkele01", "bedrost01", "benedbr01", "campri01", "ceronri01", "chambch01", "dedmoje01", "forstte01", "garbege01", "harpete01", "hornebo01", "hubbagl01", "mahleri01", "mcmurcr01", "mumphje01", "murphda05", "oberkke01", "perezpa01", "perryge01", "ramirra01", "suttebr01", "washicl01", "boddimi01", "dauerri01", "davisst02", "dempsri01", "dwyerji01", "flanami01", "fordda01", "grosswa01", "lacyle01", "lynnfr01", "martide01", "martiti01", "mcgresc01", "murraed02", "nolanjo01", "rayfofl01", ...
    ## $ salary   <int> 870000, 550000, 545000, 633333, 625000, 800000, 150000, 483333, 772000, 250000, 1500000, 455000, 407500, 275000, 775000, 1625000, 616667, 450000, 120000, 750000, 1354167, 800000, 625000, 480000, 437500, 512500, 375000, 641667, 450000, 483333, 725000, 1090000, 560000, 440000, 547143, 1472819, 341667, 128500, 800000, 558333, 60000, 130000, 581250, 121000, 915000, 272500, 1000000, 115000, 177500, 747500, 580000, 140000, 160000, 650000, 800000, 477500, 130000, 335000, 300000, 125000, 37000...

Conclusion
----------

dplyr makes easier to write clear working code--which allows you to focus on the details of your data analysis.

For more info
-------------

#### One-page cheatsheet

<https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf>

#### Explanations from creator

<http://r4ds.had.co.nz/transform.html>

#### Free online training

<https://www.datacamp.com/courses/dplyr-data-manipulation-r-tutorial>
