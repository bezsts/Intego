# Do Loops — цикли

## Що роблять
Повторюють виконання блоку коду задану кількість разів або до виконання умови.

## Синтаксис
```sas
/* Лічильний цикл */
do i = 1 to N <by increment>;
    ...
end;

/* DO WHILE — перевірка ДО */
do while (умова);
    ...
end;

/* DO UNTIL — перевірка ПІСЛЯ */
do until (умова);
    ...
end;
```

## Рецепти

### Генерувати записи в циклі (output всередині)
```sas
data schedule;
    set invagt_start;   /* перші дози суб'єктів */
    by subjid;

    do day = 1 to 15;
        visitnum = day;
        visit    = cat("Day ", day);
        exdtc    = put(start_dt + day - 1, is8601da.);
        output;
    end;
run;
```

### Вкладені цикли: суб'єкт × візит × тест
```sas
data task;
    set invagt;

    array testcds [3] $ ("PULSE", "SYSBP", "DIABP");
    array times   [8] $ ("08:00","09:00","10:00","11:00",
                         "12:00","14:00","16:00","20:00");

    do i = 1 to 15;
        do j = 1 to dim(times);
            do k = 1 to dim(testcds);
                vstestcd = testcds[k];
                vsdtc    = catx("T", put(daydate + i - 1, is8601da.), times[j]);
                visitnum = i;
                output;
            end;
        end;
    end;
run;
```

### DO UNTIL з LEAVE / CONTINUE
```sas
data loops;
    i = 0;
    do until (testvar = "TEST10");
        i + 1;

        if i = 3 then do;
            output;
            continue;    /* перейти до наступної ітерації */
        end;

        testvar = cats("TEST", i);
        output;

        if i = 10 then leave;    /* вийти з циклу */
    end;
run;
```

### Цикл по конкретних значеннях
```sas
data specific;
    do visitnum = 1, 2, 4, 8, 16;
        visit = cat("Day ", visitnum);
        output;
    end;
run;
```

## DO OVER (для масивів)
```sas
array vs_vars vstemp vsresp vspulse;

do over vs_vars;
    if not missing(vs_vars) then vs_vars = vs_vars * (-1);
    else vs_vars = 0;
end;
```
