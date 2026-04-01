# PROC COMPARE

## Що робить
Порівнює два датасети та виводить звіт про відмінності. Використовується для QC (порівняння FL vs QC).

## Синтаксис
```sas
proc compare base=<ds1> compare=<ds2> <опції>;
    id <ключові змінні>;
    var <змінні для порівняння>;    /* якщо не вказано — всі */
run;
```

## Рецепти

### Базове порівняння (QC)
```sas
proc sort data=fl.hw6_1_fl out=fl_sorted; by subjid vsdtc vstestcd; run;
proc sort data=qc.hw6_1_qc out=qc_sorted; by subjid vsdtc vstestcd; run;

proc compare base=fl_sorted compare=qc_sorted listall;
    id subjid vsdtc vstestcd;
run;
```

### Зберегти звіт у файл
```sas
proc printto print="C:\output\comparison_report.txt" new;
run;

title "Comparison of Task 1";
proc compare base=fl.hw6_1_fl compare=qc.hw6_1_qc listall;
    id subjid vsdtc vstestcd;
run;

proc printto;    /* повернути вивід до default */
run;
```

### Порівняти тільки певні змінні
```sas
proc compare base=ds1 compare=ds2;
    id usubjid;
    var aestdtc aeendtc aestdy aeendy;
run;
```

## Корисні опції
| Опція | Що робить |
|-------|-----------|
| `listall` | Показати всі відмінності |
| `warn` | Тільки WARNING якщо є відмінності |
| `noprint` | Не виводити на екран |
| `out=ds` | Зберегти відмінності в датасет |
| `criterion=0.0001` | Допустима різниця для числових |

## ⚠️ Поради
- Завжди сортуй обидва датасети **однаково** перед compare.
- Якщо не вказати `ID` — порівнює по позиції рядка.
- Різниця в **length** або **format** теж буде відмічена як відмінність.
