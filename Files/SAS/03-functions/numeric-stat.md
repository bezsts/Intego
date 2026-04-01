# Числові та статистичні функції

## Швидка довідка

| Функція | Що робить |
|---------|-----------|
| `abs(x)` | Абсолютне значення |
| `sqrt(x)` | Квадратний корінь |
| `exp(x)` | e^x |
| `log(x)` | Натуральний логарифм |
| `mod(x, d)` | Залишок від ділення |
| `sum(a, b, ...)` | Сума (ігнорує missing) |
| `mean(a, b, ...)` | Середнє (ігнорує missing) |
| `min(a, b, ...)` | Мінімум (ігнорує missing) |
| `max(a, b, ...)` | Максимум (ігнорує missing) |
| `median(a, b, ...)` | Медіана |
| `std(a, b, ...)` | Стандартне відхилення |
| `nmiss(a, b, ...)` | Кількість пропущених |
| `cmiss(a, b, ...)` | Кількість пропущених (char + num) |

## Рецепти

### Сума зі списком змінних
```sas
/* Ігнорує missing (на відміну від +) */
total = sum(csfq1, csfq2, csfq3, csfq4);
total = sum(of csfq1-csfq14);    /* діапазон */
total = sum(of csfq:);           /* за префіксом */

/* + не ігнорує missing — якщо будь-яке пропущене, результат missing */
bad_sum = csfq1 + csfq2 + csfq3;
```

### Перевірка на пропущені значення
```sas
data result;
    set source;
    n_miss = nmiss(of num_var1-num_var5);
    if n_miss = 0 then egdy = (egdtc - rfstdtc) + (egdtc >= rfstdtc);
    else call missing(egdy);
run;
```

### Розрахунки у SDTM
```sas
data vs;
    set raw.vs;
    /* Score = середнє з трьох вимірювань */
    avg_val = mean(meas1, meas2, meas3);

    /* Перевірити суму анкети */
    calc_total = sum(of q1-q14);
    result = ifc(calc_total = totalscr, "OK", "MISMATCH");
run;
```

## Округлення
| Функція | Опис | Приклад |
|---------|------|---------|
| `round(x, 0.1)` | До найближчого кратного | `round(1.25, 0.1)` → `1.3` |
| `ceil(x)` | Найменше ціле ≥ x | `ceil(2.1)` → `3` |
| `floor(x)` | Найбільше ціле ≤ x | `floor(2.9)` → `2` |
| `int(x)` | Ціла частина (ближче до 0) | `int(-2.9)` → `-2` |

```sas
/* Типові округлення в SDTM */
vsstresn = round(raw_value * conversion_factor, 0.1);
age      = floor(yrdif(birthdt, visitdt, "ACTUAL"));
```
