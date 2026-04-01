dm 'log; clear';

options missing = "";

proc datasets lib=work kill noprint;
run;

/*========*/
/* Task 1 */
/*========*/

proc sort data=rawdata.csfqfeml out=csfqfeml;
	by subjid;
run;

data task1;
	set csfqfeml;

	length SUM MEAN MEDIAN STD 8 RESULT $50;

	SUM = SUM(of CSFQ:);
	MEAN = MEAN(of CSFQ:);
	MEDIAN = MEDIAN(of CSFQ:);
	STD = STD(of CSFQ:);

	RESULT = IFC(SUM eq TOTALSCR, "Score is OK", "Calculated score does not match TOTAL SCORE");
run;

/*========*/
/* Task 2 */
/*========*/

proc sort data=rawdata.demog out=demog nodupkey;
	by subjid;
run;

data task2;
	set demog(keep = SUBJID BIRTHDT GENDER);

	length AGE 8;

	label AGE = "Age";

	AGE = INT(YRDIF(BIRTHDT, "13DEC2025"d, "ACTUAL"));
run;

proc sort data=task2;
	by AGE;
run;

data task2;
	set task2 end=eof;

	length AGEFL $1;
	
	if _N_ eq 1 then AGEFL = "Y";
	else if eof then AGEFL = "O";
	else call missing(AGEFL);
run;

proc sort data=task2;
	by GENDER AGE;
run;

data task2;
	set task2;
	by GENDER;

	length AGESEXFL $2 SEXC $1;

	if first.GENDER then do;
		if GENDER eq 1 then AGESEXFL = "YM";
		else AGESEXFL = "YF";
	end;
	else if last.GENDER then do;
		if GENDER eq 1 then AGESEXFL = "OM";
		else AGESEXFL = "OF";
	end;
	else call missing(AGESEXFL);

	SEXC = IFC(GENDER eq 1, "M", "F");
run;

proc sort data=task2;
	by SUBJID;
run;

/*========*/
/* Task 3 */
/*========*/

proc sort data=rawdata.EXTLABS out=extlabs;
	by SUBJID;
run;

data task3;
	set extlabs;

	TESTNAME = tranwrd(TESTNAME, "2ND", "SECOND");
	TESTNAME = tranwrd(TESTNAME, "3RD", "THIRD");

	if ANYDIGIT(TESTNAME) > 0 or index(TESTNAME, "SECOND") > 0 or index(TESTNAME, "THIRD") > 0 then output;
run;

data task3;
	set task3;

	length TESTNAMEN 8;

	if scan(TESTNAME, 1, " ") eq "CTDP" then TESTNAMEN = input(compress(TESTNAME, , 'kd'), best.);
	else call missing(TESTNAMEN);

	TESTNAME = upcase(TESTNAME);
	UNITS = upcase(UNITS);

	if find(RESULT, "NON-") eq 0 then RESULT = tranwrd(RESULT, "NON", "NON-");

	if not missing(TIMETEXT) then do;
		TIMETEXT = IFC(length(TIMETEXT) eq 4, catx(":", substr(TIMETEXT, 1, 2), substr(TIMETEXT, 3, 4)),
											cat("0", substr(TIMETEXT, 1, 1), ":", substr(TIMETEXT, 2, 3)));
	end;

run;

/*========*/
/* Task 4 */
/*========*/

proc sort data=rawdata.invagt out=invagt;
	by SUBJID DAYDATE TIMEADM;
run;

data task4(drop = prev_date prev_time);
	set invagt(where = (NUMTAB ne 0));
	by SUBJID;

	length ADUR ADUR1 8 GTDAYFL $1;
	
	prev_date = LAG(DAYDATE);
	prev_time = LAG(TIMEADM);

	if not first.subjid then do;
		ADUR1 = (dhms(DAYDATE, 0, 0, input(TIMEADM, time5.)) - dhms(prev_date, 0, 0, input(prev_time, time5.))) / 3600;
		ADUR = round(ADUR1, 0.01);
		ADUR1 = floor(ADUR1);

		GTDAYFL = IFC(ADUR > 24, "Y", "N");
	end;
run;

/*========*/
/* Task 5 */
/*========*/

proc sort data=rawdata.__AE out=__AE;
	by SUBJID;
run;

data task5;
	set __AE;

	length AESTART_IMP AESTOP_IMP $10;

	length STR_YEAR STR_MONTH STR_DAY 8;
	length STP_YEAR STP_MONTH STP_DAY 8;

	/* Dividing AESTART_C into YEAR MONTH DAY*/

	STR_YEAR = input(scan(AESTART_C, 1, "-"), best.);

	if substr(AESTART_C, 6, 2) eq "--" then do;
		call missing(STR_MONTH);

		STR_DAY = input(scan(AESTART_C, 2, "-"), best.);
	end;
	else STR_MONTH = input(scan(AESTART_C, 2, "-"), best.);

	if missing(STR_DAY) then STR_DAY = input(scan(AESTART_C, 3, "-"), best.);

	if missing(STR_DAY) then STR_DAY = 1;
	if missing(STR_MONTH) then STR_MONTH = 1;

	/* Dividing AESTOP_C into YEAR MONTH DAY*/

	STP_YEAR = input(scan(AESTOP_C, 1, "-"), best.);

	if substr(AESTOP_C, 6, 2) eq "--" then do;
		call missing(STP_MONTH);

		STP_DAY = input(scan(AESTOP_C, 2, "-"), best.);
	end;
	else STP_MONTH = input(scan(AESTOP_C, 2, "-"), best.);

	if missing(STP_DAY) then STP_DAY = input(scan(AESTOP_C, 3, "-"), best.);

	if missing(STP_MONTH) then STP_MONTH = 12;

	/* Filling missing date parts*/
	
	AESTART_IMP = put(MDY(STR_MONTH, STR_DAY, STR_YEAR), is8601da.);

	if not missing(STP_YEAR) then do;
		if missing(STP_DAY) then do;
			AESTOP_IMP = put(INTNX('month', MDY(STP_MONTH, 01, STP_YEAR), 0, 'end'), is8601da.);
		end;
		else AESTOP_IMP = put(MDY(STP_MONTH, STP_DAY, STP_YEAR), is8601da.);
	end;

	/*Checking if AESTOP_IMP is bigger than AESTART_IMP*/

	if AESTART_IMP > AESTOP_IMP and not missing(AESTOP_IMP) then do;
		AESTART_IMP = AESTOP_IMP;
	end;

	drop STR_YEAR STR_MONTH STR_DAY STP_YEAR STP_MONTH STP_DAY; 
run;

/*================*/
/* Output datasets*/
/*================*/

libname out "E:\1 semestr\Clinical_Trials_Programming\Home Task 4\Team I\FL";

data out.hw4_1_fl;
	set task1;
run;

data out.hw4_2_fl;
	set task2;
run;

data out.hw4_3_fl;
	set task3;
run;

data out.hw4_4_fl;
	set task4;
run;

data out.hw4_5_fl;
	set task5;
run;
