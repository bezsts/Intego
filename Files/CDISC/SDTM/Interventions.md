# Interventions

Досліджувані, терапевтичні або інші види лікування, що надаються суб'єкту або приймаються ним. Зазвичай викликають фізіологічні зміни.

## Спільні змінні

| Змінна | Опис | Додаткова інформація |
| --- | --- | --- |
| --TRT | Назва ліків | |

## CM

Збирає інформацію про всі ліки, які приймає суб'єкт, **окрім** досліджуваного препарату.

**<font color = "red">One record per recorded intervention occurrence or constant-dosing interval per subject</font>**

| Змінна | Опис | Додаткова інформація |
| --- | --- | --- |
| CMMODIFY | Модифікована назва ліків, якщо складно зрозуміти CMTRT | |
| CMOCCUR | Чи приймав пацієнт ліки | Прапорець Y/N. Зберігаємо інформація, навіть якщо відповідь - N. Те ж саме і з CMPRESP. |
| CMSTAT | Чи була відповідь на питання для CMPRESP | Або NULL, або NOT DONE |
| CMREASND | Причина, чому не було відповіді на CMPRESP | Заповнюємо, якщо CMSTAT = NOT DONE |
| CMINDC | Для чого або від чого приймаються ліки | |
| CMDECODE | Закодована назва ліків | |
| CMCLAS / CMCLASCD | Використовується для класифікації ліків | Для класифікації ліків використовується словник WHODrug. Використовується Anatomical Therapeutic Chemical (ATC) класифікація. |

* ATC contains 5 level:
  * First level indicates the anatomical main group (there are 14 groups) 
  * Second level of the code indicates the therapeutic main group
  * Third level indicates the therapeutic/pharmacological subgroup
  * Fourth level indicates the chemical/therapeutic/pharmacological subgroup
  * Fifth level of the code indicates the chemical substance

> Але в самому датасеті у нас всього дві змінні для класифікації (CMDECOD і CMCLAS), тому ми зберігаємо тільки класифікацію по другому рівню.

| Змінна | Опис | Додаткова інформація |
| --- | --- | --- |
| CMDOSE / CMDOSTXT | Скільки ліків було прийнято | Треба щоб була заповнена тільки одна з цих змінних |
| CMDOSU / CMDOSFRM / CMDOSFRQ | Юніт дози / Форма дози / Частота дози | |
| CMDOSTOT | Денна доза | НЕ ВИРАХОВУЄТЬСЯ. Записуємо інформацію, тільки якщо вона збирається на CRF |

Далі ідуть змінні, про які вже є інформація / або вона не потрібна.
Інформація про **STRF, ENRF, STRTPT, STTPT, ENRTPT, ENTPT**:

## EX

Фіксація прийому **досліджуваного препарату**.

**<font color = "red">One record per study treatment, constant dosing interval per subject</font>**

| Змінна | Опис | Додаткова інформація |
| --- | --- | --- |
| EXLNKID / EXLNKGRP | Використовуються для зв'язування записів між доменами | Часто використовуються для фармокінетики |

> Дуже часто інформація про дози exposure не збирається на CRF. Треба дивитися інформацією про це в протоколі.

| Змінна | Опис | Додаткова інформація |
| --- | --- | --- |
| EXLOT | Номер коробки ліків | Це потрібно для проведення blind досліджень |
| EXLOC / EXLAT / EXDIR | Змінні для відображення інформації про місце, куди була внесена доза | |
| EXADJ | Причина, чому змінилась доза суб'єкта | |
| EXTPT / EXTPTNUM | Таймпойнт | Визначається дизайном дослідження. Наприклад, "PM" та "AM". |

> Якщо EXTPT = Placebo, то EXDOSE повинна = 0, тому що в ній немає активної речовини.

## EC

Фіксація **обліку** досліджуваного препарату. Зберігаємо дані про досліджувані ліки, як вони збиралися.

**<font color = "red">One record per study treatment, constant dosing interval, per mood per subject</font>**

> EC майже не відрізняється структурно від EX. Відрізняється логікою: EX показує дані по протоколу, то EC показує так як вони були зібрані.

| Змінна | Опис | Додаткова інформація |
| --- | --- | --- |
| ECPSTRG | Концентрація діючої речовини в розчині | |

## Порівняння EX та EC

Бачимо, що відрізняється TRT. Також в EX ми збираємо дози, які були прийняті, а в EC можемо записувати ті які не були прийняті.

### Приклад 1 (EC vs EX)

EC (Облік ліків з флаконів - BOTTLE)

