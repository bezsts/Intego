# PROC SQL

## Що робить
Дозволяє використовувати SQL-синтаксис для роботи з SAS датасетами. Альтернатива до DATA step + PROC SORT для багатьох задач.

## Синтаксис
```sas
proc sql <noprint> <inobs=n> <outobs=n>;
    create table <ds> as
    select ...
    from ...
    where ...
    group by ...
    having ...
    order by ...
    ;
quit;    /* не run! */
```

## Рецепти

### Створити датасет з новою змінною
```sas
proc sql noprint;
    create table demog_sql as
    select *,
        catx("-", studyid, siteid, put(subjid, z6.)) as usubjid
        length=24 label="Unique Subject Identifier"
    from rawdata.demog
    order by subjid;
quit;
```

### LEFT JOIN
```sas
proc sql noprint;
    create table ae_with_demo as
    select ae.*, dm.sex, dm.age, dm.rfstdtc
    from rawdata.ae as ae
    left join rawdata.demog as dm
    on ae.subjid = dm.subjid
    order by ae.subjid, ae.aestart;
quit;
```

### GROUP BY + агрегатні функції
```sas
proc sql noprint;
    create table avg_weight as
    select usubjid,
           round(avg(vsstresn), 0.1) as avg_wgt label="Average Weight"
    from vs_train
    where vstestcd = "WEIGHT"
    group by usubjid;
quit;
```

### CASE WHEN (аналог if-then-else)
```sas
proc sql;
    create table dm_age as
    select *,
        case
            when age <= 75 then "<=75"
            else ">75"
        end as agegrp
    from dm_train;
quit;
```

### Підзапит — пацієнти без DM запису
```sas
proc sql;
    create table no_dm as
    select usubjid from ae_train
    where usubjid not in (select usubjid from dm_train);
quit;
```

### UNION — об'єднати датасети
```sas
proc sql noprint;
    create table all_subjects as
    select usubjid from ae_train
    union
    select usubjid from lb_train
    union
    select usubjid from vs_train;
quit;
```

### INTO: зберегти значення в макро-змінну
```sas
/* Одне значення */
proc sql noprint;
    select count(distinct usubjid) into :n_patients
    from dm_train;
quit;
%put Patients: &n_patients.;

/* Список через роздільник */
proc sql noprint;
    select distinct strip(trtmt) into :trt_list separated by ","
    from rdmcode;
quit;

/* Кілька змінних — кожна у свою макро-змінну */
proc sql noprint;
    select max(enddate), min(startdate)
    into :max_dt, :min_dt
    from input_data;
quit;

/* Масив макро-змінних */
proc sql noprint;
    select distinct xtrtmt into :trt1 -
    from rdmcode;
quit;
/* Створить &trt1, &trt2, ... */
```

### HAVING — фільтр після GROUP BY
```sas
proc sql;
    create table freq_ae as
    select aename,
           round(count(distinct usubjid) / &n_patients. * 100, 0.01) as pct
    from ae_train
    group by aename
    having (calculated pct) > 10;
quit;
```

## Порівняння SQL vs DATA step
| Задача | SQL | DATA step |
|--------|-----|-----------|
| JOIN | `left join` | `merge` + `if a` |
| Агрегація | `group by` + `count/avg` | `proc means` |
| Фільтрація | `where` | `where` або `if` |
| Нові змінні | `select ..., expr as var` | присвоєння |
| Без сортування | ✅ | ⚠️ потрібен sort для BY |
