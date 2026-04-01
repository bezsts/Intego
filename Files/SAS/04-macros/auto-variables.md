# Автоматичні макро-змінні SAS

## Системні змінні (read-only)

| Змінна | Значення | Приклад |
|--------|---------|---------|
| `&sysdate.` | Дата початку сесії (DATE7.) | `31MAR26` |
| `&sysdate9.` | Дата початку сесії (DATE9.) | `31MAR2026` |
| `&sysday.` | День тижня | `Wednesday` |
| `&systime.` | Час початку сесії | `08:00` |
| `&sysdsn.` | Останній створений датасет | `WORK.RESULT` |
| `&sysmacroname.` | Ім'я поточного макросу | `MY_MACRO` |
| `&sysrc.` | Return code | `0` (OK) |
| `&syslibrc.` | RC останнього libname | `0` |
| `&sysvlong.` | Версія SAS | `9.04.01M7...` |

## Використання в програмах

```sas
/* Автоматичний timestamp у звіті */
title "Report generated on &sysdate9. at &systime.";

/* Перевірити return code */
%macro safe_libname(lib=, path=);
    libname &lib. "&path.";
    %if &syslibrc. ne 0 %then %do;
        %put ERROR: Cannot connect libname &lib.;
    %end;
%mend;

/* Ім'я поточного макросу для повідомлень */
%macro process_ae;
    %put NOTE: [&sysmacroname.] Starting AE processing;
    /* ... */
    %put NOTE: [&sysmacroname.] Completed.;
%mend;
```

## Вивести всі змінні

```sas
%put _ALL_;        /* всі: системні + глобальні + локальні */
%put _GLOBAL_;     /* тільки глобальні */
%put _USER_;       /* тільки користувацькі (не системні) */
%put _LOCAL_;      /* тільки локальні (всередині макросу) */
%put _AUTOMATIC_;  /* тільки системні */
```

## parameters.md — placeholder
```sas
/* Позиційні параметри */
%macro sort_it(dataset, var);
    proc sort data=&dataset;
        by &var;
    run;
%mend;
%sort_it(ae, usubjid);

/* Keyword параметри (з default) */
%macro sort_kw(dataset=, sortvar=usubjid);
    proc sort data=&dataset;
        by &sortvar;
    run;
%mend;
%sort_kw(dataset=ae);
%sort_kw(dataset=vs, sortvar=usubjid vstestcd);
```
