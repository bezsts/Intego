# Створення макро-змінних

Три способи створити макро-змінну: `%LET`, `CALL SYMPUT`, `PROC SQL INTO`.

---

## 1. %LET — статичне присвоєння

```sas
%let domain    = AE;
%let cutoffdt  = 15JAN2024;
%let keepvars  = studyid domain usubjid aeseq aeterm aestdtc;

/* Використання */
data &domain.;
    keep &keepvars.;
run;
```

> Значення — завжди рядок. Лапки не потрібні (і будуть частиною значення якщо додати).

---

## 2. CALL SYMPUT — з DATA step

```sas
/* Зберегти значення зі змінної датасету */
data _null_;
    set rawdata.demog(obs=1);
    call symput("first_subj", cats(subjid));
run;
%put First subject: &first_subj.;

/* Перший і останній запис */
data _null_;
    set input_data end=eof;
    if _N_ = 1 then call symput("first_subj", subjid);
    if eof then do;
        call symput("obs_num", strip(put(_N_, best.)));
        call symput("last_subj", subjid);
    end;
run;

/* Масив макро-змінних */
data _null_;
    set rdmcode end=last;
    call symput(cats("pt_", _N_), cats(subjid));
    if last then call symput("numobs", cats(_N_));
run;
/* Створить: &pt_1, &pt_2, ..., &numobs */
```

> ⚠️ Не можна використати `CALL SYMPUT` і одразу ж `&var` в тому ж DATA step.

---

## 3. PROC SQL INTO — з запиту

```sas
/* Одне значення */
proc sql noprint;
    select count(distinct usubjid) into :n_patients
    from dm_train;
quit;

/* Два значення */
proc sql noprint;
    select max(systolic), min(diastolic)
    into :max_syst, :min_diast
    from sashelp.heart;
quit;

/* Список через роздільник */
proc sql noprint;
    select distinct strip(trtmt) into :trt_list separated by ","
    from rdmcode;
quit;
/* &trt_list → "A,B,C" */

/* Масив макро-змінних */
proc sql noprint;
    select distinct xtrtmt into :trt1 -
    from rdmcode;
quit;
/* &trt1, &trt2, ... — кількість визначається автоматично */

/* Із count */
proc sql noprint;
    select count(distinct subjid), xtrtmt
    into :n1 - ,
         :trt1 -
    from rdmcode
    group by xtrtmt;
quit;
```

---

## Перетворити дату з датасету в читаємий рядок

```sas
/* Отримати числове значення дати */
proc sql noprint;
    select min(startdate), max(enddate) into :stdt, :endt
    from input_data;
quit;

/* Перетворити в рядок */
data _null_;
    call symput("stdt_str", strip(put(&stdt, date9.)));
    call symput("endt_str", strip(put(&endt, date9.)));
run;

%put Start: &stdt_str. End: &endt_str.;
```

---

## Видалити макро-змінну

```sas
%symdel myvar;
%symdel var1 var2 var3;
```
