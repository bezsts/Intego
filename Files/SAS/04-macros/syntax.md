# Синтаксис макросів

## Що таке макрос
Макрос — це іменований блок коду, що генерує SAS-код під час виконання. Дозволяє параметризувати та повторно використовувати код.

## Базовий синтаксис

### Визначення та виклик
```sas
/* Визначення */
%macro my_macro;
    proc print data=work.result; run;
%mend my_macro;

/* Виклик */
%my_macro;
```

### З параметрами
```sas
%macro sort_ds(dataset, sortvar=subjid);
    proc sort data=&dataset;
        by &sortvar;
    run;
%mend sort_ds;

/* Виклик */
%sort_ds(ae_train, sortvar=usubjid);
%sort_ds(dm_train);   /* sortvar=subjid за замовчуванням */
```

## Макро-змінні

### Оголошення та використання
```sas
%let domain = AE;
%let keepvars = studyid domain usubjid aeseq aeterm;

data &domain.;
    keep &keepvars.;
    set raw_&domain.;
run;
```

> ⚠️ Крапка після `&var.` — роздільник. `&domain.seq` → значення `domain` + `seq` як текст. `&domain._seq` теж працює.

### Подвійний амперсанд (&&)
```sas
/* &&var&i → спочатку &i → 1, потім &var1 */
%let trt1 = GBR12909;
%let trt2 = Placebo;
%let i = 2;

%put &&trt&i.;   /* → Placebo */
```

## Дебаг-опції
```sas
options symbolgen;      /* показує підстановку макро-змінних */
options mlogic;         /* показує виконання макросів */
options mprint;         /* показує згенерований SAS код */
options mlogic mprint symbolgen;   /* все разом */

options nosymbolgen nomlogic nomprint;   /* вимкнути */
```

## Вивід у лог
```sas
%put Значення domain: &domain.;
%put _ALL_;      /* всі макро-змінні */
%put _USER_;     /* тільки користувацькі */
%put _GLOBAL_;   /* тільки глобальні */

/* Приховати WARNING / ERROR / NOTE у виводі */
%put NO%str(TE): Це нотатка;
%put W%str(ARNING): Це попередження;
```
