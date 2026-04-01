# Глобальні та локальні макро-змінні

## Правила scope

| Де оголошена | Видима | Тип |
|---|---|---|
| В open code (`%let` поза макросом) | Скрізь | Глобальна |
| В макросі (звичайний `%let`) | Тільки всередині макросу | Локальна |
| В макросі + `%global` | Скрізь | Глобальна |
| В макросі + `%local` | Тільки всередині макросу | Явно локальна |

## Рецепти

### Локальна змінна (за замовчуванням)
```sas
%let b = DOG;    /* глобальна */

%macro animal;
    %let b = COW;    /* локальна — перекриває глобальну тільки всередині */
    %put Inside: &b.;    /* → COW */
%mend animal;

%animal;
%put Outside: &b.;    /* → DOG (глобальна не змінилась) */
```

### %GLOBAL — зробити змінну глобальною з макросу
```sas
%macro set_city;
    %global city;          /* оголосити як глобальну */
    %let city = Kyiv;
    %put Inside: &city.;
%mend set_city;

%set_city;
%put Outside: &city.;    /* → Kyiv (доступна після виклику) */
```

### %LOCAL — захистити глобальну від перезапису
```sas
%let name = global_value;

%macro safe_macro;
    %local name;           /* локальна копія — не зачіпає глобальну */
    %let name = local_value;
    %put Inside: &name.;   /* → local_value */
%mend safe_macro;

%safe_macro;
%put Outside: &name.;     /* → global_value (не змінилась) */
```

### CALL SYMPUT — завжди глобальна з DATA step
```sas
data _null_;
    set rawdata.demog(obs=1);
    call symput("first_subj", cats(subjid));
    /* Змінна first_subj стає глобальною */
run;

%put &first_subj.;    /* доступна після завершення DATA step */
```

## ⚠️ Типовий баг
```sas
%macro process(domain=);
    %let result = some_value;    /* локальна в process */
%mend;

%process(domain=AE);
%put &result.;    /* WARNING: Macro variable RESULT not found */

/* Виправлення */
%macro process(domain=);
    %global result;
    %let result = some_value;
%mend;
```
