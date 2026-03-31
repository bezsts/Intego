# Data transformation

```r
library(nycflights13)
library(tidyverse)
```

## Rows

### filter()

```r
flights %>% 
  filter(dep_delay > 120)
```

    # A tibble: 9,723 × 19
        year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
       <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
     1  2013     1     1      848           1835       853     1001           1950
     2  2013     1     1      957            733       144     1056            853
     3  2013     1     1     1114            900       134     1447           1222
     4  2013     1     1     1540           1338       122     2020           1825
     5  2013     1     1     1815           1325       290     2120           1542
     6  2013     1     1     1842           1422       260     1958           1535
     7  2013     1     1     1856           1645       131     2212           2005
     8  2013     1     1     1934           1725       129     2126           1855
     9  2013     1     1     1938           1703       155     2109           1823
    10  2013     1     1     1942           1705       157     2124           1830
    # ℹ 9,713 more rows
    # ℹ 11 more variables: arr_delay <dbl>, carrier <chr>, flight <int>,
    #   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
    #   hour <dbl>, minute <dbl>, time_hour <dttm>

### arrange()

Sort rows based on the value of the columns

```r
flights %>% 
  arrange(year, month, day, dep_time)
```

    # A tibble: 336,776 × 19
        year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
       <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
     1  2013     1     1      517            515         2      830            819
     2  2013     1     1      533            529         4      850            830
     3  2013     1     1      542            540         2      923            850
     4  2013     1     1      544            545        -1     1004           1022
     5  2013     1     1      554            600        -6      812            837
     6  2013     1     1      554            558        -4      740            728
     7  2013     1     1      555            600        -5      913            854
     8  2013     1     1      557            600        -3      709            723
     9  2013     1     1      557            600        -3      838            846
    10  2013     1     1      558            600        -2      753            745
    # ℹ 336,766 more rows
    # ℹ 11 more variables: arr_delay <dbl>, carrier <chr>, flight <int>,
    #   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
    #   hour <dbl>, minute <dbl>, time_hour <dttm>

```r
flights %>% 
  arrange(desc(dep_delay))
```

    # A tibble: 336,776 × 19
        year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
       <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
     1  2013     1     9      641            900      1301     1242           1530
     2  2013     6    15     1432           1935      1137     1607           2120
     3  2013     1    10     1121           1635      1126     1239           1810
     4  2013     9    20     1139           1845      1014     1457           2210
     5  2013     7    22      845           1600      1005     1044           1815
     6  2013     4    10     1100           1900       960     1342           2211
     7  2013     3    17     2321            810       911      135           1020
     8  2013     6    27      959           1900       899     1236           2226
     9  2013     7    22     2257            759       898      121           1026
    10  2013    12     5      756           1700       896     1058           2020
    # ℹ 336,766 more rows
    # ℹ 11 more variables: arr_delay <dbl>, carrier <chr>, flight <int>,
    #   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
    #   hour <dbl>, minute <dbl>, time_hour <dttm>

### distinct()

```r
flights %>%  
  distinct()
```

    # A tibble: 336,776 × 19
        year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
       <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
     1  2013     1     1      517            515         2      830            819
     2  2013     1     1      533            529         4      850            830
     3  2013     1     1      542            540         2      923            850
     4  2013     1     1      544            545        -1     1004           1022
     5  2013     1     1      554            600        -6      812            837
     6  2013     1     1      554            558        -4      740            728
     7  2013     1     1      555            600        -5      913            854
     8  2013     1     1      557            600        -3      709            723
     9  2013     1     1      557            600        -3      838            846
    10  2013     1     1      558            600        -2      753            745
    # ℹ 336,766 more rows
    # ℹ 11 more variables: arr_delay <dbl>, carrier <chr>, flight <int>,
    #   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
    #   hour <dbl>, minute <dbl>, time_hour <dttm>

```r
flights %>% 
  distinct(origin, dest)
```

    # A tibble: 224 × 2
       origin dest 
       <chr>  <chr>
     1 EWR    IAH  
     2 LGA    IAH  
     3 JFK    MIA  
     4 JFK    BQN  
     5 LGA    ATL  
     6 EWR    ORD  
     7 EWR    FLL  
     8 LGA    IAD  
     9 JFK    MCO  
    10 LGA    ORD  
    # ℹ 214 more rows

