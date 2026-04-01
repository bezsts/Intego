# Параметри макросів

## Два типи параметрів

### Позиційні (Positional)
Значення передаються за позицією, без іменування.

```sas
%macro sort_ds(dataset, sortvar);
    proc sort data=&dataset;
        by &sortvar;
    run;
%mend sort_ds;

/* Виклик — порядок має значення */
%sort_ds(ae, usubjid);
%sort_ds(vs, usubjid vstestcd visitnum);
```

### Keyword
Значення передаються за іменем. Можна мати default значення.

```sas
%macro sort_kw(dataset=, sortvar=usubjid);
    proc sort data=&dataset;
        by &sortvar;
    run;
%mend sort_kw;

/* Виклик */
%sort_kw(dataset=ae);                         /* sortvar=usubjid (default) */
%sort_kw(dataset=vs, sortvar=usubjid vstestcd);
%sort_kw(sortvar=age, dataset=dm);             /* порядок не важливий */
```

## Рецепти

### Макрос сортування та обробки датасету
```sas
%macro process(dsin=, dsout=, sortvar=usubjid, lib=work);
    proc sort data=&lib..&dsin. out=&lib..&dsout.;
        by &sortvar;
    run;
    %put NOTE: &dsin. sorted by &sortvar. → &dsout.;
%mend process;

%process(dsin=ae, dsout=ae_s, sortvar=usubjid aestart);
%process(dsin=dm, dsout=dm_s, lib=rawdata);
```

### Перевірка обов'язкових параметрів
```sas
%macro run_means(data=, var=, class=);
    %if %length(&data.) = 0 %then %do;
        %put ERROR: Parameter DATA= is required.;
    %end;
    %else %if %length(&var.) = 0 %then %do;
        %put ERROR: Parameter VAR= is required.;
    %end;
    %else %do;
        proc means data=&data. n mean std;
            %if %length(&class.) > 0 %then class &class.;;
            var &var.;
        run;
    %end;
%mend run_means;

%run_means(data=vs, var=vsstresn, class=vstestcd);
%run_means(data=vs);    /* ERROR — VAR= not specified */
```

### Комбінування позиційних та keyword
```sas
/* Позиційні — спочатку, keyword — потім */
%macro analyze(domain, param=, class=usubjid);
    proc means data=&domain;
        class &class;
        var &param;
    run;
%mend analyze;

%analyze(vs, param=vsstresn);
%analyze(lb, param=lbstresn, class=usubjid lbtestcd);
```

## ⚠️ Правила
- Keyword параметри можна передавати в будь-якому порядку.
- Позиційні — тільки за позицією.
- Не можна змішувати: позиційні спочатку, keyword потім.
- Keyword без default = порожній рядок якщо не передано.
