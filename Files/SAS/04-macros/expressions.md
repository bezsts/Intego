# %IF / %DO — умови та цикли в макросах

> Макро-оператори виконуються **під час генерації коду**, не під час виконання SAS. Вони працюють з текстом.

## %IF / %ELSE

```sas
%macro process(domain=);
    %if &domain. = AE %then %do;
        proc sort data=ae; by usubjid aestart; run;
    %end;
    %else %if &domain. = VS %then %do;
        proc sort data=vs; by usubjid visitnum; run;
    %end;
    %else %do;
        %put WARNING: Unknown domain &domain.;
    %end;
%mend process;

%process(domain=AE);
```

## %DO — лічильний цикл

```sas
%macro print_subjects;
    %do i = 1 %to &numobs.;
        %put NOTE: Subject &i.: &&pt_&i.;
    %end;
%mend print_subjects;

%print_subjects;
```

## %DO %WHILE / %DO %UNTIL

```sas
%macro loop_while;
    %let i = 1;
    %do %while (&i. <= 5);
        %put Iteration: &i.;
        %let i = %eval(&i. + 1);
    %end;
%mend loop_while;
```

## Практичний приклад — цикл по доменах

```sas
%let domains = AE VS LB CM;

%macro process_all;
    %let n = %sysfunc(countw(&domains.));
    %do i = 1 %to &n.;
        %let dom = %scan(&domains., &i.);
        %put Processing domain: &dom.;

        proc sort data=&dom.;
            by usubjid;
        run;
    %end;
%mend process_all;

%process_all;
```

## Умова — перевірити чи макро-змінна не пуста

```sas
%macro run_if_set(dataset=);
    %if %length(&dataset.) > 0 %then %do;
        proc print data=&dataset.; run;
    %end;
    %else %do;
        %put WARNING: No dataset specified.;
    %end;
%mend run_if_set;
```

## %EVAL та %SYSEVALF — арифметика в макросах

```sas
%let a = 3;
%let b = 4;

%let sum  = %eval(&a. + &b.);          /* цілі числа → 7 */
%let prod = %eval(&a. * &b.);          /* → 12 */

/* Для дробових чисел потрібен SYSEVALF */
%let x = 2.5;
%let y = 1.3;
%let res = %sysevalf(&x. + &y.);       /* → 3.8 */

%put Sum: &sum. Product: &prod. Float: &res.;
```

## ⚠️ %IF тільки всередині макросу

```sas
/* НЕПРАВИЛЬНО — %if в open code не працює */
%if &n. > 0 %then %do;
    proc print data=ds; run;
%end;

/* ПРАВИЛЬНО — загорнути в макрос */
%macro conditional;
    %if &n. > 0 %then %do;
        proc print data=ds; run;
    %end;
%mend conditional;
%conditional;
```
