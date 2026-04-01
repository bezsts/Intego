# Символьні функції

## Швидка довідка

| Функція | Що робить | Приклад |
|---------|-----------|---------|
| `strip(s)` | Видалити ведучі та кінцеві пробіли | `strip("  abc  ")` → `"abc"` |
| `compress(s, chars, flags)` | Видалити/залишити символи | `compress("A1B2", , "kd")` → `"12"` |
| `upcase(s)` | Верхній регістр | `upcase("abc")` → `"ABC"` |
| `lowcase(s)` | Нижній регістр | |
| `propcase(s)` | Заголовний регістр | `propcase("hello world")` → `"Hello World"` |
| `length(s)` | Довжина рядка | `length("abc")` → `3` |
| `substr(s, pos, len)` | Підрядок | `substr("ABC123", 4, 3)` → `"123"` |
| `index(s, sub)` | Позиція підрядка (0 = не знайдено) | `index("ABC", "B")` → `2` |
| `find(s, sub, flags, start)` | Пошук з параметрами | `find(s, "x=y", "i")` |
| `scan(s, n, delim)` | N-те слово | `scan("a b c", 2)` → `"b"` |
| `countw(s, delim)` | Кількість слів | `countw("a b c")` → `3` |
| `tranwrd(s, old, new)` | Замінити підрядок | `tranwrd(s, "Hello", "Hi")` |
| `compbl(s)` | Замінити кілька пробілів одним | |
| `cat(a,b,c)` | Конкатенація | |
| `cats(a,b,c)` | Конкатенація зі strip | |
| `catx(delim, a, b)` | Конкатенація з роздільником | `catx("-", "A", "B")` → `"A-B"` |
| `left(s)` / `right(s)` | Вирівнювання | |
| `anydigit(s)` | Позиція першої цифри | `anydigit("ABC1")` → `4` |

## Рецепти

### Очистити та стандартизувати текст
```sas
/* Видалити всі не-літерні символи, залишити тільки літери */
clean = compress(text, , "ka");

/* Видалити пробіли та цифри */
letters_only = compress(text, , "ka");

/* Залишити тільки цифри */
digits_only = compress(text, , "kd");
```

### Витягти частину рядка
```sas
/* Перші 10 символів дати з DTC */
date_only = substr(aestdtc, 1, 10);

/* Від позиції до кінця */
suffix = substr(visid, 4);   /* DAY14 → "14" */

/* Видалити "DAY" і отримати число */
visitnum = input(compress(visid, , "kd"), best.);   /* DAY14 → 14 */
```

### Замінити текст
```sas
/* Замінити одне слово */
testname = tranwrd(testname, "2ND", "SECOND");

/* Замінити кілька разів */
s = tranwrd(tranwrd(s, "old1", "new1"), "old2", "new2");
```

### Конкатенація
```sas
/* Простий */
usubjid = studyid || "-" || siteid || "-" || put(subjid, z6.);

/* Зі strip (рекомендовано) */
usubjid = catx("-", strip(studyid), strip(put(siteid, best.)), strip(put(subjid, z6.)));

/* Cat vs Cats */
cat(a, b)    /* "abc   " + "def   " → "abc   def   " */
cats(a, b)   /* → "abcdef" (strip обох) */
catx("-", a, b)  /* → "abc-def" */
```

### Пошук підрядка
```sas
/* Чи містить рядок "NON-"? */
if find(result, "NON-") = 0 then result = tranwrd(result, "NON", "NON-");

/* Пошук без урахування регістру */
pos = find(text, "target", "i");

/* Пошук без урахування регістру + trim пробілів */
pos = find(text, search_var, "ti");
```

### Сформувати часовий рядок
```sas
/* Додати час до дати */
vsdtc = catx("T", put(vsdate, is8601da.), strip(vstime));
/* → "2024-01-15T08:00" */
```