```r
flights %>% 
  distinct(origin, dest, .keep_all = TRUE)
```

    # A tibble: 224 × 19
        year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
       <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
     1  2013     1     1      517            515         2      830            819
     2  2013     1     1      533            529         4      850            830
     3  2013     1     1      542            540         2      923            850
     4  2013     1     1      544            545        -1     1004           1022
     5  2013     1     1      554            600        -6      812            837
     6  2013     1     1      554            558        -4      740            728
     7  2013     1     1      555            600        -5      913            854
     8  2013     1     1      557            600        -3      709            723
     9  2013     1     1      557            600        -3      838            846
    10  2013     1     1      558            600        -2      753            745
    # ℹ 214 more rows
    # ℹ 11 more variables: arr_delay <dbl>, carrier <chr>, flight <int>,
    #   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
    #   hour <dbl>, minute <dbl>, time_hour <dttm>

## Columns

### mutate()

```r
flights %>%  
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  )
```

    # A tibble: 336,776 × 21
        gain speed  year month   day dep_time sched_dep_time dep_delay arr_time
       <dbl> <dbl> <int> <int> <int>    <int>          <int>     <dbl>    <int>
     1    -9  370.  2013     1     1      517            515         2      830
     2   -16  374.  2013     1     1      533            529         4      850
     3   -31  408.  2013     1     1      542            540         2      923
     4    17  517.  2013     1     1      544            545        -1     1004
     5    19  394.  2013     1     1      554            600        -6      812
     6   -16  288.  2013     1     1      554            558        -4      740
     7   -24  404.  2013     1     1      555            600        -5      913
     8    11  259.  2013     1     1      557            600        -3      709
     9     5  405.  2013     1     1      557            600        -3      838
    10   -10  319.  2013     1     1      558            600        -2      753
    # ℹ 336,766 more rows
    # ℹ 12 more variables: sched_arr_time <int>, arr_delay <dbl>, carrier <chr>,
    #   flight <int>, tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>,
    #   distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>

```r
flights %>% 
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )
```

    # A tibble: 336,776 × 6
       dep_delay arr_delay air_time  gain hours gain_per_hour
           <dbl>     <dbl>    <dbl> <dbl> <dbl>         <dbl>
     1         2        11      227    -9 3.78          -2.38
     2         4        20      227   -16 3.78          -4.23
     3         2        33      160   -31 2.67         -11.6 
     4        -1       -18      183    17 3.05           5.57
     5        -6       -25      116    19 1.93           9.83
     6        -4        12      150   -16 2.5           -6.4 
     7        -5        19      158   -24 2.63          -9.11
     8        -3       -14       53    11 0.883         12.5 
     9        -3        -8      140     5 2.33           2.14
    10        -2         8      138   -10 2.3           -4.35
    # ℹ 336,766 more rows

### select()

```r
flights %>% 
  select(year, month, day)
```

    # A tibble: 336,776 × 3
        year month   day
       <int> <int> <int>
     1  2013     1     1
     2  2013     1     1
     3  2013     1     1
     4  2013     1     1
     5  2013     1     1
     6  2013     1     1
     7  2013     1     1
     8  2013     1     1
     9  2013     1     1
    10  2013     1     1
    # ℹ 336,766 more rows

```r
flights %>% 
  select(year:day)
```

    # A tibble: 336,776 × 3
        year month   day
       <int> <int> <int>
     1  2013     1     1
     2  2013     1     1
     3  2013     1     1
     4  2013     1     1
     5  2013     1     1
     6  2013     1     1
     7  2013     1     1
     8  2013     1     1
     9  2013     1     1
    10  2013     1     1
    # ℹ 336,766 more rows

