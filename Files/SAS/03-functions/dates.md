# Функції для дат та часу

## Швидка довідка

| Функція | Що робить | Приклад |
|---------|-----------|---------|
| `today()` / `date()` | Поточна дата | |
| `time()` | Поточний час | |
| `datetime()` | Поточний datetime | |
| `year(d)` | Рік | `year("13DEC2023"d)` → `2023` |
| `month(d)` | Місяць | |
| `day(d)` | День | |
| `weekday(d)` | День тижня (1=неділя) | |
| `mdy(m, d, y)` | Зібрати дату | `mdy(12, 31, 2023)` |
| `datepart(dt)` | Дата з datetime | |
| `timepart(dt)` | Час з datetime | |
| `intck(interval, d1, d2)` | Кількість інтервалів між датами | `intck('MONTH', d1, d2)` |
| `intnx(interval, d, n, align)` | Зсунути дату на N інтервалів | `intnx('month', d, 3, 'end')` |
| `datdif(d1, d2, basis)` | Точна кількість днів | `datdif(d1, d2, "ACTUAL")` |
| `yrdif(d1, d2, basis)` | Кількість років | `yrdif(bday, today(), "ACTUAL")` |
| `dhms(d, h, m, s)` | Зібрати datetime | `dhms(date, 0, 0, time_in_sec)` |

## Рецепти

### Розрахувати вік
```sas
age = floor(yrdif(birthdt, visitdt, "ACTUAL"));

/* Альтернатива */
age = floor((visitdt - birthdt + 1) / 365.25);
```

### Перетворити дату в ISO 8601 рядок
```sas
rfstdtc = put(daterandomized, is8601da.);     /* → "2024-01-15" */
rfxstdtc = put(datetime_val, is8601dt20.);    /* → "2024-01-15T08:00:00" */
```

### Перетворити рядок у SAS дату
```sas
date_num = input(substr(dtc, 1, 10), is8601da.);
```

### Study Day (STDY / ENDY)
```sas
/* Формула: якщо дата >= reference → +1 (немає дня 0) */
aestdy = input(substr(aestdtc, 1, 10), is8601da.)
       - input(substr(rfstdtc, 1, 10), is8601da.)
       + (aestdtc >= rfstdtc);
```

### Кінець місяця
```sas
end_of_month = intnx('month', mdy(month, 01, year), 0, 'end');
format end_of_month date9.;
```

### Середина року / місяця
```sas
mid_year  = intnx('year',  mdy(01, 01, year),  0, 'mid');
mid_month = intnx('month', mdy(month, 01, year), 0, 'mid');
```

### Дата + N місяців
```sas
date_plus3m = intnx('month', start_date, 3, 'same');
```

### Перетворити TIMEADM (рядок "HH:MM") у секунди
```sas
time_sec = input(timeadm, time5.);
datetime_val = dhms(daydate, 0, 0, time_sec);
format datetime_val datetime20.;
```

### Вік у місяцях (для педіатрії)
```sas
age_months = intck('MONTH', birthdt, visitdt);
age_years  = floor(age_months / 12);
```

## Формати для дат
| Формат | Результат |
|--------|-----------|
| `date9.` | `31MAR2026` |
| `is8601da.` | `2026-03-31` |
| `yymmdd10.` | `2026-03-31` |
| `is8601dt.` | `2026-03-31T12:00:00` |
| `datetime20.` | `31MAR2026:12:00:00` |
| `time5.` | `12:00` |
