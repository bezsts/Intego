# PROC SORT

## Синтаксис

```sas
proc sort data=<вхідний> out=<вихідний> <опції>;
    by <DESCENDING> var1 var2 ...;
run;
```

> ⚠️ Без `OUT=` — сортування **замінює** вхідний датасет. Завжди вказуй `OUT=` для безпеки.

## Рецепти

### Просте сортування
```sas
proc sort data=ae out=ae_sorted;
    by usubjid aestart;
run;
```

### Спадний порядок
```sas
proc sort data=vs out=vs_desc;
    by descending vsstresn;
run;

/* Кілька змінних з різним напрямком */
proc sort data=auto out=auto_sort;
    by make descending mpg descending weight;
run;
```

### Видалити дублікати (NODUPKEY)
```sas
/* Залишити перший запис для кожного ключа */
proc sort data=demog out=demog_nodup nodupkey;
    by studyid siteid subjid;
run;

/* Видалити повні дублікати (всі змінні однакові) */
proc sort data=ds out=ds_nodup nodupkey;
    by _ALL_;
run;
```

### Зберегти дублікати в окремий датасет
```sas
proc sort data=demog out=demog_nodup nodupkey
          dupout=demog_dups;
    by subjid;
run;
```

### Сортування + відбір змінних в одному кроці
```sas
proc sort data=rawdata.ae
          out=ae(keep=usubjid aeterm aestdtc aeendtc aesev);
    by usubjid aestdtc;
run;
```

### Алфавітний порядок без урахування регістру (LINGUISTIC)
```sas
proc sort data=auto sortseq=linguistic(strength=primary) out=auto_alpha;
    by make;
run;
```

## Корисні опції PROC SORT
| Опція | Що робить |
|-------|-----------|
| `nodupkey` | Видалити записи з однаковим BY-ключем |
| `noduprecs` | Видалити повністю ідентичні записи |
| `dupout=ds` | Зберегти дублікати |
| `tagsort` | Економія пам'яті для великих датасетів |
| `sortseq=linguistic` | Лінгвістичне сортування |
