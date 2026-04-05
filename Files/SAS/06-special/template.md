# Шаблон програми

## Шаблон для будь-якої SAS програми

```sas
dm 'odsresults; clear';
dm 'log; clear';

options missing = '';

proc datasets lib=work kill noprint;
run;
```

## Шаблон для CDISC
```sas
*****************************************
****** Name: Stanislav             ******
****** Program Name:       ******
****** Date:              ******
*****************************************

****************************************************************************************************************************
               Version history 
Name             Version        Date         Comment

****************************************************************************************************************************;

dm 'odsresults; clear';	
dm "log; clear";

libname  "";
libname out "";

options missing = "";

proc datasets lib=work kill noprint;
run;

%let domain = ;
%let seqsort = ;

proc sort data = &domain;
	by &seqsort;
run;

proc contents data=&domain. varnum;
run;

data out.&domain(label = "");
	set &domain;
run;
```

## Шаблон для QC порівняння

```sas
libname fl "path\to\FL";
libname qc "path\to\QC";

proc printto print="path\to\report.txt" new;
run;

title "Comparison of Task 1";
proc compare base=fl.hw_1_fl compare=qc.hw_1_qc listall;
    id usubjid vsdtc vstestcd;
run;

/* ... інші порівняння ... */

proc printto;
run;
```

## Шаблон для хомворку / навчального завдання

```sas
dm 'log; clear';

options missing = '';

proc datasets lib=work kill noprint;
run;

/*========*/
/* Task 1 */
/*========*/

/* код */

/*========*/
/* Task 2 */
/*========*/

/* код */

/*================*/
/* Output datasets*/
/*================*/

libname out "path\to\output";

data out.task1; set task1; run;
data out.task2; set task2; run;
```