```r
flights %>% 
  select(!year:day)
```

    # A tibble: 336,776 × 16
       dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay carrier
          <int>          <int>     <dbl>    <int>          <int>     <dbl> <chr>  
     1      517            515         2      830            819        11 UA     
     2      533            529         4      850            830        20 UA     
     3      542            540         2      923            850        33 AA     
     4      544            545        -1     1004           1022       -18 B6     
     5      554            600        -6      812            837       -25 DL     
     6      554            558        -4      740            728        12 UA     
     7      555            600        -5      913            854        19 B6     
     8      557            600        -3      709            723       -14 EV     
     9      557            600        -3      838            846        -8 B6     
    10      558            600        -2      753            745         8 AA     
    # ℹ 336,766 more rows
    # ℹ 9 more variables: flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
    #   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>

```r
flights %>% 
  select(where(is.character))
```

    # A tibble: 336,776 × 4
       carrier tailnum origin dest 
       <chr>   <chr>   <chr>  <chr>
     1 UA      N14228  EWR    IAH  
     2 UA      N24211  LGA    IAH  
     3 AA      N619AA  JFK    MIA  
     4 B6      N804JB  JFK    BQN  
     5 DL      N668DN  LGA    ATL  
     6 UA      N39463  EWR    ORD  
     7 B6      N516JB  EWR    FLL  
     8 EV      N829AS  LGA    IAD  
     9 B6      N593JB  JFK    MCO  
    10 AA      N3ALAA  LGA    ORD  
    # ℹ 336,766 more rows

```r
flights %>%
  select(starts_with("dep") | starts_with("arr"))
```

    # A tibble: 336,776 × 4
       dep_time dep_delay arr_time arr_delay
          <int>     <dbl>    <int>     <dbl>
     1      517         2      830        11
     2      533         4      850        20
     3      542         2      923        33
     4      544        -1     1004       -18
     5      554        -6      812       -25
     6      554        -4      740        12
     7      555        -5      913        19
     8      557        -3      709       -14
     9      557        -3      838        -8
    10      558        -2      753         8
    # ℹ 336,766 more rows

```r
flights %>% 
  select(ends_with("delay") | ends_with("time"))
```

    # A tibble: 336,776 × 7
       dep_delay arr_delay dep_time sched_dep_time arr_time sched_arr_time air_time
           <dbl>     <dbl>    <int>          <int>    <int>          <int>    <dbl>
     1         2        11      517            515      830            819      227
     2         4        20      533            529      850            830      227
     3         2        33      542            540      923            850      160
     4        -1       -18      544            545     1004           1022      183
     5        -6       -25      554            600      812            837      116
     6        -4        12      554            558      740            728      150
     7        -5        19      555            600      913            854      158
     8        -3       -14      557            600      709            723       53
     9        -3        -8      557            600      838            846      140
    10        -2         8      558            600      753            745      138
    # ℹ 336,766 more rows

```r
flights %>% 
  select(contains("time"))
```

    # A tibble: 336,776 × 6
       dep_time sched_dep_time arr_time sched_arr_time air_time time_hour          
          <int>          <int>    <int>          <int>    <dbl> <dttm>             
     1      517            515      830            819      227 2013-01-01 05:00:00
     2      533            529      850            830      227 2013-01-01 05:00:00
     3      542            540      923            850      160 2013-01-01 05:00:00
     4      544            545     1004           1022      183 2013-01-01 05:00:00
     5      554            600      812            837      116 2013-01-01 06:00:00
     6      554            558      740            728      150 2013-01-01 05:00:00
     7      555            600      913            854      158 2013-01-01 06:00:00
     8      557            600      709            723       53 2013-01-01 06:00:00
     9      557            600      838            846      140 2013-01-01 06:00:00
    10      558            600      753            745      138 2013-01-01 06:00:00
    # ℹ 336,766 more rows

