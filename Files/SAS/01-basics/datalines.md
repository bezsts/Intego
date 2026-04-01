# Datalines / Infile — вбудовані дані

## DATALINES / CARDS / LINES

Вбудовує дані прямо у програму. Всі три ключові слова (`datalines`, `cards`, `lines`) рівнозначні.

```sas
data example;
    input subjid $ sex $ age;
    datalines;
001 M 43
002 F 51
003 M 27
;
run;
```

## З роздільником (INFILE DATALINES + DELIMITER)

```sas
data example;
    infile datalines delimiter=",";
    length subjid $5 sex $1 race $30;
    input subjid $ sex $ age race $;
    datalines;
01001,M,43,ASIAN
01002,F,51,WHITE
01005,M,27,OTHER
;
run;
```

## DSD — для CSV із лапками

```sas
/* DSD: роздільник = кома + strip лапок + порожні поля = missing */
data te;
    infile datalines dsd;
    length studyid domain element $10 testrl teenrl $60;
    input studyid $ domain $ element $ testrl $ teenrl $;
    datalines;
EX1,TE,SCRN,"Informed consent","1 week after start"
EX1,TE,A,"First dose","2 weeks after start"
;
run;
```

## DATALINES4 — якщо дані містять крапку з комою

```sas
/* Дані з ";" всередині → використовуй DATALINES4 */
/* Закривається чотирма ";;;;", не одним ";" */
data d4_example;
    input var1 $ var2 $;
    datalines4;
val1; val2
;; ;;;
;;;;
run;
```

## INFILE — читати з файлу

```sas
data from_file;
    infile "C:\data\subjects.csv" dsd firstobs=2;
    length usubjid $24 sex $1 age 8;
    input usubjid $ sex $ age;
run;
```

### Опції INFILE
| Опція | Що робить |
|-------|-----------|
| `delimiter=","` | Встановити роздільник |
| `dsd` | CSV-режим (кома + лапки) |
| `firstobs=2` | Почати з рядка 2 (пропустити заголовок) |
| `obs=100` | Читати тільки перші 100 рядків |
| `missover` | Не переходити на наступний рядок якщо поля закінчились |
| `truncover` | Як missover, але з усіченням |

## Зчитати дату як рядок потім перетворити

```sas
data id;
    infile datalines delimiter=",";
    length subjid $3 sex $1 race $30;
    input subjid $ sex $ age race $ date;
    datalines;
001,F,23,WHITE,20181018
002,M,31,ASIAN,20181010
;
run;

data id2;
    set id;
    day   = mod(date, 100);
    month = floor(mod(date / 100, 100));
    year  = floor(date / 10000);
    new_date  = mdy(month, day, year);
    rfxstdtc  = put(new_date, is8601da.);
    format new_date date9.;
run;
```
