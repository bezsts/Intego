# Спільні правила для створення ADAM

## Принципи

- Дотримуйтесь принципу гармонізації при копіюванні змінних SDTM: **«однакова назва, однаковий зміст, однакові значення»** (назва, мітка, формат і вміст мають залишатися незмінними).

- Дозволені винятки: довжину змінної можна скоротити до фактично необхідної; також є окремі винятки згідно з IG (наприклад, DS.DSDECOD).

- На одній стадії назви одних і тих самих зміних в різних датасетах повинні бути однакові

## Numeric variables

- Character variables whenever possible in preference
- Numeric variables when:
  - Statistical model requires a numeric variable
  - For sorting
- Append ‘N’ to a character variable *if* there is a one-to-one correspondence between character and numeric
  - SEX and SEXN
  - RACE and RACEN
  - AVISIT and AVISITN

## Naming new variables

Respect naming conventions for standards variables or use ADaM fragments when deriving new variables. If the variable is defined in IG do not change the attributes/name, otherwise, create new.

| Fragment | Meaning |
| :--- | :--- |
| CHG | Change |
| BL | Baseline |
| FU | Follow-up |
| OT | On treatment |
| RU | Run-in |
| SC | Screening |
| TA | Taper |
| TI | Titer |
| WA | Washout |

Format:
<span style="color: red;">User defined content fragment</span> + <span style="color: #3bb2d0;">Period (i.e., xx)</span> + <span style="color: #7a5ba3;">ADaM timing fragment</span> + <span style="color: #00b050;">Date/Time Suffix or Grouping Suffix</span>

Examples:
<span style="color: red;">SBP</span><span style="color: #3bb2d0;">01</span><span style="color: #7a5ba3;">BL</span>
<span style="color: red;">WEIGHT</span><span style="color: #7a5ba3;">SC</span>
<span style="color: red;">WT</span><span style="color: #3bb2d0;">01</span><span style="color: #7a5ba3;">SC</span>
<span style="color: #7a5ba3;">RU</span><span style="color: #00b050;">SDT</span>
<span style="color: red;">WA</span><span style="color: #3bb2d0;">01</span><span style="color: #00b050;">SDT</span>
<span style="color: red;">BMI</span><span style="color: #7a5ba3;">BL</span><span style="color: #00b050;">GR1</span>

*(ref. ADaM Ig 1.1 section 3.1.5 “Variable Naming Fragments”)*