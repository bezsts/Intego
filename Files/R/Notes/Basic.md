# Workflow: basics

## Using packages

```r
install.packages('dplyr')

library(dplyr)

dplyr::select()
```

## Working directory

```r
# print current working directory
getwd()

# set a new working directory
setwd("my/new/path")

# get the list of files in the working directory
dir()

# cross-platform way to define a path
file.path("my", "current", "path", "my_file.csv")

# list the names of the objects in an environment
ls()

# delete an object
rm("my_var")

# delete all objects
rm(list = ls())
```

## Data Import

```R
# CSV
library(readr)
dm_readr <- read_csv(file.path("data", "dm.csv"))
write_csv(dm, file.path("data", "dm.csv"))

dm_readr <- read_csv(
     file.path("data", "dm.csv"),
     col_select = -1,
     col_types = cols(
     SUBJID = col_integer(),
     RFSTDTC = col_character(), # keeping date cols as character
     RFENDTC = col_character()
     )
)

# RDS
readr::write_rds() # writing an .rds file
readr::read_rds() # reading an .rds file

# SAS
library(haven)
library(admiral)

write_sas(dm, file.path("data", "dm.sas7bdat"))
dm_sas <- read_sas(file.path(raw_data_path, "dm.sas7bdat")) %>% 
  convert_blanks_to_na()

write_xpt()
read_xpt()

```

## Variable assignment

```r
x <- 3 * 4
a <- 'apple'
```

## Operators

```r
> greater than
>= greater than or equal to
< less than 
<= less than or equal to 
== equal to 
!= not equal to 

& and 
| or
%in% range
```

## Vectors

```r
c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

1:10

seq(1, 10)
```
    [1]  1  2  3  4  5  6  7  8  9 10
```r
primes <- c(2, 3, 5, 7, 11, 13)

primes * 2

primes - 1
```
     [1]  4  6 10 14 22 26

     [1]  1  2  4  6 10 12

## Comments

```r
# this is comment

# important to write why, but not what and when
```
