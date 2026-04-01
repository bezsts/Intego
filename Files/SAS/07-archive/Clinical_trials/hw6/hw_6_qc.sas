dm 'log; clear';

proc datasets lib=work kill noprint;
run;

options missing='';

/*========*/
/* Task 1 */
/*========*/

data invagt(where = (VISID = "DAY1"));
	set rawdata.invagt(rename = (SUBJID = _SUBJID));
run;

data task1(keep = SUBJID VSTESTCD VSDTC VISIT VISITNUM);
	attrib 	SUBJID		length = 8		label = "Subject Identifier" format = z6.
			VSTESTCD 	length = $8 	label = "Vital Signs Test Short Name"
			VSDTC		length = $19	label = "Date/Time of Measurements"
			VISIT		length = $200	label = "Visit Name"
			VISITNUM	length = 8		label = "Visit Number"
			;
	
	set invagt;
	
	array vstestcd_arr [3] $ ("PULSE", "SYSBP", "DIABP");
	array times_arr [8] $ ("08:00", "09:00", "10:00", "11:00", "12:00", "14:00", "16:00", "20:00");
	
	do i = 1 to 15;
		do j = 1 to dim(times_arr);
			do k = 1 to dim(vstestcd_arr);
				SUBJID = _SUBJID;
				VSTESTCD = vstestcd_arr[k];
				VSDTC = catx("T", put(DAYDATE + i - 1, is8601da.), times_arr[j]);
				VISIT = catx(" ", "Day", i);
				VISITNUM = i;
				output;
			end;
		end;
	end;
run;

/*========*/
/* Task 2 */
/*========*/

proc format;
	value $ param	"VSTEMP_C" = "TEMP"
					"VSRESP" = "RESP"
					"VSPULSE" = "PULSE"
					"VSBPSYS" = "SYSBP"
					"VSBPDIA" = "DIABP"
					;
run;

data vitals;
	set rawdata.vitals
		rawdata.vitals2
		;
		
	length VSTEMP_C 8;
	
	if VSTEMP_U = 1 then
		VSTEMP_C = round((VSTEMP - 32) / 1.8, 0.1);
	else
		VSTEMP_C = VSTEMP;
run;

proc sort data = vitals;
	by SUBJID VSDATE VSTIME;
run;

proc transpose data = vitals out = vitals_transposed(rename=(SUBJID = _SUBJID)) prefix = VAL;
	by SUBJID VSDATE VSTIME VISID;
	var VSTEMP_C VSRESP VSPULSE VSBPSYS VSBPDIA;
run;

data task2(keep = SUBJID PARAMCD AVAL VISIT VISITNUM VSDTC);
	set vitals_transposed;
	
	attrib 	SUBJID		length = 8		label = "Subject Identifier" format = z6.
			PARAMCD 	length = $8 	label = "Parameter Code"
			AVAL		length = 8		label = "Analysis Value"
			VISIT		length = $200	label = "Visit Name"
			VISITNUM	length = 8		label = "Visit Number"
			VSDTC		length = $19	label = "Date/Time of Measurements"
			;
			
	SUBJID = _SUBJID;
	PARAMCD = put(_NAME_, $param.);
	AVAL = VAL1; 
	VISIT = VISID;

	if VISIT eq "SCRNBASE" then 
		VISITNUM = 0;
	else 
		VISITNUM = input(compress(VISIT, , 'kd'), best.);

	VSDTC = cat(put(VSDATE, is8601da.), "T", VSTIME, ":00"); 	
run;

proc sort data = task2;
	by SUBJID PARAMCD VSDTC;
run;

/*========*/
/* Task 3 */
/*========*/

proc format;
	value pchgcat 
		low -< -3 	= "Less than -3 PCT Change"
		-3 -< 0 	= "-3 to 3 PCT Change"
		0			= "No change"
		0 <- 3 		= "-3 to 3 PCT Change"
		3 <- high 	= "More than 3 PCT Change";
run;

proc sort data = task2 out = task2_param_sorted;
	by SUBJID PARAMCD;
run;

data task3(drop = aval_prev);
	set task2_param_sorted;
	by SUBJID PARAMCD;
	
	length CHG PCHG 8 PCHGCAT $100;
	
	aval_prev = LAG(AVAL);
	CHG = DIF(AVAL);
	
	/*
	if not first.PARAMCD then do;
		if not missing(aval_prev) then do;
			*CHG = AVAL - aval_prev;
			CHG = DIF(aval_prev);
			PCHG = CHG * 100 / aval_prev;
		end;
	end;
	*/

	if first.PARAMCD then do;
		call missing(CHG);
		call missing(PCHG);
	end;
	else do;
		PCHG = CHG / aval_prev * 100;
		PCHGCAT = put(PCHG, pchgcat.);
	end;
run;

proc sort data = task3;
	by SUBJID PARAMCD VSDTC;
run;

/*========*/
/* Task 4 */
/*========*/

proc format;
	value csfq_c
		1 = "Bad"
		2 = "Poor"
		3 = "Satisfactory"
		4 = "Good"
		5 = "Excellent";
run;

data task4(keep = SUBJID VISID CSFQ1-CSFQ14 CSFQ_C1-CSFQ_C14 NUM_BAD);
	attrib  SUBJID	length = 8		label = "Subject Identifier"	format = z6.;

	set rawdata.CSFQMALE(rename=(SUBJID = _SUBJID));
	
	array csfq_raw CSFQ1-CSFQ14;
	array csfq_c $20 CSFQ_C1-CSFQ_C14;
	
	NUM_BAD = 0;
	
	SUBJID = _SUBJID;
	
	do i = 1 to dim(csfq_raw);
		csfq_c[i] = put(csfq_raw[i], csfq_c.);
		
		if csfq_raw[i] eq 1 then NUM_BAD = NUM_BAD + 1;
	end;	
run;

/*========*/
/* Task 5 */
/*========*/

proc sort data = rawdata.CSFQMALE out = CSFQMALE_sorted;
	by SUBJID VISITDT;
run;

proc transpose data = CSFQMALE_sorted out = CSFQMALE_transposed(rename=(SUBJID = _SUBJID)) prefix = VAL;
	by SUBJID VISITDT VISID;
	var CSFQ1-CSFQ14;
run;

data task5(keep = SUBJID VISID PARAMCD PARAM AVAL AVALC);
	attrib  SUBJID	length = 8		label = "Subject Identifier"	format = z6.;

	set CSFQMALE_transposed;
	
	attrib  PARAMCD length = $8 	label = "Parameter Code"
    		PARAM 	length = $40 	label = "Parameter"
    		AVAL 	length = 8 		label = "Analysis Value" 
    		AVALC 	length = $200 	label = "Analysis Value (C)"
			;
	
	SUBJID = _SUBJID;	
	PARAMCD = _NAME_;
	PARAM = _LABEL_;
	AVAL = VAL1;
	AVALC = put(AVAL, csfq_c.);
run;

proc sort data = task5;
	by SUBJID VISID PARAMCD;
run;

/*========*/
/* OUTPUT */
/*========*/

libname out "E:\1 semestr\Clinical_Trials_Programming\Home Task 6\Team F\QC";

data out.hw6_1_qc;
	set task1;
run;

data out.hw6_2_qc;
	set task2;
run;

data out.hw6_3_qc;
	set task3;
run;

data out.hw6_4_qc;
	set task4;
run;

data out.hw6_5_qc;
	set task5;
run;
