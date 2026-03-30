# Findings

Спостереження, отримані із запланованих та незапланованих оцінок, тестів, опитувань та вимірювань.

## Спільні змінні

| Змінна | Опис | Додаткова інформація |
| --- | --- | --- |
| <span style="color: #c00000;">--TESTCD</span> | <span style="color: #c00000;">Коротка назва</span> | <span style="color: #c00000;">Макс. 8 символів.<br>Не повинен починатися з цифри</span> |
| <span style="color: #c00000;">--TEST</span> | <span style="color: #c00000;">Назва виміру, тесту або файндінга</span> | <span style="color: #c00000;">Макс. 40 символів</span> |
| --ORES | Оригінальний результат | |
| --STRESC | Стандартизований результат | Отримується з ORES |
| --STRESN | STRESC в числовому еквіваленті | |
| --BLFL | Флаг для позначення базового виміру, від якого буде проводитись подальші порівнювання | Це значення, яке відбулося найближче до прийому ліків (RFXSTDTC), але щоб воно відбулося **ДО** прийому ліків |

```sas
/* Example code for creating --BLFL */
  data vsblfl main_vs;
  set vs;

  if vsdtc <= rfxstdtc and not missing (vsdtc)
    and (not missing(vsorres) or not missing (vsstresn)) then output vsblfl;
  else output main_vs;
run;</code>

proc sort data vsblfl; by usubjid vstested vsdtc /*visitnum vstptnum*/; run;

data vsblfl1;
  set vsblfl;
  by usubjid vstested vsdtc /*visitnum vstptnum*/;

  if last.vstested then vsblfl "Y";
run;

data vs;
  set main_vs vsblfl1;
run;
```

**Baseline check**

* Дата дози і дата виміру повинні мати один формат
* Перевірити, що baseline запис не має NULL в —ORRES
* Перевірити, що немає дублікатів baseline запису per subject per test

> В рамках файндінгів немає змінної —STDTC, тому що вона показує початок якогось івенту, а вимірювання не має початку, воно просто є. Тому для файндінгів є —DTC змінна.
> —ENDTC рідко може бути, але тільки коли є інтервал вимірювання.

| Змінна | Опис | Додаткова інформація |
| --- | --- | --- |
| —ELTM | Запланований проміжок часу в стандартизованому вигляді. | За ISO стандартами |
| —TPTREF | До чого посилається таймпоінт | Наприклад, "FIRST DOSE" |
| —RFTDTC | Дата —TPTREF | |
| —DTC | Фактична дата виміру | |

> Часто буває, що у нас немає чітко запланованого таймпоінту, коли треба зробити вимірювання, тоді —TPT = "PRE-DOSE", a —ELTM = NULL

**Alternative Study Design**

| VSTPTNUM | VSTPT | VSELTM | VSTPTREF | VSRFTDTC | VSDTC |
|---|---|---|---|---|---|
| 1 | PRE-DOSE | | FIRST DOSE | 2006-08-01T08:00 | 2006-08-01T07:55 |

## VS

Зберігання вимірювань фізіологічних параметрів

<span style="color: #c00000;">One record per vital sign measurement per time point per visit per subject</span>

| Змінна | Опис | Додаткова інформація |
| --- | --- | --- |
| VSPOS | Позиція пацієнта, в якій було зроблемо вимірювання | Інформацію про це можна знайти в протоколі в розділі Vital Signs |
| VSSTAT | Чи відбулося вимірювання | Або NULL, або NOT DONE |
| VSREASND | Причина, чому не відбулося вимірювання | Тільки якщо VSSTAT = NOT DONE |
| VSLOC / VSLAT | Місце на тілі, де відбулося вимірювання | |
| VSTPT | Зазвичай, це точка в рамках візиту. | |

> Якщо пацієнт не зробив за візит жодного тесту, то є два варіанти як представити це в датасеті:
>
> * На кожний тест поставити VSSTAT = "NOT DONE"
> * Зробити один тест VSALL та на нього поставити VSSTAT = "NOT DONE". Це буде виглядати так:

| VSTESTCD | VSTEST | VSORRES | VSSTAT |
|---|---|---|---|
| VSALL | Vital Signs Data | | NOT DONE |

Можливі інструменти створення VS

```sas
/* OUTPUT */

libname raw " path to data ";

data vital;
  length vstest vstestcd vsorresu vsorre $200;
  set raw.vitals;

  vstest = "Temperature";
  vstestcd = "TEMP";
  if vstemp_u = 1 then vsorresu = "C";

  vsorres = strip(put(vstemp,best.));
  output;

  call missing(vstest,vstestcd,vsorresu,vsorres);

  vstest = "Respiratory Rate";
  vstestcd = "RESP";

  vsorres = strip(put(vsresp,best.));
  output;
run;
```

```sas
/* MACROS */

libname raw "/home/mykolakozak0/my_shared_file_links/glebvk";

%macro vs (vstest = , vstestcd = , vsorresu = , vsorres = );
  call missing(vstest,vstestcd,vsorresu,vsorres);

  vstest = "&vstest";
  vstestcd = "&vstestcd";
  /*if vstemp_u =1 then*/ vsorresu = "&vsorresu";

  vsorres = strip(put(&vsorres,best.));
  output;
%mend vs;

data vital;
  length vstest vstestcd vsorresu vsorres $200;
  set raw.vitals;

  %vs(vstest =Temperature, vstestcd = TEMP, vsorresu = C, vsorres =vstemp);
  %vs(vstest =%str(Respiratory Rate), vstestcd = RESP, vsorresu = , vsorres =vsresp);
run;


/* PROC TRANSPOSE */

libname raw "path to data";

proc sort data = raw.vitals out=vital; by subjid visid vshour vstime; run;

proc transpose data = vital out = vital_tr;
  by subjid visid vshour vstime;
  var vstemp vsresp vspulse vsbpsys vsbpdia;
run;
```

```sas
/* COMBINING UNIT AND RESULT */

data vital;
  length vstempc $200;
  set raw.vitals;

  if vstemp_u =1 then vsorresu = "C";
  vstempc = strip(put(vstemp,best.)) || "   UNIT!!! = "||strip(vsorresu);
run;

proc sort data =vital; by subjid visid vshour vstime;run;

proc transpose data = vital out = vital_tr;
  by subjid visid vshour vstime;
  var vstempc;
run;
```

## QS
Збір даних з questionnaires

<span style="color: #c00000;">One record per questionnaire question per time point per visit per per subject</span>

> Для **QSTEST** допускаються значення до 200 символів.

> В **QSCAT** записується назва словника, тому ця змінна Req

| Змінна | Опис | Додаткова інформація |
| --- | --- | --- |
| QSEVAL | Той, хто заповнював questionnaire | |
| QSEVLINT | Якщо в питанні є інтервал часу, то в цю змінну записується інтервал | "Чи ви робили щось протягом останніх 2 років?"<br>"-P2Y" |

