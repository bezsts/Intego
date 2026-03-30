# Subject-Level Analysis Dataset (ADSL)

**<span style="color: red">One record per subject, regardless of study design</span>**

**ADSL expected contents**:

- Demographics 
- Arm/Treatment Variables
- Periods
- Key baseline characteristics
- Study Population Indicators

## Population

**Population** - це вибірка суб'єктів за певними критеріями.

| Variable Name | Variable Label | Type | Codelist/Controlled Terms | Core | Пояснення популяції (українською) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| FASFL | Full Analysis Set Population Flag | Char | Y, N | Cond | **Повний набір для аналізу:** Зазвичай включає всіх рандомізованих пацієнтів, які отримали хоча б одну дозу препарату та мають хоча б одну оцінку показників після початку лікування. |
| SAFFL | Safety Population Flag | Char | Y, N | Cond | **Популяція для оцінки безпеки:** Включає всіх пацієнтів, які отримали хоча б одну дозу досліджуваного препарату. Використовується для аналізу побічних явищ. |
| ITTFL | Intent-To-Treat Population Flag | Char | Y, N | Cond | **ITT-популяція (намір лікувати):** Включає всіх рандомізованих пацієнтів, незалежно від того, чи почали вони лікування. Аналіз базується виключно на групі, в яку їх було рандомізовано. |
| PPROTFL | Per-Protocol Population Flag | Char | Y, N | Cond | **Популяція "за протоколом":** Може бути будь-яка умова. |
| COMPLFL | Completers Population Flag | Char | Y, N | Cond | **Популяція тих, хто завершив:** Пацієнти, які повністю пройшли всі етапи та візити, передбачені планом дослідження. |
| RANDFL | Randomized Population Flag | Char | Y, N | Cond | **Рандомізована популяція:** Всі пацієнти, які успішно пройшли етап скринінгу та були рандомізовані. |
| ENRLFL | Enrolled Population Flag | Char | Y, N | Cond | **Залучена популяція:** Всі пацієнти, які підписали informed consent. |