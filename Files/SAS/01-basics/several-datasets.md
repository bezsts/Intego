# Set кілька датасетів

## Що робить
Вертикальне об'єднання датасетів (додати рядки). Аналог `UNION ALL` у SQL.

## Рецепти

### SET кількох датасетів (стекування)
```sas
data combined;
    set ae_train lb_train vs_train;
run;

/* За маскою імені */
data combined;
    set name1 name2 name3;    /* явно */
run;

data combined;
    set name:;    /* всі датасети починаються з "name" */
run;
```

### SET із IN= флагом (знати звідки запис)
```sas
data cm_all;
    set raw.conmeds(in=a)
        raw.priormed(in=b);

    if a then source = "CONMEDS";
    else if b then source = "PRIORMED";
run;
```

### SET із умовними змінними (конмеди + пріормеди → CM)
```sas
data cm_setall;
    set raw.conmeds(in=a rename=(studyid=_studyid))
        raw.priormed(in=b rename=(studyid=_studyid));

    if not missing(_studyid) then studyid = strip(_studyid);

    if a then do;
        cmtrt = strip(cmname);
        cmstdtc = put(cmstrtdt, is8601da.);
    end;

    if b then do;
        cmtrt = strip(pmname);
        cmstdtc = put(pmstrtdt, is8601da.);
    end;
run;
```

### Output у кілька датасетів
```sas
data cool_cars(keep=make model msrp horsepower)
     boring_cars(keep=make model);
    set sashelp.cars;
    if msrp > 90000 or horsepower > 400 then output cool_cars;
    else output boring_cars;
run;
```

## ⚠️ Важливо при стекуванні
- Якщо в датасетах є **однакові змінні різного типу** (char vs num) — SAS видасть ERROR.
- Якщо довжина змінної різна — буде взята довжина з **першого** датасету. Використовуй `LENGTH` на початку або `ATTRIB`, щоб встановити потрібну довжину.
- `FORCE` в `PROC DATASETS APPEND` дозволяє об'єднати датасети з різними структурами.
