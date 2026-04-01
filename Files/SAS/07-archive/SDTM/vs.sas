*****************************************
****** Name: Stanislav Bezsmertnyi ******
****** Program Name: vs.sas        ******
****** Date: 22DEC2025             ******
*****************************************

****************************************************
               Version history 
Name           Version          Date         Comment
Stanislav      Initial          22DEC2025           
****************************************************;

dm "log; clear";

libname raw "E:\1 semestr\Mentors\Oleksandra Smilyk\Share File\Rawdata";
libname sdtm "E:\1 semestr\Mentors\Oleksandra Smilyk\Stanislav Bezsmertnyi\DM";
libname out "E:\1 semestr\Mentors\Oleksandra Smilyk\Stanislav Bezsmertnyi\VS";

options missing = "";

proc datasets lib=work kill noprint;
run;

%let domain = VS;
%let keepvars = STUDYID DOMAIN USUBJID VSSEQ VSTESTCD VSTEST VSORRES VSORRESU 
				VSSTRESC VSSTRESN VSSTRESU VSSTAT VSBLFL VISITNUM VISIT VISITDY 
				VSDTC VSDY VSTPT VSTPTNUM;
%let seqsort = STUDYID USUBJID VSTESTCD VISITNUM VSTPTNUM; 

proc format;
	value $testcd
		"HEIGHT" = "HEIGHT"
		"WEIGHT" = "WEIGHT"
		"VSTEMP" = "TEMP"
		"VSRESP" = "RESP"
		"VSPULSE" = "PULSE"
		"VSBPSYS" = "SYSBP"
		"VSBPDIA" = "DIABP"
		;

	value $test
		"HEIGHT" = "Height"
		"WEIGHT" = "Weight"
		"TEMP" = "Temperature"
		"RESP" = "Respiratory Rate"
		"PULSE" = "Pulse Rate"
		"SYSBP" = "Systolic Blood Pressure"
		"DIABP" = "Diastolic Blood Pressure"
		;
run;

%macro _attrib();
    attrib  STUDYID     length = $13    label = "Study Identifier"
            DOMAIN      length = $2     label = "Domain Abbreviation"
            USUBJID     length = $24    label = "Unique Subject Identifier"
            VSSEQ       length = 8      label = "Sequence Number"
            VSTESTCD    length = $8     label = "Vital Signs Test Short Name"
            VSTEST      length = $40    label = "Vital Signs Test Name"
            VSORRES     length = $8     label = "Result or Finding in Original Units"
            VSORRESU    length = $11    label = "Original Units"
            VSSTRESC    length = $8     label = "Character Result/Finding in Std Format"
            VSSTRESN    length = 8      label = "Numeric Result/Finding in Standard Units"
            VSSTRESU    length = $11    label = "Standard Units"
            VSSTAT      length = $8     label = "Completion Status"
            VSBLFL      length = $1     label = "Baseline Flag"
            VISITNUM    length = 8      label = "Visit Number"
            VISIT       length = $9     label = "Visit Name"
            VISITDY     length = 8      label = "Planned Study Day of Visit"
            VSDTC       length = $19    label = "Date/Time of Measurements"
            VSDY        length = 8      label = "Study Day of Vital Signs"
            VSTPT       length = $13    label = "Planned Time Point Name"
            VSTPTNUM    length = 8      label = "Planned Time Point Number"
            ;
%mend _attrib;

/*==========================================================*/
/* Set physexam, vitals v1, vitals v2 datasets from rawdata */
/*==========================================================*/
data pe1;
    set raw.PHYSEXAM(rename=(STUDYID = _STUDYID));
run;

data vs1;
    set raw.VITALS(rename=(STUDYID = _STUDYID));
run;

data vs2;
    set raw.VITALS2(rename=(STUDYID = _STUDYID));
run;

/*==============================*/
/* Transposing physexam dataset */
/*==============================*/

