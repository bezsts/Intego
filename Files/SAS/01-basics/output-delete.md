# Output / Delete

## OUTPUT — записати рядок у датасет

За замовчуванням SAS записує рядок **автоматично** в кінці кожної ітерації. Явний `output` дозволяє контролювати **коли** і **куди** записувати.

```sas
/* Явний output — потрібен якщо є кілька output або умови */
data result;
    set source;
    if condition then output;   /* тільки ці записи потраплять у результат */
run;
```

## Рецепти

### Output у кілька датасетів
```sas
data cool_cars boring_cars;
    set sashelp.cars;
    if msrp > 90000 then output cool_cars;
    else output boring_cars;
run;
```

### Генерувати кілька рядків з одного (наприклад, VS)
```sas
data vs;
    set vs_raw;
    by usubjid visitnum;

    /* Запис 1: SYSBP */
    vstestcd = "SYSBP";
    vstest   = "Systolic Blood Pressure";
    if not missing(sysbp) then do;
        vsorres  = strip(put(sysbp, best.));
        vsorresu = "mmHg";
        call missing(vsstat);
    end;
    else do;
        call missing(vsorres, vsorresu);
        vsstat = "NOT DONE";
    end;
    output;

    /* Очистити змінні перед наступним параметром */
    call missing(vstestcd, vstest, vsorres, vsorresu, vsstat);

    /* Запис 2: DIABP */
    vstestcd = "DIABP";
    vstest   = "Diastolic Blood Pressure";
    if not missing(diabp) then do;
        vsorres  = strip(put(diabp, best.));
        vsorresu = "mmHg";
        call missing(vsstat);
    end;
    else do;
        call missing(vsorres, vsorresu);
        vsstat = "NOT DONE";
    end;
    output;
run;
```

### Output тільки останнього/першого запису групи
```sas
data last_per_subject;
    set ds;
    by usubjid;
    if last.usubjid then output;
run;
```

### Output з лічильником
```sas
data count_insomnia(keep=usubjid count);
    set ae;
    by usubjid;

    retain count 0;
    if first.usubjid then count = 0;
    if aename = "Insomnia" then count + 1;
    if last.usubjid then output;
run;
```

---

## DELETE — видалити запис

```sas
data result;
    set source;
    if condition then delete;   /* не записати цей рядок */
run;

/* Еквівалент до */
data result;
    set source;
    if not condition;           /* or: if NOT condition then output */
run;
```
