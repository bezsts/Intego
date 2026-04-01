# Format / Label у DATA step

## Що роблять
- `FORMAT` — визначає як **відображати** значення змінної.
- `LABEL` — задає описову мітку для змінної (для звітів та `PROC CONTENTS`).

> Формат НЕ змінює значення — тільки відображення.

## Синтаксис

```sas
data result;
    format var1 format1. var2 format2.;
    label  var1 = "Мітка 1"
           var2 = "Мітка 2";
run;
```

## Рецепти

### Форматування дат
```sas
data time;
    current_date     = today();
    current_time     = time();
    current_datetime = datetime();

    format current_date     yymmdd10.
           current_time     time5.
           current_datetime is8601dt.;

    label current_date     = "Current Date"
          current_time     = "Current Time"
          current_datetime = "Current Date/Time";
run;
```

### ATTRIB — все в одному
```sas
data dm;
    attrib
        usubjid  length=$24  format=$char24.  label="Unique Subject Identifier"
        age      length=8    format=best.     label="Age"
        rfstdtc  length=$19                   label="Reference Start Date"
    ;
run;
```

### Змінити формат у наявному датасеті (без DATA step)
```sas
proc datasets lib=work;
    modify result;
        format age 3.
               rfstdtc $19.;
        label  age = "Age at Baseline";
quit;
```

## Найпоширеніші формати
| Формат | Приклад результату |
|--------|--------------------|
| `date9.` | `31MAR2026` |
| `is8601da.` | `2026-03-31` |
| `yymmdd10.` | `2026-03-31` |
| `datetime20.` | `31MAR2026:08:00:00` |
| `is8601dt.` | `2026-03-31T08:00:00` |
| `time5.` | `08:00` |
| `best.` | `1234` (числовий без пробілів) |
| `z6.` | `001234` (з ведучими нулями) |
| `dollar9.` | `$1,234` |
| `$char20.` | символьне значення (20 символів) |