```r
flights_race <- flights %>% 
  mutate(race1 = "WHITE", race2 = "BLACK", race3 = "ASIAN", race4 = "LATINO", race5 = "PACIFIC", .before = 1)

flights_race %>% 
  select(num_range("race", 1:5))
```

    # A tibble: 336,776 × 5
       race1 race2 race3 race4  race5  
       <chr> <chr> <chr> <chr>  <chr>  
     1 WHITE BLACK ASIAN LATINO PACIFIC
     2 WHITE BLACK ASIAN LATINO PACIFIC
     3 WHITE BLACK ASIAN LATINO PACIFIC
     4 WHITE BLACK ASIAN LATINO PACIFIC
     5 WHITE BLACK ASIAN LATINO PACIFIC
     6 WHITE BLACK ASIAN LATINO PACIFIC
     7 WHITE BLACK ASIAN LATINO PACIFIC
     8 WHITE BLACK ASIAN LATINO PACIFIC
     9 WHITE BLACK ASIAN LATINO PACIFIC
    10 WHITE BLACK ASIAN LATINO PACIFIC
    # ℹ 336,766 more rows

```r
# rename
flights %>% 
  select(tail_num = tailnum)
```

    # A tibble: 336,776 × 1
       tail_num
       <chr>   
     1 N14228  
     2 N24211  
     3 N619AA  
     4 N804JB  
     5 N668DN  
     6 N39463  
     7 N516JB  
     8 N829AS  
     9 N593JB  
    10 N3ALAA  
    # ℹ 336,766 more rows

### rename()

```r
flights %>% 
  rename(tail_num = tailnum)
```

    # A tibble: 336,776 × 19
        year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
       <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
     1  2013     1     1      517            515         2      830            819
     2  2013     1     1      533            529         4      850            830
     3  2013     1     1      542            540         2      923            850
     4  2013     1     1      544            545        -1     1004           1022
     5  2013     1     1      554            600        -6      812            837
     6  2013     1     1      554            558        -4      740            728
     7  2013     1     1      555            600        -5      913            854
     8  2013     1     1      557            600        -3      709            723
     9  2013     1     1      557            600        -3      838            846
    10  2013     1     1      558            600        -2      753            745
    # ℹ 336,766 more rows
    # ℹ 11 more variables: arr_delay <dbl>, carrier <chr>, flight <int>,
    #   tail_num <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
    #   hour <dbl>, minute <dbl>, time_hour <dttm>

### relocate()

```r
flights %>% 
  relocate(time_hour, air_time)
```

    # A tibble: 336,776 × 19
       time_hour           air_time  year month   day dep_time sched_dep_time
       <dttm>                 <dbl> <int> <int> <int>    <int>          <int>
     1 2013-01-01 05:00:00      227  2013     1     1      517            515
     2 2013-01-01 05:00:00      227  2013     1     1      533            529
     3 2013-01-01 05:00:00      160  2013     1     1      542            540
     4 2013-01-01 05:00:00      183  2013     1     1      544            545
     5 2013-01-01 06:00:00      116  2013     1     1      554            600
     6 2013-01-01 05:00:00      150  2013     1     1      554            558
     7 2013-01-01 06:00:00      158  2013     1     1      555            600
     8 2013-01-01 06:00:00       53  2013     1     1      557            600
     9 2013-01-01 06:00:00      140  2013     1     1      557            600
    10 2013-01-01 06:00:00      138  2013     1     1      558            600
    # ℹ 336,766 more rows
    # ℹ 12 more variables: dep_delay <dbl>, arr_time <int>, sched_arr_time <int>,
    #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>, origin <chr>,
    #   dest <chr>, distance <dbl>, hour <dbl>, minute <dbl>

```r
flights %>% 
  relocate(year:dep_time, .after = time_hour)
```

    # A tibble: 336,776 × 19
       sched_dep_time dep_delay arr_time sched_arr_time arr_delay carrier flight
                <int>     <dbl>    <int>          <int>     <dbl> <chr>    <int>
     1            515         2      830            819        11 UA        1545
     2            529         4      850            830        20 UA        1714
     3            540         2      923            850        33 AA        1141
     4            545        -1     1004           1022       -18 B6         725
     5            600        -6      812            837       -25 DL         461
     6            558        -4      740            728        12 UA        1696
     7            600        -5      913            854        19 B6         507
     8            600        -3      709            723       -14 EV        5708
     9            600        -3      838            846        -8 B6          79
    10            600        -2      753            745         8 AA         301
    # ℹ 336,766 more rows
    # ℹ 12 more variables: tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>,
    #   distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>, year <int>,
    #   month <int>, day <int>, dep_time <int>

