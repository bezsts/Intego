# Спеціальні функції: LAG, IFC/IFN, COALESCE, EXIST, WHICHN

## LAG / DIF — значення з попереднього рядка

### Що роблять
- `LAG(var)` — повертає значення змінної з **попередньої ітерації**.
- `DIF(var)` — різниця між поточним і попереднім значенням.

> ⚠️ `LAG` має власну чергу. Якщо виклик знаходиться всередині `IF` — черга не оновлюється для пропущених ітерацій. Завжди викликай **безумовно**.

```sas
data changes;
    set vs_sorted;
    by subjid paramcd;

    lag_val  = lag(aval);      /* ЗАВЖДИ безумовно */
    dif_val  = dif(aval);

    /* Скинути на початку групи */
    if first.paramcd then call missing(lag_val, dif_val);

    if not missing(lag_val) then do;
        chg  = aval - lag_val;
        pchg = chg * 100 / lag_val;
    end;
run;
```

---

## IFC / IFN — інлайн умовна функція

### Що роблять
Повертають значення залежно від умови (аналог тернарного оператора).
- `IFC` — повертає **символьне** значення.
- `IFN` — повертає **числове** значення.

```sas
/* IFC(умова, якщо_true, якщо_false) */
sex_label = ifc(gender = 1, "Male", "Female");
vsstat    = ifc(missing(vsorres), "NOT DONE", "");

/* IFN */
trt_flag  = ifn(trtmt = "A", 1, 0);
```

---

## COALESCE — перше не-пропущене значення

```sas
/* Числовий */
final_val = coalesce(val1, val2, val3);   /* перший не-missing */

/* Символьний */
final_str = coalescec(str1, str2, str3);

/* Масив змінних */
result = coalesce(of v1-v5);
result = coalesce(of v:);
```

---

## EXIST — перевірити чи існує датасет

```sas
data _null_;
    if exist("rawdata.ae", "DATA") then
        put "NOTE: Dataset exists.";
    else
        put "ERROR: Dataset not found!";
run;

/* В макросі */
%if %sysfunc(exist(&dsin.)) %then %do;
    /* ... */
%end;
```

---

## MISSING — перевірити пропущене значення

```sas
if missing(var) then ...;
if not missing(var) then ...;

/* Кількість пропущених у списку */
n_miss = nmiss(v1, v2, v3, v4);        /* числові */
n_miss = cmiss(v1, v2, str1, str2);    /* змішані */
```

---

## WHICHN / WHICHC — індекс значення в масиві

```sas
/* Знайти де мінімум у масиві */
array diffs {11};
/* ... заповнити diffs ... */
min_val  = min(of diffs{*});
min_idx  = whichn(min_val, of diffs{*});   /* повертає індекс */
dose_date = all_dates{min_idx};
```

---

## V-функції — атрибути змінних

```sas
data v_attrs;
    dog = 13790;
    label dog = "Variable 1";
    format dog date9.;

    var_label = vlabel(dog);    /* "Variable 1" */
    var_type  = vtype(dog);     /* "N" або "C" */
    var_value = vvalue(dog);    /* "28SEP1997" — форматоване значення */
    var_name  = vname(dog);     /* "DOG" */
run;
```

---

## CALL MISSING — скинути змінні

```sas
/* Очистити одну */
call missing(var1);

/* Очистити кілька */
call missing(var1, var2, var3);

/* Очистити масив */
array flags $1 fl1-fl10;
call missing(of flags{*});
```
