# BY / First. / Last.

## Що робить
`BY` в DATA step ділить дані на групи. `First.var` = перший запис групи, `Last.var` = останній.

> ⚠️ Дані мають бути **відсортовані** за BY-змінними перед DATA step.

## Синтаксис
```sas
proc sort data=ds; by var1 var2; run;

data result;
    set ds;
    by var1 var2;

    if first.var1 then ...;
    if last.var2  then ...;
run;
```

## Рецепти

### Лічильник всередині групи (RETAIN + First/Last)
```sas
proc sort data=ae; by usubjid aestart; run;

data ae_seq;
    set ae;
    by usubjid;

    if first.usubjid then seq = 1;
    else seq + 1;          /* seq + 1 — автоматично RETAIN */
run;
```

### Взяти тільки перший або останній запис групи
```sas
/* Перший */
data first_dose;
    set invagt;
    by subjid;
    if first.subjid;
run;

/* Останній */
data last_dose;
    set invagt;
    by subjid;
    if last.subjid;
run;
```

### Останній запис усього датасету (END=)
```sas
data last_rec;
    set ds end = eof;
    if eof;
run;
```

### Флаги для першого і останнього
```sas
data flags;
    set ds;
    by usubjid;

    length aoccfl $1;
    if first.usubjid then aoccfl = "Y";
    else call missing(aoccfl);
run;
```

### Вкладені BY-групи
```sas
/* first.var2 спрацьовує при зміні var2 АБО var1 */
data nested;
    set ds;
    by var1 var2;

    if first.var1 then cnt1 = 1;
    else cnt1 + 1;

    if first.var2 then cnt2 = 1;
    else cnt2 + 1;
run;
```

## ⚠️ Підводні камені
- `seq + 1` без `retain` не збереже значення — але SAS автоматично додає `retain` для змінних що використовують `+ <число>`.
- Не плутай `by` в DATA step та `by` в PROC — різна логіка.