```r
flights %>% 
  relocate(starts_with("arr"), .before = dep_time)
```

    # A tibble: 336,776 × 19
        year month   day arr_time arr_delay dep_time sched_dep_time dep_delay
       <int> <int> <int>    <int>     <dbl>    <int>          <int>     <dbl>
     1  2013     1     1      830        11      517            515         2
     2  2013     1     1      850        20      533            529         4
     3  2013     1     1      923        33      542            540         2
     4  2013     1     1     1004       -18      544            545        -1
     5  2013     1     1      812       -25      554            600        -6
     6  2013     1     1      740        12      554            558        -4
     7  2013     1     1      913        19      555            600        -5
     8  2013     1     1      709       -14      557            600        -3
     9  2013     1     1      838        -8      557            600        -3
    10  2013     1     1      753         8      558            600        -2
    # ℹ 336,766 more rows
    # ℹ 11 more variables: sched_arr_time <int>, carrier <chr>, flight <int>,
    #   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
    #   hour <dbl>, minute <dbl>, time_hour <dttm>

## Groups

### group_by()

```r
flights %>% 
  group_by(month)
```

    # A tibble: 336,776 × 19
    # Groups:   month [12]
        year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
       <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
     1  2013     1     1      517            515         2      830            819
     2  2013     1     1      533            529         4      850            830
     3  2013     1     1      542            540         2      923            850
     4  2013     1     1      544            545        -1     1004           1022
     5  2013     1     1      554            600        -6      812            837
     6  2013     1     1      554            558        -4      740            728
     7  2013     1     1      555            600        -5      913            854
     8  2013     1     1      557            600        -3      709            723
     9  2013     1     1      557            600        -3      838            846
    10  2013     1     1      558            600        -2      753            745
    # ℹ 336,766 more rows
    # ℹ 11 more variables: arr_delay <dbl>, carrier <chr>, flight <int>,
    #   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
    #   hour <dbl>, minute <dbl>, time_hour <dttm>

```r
daily <- flights %>%  
  group_by(year, month, day)
daily
```

    # A tibble: 336,776 × 19
    # Groups:   year, month, day [365]
        year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
       <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
     1  2013     1     1      517            515         2      830            819
     2  2013     1     1      533            529         4      850            830
     3  2013     1     1      542            540         2      923            850
     4  2013     1     1      544            545        -1     1004           1022
     5  2013     1     1      554            600        -6      812            837
     6  2013     1     1      554            558        -4      740            728
     7  2013     1     1      555            600        -5      913            854
     8  2013     1     1      557            600        -3      709            723
     9  2013     1     1      557            600        -3      838            846
    10  2013     1     1      558            600        -2      753            745
    # ℹ 336,766 more rows
    # ℹ 11 more variables: arr_delay <dbl>, carrier <chr>, flight <int>,
    #   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
    #   hour <dbl>, minute <dbl>, time_hour <dttm>

```r
daily %>% 
  ungroup()
```

    # A tibble: 336,776 × 19
        year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
       <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
     1  2013     1     1      517            515         2      830            819
     2  2013     1     1      533            529         4      850            830
     3  2013     1     1      542            540         2      923            850
     4  2013     1     1      544            545        -1     1004           1022
     5  2013     1     1      554            600        -6      812            837
     6  2013     1     1      554            558        -4      740            728
     7  2013     1     1      555            600        -5      913            854
     8  2013     1     1      557            600        -3      709            723
     9  2013     1     1      557            600        -3      838            846
    10  2013     1     1      558            600        -2      753            745
    # ℹ 336,766 more rows
    # ℹ 11 more variables: arr_delay <dbl>, carrier <chr>, flight <int>,
    #   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
    #   hour <dbl>, minute <dbl>, time_hour <dttm>

```r
flights %>% 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = month
  )
```

    # A tibble: 12 × 3
       month delay     n
       <int> <dbl> <int>
     1     1 10.0  27004
     2    10  6.24 28889
     3    11  5.44 27268
     4    12 16.6  28135
     5     2 10.8  24951
     6     3 13.2  28834
     7     4 13.9  28330
     8     5 13.0  28796
     9     6 20.8  28243
    10     7 21.7  29425
    11     8 12.6  29327
    12     9  6.72 27574

