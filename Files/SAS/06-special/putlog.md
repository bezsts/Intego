# PUTLOG — дебаг через лог

## Що робить
Виводить повідомлення у SAS лог під час виконання DATA step. Використовується для дебагу та валідації даних.

## Синтаксис
```sas
putlog "текст";
putlog "текст" var1 "текст" var2;
putlog var1= var2=;          /* виведе: var1=значення var2=значення */
```

## Рецепти

### Вивести значення змінних
```sas
data _null_;
    set vitals;
    putlog SUBJID VISIT VSDATE VSTIME;
    putlog "SUBJID=" SUBJID " VISIT=" VISIT " DATE=" VSDATE;
run;
```

### Один раз на початку
```sas
data _null_;
    set vitals;
    if _N_ = 1 then putlog "=== Processing started ===";
    putlog SUBJID VSDATE VSTEMP;
run;
```

### Знайти проблемні записи
```sas
data _null_;
    set vitals;
    if vstemp >= 99 then
        putlog "WARNING: High temperature! SUBJID=" SUBJID " VISID=" VISID " TEMP=" vstemp;
run;
```

### Перевірити пропущені дати
```sas
data _null_;
    set ae;
    if missing(aestop) then
        putlog "WARNING: Missing AE Stop. SUBJID=" SUBJID " AENAME=" AENAME;
run;
```

### Форматувати повідомлення у лозі
```sas
/* Форматування SAS-типу повідомлень */
putlog "NOTE: Processing subject " SUBJID;
putlog "W" "ARNING: Check value for " SUBJID;    /* щоб не активувати SAS warning */
putlog "E" "RROR: Critical issue at " SUBJID;    /* щоб не зупинити програму */
```

### Статистика в лозі
```sas
data _null_;
    set vitals end=eof;
    retain cnt_high 0;
    if vstemp >= 99 then cnt_high + 1;
    if eof then putlog "NOTE: Total high temp records: " cnt_high;
run;
```

## PUT vs PUTLOG
| | PUT | PUTLOG |
|-|-----|--------|
| Куди виводить | Default output (Results) | Тільки LOG |
| Використання | Вивід даних | Дебаг |
