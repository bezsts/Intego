# Arrays — масиви

## Що роблять
Масив — це іменований список змінних, що дозволяє обробляти їх в циклі замість повторення коду.

> ⚠️ Масив існує тільки всередині DATA step — це не структура даних, а **посилання** на змінні.

## Синтаксис
```sas
array <ім'я> {n} <$> <length> <var1 var2 ... varN> <(початкові значення)>;
```

## Рецепти

### Обробити кілька змінних одночасно
```sas
data vs_neg;
    set vs;
    array vitals vstemp vsresp vspulse vsbpsys vsbpdia;

    do i = 1 to dim(vitals);
        if not missing(vitals{i}) then vitals{i} = vitals{i} * (-1);
        else vitals{i} = 0;
    end;
run;
```

### Масив з автоматичним захопленням змінних (VS:)
```sas
data vs_all;
    set vs;
    array vs_vars VS:;    /* всі змінні що починаються з VS */

    do i = 1 to dim(vs_vars);
        if missing(vs_vars{i}) then vs_vars{i} = 0;
    end;
run;
```

### Перетворити широкий формат у довгий (turn)
```sas
data vs_long;
    set vs_wide;
    array tests vstemp vsresp vspulse vsbpsys vsbpdia;

    do i = 1 to dim(tests);
        vstestcd = vname(tests[i]);     /* ім'я змінної */
        vstest   = vlabel(tests[i]);    /* label змінної */
        vsorres  = tests[i];
        output;
    end;

    drop vstemp vsresp vspulse vsbpsys vsbpdia i;
run;
```

### Масив із початковими значеннями
```sas
data lookup;
    array testcds [3] $ ("PULSE", "SYSBP", "DIABP");
    array tests   [3] $ 30 ("Pulse Rate", "Systolic BP", "Diastolic BP");

    do i = 1 to 3;
        vstestcd = testcds[i];
        vstest   = tests[i];
        output;
    end;
run;
```

### Тимчасовий масив (_temporary_) — не створює змінних у датасеті
```sas
data search;
    array target {3} _temporary_ (15, 8, 42);
    min_val = 8;

    idx = whichn(min_val, of target{*});
run;
```

### Масив символьних змінних
```sas
data csfq_coded;
    set csfqmale;
    array csfq_raw  csfq1-csfq14;
    array csfq_char $20 csfq_c1-csfq_c14;

    do i = 1 to dim(csfq_raw);
        csfq_char[i] = put(csfq_raw[i], csfq_fmt.);
    end;
run;
```

## Корисні функції для масивів
| Функція | Опис |
|---------|------|
| `dim(arr)` | Кількість елементів |
| `lbound(arr)` | Нижня межа індексу |
| `hbound(arr)` | Верхня межа індексу |
| `vname(arr[i])` | Ім'я змінної |
| `vlabel(arr[i])` | Label змінної |
| `whichn(val, of arr{*})` | Індекс значення в масиві |
