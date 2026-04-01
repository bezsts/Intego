# PROC MEANS

## Що робить
Обчислює описову статистику (N, Mean, Std, Min, Max, Median тощо) для числових змінних. Підтримує групування через `CLASS` або `BY`.

## Синтаксис
```sas
proc means data=<ds> <статистики> <опції>;
    by <змінна>;           /* групування (потрібне сортування) */
    class <змінна(и)>;     /* групування (сортування НЕ потрібне) */
    var <змінні>;          /* змінні для аналізу */
    types <комбінації>;    /* які рівні CLASS виводити */
    ways <0|1|2...>;       /* скільки змінних комбінувати */
    output out=<ds> <статистика>=<ім'я> / autoname;
run;
```

## Основні статистики
| Ключ | Значення |
|------|---------|
| `n` | Кількість не пропущених |
| `nmiss` | Кількість пропущених |
| `mean` | Середнє |
| `median` | Медіана |
| `std` | Стандартне відхилення |
| `min` / `max` | Мінімум / Максимум |
| `q1` / `q3` | Квартилі 25% / 75% |
| `range` | Max − Min |
| `uclm` / `lclm` | Верхня / нижня межа ДІ |

## Рецепти

### Базова статистика
```sas
proc means data=vs n mean std min max;
    var vsstresn;
run;
```

### BY-групи (потрібне сортування)
```sas
proc sort data=vs; by usubjid; run;

proc means data=vs n mean median min max std noprint;
    by usubjid;
    var vsstresn;
    output out=mean_by n=n mean=mean median=median min=min max=max std=std;
run;
```

### CLASS (сортування не потрібне)
```sas
proc means data=vs noprint n mean;
    class usubjid vstestcd;
    var vsstresn;
    output out=mean_class n= mean= / autoname;
run;
```

### TYPES — вибрати конкретні комбінації CLASS
```sas
proc means data=vs noprint n;
    class usubjid vstestcd;
    var vsstresn;
    types usubjid*vstestcd usubjid;    /* тільки ці дві комбінації */
    output out=mean_types n= / autoname;
run;

/* Те саме через WAYS */
proc means data=vs noprint n;
    class usubjid vstestcd;
    var vsstresn;
    ways 1;    /* всі одиночні CLASS: usubjid та vstestcd окремо */
    output out=mean_ways n= / autoname;
run;
```

### Зберегти в датасет з власними іменами
```sas
proc means data=vs n mean median min max std noprint;
    by usubjid;
    var vsstresn;
    output out=mean_out
        n      = n_obs
        mean   = mean_val
        median = median_val
        min    = min_val
        max    = max_val
        std    = std_val;
run;
```

### AUTONAME — автоматичні імена
```sas
proc means data=vs noprint n mean std;
    class usubjid vstestcd;
    var vsstresn;
    output out=mean_auto n= mean= std= / autoname;
    /* Створить: vsstresn_n, vsstresn_mean, vsstresn_std */
run;
```

## Змінна _TYPE_ у виводі CLASS
| _TYPE_ | Значення |
|--------|---------|
| `0` | Загальний підсумок (весь датасет) |
| `1` | Підсумок по другій CLASS-змінній |
| `2` | Підсумок по першій CLASS-змінній |
| `3` | Підсумок по обох CLASS-змінних |
