# Макро-функції

## Швидка довідка

| Функція | Що робить |
|---------|-----------|
| `%length(str)` | Довжина рядка |
| `%upcase(str)` | Верхній регістр |
| `%substr(str, pos, len)` | Підрядок |
| `%scan(str, n, delim)` | N-те слово |
| `%index(src, str)` | Позиція підрядка |
| `%eval(expr)` | Цілочисельна арифметика |
| `%sysevalf(expr)` | Арифметика з дробами |
| `%str(text)` | Маскування спеціальних символів |
| `%nrstr(text)` | Маскування + `&` та `%` |
| `%sysfunc(func())` | Виклик SAS-функції у макросі |
| `%symexist(var)` | Чи існує макро-змінна (0/1) |
| `%symdel var` | Видалити макро-змінну |

## Рецепти

### Арифметика
```sas
%let n = 5;
%let m = 3;

%let sum   = %eval(&n. + &m.);          /* → 8 (цілі числа) */
%let prod  = %eval(&n. * &m.);          /* → 15 */
%let float = %sysevalf(2.5 + 1.3);      /* → 3.8 */
%let bool  = %sysevalf(3.5 > 2, boolean); /* → 1 */
%let ceil  = %sysevalf(3.2, ceil);       /* → 4 */
```

### Рядкові функції
```sas
%let domain = ae_train;

%let n    = %length(&domain.);              /* → 8 */
%let up   = %upcase(&domain.);             /* → AE_TRAIN */
%let part = %substr(&domain., 1, 2);       /* → ae */
%let word = %scan(&domain., 1, _);         /* → ae */
%let pos  = %index(&domain., _);           /* → 3 */
```

### %SYSFUNC — SAS функції в макросах
```sas
/* Виклик будь-якої SAS функції */
%let today_str = %sysfunc(today(), date9.);        /* → 31MAR2026 */
%let today_iso = %sysfunc(today(), is8601da.);     /* → 2026-03-31 */

/* Перевірити чи існує датасет */
%if %sysfunc(exist(rawdata.ae)) %then %do;
    %put Dataset exists;
%end;

/* Відкрити/закрити датасет для читання атрибутів */
%let dsid = %sysfunc(open(rawdata.ae));
%let nobs = %sysfunc(attrn(&dsid., nlobs));
%let rc   = %sysfunc(close(&dsid.));
%put Observations: &nobs.;

/* Рядкові функції */
%let clean = %sysfunc(compress(&domain., _));
%let repl  = %sysfunc(tranwrd(&domain., train, test));
```

### %STR — маскування розділових символів
```sas
/* Якщо значення містить кому, крапку з комою тощо */
%let cond = %str(a.AESEV = "MODERATE" and a.AEREL = "POSSIBLY");

proc sql;
    select * from ae where &cond.;
quit;

/* Текст NOTE у %put без SAS-інтерпретації */
%put NO%str(TE): Processing complete.;
```

### %SYMEXIST — перевірити існування змінної
```sas
%if %symexist(my_var) %then %do;
    %put Variable exists: &my_var.;
%end;
%else %do;
    %put Variable not defined.;
%end;
```
