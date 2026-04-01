# Keep / Drop / Where / Rename

## Де можна застосовувати

| Опція | В SET/DATA | В PROC | Як statement |
|-------|-----------|--------|-------------|
| KEEP | ✅ | ✅ | ✅ |
| DROP | ✅ | ✅ | ✅ |
| WHERE | ✅ | ✅ | ✅ |
| RENAME | ✅ | — | ✅ |

> ⚠️ Опції в дужках `dataset(keep=...)` обробляються **при читанні/записі**, statement без дужок — **в кінці** DATA step.

## Рецепти

### KEEP — залишити тільки ці змінні
```sas
/* В SET — читаємо тільки потрібні */
data result;
    set sashelp.cars(keep=make model msrp);
run;

/* В DATA — зберігаємо тільки потрібні */
data result(keep=make model msrp);
    set sashelp.cars;
    msrp_eur = msrp * 0.92;   /* ця змінна НЕ збережеться */
run;
```

### DROP — видалити змінні
```sas
data result;
    set sashelp.cars;
    drop type origin drivetrain invoice;
run;

/* DROP у SET — не завантажувати ці змінні */
data result;
    set raw.ae(drop=formid aelineno);
run;
```

### WHERE — фільтр записів
```sas
/* В SET */
data weight_only;
    set vs(where=(vstestcd = "WEIGHT"));
run;

/* Як statement */
data weight_only;
    set vs;
    where vstestcd = "WEIGHT";
run;

/* В PROC */
proc means data=vs(where=(vstestcd = "WEIGHT"));
    var vsstresn;
run;
```

### RENAME — перейменувати змінну
```sas
/* При читанні — зручно уникати конфліктів */
data ae;
    set raw.ae(rename=(studyid=_studyid cmdose=_cmdose));
    if not missing(_studyid) then studyid = strip(_studyid);
run;

/* Як statement — в кінці datastep */
data result;
    set source;
    rename old_name = new_name;
run;
```

### Комбінування всіх опцій
```sas
data result(keep=make model company msrp);
    set sashelp.cars(
        keep    = make model msrp
        where   = (make = "Audi")
        rename  = (make = company)
    );
run;
```

## ⚠️ Порядок виконання
SAS обробляє опції датасету в алфавітному порядку: `drop` → `keep` → `rename` → `where`. Але на практиці важливо пам'ятати:
- Якщо `rename` у SET і `keep` у DATA — посилайся на **нове** ім'я в `keep`.
- `where` у SET не може посилатися на змінні, яких немає у вхідному датасеті.
