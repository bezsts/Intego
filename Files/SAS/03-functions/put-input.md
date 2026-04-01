# PUT / INPUT

## Що роблять
- `PUT(var, format.)` — перетворює числову або символьну змінну **у символьний** рядок за форматом.
- `INPUT(var, informat.)` — перетворює символьний рядок **у числове або символьне** значення за інформатом.

```
PUT   → завжди повертає CHARACTER
INPUT → повертає те, що визначає informat (числовий або символьний)
```

## Синтаксис
```sas
char_var = put(num_or_char_var, format.);
num_var  = input(char_var, informat.);
```

## Рецепти

### Число → Рядок
```sas
/* Число у рядок (без пробілів) */
n_str  = strip(put(subjid, best.));         /* 18349 → "18349" */
n_zero = put(subjid, z6.);                  /* 123   → "000123" */

/* SAS дата → ISO рядок */
dtc = put(visitdt, is8601da.);              /* → "2024-01-15" */
dtc = put(datetime_val, is8601dt20.);       /* → "2024-01-15T08:00:00" */
```

### Рядок → Число
```sas
/* ISO дата → SAS date */
dt = input("2024-01-15", is8601da.);

/* Рядок із числом */
n = input("12345", best.);
n = input(compress(visid, , "kd"), best.);  /* "DAY14" → 14 */
```

### Застосувати користувацький формат
```sas
proc format;
    value $sex_fmt "M" = "Male" "F" = "Female";
run;

sex_label = put(sex, $sex_fmt.);
```

### PUTN / PUTC — формат як рядок (динамічний)
```sas
/* Корисно, коли формат обирається динамічно */
result = putn(number, "date9");   /* те саме що put(number, date9.) */
result = putc(charvar, "$20.");
```

### Конвертація NUM ↔ CHAR у SDTM
```sas
data dm;
    set raw.demog;

    /* SUBJID (num) → USUBJID (char) */
    usubjid = catx("-", strip(studyid),
                        strip(put(siteid, best.)),
                        strip(put(subjid, z6.)));

    /* VISITDT (num date) → RFSTDTC (char ISO) */
    rfstdtc = put(visitdt, is8601da.);

    /* RFSTDTC (char) → числова дата для розрахунків */
    ref_date = input(substr(rfstdtc, 1, 10), is8601da.);
    format ref_date date9.;
run;
```

## ⚠️ Підводні камені

```sas
/* Неправильно: PUT повертає рядок із пробілами */
n_str = put(age, 8.);    /* "      45" */

/* Правильно: strip */
n_str = strip(put(age, best.));   /* "45" */

/* Неправильно: автоконвертація викликає NOTE в лозі */
char_var = num_var;     /* NOTE: Numeric values have been converted... */

/* Правильно */
char_var = put(num_var, best.);
```