| Row | STUDYID | DOMAIN | USUBJID | ECSEQ | ECLNKID | ECTRT | ECPRESP | ECOCCUR | ECDOSE | ECDOSU | ECDOSFRQ | EPOCH | ECSTDTC | ECENDTC | ECSTDY | ECENDY |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | ABC | EC | ABC1001 | 1 | A2-20110114 | BOTTLE A | Y | Y | 2 | TABLET | QD | TREATMENT | 2011-01-14 | 2011-01-28 | 1 | 15 |
| 2 | ABC | EC | ABC2001 | 1 | A2-20110114 | BOTTLE A | Y | Y | 2 | TABLET | QD | TREATMENT | 2011-01-14 | 2011-01-23 | 1 | 10 |
| 3 | ABC | EC | ABC2001 | 2 | A0-20110124 | BOTTLE A | Y | **N** | | TABLET | QD | TREATMENT | 2011-01-24 | 2011-01-24 | 11 | 11 |
| 4 | ABC | EC | ABC2001 | 3 | A2-20110125 | BOTTLE A | Y | Y | 2 | TABLET | QD | TREATMENT | 2011-01-25 | 2011-01-28 | 12 | 15 |

EX (Фактично прийнятий препарат - DRUG)

| Row | STUDYID | DOMAIN | USUBJID | EXSEQ | EXLNKID | EXTRT | EXDOSE | EXDOSU | EXDOSFRM | EXDOSFRQ | EXROUTE | EPOCH | EXSTDTC | EXENDTC | EXSTDY | EXENDY |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | ABC | EX | ABC1001 | 1 | A2-20110114 | DRUG X | 1000 | mg | TABLET, EXTENDED RELEASE | QD | ORAL | TREATMENT | 2011-01-14 | 2011-01-28 | 1 | 15 |
| 2 | ABC | EX | ABC2001 | 1 | A2-20110114 | DRUG Z | 500 | mg | TABLET | QD | ORAL | TREATMENT | 2011-01-14 | 2011-01-23 | 1 | 10 |
| 3 | ABC | EX | ABC2001 | 2 | A2-20110125 | DRUG Z | 500 | mg | TABLET | QD | ORAL | TREATMENT | 2011-01-25 | 2011-01-28 | 12 | 15 |

*(У прикладі видно, що в EC записується пропуск прийому ліків (Row 3, ECOCCUR=N), тоді як в EX фіксуються лише фактичні прийоми, розділені цим пропуском).*

### Приклад 2 (Зміна дози)

EC (Облік ліків з флаконів)

| Row | STUDYID | DOMAIN | USUBJID | ECSEQ | ECTRT | ECPRESP | ECOCCUR | ECDOSE | ECDOSU | ECDOSFRQ | EPOCH | ECSTDTC | ECENDTC | ECSTDY | ECENDY |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | ABC | EC | ABC4001 | 1 | BOTTLE A | Y | Y | 1 | TABLET | QD | TREATMENT | 2011-01-14 | 2011-01-28 | 1 | 15 |
| 2 | ABC | EC | ABC4001 | 2 | BOTTLE C | Y | Y | 1 | TABLET | QD | TREATMENT | 2011-01-14 | 2011-01-28 | 1 | 15 |
| 3 | ABC | EC | ABC4001 | 3 | BOTTLE B | Y | Y | 1 | TABLET | QD | TREATMENT | 2011-01-14 | 2011-01-20 | 1 | 7 |
| 4 | ABC | EC | ABC4001 | 4 | BOTTLE B | Y | N | | TABLET | QD | TREATMENT | 2011-01-21 | 2011-01-21 | 8 | 8 |
| 5 | ABC | EC | ABC4001 | 5 | BOTTLE B | Y | Y | 2 | TABLET | QD | TREATMENT | 2011-01-22 | 2011-01-22 | 9 | 9 |
| 6 | ABC | EC | ABC4001 | 6 | BOTTLE B | Y | Y | 1 | TABLET | QD | TREATMENT | 2011-01-23 | 2011-01-28 | 10 | 15 |

EX (Фактично прийнятий препарат)

| Row | STUDYID | DOMAIN | USUBJID | EXSEQ | EXTRT | EXDOSE | EXDOSU | EXDOSFRM | EXDOSFRQ | EXROUTE | EPOCH | EXSTDTC | EXENDTC | EXSTDY | EXENDY |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | ABC | EX | ABC4001 | 1 | DRUG X | 20 | mg | TABLET | QD | ORAL | TREATMENT | 2011-01-14 | 2011-01-20 | 1 | 7 |
| 2 | ABC | EX | ABC4001 | 2 | DRUG X | 10 | mg | TABLET | QD | ORAL | TREATMENT | 2011-01-21 | 2011-01-21 | 8 | 8 |
| 3 | ABC | EX | ABC4001 | 3 | DRUG X | 30 | mg | TABLET | QD | ORAL | TREATMENT | 2011-01-22 | 2011-01-22 | 9 | 9 |
| 4 | ABC | EX | ABC4001 | 4 | DRUG X | 20 | mg | TABLET | QD | ORAL | TREATMENT | 2011-01-23 | 2011-01-28 | 10 | 15 |

> Тут бачимо різницю в тому, як ми представляємо дози в датасетах. В EX важлива просто кількість, а в EC ми можемо записувати інтервал тільки, якщо була однакова доза. Якщо доза змінюється, то це вже інший інтервал
