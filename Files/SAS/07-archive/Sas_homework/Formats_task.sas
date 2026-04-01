proc import
	datafile = "E:\1 semestr\Students\Stanislav Bezsmertnyi\SAS\Data\lastadt.xlsx"
	dbms = xlsx
	out = work.lastadt
	replace;
run;

proc format;
	value agegr		1 = "Subject is 22 or older"
					2 = "Subject is younger than 22";
run;

data final(keep = subjid BRTHDTC AGE AGEGR1);
	set lastadt;

	array date {*} $ date1-date12;
	array _date {*} _date1-_date12;

	do i=1 to dim(_date);
		_date[i] = input(date[i], date9.);
	end;
	
	/*_date1 = input(date1, date9.);
	_date2 = input(date2, date9.);
	_date3 = input(date3, date9.);
	_date4 = input(date4, date9.);
	_date5 = input(date5, date9.);
	_date6 = input(date6, date9.);
	_date7 = input(date7, date9.);
	_date8 = input(date8, date9.);
	_date9 = input(date9, date9.);
	_date10 = input(date10, date9.);
	_date11 = input(date11, date9.);
	_date12 = input(date12, date9.);*/

	brthdn = min(of _date1 - _date12);
	BRTHDTC = put(brthdn, is8601da.);

	age_date = '27MAR2020'D;
	agem = intck('MONTH', brthdn, age_date);
	AGE= floor(agem / 12);
	
	if AGE>=22 then AGEN = 1;
	else if .<AGE<22 then AGEN = 2;

	AGEGR1 = put(AGEN, agegr.); 
run;
