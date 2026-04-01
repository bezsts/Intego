libname data "E:\1 semestr\Students\Stanislav Bezsmertnyi\SAS\Data";

/* 1 Method */
proc transpose data = data.tr_task
			   out = orres(drop = _NAME_)
			   suffix = _ORRES;
	by usubjid;
	var vsorres;
	id vstestcd;
run;

proc transpose data = data.tr_task
			   out = stresc(drop = _NAME_)
			   suffix = _STRESC;
	by usubjid;
	var vsstresc;
	id vstestcd;
run;

data result1;
	merge orres stresc;
	by usubjid;
run;

title "Method 1";

proc print data = result1;
run;

/* 2 Method */
proc transpose data = data.tr_task(rename=(vsorres=ORRES vsstresc=STRESC))
			   out  = tr1
			   name = units
			   prefix = value;
	by usubjid vstestcd;
	var orres stresc;
run;

proc sort data = tr1;
	by usubjid units;
run;

proc transpose data = tr1
			   out = result2(drop = _NAME_)
			   delimiter = _;
	by usubjid;
	id vstestcd units;
	var value1;
run;

title "Method 2";

proc print data=result2;
run;
