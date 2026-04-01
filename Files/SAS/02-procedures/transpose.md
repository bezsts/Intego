# PROC TRANSPOSE

## Що робить
Перетворює рядки на стовпці або стовпці на рядки. Широкий формат ↔ довгий формат.

## Синтаксис
```sas
proc transpose data=<ds> out=<ds>
    prefix=<префікс>      /* замість COL1, COL2... */
    name=<ім'я_стовпця>   /* перейменувати _NAME_ */
    suffix=<суфікс>
    ;
    by <змінні>;          /* групування (SORT FIRST!) */
    var <змінні>;         /* що транспонуємо */
    id <змінна>;          /* значення → імена стовпців */
    idlabel <змінна>;     /* значення → labels стовпців */
run;
```

## Рецепти

### Довгий → Широкий (pivot)
```sas
/* Кожен тест стає окремим стовпцем */
proc sort data=vs; by usubjid; run;

proc transpose data=vs out=vs_wide(drop=_name_)
    suffix=_orres;
    by usubjid;
    var vsorres;
    id vstestcd;    /* WEIGHT_ORRES, PULSE_ORRES ... */
run;
```

### Широкий → Довгий (unpivot)
```sas
proc transpose data=vs_wide out=vs_long
    name=vstestcd;
    by usubjid;
    var weight_orres pulse_orres sysbp_orres;
run;
```

### Транспонувати кілька змінних — два кроки
```sas
/* Крок 1: ORRES */
proc transpose data=vs out=orres(drop=_name_) suffix=_orres;
    by usubjid;
    var vsorres;
    id vstestcd;
run;

/* Крок 2: STRESC */
proc transpose data=vs out=stresc(drop=_name_) suffix=_stresc;
    by usubjid;
    var vsstresc;
    id vstestcd;
run;

data vs_wide;
    merge orres stresc;
    by usubjid;
run;
```

### Транспонувати дати — отримати масив для пошуку
```sas
proc sort data=invagt out=dose_info nodupkey;
    by studyid subjid daydate;
run;

proc transpose data=dose_info out=tr_doses(drop=_name_ _label_) prefix=__date;
    by subjid;
    var daydate;
run;
/* Результат: __date1, __date2, ... __dateN */
```

### BY + ID + VAR разом
```sas
proc sort data=rdmcode; by subjid trtmt; run;

proc transpose data=rdmcode out=rdmcode_wide;
    by subjid;
    var daterandomized;
    id trtmt;       /* A, B, C → стовпці */
    idlabel xtrtmt; /* labels = назви груп */
run;
```

## Авто-змінні у виводі
| Змінна | Опис |
|--------|------|
| `_NAME_` | Ім'я транспонованої змінної |
| `_LABEL_` | Label транспонованої змінної |
| `COL1, COL2...` | Значення (якщо немає ID) |

## ⚠️ Підводні камені
- ID-змінна **не може мати дублікатів** всередині BY-групи → треба спочатку вирішити дублікати або створити суррогатний ключ.
- `BY` вимагає попереднього `PROC SORT`.
