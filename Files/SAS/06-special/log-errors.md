# Типові помилки та як їх виправити

---

## NOTE: Variable not referenced (DROP/KEEP list)

```sas
/* ❌ Неправильно — "pol" не існує */
data result(keep=name region pop pol);
    set sashelp.demographics(keep=name region pop);
run;

/* ✅ Правильно */
data result(keep=name region pop new_var);
    set sashelp.demographics(keep=name region pop);
    length new_var 8;
    call missing(new_var);
run;
```

---

## NOTE: Missing values generated (операції з missing)

```sas
/* ❌ Неправильно — якщо stores=missing, dummy_1=missing і NOTE в лозі */
data result;
    set shoes;
    dummy_1 = stores + 7;
run;

/* ✅ Правильно — варіант 1 */
data result;
    set shoes;
    if not missing(stores) then dummy_1 = stores + 7;
run;

/* ✅ Правильно — варіант 2 (SUM ігнорує missing) */
data result;
    set shoes;
    dummy_1 = sum(stores, 7);
run;
```

---

## NOTE: Numeric values converted to character

```sas
/* ❌ Неправильно */
char_var = weight;   /* NOTE: Numeric values converted... */

/* ✅ Правильно */
char_var = strip(put(weight, best.));
```

---

## ERROR: Format not found

```sas
/* ❌ Неправильно — формат "zdsa" не існує */
format v1 zdsa2.;

/* ✅ Правильно — використовуй стандартний або визначений формат */
format v1 date9.;
```

---

## W.D Format — значення не поміщається

```sas
/* ❌ Неправильно — 8.2 для 123124.322 → "********" */
l = put(k, 8.2);

/* ✅ Правильно */
l = strip(put(k, best.));
l = strip(put(k, 12.2));   /* достатня ширина */
```

---

## Many-to-Many MERGE (NOTE у лозі)

```sas
/* ❌ Небезпечно — обидва мають дублікати по BY-змінній */
data result;
    merge ds1 ds2;
    by subjid;
run;

/* ✅ Правильно — видалити дублікати з одного перед merge */
proc sort data=ds2 nodupkey; by subjid; run;
data result;
    merge ds1 ds2;
    by subjid;
run;

/* Або використати PROC SQL */
proc sql;
    create table result as
    select a.*, b.var1
    from ds1 as a
    left join (select distinct subjid, var1 from ds2) as b
    on a.subjid = b.subjid;
quit;
```

---

## Remerging Summary Statistics (PROC SQL)

```sas
/* ❌ Неправильно — NOTE: Remerging has been done */
proc sql;
    select make, model, horsepower,
           max(horsepower) as max_hp
    from cars
    group by make;
quit;

/* ✅ Правильно — підзапит */
proc sql;
    create table summary as
    select distinct make, max(horsepower) as max_hp
    from cars
    group by make;

    create table result as
    select a.*, b.max_hp
    from cars as a
    left join summary as b on a.make = b.make;
quit;
```

---

## Unbalanced quotation (довгі title)

```sas
/* ❌ Може викликати NOTE: QUOTELENMAX */
title "Дуже довгий заголовок ...";

/* ✅ Правильно */
option noquotelenmax;
title "Дуже довгий заголовок ...";
```

---

## Ділення на нуль

```sas
/* ❌ Неправильно */
c = n / d;

/* ✅ Правильно */
if d = 0 then c = .;
else c = n / d;
```
