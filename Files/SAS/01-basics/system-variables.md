# Системні змінні _N_ та _ERROR_

## _N_ — номер поточної ітерації

```sas
data result;
    set ds;
    obs_num = _N_;    /* 1, 2, 3, ... */
run;
```

### Типові застосування
```sas
/* Перший запис */
data result;
    set ds;
    if _N_ = 1 then putlog "First record: " subjid;
run;

/* Кожен 100-й запис */
data result;
    set ds;
    if mod(_N_, 100) = 0 then putlog "Processing record " _N_;
run;

/* Обмежити кількість записів для тестування */
data sample;
    set ds;
    if _N_ > 50 then stop;
run;
```

## _ERROR_ — прапор помилки

```sas
data result;
    set ds;
    obs_num = _N_;
    has_error = _ERROR_;    /* 0 = OK, 1 = помилка в цій ітерації */
run;
```

### Знайти записи з помилками конвертації
```sas
data result;
    set ds;
    num_val = input(char_field, best.);    /* якщо "ABC" → _ERROR_=1 */
    if _ERROR_ then do;
        putlog "ERROR: Cannot convert '" char_field "' to number. N=" _N_;
        _ERROR_ = 0;    /* скинути щоб не зупиняти датастеп */
    end;
run;
```

## Автоматичні макро-змінні SAS

```sas
%put &sysdate.;       /* дата початку сесії: 31MAR26 */
%put &sysday.;        /* день тижня: Wednesday */
%put &systime.;       /* час початку сесії: 08:00 */
%put &sysdsn.;        /* останній створений датасет */
%put &sysmacroname.;  /* ім'я поточного макросу */
%put &sysrc.;         /* return code останньої операції */

/* Вивести всі */
%put _ALL_;
%put _USER_;          /* тільки користувацькі */
%put _GLOBAL_;        /* тільки глобальні */
```
