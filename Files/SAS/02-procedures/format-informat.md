# PROC FORMAT / INFORMAT

## Що робить
- **Format** — перетворює збережене значення у відображуваний вигляд (число/символ → символ).
- **Informat** — зчитує вхідні дані у певному форматі (символ → число або символ).
- `PUT(var, format.)` — застосувати формат.
- `INPUT(var, informat.)` — застосувати informat.

## Синтаксис
```sas
proc format;
    value <ім'я> <діапазони = мітки>;      /* числовий → символьний */
    value $<ім'я> <діапазони = мітки>;     /* символьний → символьний */
    invalue <ім'я> <діапазони = значення>; /* символьний → числовий */
    invalue $<ім'я> ...;                   /* символьний → символьний */
run;
```

## Рецепти

### Числовий → Символьний (value)
```sas
proc format;
    value gender_fmt
        1 = "Male"
        2 = "Female"
        . = "Unknown";

    value agegr_fmt
        low  -< 18 = "<18"
        18   -< 65 = "18-64"
        65   - high = ">=65"
        .          = "Unknown";
run;

data dm;
    set raw.demog;
    sex    = put(gender, gender_fmt.);
    agegrp = put(age, agegr_fmt.);
run;
```

### Символьний → Символьний ($value)
```sas
proc format;
    value $visit_fmt
        "DAY1"        = "Day 1"
        "DAY2"        = "Day 2"
        "DAY3"-"DAY8" = "Days 3-8"
        "DAY9","DAY15"= [$200.]      /* залишити як є, але розширити довжину */
        other         = "Other";
run;

data vs;
    set raw.vitals;
    visit_label = put(visid, $visit_fmt.);
run;
```

### Символьний → Числовий (invalue)
```sas
proc format;
    invalue visnum_fmt
        "DAY1"  = 1
        "DAY2"  = 2
        "DAY3"  = 3
        other   = 999;
run;

data vs;
    set raw.vitals;
    visitnum = input(visid, visnum_fmt.);
run;
```

### Формат із датасету (cntlin=)
```sas
/* Підготувати датасет-словник */
data fmt_ds;
    length start label fmtname $200;
    start = "WEIGHT"; label = "Body Weight";   fmtname = "$vspar"; output;
    start = "HEIGHT"; label = "Body Height";   fmtname = "$vspar"; output;
    start = "PULSE";  label = "Pulse Rate";    fmtname = "$vspar"; output;
    start = "OTHER";  label = "Other";         fmtname = "$vspar"; hlo = "O"; output;
run;

proc format cntlin=fmt_ds;
run;

data vs;
    vstest = put(vstestcd, $vspar.);
run;
```

### _same_ та _error_
```sas
proc format;
    invalue $visit_safe
        "DAY1" = "Day 1"
        "DAY2" = "Day 2"
        other  = _same_;    /* повернути вхідне значення без змін */
        /* other = _error_; — видати помилку для неочікуваних */
run;
```

## Стандартні формати SAS (без proc format)
| Формат | Приклад | Результат |
|--------|---------|-----------|
| `date9.` | `put(today(), date9.)` | `31MAR2026` |
| `is8601da.` | `put(today(), is8601da.)` | `2026-03-31` |
| `is8601dt.` | `put(datetime(), is8601dt.)` | `2026-03-31T12:00:00` |
| `best.` | `put(1234, best.)` | `1234` |
| `z6.` | `put(123, z6.)` | `000123` |
| `dollar9.` | `put(1234, dollar9.)` | `$1,234` |
