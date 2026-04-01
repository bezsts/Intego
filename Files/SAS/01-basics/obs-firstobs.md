# Obs / Firstobs / End=

## Що роблять
Контролюють, які рядки читаються з датасету.

```sas
/* Тільки перші N рядків */
data sample;
    set ds(obs=10);
run;

/* Починаючи з рядка i */
data tail;
    set ds(firstobs=100);
run;

/* З рядка i до рядка j */
data slice;
    set ds(firstobs=50 obs=100);
run;
```

## Рецепти

### Переглянути датасет (перші 20 рядків)
```sas
proc print data=ds(obs=20);
run;
```

### Отримати останній рядок датасету
```sas
data last_record;
    set ds end=eof;
    if eof;
run;
```

### Отримати перший рядок
```sas
data first_record;
    set ds(obs=1);
run;
```

### END= у циклі обробки
```sas
/* Підрахувати кількість записів і зберегти в макро-змінну */
data _null_;
    set ae end=last;
    if last then call symput("n_ae", cats(_N_));
run;
%put Total AE records: &n_ae.;
```

### OBS= у PROC
```sas
/* Тест на невеликій вибірці */
proc means data=vs(obs=100) n mean;
    var vsstresn;
run;
```

## ⚠️ OBS= vs WHERE
```sas
/* OBS=10 → перші 10 рядків фізично */
data sample;
    set ds(obs=10);
run;

/* WHERE → рядки що відповідають умові (може бути менше або більше 10) */
data sample;
    set ds(where=(subjid=18349));
run;
```
