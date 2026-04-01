# PROC IMPORT

## Що робить
Зчитує зовнішні файли (Excel, CSV, тощо) у SAS датасет.

## Синтаксис

```sas
proc import
    datafile = "<шлях до файлу>"
    out      = <вихідний датасет>
    dbms     = <тип файлу>
    replace;        /* перезаписати якщо вже існує */

    /* Опції залежно від DBMS */
run;
```

## DBMS типи
| DBMS | Тип файлу |
|------|-----------|
| `csv` | CSV файл |
| `xlsx` | Excel (новий формат) |
| `xls` | Excel (старий формат) |
| `tab` | Tab-separated |
| `dlm` | Загальний роздільник |

## Рецепти

### Імпорт CSV
```sas
proc import
    datafile = "C:\data\subjects.csv"
    out      = work.subjects
    dbms     = csv
    replace;
    getnames = yes;       /* перший рядок = назви змінних */
    /* guessingrows = max; */  /* SAS визначає типи з усіх рядків (повільніше) */
run;
```

### Імпорт Excel
```sas
proc import
    datafile = "C:\data\vitals.xlsx"
    out      = work.vitals
    dbms     = xlsx
    replace;
    sheet    = "VS Data";    /* назва листа */
    getnames = yes;
run;
```

### CSV без заголовка
```sas
proc import
    datafile = "C:\data\noheader.csv"
    out      = work.data
    dbms     = csv
    replace;
    getnames = no;          /* немає заголовка → змінні: VAR1, VAR2, ... */
    datarow  = 1;           /* дані починаються з рядка 1 */
run;
```

### Після імпорту — перевірити структуру
```sas
proc contents data=work.vitals varnum;
run;

proc print data=work.vitals(obs=5);
run;
```

## ⚠️ Типові проблеми

| Проблема | Причина | Рішення |
|----------|---------|---------|
| Тип змінної неправильний | SAS визначає тип за першими 20 рядками | `guessingrows=max` |
| Дати як числа | SAS не розпізнав формат дати | Ручна конвертація після імпорту |
| Пробіли в іменах змінних | Excel дозволяє пробіли | `options validvarname=any;` або перейменувати |
