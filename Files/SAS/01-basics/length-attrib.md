# Length / Attrib — типи та атрибути змінних

## Що роблять
- `LENGTH` — задає тип та довжину змінної.
- `ATTRIB` — задає одразу length + format + informat + label в одному місці.

> ⚠️ Завжди оголошуй `LENGTH`/`ATTRIB` **до** першого використання змінної — SAS визначає тип за першим присвоєнням.

## Синтаксис
```sas
length <змінна> $<довжина>;        /* char */
length <змінна> <довжина>;         /* numeric (зазвичай 8) */

attrib <змінна>
    length = $<n> | <n>
    format = <формат>
    label  = "<мітка>";
```

## Рецепти

### Оголосити символьні та числові змінні
```sas
data dm;
    length usubjid $24 sex $1 age 8;
    /* ... */
run;
```

### Attrib — все в одному місці
```sas
data ae;
    attrib
        usubjid  length = $24  label = "Unique Subject Identifier"
        aeterm   length = $200 label = "Reported Term for the AE"
        aestdtc  length = $19  label = "Start Date/Time of AE"
        aestdy   length = 8    label = "Study Day of Start"
        aeser    length = $1   label = "Serious Event"
    ;
    /* ... */
run;
```

### Задати формат і label окремо
```sas
data time;
    current_date = today();
    format current_date yymmdd10.;
    label current_date = "Current Date";
run;
```

## Типові довжини для SDTM
| Змінна | Length |
|--------|--------|
| USUBJID | `$24` |
| STUDYID | `$13` |
| DOMAIN | `$2` |
| Дати (DTC) | `$19` |
| Текстові терміни | `$200` |
| Флаги (Y/N) | `$1` |
| Числові (SEQ, AGE…) | `8` |