```r
flights %>% 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = c(origin, dest)
  )
```

    # A tibble: 224 × 4
       origin dest  delay     n
       <chr>  <chr> <dbl> <int>
     1 EWR    IAH   11.8   3973
     2 LGA    IAH    9.06  2951
     3 JFK    MIA    9.34  3314
     4 JFK    BQN    6.67   599
     5 LGA    ATL   11.4  10263
     6 EWR    ORD   14.6   6100
     7 EWR    FLL   13.5   3793
     8 LGA    IAD   16.7   1803
     9 JFK    MCO   10.6   5464
    10 LGA    ORD   10.7   8857
    # ℹ 214 more rows

### summarize()

```r
flights %>% 
  group_by(month) %>% 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  )
```

    # A tibble: 12 × 3
       month avg_delay     n
       <int>     <dbl> <int>
     1     1     10.0  27004
     2     2     10.8  24951
     3     3     13.2  28834
     4     4     13.9  28330
     5     5     13.0  28796
     6     6     20.8  28243
     7     7     21.7  29425
     8     8     12.6  29327
     9     9      6.72 27574
    10    10      6.24 28889
    11    11      5.44 27268
    12    12     16.6  28135

### slice\_

```r
flights %>% 
  group_by(dest) %>% 
  slice_max(arr_delay, n = 1) %>% 
  select(dest, arr_delay)
```

    # A tibble: 108 × 2
    # Groups:   dest [105]
       dest  arr_delay
       <chr>     <dbl>
     1 ABQ         153
     2 ACK         221
     3 ALB         328
     4 ANC          39
     5 ATL         895
     6 AUS         349
     7 AVL         228
     8 BDL         266
     9 BGR         238
    10 BHM         291
    # ℹ 98 more rows

```r
flights %>% 
  group_by(dest) %>% 
  slice_min(arr_delay, n = 1) %>% 
  select(dest, arr_delay)
```

    # A tibble: 115 × 2
    # Groups:   dest [105]
       dest  arr_delay
       <chr>     <dbl>
     1 ABQ         -61
     2 ACK         -25
     3 ALB         -34
     4 ANC         -47
     5 ATL         -49
     6 AUS         -59
     7 AVL         -29
     8 AVL         -29
     9 BDL         -43
    10 BGR         -43
    # ℹ 105 more rows

```r
flights %>% 
  group_by(dest) %>% 
  slice_head(n = 1) %>% 
  select(dest, arr_delay)
```

    # A tibble: 105 × 2
    # Groups:   dest [105]
       dest  arr_delay
       <chr>     <dbl>
     1 ABQ         -35
     2 ACK         -14
     3 ALB         -10
     4 ANC           1
     5 ATL         -25
     6 AUS          40
     7 AVL         -16
     8 BDL         -18
     9 BGR         121
    10 BHM          31
    # ℹ 95 more rows

```r
flights %>% 
  group_by(dest) %>% 
  slice_tail(n = 1) %>% 
  select(dest, arr_delay)
```

    # A tibble: 105 × 2
    # Groups:   dest [105]
       dest  arr_delay
       <chr>     <dbl>
     1 ABQ         -39
     2 ACK          -6
     3 ALB         -23
     4 ANC          -4
     5 ATL         136
     6 AUS         -52
     7 AVL           4
     8 BDL         -12
     9 BGR           8
    10 BHM         -29
    # ℹ 95 more rows

```r
flights %>% 
  group_by(dest) %>% 
  slice_sample(n = 1) %>% 
  select(dest, arr_delay)
```

    # A tibble: 105 × 2
    # Groups:   dest [105]
       dest  arr_delay
       <chr>     <dbl>
     1 ABQ           2
     2 ACK          81
     3 ALB          NA
     4 ANC          10
     5 ATL         -14
     6 AUS         -12
     7 AVL         127
     8 BDL         -18
     9 BGR         -16
    10 BHM          NA
    # ℹ 95 more rows