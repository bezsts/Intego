# PROC DATASETS

## Що робить
Керує файлами SAS-бібліотек: видаляє, перейменовує, модифікує атрибути змінних, додає датасети.

> Використовує `QUIT;`, не `RUN;`.

## Рецепти

### Очистити WORK на початку програми
```sas
proc datasets lib=work kill noprint;
run;
```

### Переглянути вміст бібліотеки
```sas
proc datasets lib=work;
    contents data=_all_ varnum;
quit;
```

### Переглянути один датасет
```sas
proc datasets lib=work;
    contents data=result varnum;
quit;

/* Або коротше */
proc contents data=result varnum;
run;
```

### Видалити конкретні датасети
```sas
proc datasets lib=work noprint;
    delete temp1 temp2 temp3;
quit;
```

### Зберегти тільки потрібні (видалити решту)
```sas
proc datasets lib=work noprint;
    save task1 task2 task3 final_result;
quit;
```

### Змінити атрибути змінних без DATA step
```sas
proc datasets lib=work noprint;
    modify result;
        format   visitdt date9.
                 age     3.;
        label    usubjid = "Unique Subject Identifier"
                 age     = "Age at Baseline";
        rename   old_name = new_name;
quit;
```

### Append — додати рядки до датасету
```sas
proc datasets lib=work noprint;
    append base=main_ds data=new_data;          /* мають однакову структуру */
    append base=main_ds data=new_data force;    /* різна структура */
quit;
```

## PROC CONTENTS — детально про датасет
```sas
proc contents data=result varnum;   /* varnum → порядок змінних */
run;

/* Зберегти метадані у датасет */
proc contents data=result out=metadata noprint;
run;
```
