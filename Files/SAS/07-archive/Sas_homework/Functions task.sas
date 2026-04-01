proc import 
  datafile="E:\1 semestr\Students\Stanislav Bezsmertnyi\SAS\Data\vdata.xlsx" 
  dbms=xlsx 
  out=work.vdata 
  replace;
run;

data vdata_1;
	set vdata;
	length age agem 8;
	agem = intck('MONTH', brthdtc, today());
	age = floor(agem / 12);
	/*sex=upcase(substr(sex, 1, 1));*/
	sex=compress(propcase(sex), , 'ku');

	if lowcase(vsorres) = "not done" then call missing(vsorresn);  
	else vsorresn = round(input(strip(vsorres), best.), .1);

	vsorresu2 = vsorresu; 

	if index(vstestcd, "WEIGHT") and index(vsorresu, "lb") then do;
		vsorresn = round(vsorresn * 0.45359237, .1);
		vsorresu2 = tranwrd(vsorresu, "lb", "kg");
	end;
	else if vstestcd = "TEMP" and vsorresu = "F" then do;
		vsorresn = round((vsorresn - 32) * 5/9, .1);
		vsorresu2 = upcase("c");
	end;
run;

proc sort data=vdata_1 out=vdata_2 nodupkey;
	by usubjid;
run;

data vdata_2;
	set vdata_2(keep=usubjid sex age);
	
	result = catx("\", usubjid, sex, age);	
run;