На кожен стандартизований questionnaire є окремий Implementation guide.
[https://www.cdisc.org/standards/foundational/qrs](https://www.cdisc.org/standards/foundational/qrs)

## LB

Збір результатів аналізів біологічних матеріалів (кров, сеча, інші рідини/тканини)

<span style="color: #c00000;">One record per lab test per time point per visit per subject</span>

> В **LBREFID** кладуть Specimen ID, що є номером аналізу.

> В **LBCAT** записується тип аналізу, тому ця змінна EXP

| Змінна | Опис | Додаткова інформація |
| --- | --- | --- |
| LBORNRLO | Нижня межа нормального значення в оригінальних юнітах | Приходить з rawdata |
| LBORNRHI | Верхня межа нормального значення в оригінальних юнітах | Приходить з rawdata |
| LBSTNRLO | Нижня межа нормального значення в стандартних юнітах | |
| LBSTNRHI | Верхня межа нормального значення в стандартних юнітах | |
| LBSTNRC | Інтервал нормального значення, якщо ми не можемо його представити в Num | |
| LBNRIND | Індикатор, який показує чи результат аналізу в межах нормального значення чи ні | Можуть зустрічатися значення "HIGH/LOW PANIC", хоча їх немає в control terminology |
| LBNAM | Назва лабораторії, де робився аналіз | |
| LBSPEC | Що саме здає суб'єкт | |
| LBSPCCND | Умови зразка | Наприклад, заморожений |
| LBMETHOD | Яким методом був зібраний зразок | |
| LBTOX | Повний опис LBTOXGR | |
| LBTOXGR | Якщо результат аналіз поза межами нормального значення, то в цій змінній записується наскільки він поза межами | Використовується той самий словник, що і в AE |
| LBLOINC | Код, в якому зашифрована інформація | Повна інфа про LOINC: [https://www.cdisc.org/kb/articles/loinc-and-sdtm](https://www.cdisc.org/kb/articles/loinc-and-sdtm) |

> Для конвертації юнітів з оригінальних в стандартні нормально використовувати гугл, але треба задавати з назвою тесту, бо для кожного тесту може бути різний коефіцієнт, навіть з однаковими юнітами.

> При конвертації треба звертати увагу на %. Наприклад, якщо в теста є декілька оригінальних юнітів, і один з них %, то можливо його треба винести в окремий тест.

### <span style="color: #c00000;">Special Issue: Non-Convertible Units (example):</span>

* **Incorrect dataset**

| LBTESTCD | LBTEST | LBORRES | LBORRESU | LBSTRESC | LBSTRESN | LBSTRESU |
|---|---|---|---|---|---|---|
| BASO | Basophils | 0 | % | 0 | 0 | X 10*9/L |
| BASO | Basophils | 0 | % | 0 | 0 | X 10*9/L |
| BASO | Basophils | 1 | PER 100 BLOOD CELLS | 1 | 1 | X 10*9/L |
| BASO | Basophils | 1 | PER 100 BLOOD CELLS | 1 | 1 | X 10*9/L |
| BASO | Basophils | 2 | PER 100 BLOOD CELLS | 2 | 2 | X 10*9/L |
| BASO | Basophils | 0.028 | X 10*9/L | 0.028 | 0.028 | X 10*9/L |
| BASO | Basophils | 0.041 | X 10*9/L | 0.041 | 0.041 | X 10*9/L |
| BASO | Basophils | 0.056 | X 10*9/L | 0.056 | 0.056 | X 10*9/L |

* **Correct dataset**

| LBTESTCD | LBTEST | LBORRES | LBORRESU | LBSTRESC | LBSTRESN | LBSTRESU |
|---|---|---|---|---|---|---|
| BASOLE | Basophils/Leukocytes | 0 | % | 0 | 0 | % |
| BASOLE | Basophils/Leukocytes | 0 | % | 0 | 0 | % |
| BASOLE | Basophils/Leukocytes | 1 | PER 100 BLOOD CELLS | 1 | 1 | % |
| BASOLE | Basophils/Leukocytes | 1 | PER 100 BLOOD CELLS | 1 | 1 | % |
| BASOLE | Basophils/Leukocytes | 2 | PER 100 BLOOD CELLS | 2 | 2 | % |
| BASO | Basophils | 0.028 | X 10*9/L | 0.028 | 0.028 | X 10*9/L |
| BASO | Basophils | 0.041 | X 10*9/L | 0.041 | 0.041 | X 10*9/L |
| BASO | Basophils | 0.056 | X 10*9/L | 0.056 | 0.056 | X 10*9/L |

> Також треба пам'ятати, що стандартний юніт повинен бути один per test per category per specimen. Тобто у одного тесту може бути декілька стандартних юнітів, якщо в ньому є різні категорії та типи specimen (зразку).

> Корисне посилання для мапінгу юнітів: [https://ncim.nci.nih.gov/ncimbrowser/](https://ncim.nci.nih.gov/ncimbrowser/). Треба обрати словник NCI Thesaurus