proc sort data = pe1;
	by _STUDYID SITEID SUBJID VISID VISITDT HEIGHTUN WEIGHTUN;
run;

proc transpose data = pe1 out = pe1_tr prefix = test;
	by _STUDYID SITEID SUBJID VISID VISITDT HEIGHTUN WEIGHTUN;
	var HEIGHT WEIGHT;
run;

/*===============================*/
/* Transposing vitals v1 dataset */
/*===============================*/

proc sort data = vs1;
	by _STUDYID SITEID SUBJID VISID VSDATE VSTIME VSHOUR;
run;

data vs1;
	set vs1;
	by SUBJID VISID;

	if first.subjid then SEQ = 1;
	else SEQ + 1;
run;

proc transpose data = vs1 out = vs1_tr prefix = test;
	by _STUDYID SITEID SUBJID VISID VSDATE VSTIME VSHOUR SEQ VSTEMP_U;
	var VSTEMP VSRESP VSPULSE VSBPSYS VSBPDIA;
run;

/*===============================*/
/* Transposing vitals v2 dataset */
/*===============================*/

proc sort data = vs2;
	by _STUDYID SITEID SUBJID VISID VSDATE VSTIME;
run;

data vs2;
	set vs2;
	by SUBJID VISID;

	if first.subjid then SEQ = 1;
	else SEQ + 1;
run;

proc transpose data = vs2 out = vs2_tr prefix = test;
	by _STUDYID SITEID SUBJID VISID VSDATE VSTIME SEQ VSTEMP_U;
	var VSTEMP VSRESP VSPULSE VSBPSYS VSBPDIA;
run;

/*=================================================*/
/* Deriving all variables except VSSEQ VSBLFL VSDY */
/*=================================================*/

data vs_setall;
    length STUDYID $13 DOMAIN $2 USUBJID $24 VSTESTCD $8 VSTEST $40 VSORRES $8 VSORRESU $11
		VSSTRESC $8 VSSTRESN 8 VSSTRESU $11 VSSTAT $8 VISITNUM 8 VISIT $9 VISITDY 8 
		VSDTC $19 VSTPT $13 VSTPTNUM 8;
    set pe1_tr(in=pe)
        vs1_tr(in=vs1)
        vs2_tr(in=vs2)
        ;

    if not missing(_STUDYID) then STUDYID = strip(_STUDYID);
    DOMAIN = "&domain";
    USUBJID = catx("-", STUDYID, strip(put(SITEID, best.)), strip(put(SUBJID, z6.)));
	if not missing(_NAME_) then do;
		VSTESTCD = put(strip(_NAME_), testcd.);
		VSTEST = put(VSTESTCD, test.);
	end;
    
    if not missing(test1) then do;
        VSORRES = strip(put(test1, best.));

		if VSTESTCD eq "HEIGHT" then do; 
			if HEIGHTUN eq 1 then do;
				VSORRESU = "IN";
				VSSTRESC = strip(put(round(test1 * 2.54, 0.1), best.));
			end;
			else if HEIGHTUN eq 2 then do;
				VSORRESU = "cm";
				VSSTRESC = strip(put(round(test1, 0.1), best.));
			end;

			VSSTRESU = "cm";
		end;
		else if VSTESTCD eq "WEIGHT" then do; 
			if WEIGHTUN eq 1 then do;
				VSORRESU = "LB";
				VSSTRESC = strip(put(round(test1 * 0.45359237, 0.1), best.));
			end;
			else if WEIGHTUN eq 2 then do;
				VSORRESU = "kg";
				VSSTRESC = strip(put(round(test1, 0.1), best.));
			end;

			VSSTRESU = "kg";
		end;
		else if VSTESTCD eq "TEMP" then do; 
			if VSTEMP_U eq 1 then do;
				VSORRESU = "F";
				VSSTRESC = strip(put(round((test1-32)/1.8, 0.1), best.));
			end;
			else if VSTEMP_U eq 2 then do;
				VSORRESU = "C";
				VSSTRESC = strip(put(round(test1, 0.1), best.));
			end;

			VSSTRESU = "C";
		end;
		else if VSTESTCD eq "RESP" then do;
			VSORRESU = "BREATHS/MIN";
			VSSTRESC = VSORRES;
			VSSTRESU = "BREATHS/MIN";
		end;
		else if VSTESTCD eq "PULSE" then do; 
			VSORRESU = "BEATS/MIN";
			VSSTRESC = VSORRES;
			VSSTRESU = "BEATS/MIN";
		end;
		else if VSTESTCD eq "SYSBP" or VSTESTCD eq "DIABP" then do;
			VSORRESU = "mmHg";
			VSSTRESC = VSORRES;
			VSSTRESU = "mmHg";
		end;

		VSSTRESN = input(VSSTRESC, best.);
    end;

	if missing(VSORRES) then do;
		VSSTAT = "NOT DONE";
	end;
	else do;
		call missing(VSSTAT);
	end;

	if not missing(VISID) then do;
		if VISID eq "SCRNBASE" then do; 
			VISITNUM = -30;
			VISIT = "SCREENING";
		end;
		else if VISID eq "UNSCHEDULED" then do;
			VISITNUM = 99;
		end;
		else do;
			VISITNUM = input(compress(VISID,,'kd'), best.);
			VISIT = strip(catx(' ', "DAY", VISITNUM));
		end;

		VISITDY = VISITNUM;
	end;

	if pe then do;
		if not missing(VISITDT) then
			VSDTC = strip(put(VISITDT, is8601da.));
	end;
	else do;
		if not missing(VSDATE) and not missing(VSTIME) then
			VSDTC = catx('T', strip(put(VSDATE, is8601da.)), strip(VSTIME));
	end;

	if not missing(VSHOUR) then do;
		VSTPTNUM = VSHOUR;
		VSTPT = strip(cat(VSTPTNUM, 'H'));
	end;
