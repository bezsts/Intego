dm 'odsresults; clear';	
dm 'log; clear';

options missing='';

proc datasets lib=work kill noprint; run;

libname train "E:\1 semestr\Students\Stanislav Bezsmertnyi\SAS\Data\sql-datasets";

/*========*/
/* TASK 1 */
/*========*/

proc sort data=train.ae_train out=ae_sort;
	by AEBODSYS AESEV AEDECOD;
run;

ods output nlevels=un_usubjid;
proc freq data=ae_sort nlevels;
	by AEBODSYS AESEV AEDECOD;
	tables USUBJID / noprint;
run;

proc freq data=ae_sort noprint;
	tables AEBODSYS*AESEV*AEDECOD / out = number_ae;
run;

data freq1(drop = NLevels COUNT);
	merge un_usubjid(drop = TableVar) number_ae(drop = PERCENT);
	by AEBODSYS AESEV AEDECOD;

	length N EVENT 8;

	N = NLevels;
	EVENT = COUNT;
run;

/*========*/
/* TASK 2 */
/*========*/

/*
proc freq data=train.ae_train noprint;
	tables STUDYID / out = any_event;
	tables AESER / out = ser_event;
	tables AEREL / out = rel_event;
	tables AEACN / out = acn_event;
run;

* Any Ae; 
ods output nlevels=any_n;
proc freq data=train.ae_train nlevels;
	by STUDYID;
	tables USUBJID / noprint;
run;

* Ser Ae; 
proc sort data=train.ae_train out = ae_ser_sort;
	by AESER;
run;
 
ods output nlevels=ser_n;
proc freq data=ae_ser_sort nlevels;
	by AESER;
	tables USUBJID / noprint;
run;

* Rel Ae; 
proc sort data=train.ae_train out = ae_rel_sort;
	by AEREL;
run;

ods output nlevels=rel_n;
proc freq data=ae_rel_sort nlevels;
	by AEREL;
	tables USUBJID / noprint;
run;

* Acn Ae;
proc sort data=train.ae_train out = ae_acn_sort;
	by AEACN;
run;

ods output nlevels=acn_n;
proc freq data=ae_acn_sort nlevels;
	by AEACN;
	tables USUBJID / noprint;
run;

data freq2_Event(keep = CATEGORY EVENT);
	set any_event(in = inAny) 
		ser_event(in = inSer where = (AESER eq "Y")) 
		rel_event(in = inRel where = (AEREL eq "POSSIBLY RELATED" or AEREL eq "PROBABLY RELATED")) 
		acn_event(in = inAcn where = (AEACN eq "DRUG WITHDRAWN"))
		;

	length CATEGORY $200 EVENT 8;
	EVENT = COUNT;

	if inAny then
		CATEGORY = "Any AE";
	else if inSer then
		CATEGORY = "Serious AE";
	else if inRel then
		CATEGORY = "Drug-Related AE";
	else if inAcn then
		CATEGORY = "Permanent withdrawal of treatment due to AE";
run;

data freq2_N(keep = CATEGORY N);
	set any_n(in = inAny) 
		ser_n(in = inSer where = (AESER eq "Y")) 
		rel_n(in = inRel where = (AEREL eq "POSSIBLY RELATED" or AEREL eq "PROBABLY RELATED")) 
		acn_n(in = inAcn where = (AEACN eq "DRUG WITHDRAWN"))
		;

	length CATEGORY $200 N 8;
	N = NLevels;

	if inAny then
		CATEGORY = "Any AE";
	else if inSer then
		CATEGORY = "Serious AE";
	else if inRel then
		CATEGORY = "Drug-Related AE";
	else if inAcn then
		CATEGORY = "Permanent withdrawal of treatment due to AE";
run;

proc sort data= freq2_n;
	by CATEGORY;
run;

proc sort data= freq2_event;
	by CATEGORY;
run;

data freq2;
	merge freq2_n freq2_event;
	by CATEGORY;
run;

*/

data ae_category;
	set train.ae_train;
	
	length CATEGORY $200;
	
	CATEGORY = "Any AE";
	output;

	if AESER eq "Y" then do;
		CATEGORY = "Serious AE";
		output;
	end;

	if AEACN eq "DRUG WITHDRAWN" then do;
		CATEGORY = "Permanent withdrawal of treatment due to AE";
		output;
	end;

	if AEREL eq "POSSIBLY RELATED" or AEREL eq "PROBABLY RELATED" then do;
		CATEGORY = "Drug-Related AE";
		output;
	end;
run;

proc freq data = ae_category noprint;
	tables CATEGORY / out = event_values(drop = PERCENT rename = (COUNT = EVENT));
run;

proc freq data = ae_category noprint;
	tables CATEGORY * USUBJID / out = category_usubjid;
run;

proc freq data = category_usubjid noprint;
	tables CATEGORY / out = n_values(drop = PERCENT rename = (COUNT = N));
run;

data freq2;
	merge n_values event_values;
	by CATEGORY;

	label N = ' ';
	label EVENT = ' ';
run; 
