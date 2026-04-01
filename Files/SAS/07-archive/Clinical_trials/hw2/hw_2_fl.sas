dm 'log; clear';

proc datasets library=work kill noprint;
quit;

/* Task 1 */

proc sort data=rawdata.ae out=ae_s;
	by SUBJID AESTART AELINENO;
run;

data hw2_1_fl(keep = STUDYID SUBJID AENAME AESTART AELINENO USUBJID);
	retain STUDYID SUBJID AENAME AESTART AELINENO;
	set ae_s;
	
	attrib USUBJID length = $50		label = "Unique Subject Identifier";

	USUBJID = catx('-', STUDYID, SITEID, put(SUBJID, Z6.));
run;

/* Task 2 */

proc sort data=hw2_1_fl out=hw2_2_fl;
	by AESTART;
run;

data hw2_2_fl;
	set hw2_2_fl;

	if _N_ = 1 then first_date = 'Y';
	else call missing(first_date);
run;

proc sort data=hw2_2_fl;
	by SUBJID AESTART AELINENO;
run;

data hw2_2_fl(drop = first_date);
	set hw2_2_fl;
	by USUBJID;

	attrib AOCCFL   length = $1 label = "1st Occurrence within Subject Flag"
		   AOCCOVFL length = $1 label = "1st Occurrence Overall Flag"
		   ;

	if first.usubjid then AOCCFL = 'Y';
	else call missing(AOCCFL);

	if not missing(first_date) then AOCCOVFL = 'Y';
	else call missing(AOCCOVFL);
run;

/* Task 3 */

proc sort data = rawdata.demog out = demog_nodup nodupkey;
	by STUDYID SITEID SUBJID;
run;

data demog(keep=USUBJID AGE AGEU RFSTDTC SEX);
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

data hw2_3_fl;
	merge demog(in = inA) hw2_2_fl(in = inB);
	by USUBJID;
	if inA;
run;

/* Task 4*/

proc sort data=rawdata.ECGPRFL1 out=ecgprfl1_s;
	by SUBJID ECGDATE ECGDIGTM;
run;

data hw2_4_fl(keep = STUDYID USUBJID VISID ECGDATE ECGDIGTM);
	set ecgprfl1_s;
	by SUBJID VISID;
	
	attrib USUBJID length = $50		label = "Unique Subject Identifier";

	USUBJID = catx('-', STUDYID, SITEID, put(SUBJID, Z6.));

	if last.visid;
run;

data hw2_4_fl;
	merge hw2_3_fl(where = (AOCCFL eq 'Y')) hw2_4_fl;
	by USUBJID;
run;

/* Task 5 */

proc sort data=rawdata.ECGPRFL2 out=ecgprfl2_s;
	by SUBJID ECGDATE;
run;

data hw2_5_fl(keep = STUDYID USUBJID VISID ECGDATE ECGHOUR ECGDIGTM);
	retain STUDYID USUBJID;
	set ecgprfl2_s;
	by SUBJID VISID;

	retain prev_digtm;

	attrib USUBJID length = $50		label = "Unique Subject Identifier";

	USUBJID = catx('-', STUDYID, SITEID, put(SUBJID, Z6.));
	
	if not missing(ECGDIGTM) or first.visid then prev_digtm = ecgdigtm;
	else ECGDIGTM = prev_digtm;
run;

/*libname output "E:\1 semestr\Clinical_Trials_Programming\Home Task 2\Team J\FL";

data output.hw2_1_fl;
	set hw2_1_fl;
run;

data output.hw2_2_fl;
	set hw2_2_fl;
run;

data output.hw2_3_fl;
	set hw2_3_fl;
run;

data output.hw2_4_fl;
	set hw2_4_fl;
run;

data output.hw2_5_fl;
	set hw2_5_fl;
run;*/