run;

/*======================================*/
/* Merging DM dataset and deriving VSDY */
/*======================================*/

proc sort data = sdtm.dm out = dm;
	by USUBJID;
run;

proc sort data = vs_setall;
	by USUBJID;
run;

data &domain.;
	length VSDY 8;
	merge vs_setall(in = a) dm(in = b keep = USUBJID RFSTDTC);
	by USUBJID;
	if a;

	if length(VSDTC) >= 10 and length(RFSTDTC) >= 10 then do;
		VSDY = input(substr(strip(VSDTC), 1, 10), is8601da.) - input(substr(strip(RFSTDTC), 1, 10), is8601da.)
				+ (VSDTC >= RFSTDTC);
	end;
run;

/*=================*/
/* Deriving VSBLFL */
/*=================*/

data vsblfl;
	set &domain.;

	if VSDTC <= RFSTDTC and not missing(VSDTC) and not missing(VSORRES) and not missing(VSSTRESN);
run;

proc sort data = vsblfl;
	by USUBJID VSTESTCD VSDTC;
run;

data vsblfl1;
	length VSBLFL $1;
	set vsblfl;
	by USUBJID VSTESTCD VSDTC;

	if last.VSTESTCD then VSBLFL = 'Y';
run;

proc sort data=&domain.;
	by USUBJID VSTESTCD VSDTC;
run;

data &domain.;
	merge &domain.(in = a) vsblfl1(in = b keep = USUBJID VSTESTCD VSDTC VSBLFL);
	by USUBJID VSTESTCD VSDTC;
	if a;
run;

/*==================================*/
/* Deriving VSSEQ and final dataset */
/*==================================*/

proc sort data = &domain;
	by &seqsort;
run;

data &domain.(keep = &keepvars.);
	%_attrib();
	set &domain;
	by &seqsort;

	if first.USUBJID then &domain.SEQ = 1;
	else &domain.SEQ + 1;
run;

proc contents data=&domain. varnum;
run;

data out.&domain.;
	set &domain;
run;
