# Dictionary Tables

## Що таке Dictionary Tables
Read-only псевдо-таблиці, що містять метадані поточної SAS-сесії: бібліотеки, датасети, змінні, формати тощо.

Доступні тільки через `PROC SQL`.

## Основні таблиці
| Таблиця | Що містить |
|---------|-----------|
| `dictionary.tables` | Інформація про датасети |
| `dictionary.columns` | Змінні (ім'я, тип, формат, label) |
| `dictionary.libnames` | Підключені бібліотеки |
| `dictionary.formats` | Зареєстровані формати |
| `dictionary.macros` | Макро-змінні |
| `dictionary.options` | Опції SAS |

## Рецепти

### Знайти всі змінні з DATE форматом у датасеті
```sas
proc sql noprint;
    select name into :vars separated by " "
    from dictionary.columns
    where libname = "RAWDATA"
      and memname = "AE"
      and format like "DATE%";
quit;
%put Date variables: &vars.;
```

### Перевірити чи існує змінна
```sas
proc sql noprint;
    select count(*) into :var_exists
    from dictionary.columns
    where libname = "WORK"
      and memname = "DS"
      and name = "USUBJID";
quit;

%if &var_exists. > 0 %then %put Variable exists.;
```

### Список всіх датасетів у бібліотеці
```sas
proc sql;
    select memname, nobs, nvar
    from dictionary.tables
    where libname = "RAWDATA"
    order by memname;
quit;
```

### Список змінних у датасеті (з атрибутами)
```sas
proc sql;
    select name, type, length, format, label
    from dictionary.columns
    where libname = "WORK"
      and memname = "DM"
    order by varnum;
quit;
```

### Знайти змінні певного типу
```sas
proc sql noprint;
    select name into :char_vars separated by " "
    from dictionary.columns
    where libname = "WORK"
      and memname = "VS"
      and type = "char";
quit;
```

## ⚠️ Важливо
- Імена бібліотек та датасетів зберігаються у **ВЕРХНЬОМУ РЕГІСТРІ** → використовуй `upcase()`.
- Поле `varnum` — порядковий номер змінної у датасеті.
