# If-Then-Else

## Синтаксис

```sas
if умова then дія;
else if умова then дія;
else дія;

/* З блоком DO */
if умова then do;
    дія1;
    дія2;
end;
else do;
    дія3;
end;
```

## Рецепти

### Простий if-else
```sas
data dm;
    set raw.demog;

    if gender = 1 then sex = "M";
    else if gender = 2 then sex = "F";
    else call missing(sex);
run;
```

### Вкладені блоки
```sas
data cars;
    set sashelp.cars;
    length class $20;

    if msrp > 50000 then class = "LUXURY";
    else if msrp < 15000 then class = "CHEAP";
    else do;
        if horsepower >= 250 then class = "MIDDLE-COOL";
        else class = "MIDDLE";
    end;
run;
```

### if vs where — різниця
```sas
/* WHERE — фільтрує до завантаження (швидше, але є обмеження) */
data result;
    set ds;
    where vstestcd = "WEIGHT";   /* не можна використовувати нові змінні */
run;

/* IF — фільтрує після завантаження */
data result;
    set ds;
    if vstestcd = "WEIGHT";      /* можна використовувати будь-які змінні */
run;

/* WHERE в SET — ефективно */
data result;
    set ds(where=(vstestcd = "WEIGHT"));
run;
```

### WHERE не може посилатися на нові змінні
```sas
data result;
    set ds;
    trtcd = ifc(trtmt = "A", 1, 0);

    /* if trtcd = 1; */     /* ✅ — нова змінна */
    /* where trtcd = 1; */  /* ❌ — помилка компіляції */
run;
```

## IFC / IFN — однорядковий if
```sas
/* Символьний результат */
sex    = ifc(gender = 1, "Male", "Female");
vsstat = ifc(missing(vsorres), "NOT DONE", "");

/* Числовий результат */
flag   = ifn(aeval >= 3, 1, 0);
```
