# PROC FREQ

## Що робить
Підраховує частоти та відсотки для категоріальних змінних. Будує крос-таблиці. Може розраховувати статистики (chi-square, odds ratio).

## Синтаксис

```sas
proc freq data=<ds> <noprint> <nlevels>;
    by <змінні>;
    tables <змінні> / <опції>;
    output out=<ds> <опції>;
    weight <змінна>;
run;
```

## Рецепти

### Базова частота
```sas
proc freq data=ae;
    tables aesev / nocum nopercent;
run;
```

### Крос-таблиця
```sas
proc freq data=ae noprint;
    tables aesev * aeterm / out=freq_sev_term;
run;
```

### Зберегти результат у датасет
```sas
proc freq data=ae noprint;
    tables aeterm / out=term_freq(drop=percent rename=(count=n_events));
run;
```

### Кількість унікальних значень (NLEVELS)
```sas
/* Порахувати унікальних суб'єктів у кожній групі */
ods output nlevels=unique_subjects;

proc freq data=ae nlevels;
    by aesev;
    tables usubjid / noprint;
run;
/* unique_subjects міститиме: aesev, NLevels */
```

### Побудова таблиці AE: події та суб'єкти
```sas
/* Кількість подій */
proc freq data=ae noprint;
    tables aesev * aeterm / out=n_events(drop=percent rename=(count=events));
run;

/* Кількість унікальних суб'єктів */
proc sort data=ae; by aesev aeterm; run;

ods output nlevels=n_subjects;
proc freq data=ae nlevels;
    by aesev aeterm;
    tables usubjid / noprint;
run;

data ae_table;
    merge n_events n_subjects;
    by aesev aeterm;
run;
```

### Категорії AE через output у кілька датасетів
```sas
data ae_cats;
    set ae;
    length category $100;

    category = "Any AE"; output;

    if aeser = "Y" then do;
        category = "Serious AE"; output;
    end;

    if aeacn = "DRUG WITHDRAWN" then do;
        category = "Drug Withdrawn"; output;
    end;
run;

proc freq data=ae_cats noprint;
    tables category / out=event_counts(drop=percent rename=(count=events));
run;
```

### Chi-square тест
```sas
proc freq data=example;
    tables treatment * response / chisq relrisk;
    ods output chisq=chi_result;
    ods output relativerisks=or_result;
run;
```

## Корисні опції TABLE
| Опція | Що робить |
|-------|-----------|
| `nocum` | Не виводити накопичені відсотки |
| `nopercent` | Не виводити відсотки |
| `noprint` | Не виводити на екран |
| `missing` | Включити missing як окрему категорію |
| `sparse` | Показати всі комбінації (навіть з 0) |
| `out=ds` | Зберегти в датасет |
