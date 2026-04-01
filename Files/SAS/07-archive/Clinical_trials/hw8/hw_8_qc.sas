dm 'log; clear';

options missing = ' ';

proc datasets lib=work kill noprint;
run;

/*========*/
/* TASK 1 */
/*========*/

data vitals_setall;
    set rawdata.vitals
        rawdata.vitals2;

    if VSTEMP_U eq 1 then
        VSTEMP = round((VSTEMP - 32) / 1.8, 0.1);
run;

proc sort data = vitals_setall;
	by SUBJID;
run;

proc means data = vitals_setall min noprint;
	class SUBJID;
	var VSTEMP;
	output out = min_vstemp(rename = (SUBJID = _SUBJID)) min = VSTEMP;
run;

data task1(keep = SUBJID VSTEMP);
	attrib SUBJID length = $7 label = "Subject";
	set min_vstemp;
	if _TYPE_ eq 0 then
		SUBJID = "OVERALL";
	else
		SUBJID = put(_SUBJID, z6.);
run;

proc sort data = task1;
	by SUBJID;
run;

/*========*/
/* TASK 2 */
/*========*/

data priormed;
	set rawdata.priormed(rename=(SUBJID=_SUBJID));

	length PMDOSEN 8 SUBJID $6;

	SUBJID = put(_SUBJID, z6.);

	if PMUNIT eq "OTH" or PMUNIT eq "TAB" then
		PMDOSE = "100";

	if missing(PMDOSE) then PMDOSE = "0";

	PMDOSEN = input(PMDOSE, best.);
run;

proc freq data = priormed noprint;
	by SUBJID;
	tables PMANYMED / out = freq_pmdose;
	weight PMDOSEN / zeros;
run;

data task2(keep = SUBJID TOTDOSE);
	set freq_pmdose;

	length TOTDOSE 8;

	TOTDOSE = COUNT;
run;

/*========*/
/* TASK 3 */
/*========*/

proc sort data=rawdata.extlabs out=extlabs(rename=(SUBJID=_SUBJID));
    by TESTNAME RESULT
;

proc freq data=extlabs noprint;
	by TESTNAME;
	tables RESULT / out = freq_lab_result missing;
run;

/* Deleting all tests that contain ONLY missing values*/

data extlabs_missing(where = (drop_group eq 1));
	set freq_lab_result;
	by TESTNAME;

	if missing(RESULT) and PERCENT >= 100 then do;
		drop_group = 1;
	end;
run;

/* Deleting all tests that DO NOT have any numeric results*/

data extlabs_char;
	set freq_lab_result;
	by TESTNAME;

	if first.TESTNAME then sum_char_percent = 0;

	if missing(compress(RESULT,,'kd')) then sum_char_percent + PERCENT;

	if sum_char_percent >= 100;
run;

data extlabs_clear;
	merge extlabs
		  extlabs_missing(in = inmissing keep = TESTNAME)
		  extlabs_char(in = inchar keep = TESTNAME);
	by TESTNAME;

	length RESULTN 8;

	SUBJID = put(_SUBJID, z6.);

	if missing(compress(RESULT,,'kd')) then call missing(RESULT);

	if not inmissing and not inchar and FINDC(RESULT, '+-<>') eq 0 then do;
		if not missing(RESULT) then RESULTN = input(RESULT, best.);
		output;
	end;
run;

proc means data = extlabs_clear mean median std min max nmiss noprint;
	class SUBJID TESTNAME / missing;
	types SUBJID*TESTNAME;
	var RESULTN;
	output out = extlabs_means 	mean   = Mean
								median = Median
								std	   = SD
								min    = Min
								max    = Max
								nmiss  = NMiss;
run;

proc sort data = extlabs_means out = task3(drop = _TYPE_ _FREQ_);
	by SUBJID TESTNAME;
run;


/*========*/
/* TASK 4 */
/*========*/

proc format;
    value response_c
        1 = "Bad"
        2 = "Poor"
        3 = "Satisfactory"
        4 = "Good"
        5 = "Excellent";
run;

data csfq_setall;
    set rawdata.CSFQFEML
        rawdata.CSFQMALE;
        
    array csfq CSFQ1-CSFQ14;
    array csfq_c $200 CSFQC1-CSFQC14;

    do i = 1 to dim(csfq);
        csfq_c[i] = put(csfq[i], response_c.);
    end;
run;

proc sort data = csfq_setall;
    by SUBJID;
run;

proc sort data = rawdata.rdmcode out = rdmcode;
    by SUBJID;
run;

data csfq_rdmcode;
    merge csfq_setall
          rdmcode(keep=SUBJID XTRTMT TRTMT);
    by SUBJID;
run;

