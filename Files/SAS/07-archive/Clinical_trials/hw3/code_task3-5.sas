dm 'log; clear';

option missing = "";

proc datasets lib=work kill noprint; quit;

/*========*/
/* Task 3 */
/*========*/

proc sort data=rawdata.followup out=followup;
	by SUBJID;
run;

data cocaine(keep = USUBJID COCDAYS);
	set followup;
	by SUBJID;
	length USUBJID $50 COCDAYS 8;
	label USUBJID = "Unique Subject Identifier";
	
	USUBJID = catx("-", STUDYID, strip(put(SITEID, best.)), strip(put(SUBJID, z6.)));

	if first.SUBJID then do;
		if not missing(COCAIN_D) then COCDAYS = COCAIN_D;
		else COCDAYS = 0;
	end;
	else if not missing(COCAIN_D) then COCDAYS + COCAIN_D;
	
	if last.subjid;
run;

/*========*/
/* Task 4 */
/*========*/

proc sort data=rawdata.rdmcode out=rdmcode;
	by SUBJID;
run;

proc sort data=rawdata.ae out = ae;
	by SUBJID;
run;

data ae_trtA
	 ae_trtB;
	merge ae(in=a) rdmcode(in=r);
	by SUBJID;
	if a;

	if TRTMT = "A" then output ae_trtA;
	else if TRTMT = "B" then output ae_trtB;
run;

data ae_trtA;
	set ae_trtA end = eof;

	retain COUNT 0;

	COUNT = COUNT + 1;

	if eof;
run;

data ae_trtB;
	set ae_trtB end = eof;

	retain COUNT 0;

	COUNT = COUNT + 1;

	if eof;
run;

data trt_count(keep = XTRTMT COUNT);
	set ae_trtA
		ae_trtB;
run;

/*========*/
/* Task 5 */
/*========*/

proc sort data=rawdata.ecg1 out=ecg1;
	by subjid ECGHRTRT;
run;

data ecg_hrt(keep = USUBJID VISIT VISITNUM ECG12TM ECGHRTRT);
	length USUBJID $50 VISIT $50 VISITNUM 8;
	set ecg1;
	by SUBJID;

	label USUBJID = "Unique Subject Identifier";
	USUBJID = catx("-", STUDYID, strip(put(SITEID, best.)), strip(put(SUBJID, z6.)));
	
	if first.subjid then do;
		VISIT = "Min Heart Rate";
		VISITNUM = -1;
		output;
	end;

	VISIT = VISID;
	VISITNUM = input(compress(VISID,, 'kd'), best.);
	
	if missing(VISITNUM) then VISITNUM = 0;

	output;

	if last.subjid then do;
		VISIT = "Max Heart Rate";
		VISITNUM = 999;
		output;
	end;
run;

proc sort data=ecg_hrt;
	by USUBJID VISITNUM;
run;

libname output "E:\1 semestr\Clinical_Trials_Programming\Home Task 3\Team I\QC";

data output.hw3_3_qc;
	set cocaine;
run;

data output.hw3_4_qc;
	set trt_count;
run;

data output.hw3_5_qc;
	set ecg_hrt;
run;


