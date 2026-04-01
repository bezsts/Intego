# Merge — об'єднання датасетів

## Що робить
Об'єднує два або більше датасети по ключових змінних (аналог JOIN у SQL).

> ⚠️ Перед `merge` — завжди `proc sort` по BY-змінних.

## Синтаксис
```sas
data result;
    merge A(in=a) B(in=b);
    by key;
    if a;       /* LEFT JOIN — тільки записи з A */
run;
```

## Типи з'єднань через IN=

| Умова | Тип |
|-------|-----|
| `if a` | LEFT JOIN (всі з A) |
| `if b` | RIGHT JOIN (всі з B) |
| `if a and b` | INNER JOIN (тільки збіги) |
| *(без умови)* | FULL OUTER JOIN |

## Рецепти

### LEFT JOIN: додати демографію до AE
```sas
proc sort data=ae;  by usubjid; run;
proc sort data=dm;  by usubjid; run;

data ae_with_demo;
    merge ae(in=a) dm(keep=usubjid sex age rfstdtc);
    by usubjid;
    if a;
run;
```

### INNER JOIN: тільки пацієнти з обох датасетів
```sas
data matched;
    merge ds1(in=a) ds2(in=b);
    by subjid;
    if a and b;
run;
```

### Додати одну змінну з іншого датасету
```sas
proc sort data=vs; by usubjid; run;
proc sort data=dm(keep=usubjid rfstdtc); by usubjid; run;

data vs_with_rfstdtc;
    merge vs(in=a) dm;
    by usubjid;
    if a;
run;
```

### Вирахувати Study Day після merge
```sas
data ae_studyday;
    merge ae(in=a) dm(keep=usubjid rfstdtc);
    by usubjid;
    if a;

    if length(aestdtc) >= 10 and length(rfstdtc) >= 10 then
        aestdy = input(substr(aestdtc,1,10), is8601da.)
               - input(substr(rfstdtc,1,10), is8601da.)
               + (aestdtc >= rfstdtc);
run;
```

## ⚠️ Підводні камені

### Many-to-many — небезпечно!
```sas
/* Якщо обидва датасети мають дублікати по BY-змінній — 
   SAS видасть NOTE у лог і результат може бути несподіваним */
/* Краще використовуй PROC SQL або видаляй дублікати заздалегідь */
```

### Однакові змінні в обох датасетах
```sas
/* Змінна з другого датасету перезапише першу */
/* Розв'язок: drop або rename перед merge */
merge ae(in=a drop=studyid) dm(keep=usubjid studyid);
```
