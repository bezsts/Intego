/* Task 1 */

proc sort data = rawdata.demog out = demog_nodup nodupkey;
	by STUDYID SITEID SUBJID;
run;

data hw1_1_qc(keep=USUBJID AGE AGEU RFSTDTC SEX);
	set demog_nodup;
	
	attrib USUBJID length = $50		label = "Unique Subject Identifier" 		   
		   AGE	   length = 8		label = "Age"	
		   AGEU    length = $5  	label = "Age Units" 				   		   
		   RFSTDTC length = $10 	label = "Subject Reference Start Date/Time" 
		   SEX     length = $1  	label = "Sex"							   
		   ;

	USUBJID = catx('-', STUDYID, SITEID, put(SUBJID, Z6.));
	AGE = floor((VISITDT - BIRTHDT + 1) / 365.25);
	AGEU = "YEARS";
	RFSTDTC = put(VISITDT, e8601da.);

	if GENDER = 1 then SEX = "M";
	else if GENDER = 2 then SEX = "F";
run;

/* Task 2 */

proc sort data = rawdata.RDMCODE out = rdmcode_s;
	by DATERANDOMIZED;
run;

data hw1_2_qc(keep = USUBJID ARM ARMCD RANDDTC);
	set rdmcode_s;
	
	attrib USUBJID length = $50		label = "Unique Subject Identifier" 		   
		   ARM	   length = $8		label = "Description of Planned Arm"	
		   ARMCD   length = $1  	label = "Description of Planned Arm Code" 				   		   
		   RANDDTC length = $10 	label = "Randomization Date" 
		   ;

	USUBJID = catx('-', STUDYID, SITEID, put(SUBJID, Z6.));
	ARM = upcase(XTRTMT);
	ARMCD = TRTMT;
	RANDDTC = put(DATERANDOMIZED, e8601da.);
run;

/* Task 3 */

proc sort data = hw1_2_qc out = task2_reverse;
	by descending RANDDTC;
run;

data hw1_3_qc;
	set task2_reverse;

	attrib PTNUM length = 8 	label = "Patient Number"
	;

	PTNUM = _N_;
run;

/* Task 4 */

proc sort data = hw1_1_qc out = task1_s;
	by USUBJID;
run;

proc sort data = hw1_3_qc out = task3_s;
	by USUBJID;
run;

data hw1_4_qc;
	merge task1_s(in = a) task3_s(in = b);
	by USUBJID;
	if a and b;
run;

/*
libname myFiles "E:\1 semestr\Clinical_Trials_Programming\Home Task 1\Team J\QC";

proc copy 
		in = work
		out = myFiles;
	select hw1_1_qc;
run;

proc copy 
		in = work
		out = myFiles;
	select hw1_2_qc;
run;

proc copy 
		in = work
		out = myFiles;
	select hw1_3_qc;
run;

proc copy 
		in = work
		out = myFiles;
	select hw1_4_qc;
run;
*/

