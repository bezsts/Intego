# Корисні макро-патерни

Готові шаблони для типових задач у клінічному програмуванні.

---

## Перевірити чи датасет існує і не порожній

```sas
%macro checkds(dsin=, flagname=FLG);
    %global &flagname.;

    %if %sysfunc(exist(&dsin.)) %then %do;
        %let dsid = %sysfunc(open(&dsin.));
        %let nobs = %sysfunc(attrn(&dsid., nlobs));
        %let dsid = %sysfunc(close(&dsid.));

        %if &nobs. = 0 %then %do;
            %put WARNING: Dataset &dsin. is empty!;
            %let &flagname. = 0;
        %end;
        %else %do;
            %put NOTE: Dataset &dsin. has &nobs. observations.;
            %let &flagname. = 1;
        %end;
    %end;
    %else %do;
        %put WARNING: Dataset &dsin. does not exist!;
        %let &flagname. = -1;
    %end;
%mend checkds;

%checkds(dsin=rawdata.ae, flagname=ae_flag);
%if &ae_flag. = 1 %then %do;
    /* обробляти AE */
%end;
```

---

## Створити формат вікових груп динамічно

```sas
%macro create_agegroup(agegroup=);
    proc format;
        value agefmt&agegroup.yr
            low   - &agegroup.  = "<=&agegroup. years"
            &agegroup. <- high  = ">&agegroup. years"
            .                   = "Unknown";
    run;
%mend create_agegroup;

%create_agegroup(agegroup=35);
%create_agegroup(agegroup=40);
%create_agegroup(agegroup=65);

/* Тепер доступні формати: agefmt35yr. agefmt40yr. agefmt65yr. */
data dm;
    set demog;
    agegr_35 = put(age, agefmt35yr.);
    agegr_40 = put(age, agefmt40yr.);
run;
```

---

## Порахувати пацієнтів за TRT-групами

```sas
proc sort data=rawdata.rdmcode out=rdmcode;
    by xtrtmt;
run;

data _null_;
    set rdmcode;
    by xtrtmt;
    if first.xtrtmt then cnt = 1;
    else cnt + 1;
    if last.xtrtmt then do;
        call symput(cats(xtrtmt), cats(cnt));
        call symput(cats("trtgr", _N_), cats(xtrtmt));
    end;
run;

%put GBR12909 n=&gbr12909.  Placebo n=&placebo.;

/* Доступ через &&& */
%put Group 1: &trtgr1. (n=&&&trtgr1.);
%put Group 2: &trtgr2. (n=&&&trtgr2.);
```

---

## Конвертувати дати в ISO по всьому датасету (за форматом)

```sas
%macro convert_dates(lib=, ds=);
    /* Знайти всі змінні з DATE форматом */
    proc sql noprint;
        select name into :vars separated by " "
        from dictionary.columns
        where libname = upcase("&lib.")
          and memname = upcase("&ds.")
          and format like "DATE%";
    quit;

    data &ds._iso;
        set &lib..&ds.;
        %do i = 1 %to %sysfunc(countw(&vars.));
            %let v = %scan(&vars., &i.);
            &v._c = put(&v., is8601da.);
        %end;
    run;
%mend convert_dates;

%convert_dates(lib=rawdata, ds=ae);
```

---

## Повторити PROC MEANS по списку параметрів

```sas
%let params = SYSBP DIABP PULSE TEMP;

%macro means_by_param;
    %let n = %sysfunc(countw(&params.));
    %do i = 1 %to &n.;
        %let p = %scan(&params., &i.);

        title "Statistics for &p.";
        proc means data=vs n mean std min max;
            where vstestcd = "&p.";
            by usubjid;
            var vsstresn;
        run;
    %end;
%mend means_by_param;

%means_by_param;
title;
```

---

## Підрахунок подій по категоріях (для таблиці AE)

```sas
%macro count_category(category_text, SEV=, REL=, OUT=, ACN=);
    %let condition = %str();
    %if %length(&SEV.) > 0 %then
        %let condition = &condition. and a.AESEV = "&SEV.";
    %if %length(&REL.) > 0 %then
        %let condition = &condition. and a.AEREL = "&REL.";

    proc sql;
        create table cat_&SEV.&REL. as
        select "&category_text." as category length=100,
               t.xtrtmt,
               count(distinct a.subjid) as count
        from ae_vars as a
        right join trtmt as t on a.subjid = t.subjid
        %if %length(&condition.) > 0 %then
            where 1=1 &condition.;
        group by t.xtrtmt;
    quit;
%mend count_category;

%count_category("Moderate AEs", SEV=MODERATE);
%count_category("Possibly Related", REL=POSSIBLY);
```
