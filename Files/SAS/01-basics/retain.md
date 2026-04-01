# Retain — збереження значень між ітераціями

## Що робить
За замовчуванням SAS обнуляє всі змінні на кожній ітерації DATA step. `RETAIN` змушує змінну **зберігати** значення з попередньої ітерації.

## Синтаксис
```sas
retain <змінна>;                    /* без початкового значення (missing) */
retain <змінна> <початкове_знач>;   /* з початковим значенням */
retain var1 0 var2 1 var3 "A";      /* кілька змінних */
```

## Рецепти

### Заповнити пропуски попереднім значенням (LOCF)
```sas
proc sort data=vs; by subjid vsdate; run;

data vs_filled;
    set vs;
    by subjid;

    retain prev_temp;

    if first.subjid then call missing(prev_temp);  /* скинути на початку суб'єкта */

    if not missing(vstemp) then prev_temp = vstemp;
    else vstemp = prev_temp;                        /* підставити попереднє */
run;
```

### Лічильник із reset на групу
```sas
data ae_count;
    set ae;
    by usubjid;

    retain cnt 0;
    if first.usubjid then cnt = 0;
    cnt + 1;
run;
```

### Накопичення суми
```sas
data cocaine_total;
    set followup;
    by subjid;

    retain total_days 0;
    if first.subjid then total_days = 0;
    if not missing(cocain_d) then total_days + cocain_d;

    if last.subjid then output;
run;
```

### Зберегти значення з першого запису
```sas
data with_start_date;
    set vs;
    by subjid;

    retain first_date;
    if first.subjid then first_date = vsdate;
    format first_date date9.;
run;
```

## ⚠️ Нюанси
- `var + 1` — SAS **автоматично додає** retain для такого синтаксису.
- `retain` не впливає на BY-змінні та змінні із `set` — вони завжди оновлюються з датасету.
- `call missing(var)` — явний спосіб скинути retained значення.