proc sort data = csfq_rdmcode;
    by XTRTMT SUBJID VISID;
run;

proc transpose data = csfq_rdmcode out = csfq_rdmcode_tr(rename = (_NAME_ = QUESTION COL1 = RESPONSE));
    by XTRTMT TRTMT SUBJID VISID;
    var CSFQC1-CSFQC14;
run;

proc freq data = csfq_rdmcode_tr noprint;
    by XTRTMT TRTMT;
    tables RESPONSE / out = response_freq;
run;

proc freq data = csfq_rdmcode_tr noprint;
    tables RESPONSE / out = response_freq_overall;
run;

data task4(keep = ARM ARMCD QSTEST QSSTRESN);
    attrib  ARM     length = $50    label = "Description of Planned Arm"
            ARMCD   length = $1     label = "Planned Arm Code"
            QSTEST  length = $100   label = "Question Name"
            QSSTRESN length = 8     label = "Numeric Finding in Standard Units"
            ;
    set response_freq(in = ina)
		response_freq_overall(in = inb);

    if ina then do;
		ARM = strip(XTRTMT);
    	ARMCD = strip(TRTMT);
	end;
	else do;
		ARM = "Overall";
		ARMCD = "O";
	end;
    QSTEST = cat("Number of '", strip(RESPONSE), "' Answers");
    QSSTRESN = COUNT;
run;

proc sort data = task4;
    by ARMCD QSTEST;
run;

/*========*/
/* TASK 5 */
/*========*/

proc datasets lib=work kill noprint;
run;

data ecg1_rdmcode;
	merge rawdata.ecg1
		  rawdata.rdmcode(keep = SUBJID XTRTMT);
	by SUBJID;
run;

proc means data = ecg1_rdmcode alpha = 0.1 noprint;
	class XTRTMT VISID;
	var ECGPR ECGHRTRT;
	types XTRTMT*VISID;
	output out = ecg1_means mean(ECGPR) 	=
							mean(ECGHRTRT) 	=
							lclm(ECGPR)		=
							lclm(ECGHRTRT)	=
							uclm(ECGPR)		=
							uclm(ECGHRTRT)	=
							std(ECGPR) 		=
							std(ECGHRTRT) 	=
							min(ECGPR) 		=
							min(ECGHRTRT)	=
							max(ECGPR)		=
							max(ECGHRTRT)	= / autoname;
run;

data task5(keep = VISIT VISITNUM ARM EGTESTCD Mean L_90CI U_90CI SD Min Max);
	attrib 	VISIT 		length = $50 	label = "Visit Name "
			VISITNUM	length = 8		label = "Visit Number"
			ARM			length = $50	label = "Description of Planned Arm"
			EGTESTCD	length = $8		label = "ECG Test or Examination Short Name"
			Mean		length = 8
			L_90CI		length = 8
			U_90CI		length = 8
			SD			length = 8
			Min			length = 8
			Max			length = 8
			;
	set ecg1_means;

	VISIT = strip(VISID);

	if VISIT eq "SCRNBASE" then VISITNUM = -999;
	else VISITNUM = input(strip(compress(VISIT,,'kd')), best.);

	ARM = strip(XTRTMT);

	EGTESTCD = "ECGHRTRT";
	Mean = round(ECGHRTRT_Mean, 0.001);
	L_90CI = round(ECGHRTRT_LCLM, 0.001);
	U_90CI = round(ECGHRTRT_UCLM, 0.001);
	SD = round(ECGHRTRT_StdDev, 0.001);
	Min = round(ECGHRTRT_Min, 0.001);
	Max = round(ECGHRTRT_Max, 0.001);
	output;

	EGTESTCD = "ECGPR";
	Mean = round(ECGPR_Mean, 0.001);
	L_90CI = round(ECGPR_LCLM, 0.001);
	U_90CI = round(ECGPR_UCLM, 0.001);
	SD = round(ECGPR_StdDev, 0.001);
	Min = round(ECGPR_Min, 0.001);
	Max = round(ECGPR_Max, 0.001);
	output;
run;

proc sort data = task5;
	by ARM EGTESTCD VISITNUM;
run;

/*===========================================================================================================*/

libname out "E:\1 semestr\Clinical_Trials_Programming\Home Task 8\Team D\QC\QC2";

/*data out.hw8_1_qc;*/
/*    set task1;*/
/*run;*/
/**/
/*data out.hw8_2_qc;*/
/*    set task2;*/
/*run;*/
/**/
/*data out.hw8_3_qc;*/
/*    set task3;*/
/*run;*/
/**/
data out.hw8_4_qc;
    set task4;
run;
/**/
/*data out.hw8_5_qc;*/
/*    set task5;*/
/*run;*/
