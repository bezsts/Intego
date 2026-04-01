dm 'log; clear';

libname raw "E:\1 semestr\Mentors\Oleksandra Smilyk\Share File\Rawdata";
libname output "E:\1 semestr\Mentors\Oleksandra Smilyk\Stanislav Bezsmertnyi\AE";
libname sdtm "E:\1 semestr\Mentors\Oleksandra Smilyk\Stanislav Bezsmertnyi\DM";

option missing = '';

proc datasets lib=work kill noprint;
quit;

%LET domain = AE;
%LET keepvars = STUDYID DOMAIN USUBJID AESEQ AETERM AEMODIFY AELLT AELLTCD AEDECOD AEPTCD AEHLT AEHLTCD AEHLGT 
			AEHLGTCD AEBODSYS AEBDSYCD AESOC AESOCCD AESEV AESER AEACN AEACNOTH AEREL AEOUT AESTDTC AEENDTC 
			AESTDY AEENDY AEENRTPT AEENTPT;

/*=====================================================*/
/* Merging raw AE and MEDDRASUB by LLT and PT variables*/
/*=====================================================*/

data ae;
	set raw.ae(rename=(STUDYID=_STUDYID AESOC = SOC AEHLGT = HLGT AEHLT = HLT AEPT = PT AELLT = LLT));
run;

data med;
	set raw.MEDDRASUB;
	length LLT PT 8;
	LLT = input(LOW_LEVEL_TERM_CODE, best.);
	PT = input(PREFERRED_TERM_CODE, best.);
run;

proc sort data=med;
	by LLT PT;
run;

proc sort data=ae;
	by LLT PT;
run;

data ae;
	merge ae(in=a) med(in=m);
	by LLT PT;
	if a;
run;

/*======================================================*/
/* Deriving all necessary variables from raw AE dataset */
/*======================================================*/

data ae1;
	length STUDYID $13 DOMAIN $2 USUBJID $24 AETERM $200 AEMODIFY $200 AELLT $200 AELLTCD 8 AEDECOD $200 
			AEPTCD 8 AEHLT $200	AEHLTCD 8 AEHLGT $200 AEHLGTCD 8 AEBODSYS $200 AEBDSYCD 8
			AESOC $200 AESOCCD 8 AESEV $8 AESER $1 AEACN $17 AEACNOTH $25 AEREL $18 AEOUT $32
			AESTDTC $19 AEENDTC $19 AEENRTPT $20 AEENTPT $40;
	set ae;

	STUDYID = strip(_STUDYID);
	DOMAIN = "&domain";
	USUBJID = catx("-", STUDYID, strip(put(SITEID, best.)), strip(put(SUBJID, z6.)));

	AETERM = upcase(AENAME);
	AEMODIFY = VERBATIM;

	if not missing(LOW_LEVEL_TERM) then AELLT = LOW_LEVEL_TERM;
	else AELLT = "UNCODED";
	AELLTCD = LLT;

	if not missing(PREFERRED_TERM) then AEDECOD = PREFERRED_TERM;
	else AEDECOD = "UNCODED";
	AEPTCD = PT;

	if not missing(HIGH_LEVEL_TERM) then AEHLT = HIGH_LEVEl_TERM;
	else AEHLT = "UNCODED";
	AEHLTCD = HLT;

	if not missing(HIGH_LEVEL_GROUP_TERM) then AEHLGT = HIGH_LEVEl_GROUP_TERM;
	else AEHLGT = "UNCODED";
	AEHLGTCD = HLGT;

	if not missing(SYSTEM_ORGAN_CLASS) then AEBODSYS = SYSTEM_ORGAN_CLASS;
	else AEBODSYS = "UNCODED";
	AEBDSYCD = SOC;

	if not missing(SYSTEM_ORGAN_CLASS) then AESOC = SYSTEM_ORGAN_CLASS;
	else AESOC = "UNCODED";
	AESOCCD = SOC;

	if AESEVERE = 1 then AESEV = "MILD";
	else if AESEVERE = 2 then AESEV = "MODERATE";
	else if AESEVERE = 3 then AESEV = "SEVERE";

	if AESERIOS = 0 then AESER = "N";
	else if AESERIOS = 1 then AESER = "Y";

	if AEACTION = 1 then AEACN = "DOSE NOT CHANGED";
	else if AEACTION = 2 then AEACN = "DRUG WITHDRAWN";
	else if AEACTION = 3 then AEACN = "DRUG INTERRUPTED";
	else if AEACTION = 4 then AEACN = "DOSE REDUCED";
	else if AEACTION = 5 then AEACN = "DOSE INCREASED";
	else if AEACTION = 6 then AEACN = "DRUG INTERRUPTED";

	if AEOTHER = 1 then AEACNOTH = "NONE";
	else if AEOTHER = 2 then AEACNOTH = "REMEDIAL THERAPY-PHARM";
	else if AEOTHER = 3 then AEACNOTH = "REMEDIAL THERAPY-NONPHARM";
	else if AEOTHER = 4 then AEACNOTH = "HOSPITALIZATION";
	
	if AERELATE = 1 then AEREL = "DEFINITELY";
	else if AERELATE = 2 then AEREL = "PROBABLY";
	else if AERELATE = 3 then AEREL = "POSSIBLY";
	else if AERELATE = 4 then AEREL = "REMOTELY";
	else if AERELATE = 5 then AEREL = "DEFINITELY NOT";
	else if AERELATE = 6 then AEREL = "UNKNOWN";

	if AEOUTCOM = 1 then AEOUT = "RECOVERED/RESOLVED";
	else if AEOUTCOM = 2 then AEOUT = "NOT RECOVERED/NOT RESOLVED";
	else if AEOUTCOM = 3 then AEOUT = "RECOVERING/RESOLVING";
	else if AEOUTCOM = 4 or AEOUTCOM = 5 then AEOUT = "RECOVERED/RESOLVED WITH SEQUELAE";
	else if AEOUTCOM = 6 then AEOUT = "FATAL";
	else if AEOUTCOM = 7 then AEOUT = "UNKNOWN";

	AESTDTC = put(AESTART, is8601da.);
	AEENDTC = put(AESTOP, is8601da.);
	
	if AECONT = 1 and missing(AESTOP) then do;
		AEENRTPT = "ONGOING";
		AEENTPT = "DATE OF LAST ASSESSMENT";
	end;
	else do;
		call missing(AEENRTPT);
		call missing(AEENTPT);
	end;
run;

/*================*/
/* Deriving AESEQ */
/*================*/

proc sort data=ae1 out=ae2;
	by USUBJID AEDECOD AETERM AESTDTC;
run;

data ae2;
	length AESEQ 8;
	set ae2;
	by STUDYID USUBJID;

	if first.usubjid then AESEQ = 1;
	else AESEQ + 1;
run;

/*============================*/
/* Deriving AESTDY and AEENDY */
/*============================*/

data ae3;
	merge ae2(in=a) sdtm.dm(keep = STUDYID USUBJID RFSTDTC in=d);
	by STUDYID usubjid;
	if a;
run;

data ae3;
	set ae3;

	length AESTDY AEENDY 8;

	AESTDY = input(substr(AESTDTC, 1, 10), is8601da.) - input(substr(RFSTDTC, 1, 10), is8601da.) + (AESTDTC >= RFSTDTC);
	if not missing(AEENDTC) then 
		AEENDY = input(substr(AEENDTC, 1, 10), is8601da.) - input(substr(RFSTDTC, 1, 10), is8601da.) + (AEENDTC >= RFSTDTC);
run;

/*===============*/
/* Final dataset */
/*===============*/

data ae_final(keep = &keepvars);
	retain &keepvars;
	set ae3;
	
	label 	STUDYID  = "Study Identifier"
			DOMAIN   = "Domain Abbreviation"
			USUBJID	 = "Unique Subject Identifier"
			AESEQ	 = "Sequence Number"
			AETERM	 = "Reported Term for the Adverse Event"
			AEMODIFY = "Modified Reported Term"
			AELLT	 = "Lowest Level Term"
			AELLTCD	 = "Lowest Level Term Code"
			AEDECOD	 = "Dictionary-Derived Term"
			AEPTCD	 = "Preferred Term Code"
			AEHLT	 = "High Level Term"
			AEHLTCD	 = "High Level Term Code" 
			AEHLGT	 = "High Level Group Term"
			AEHLGTCD = "High Level Group Term Code"
			AEBODSYS = "Body System or Organ Class" 
			AEBDSYCD = "Body System or Organ Class Code"
			AESOC	 = "Primary System Organ Class"
			AESOCCD	 = "Primary System Organ Class Code"
			AESEV	 = "Severity/Intensity"
			AESER	 = "Serious Event"
			AEACN	 = "Action Taken with Study Treatment"
			AEACNOTH = "Other Action Taken"  
			AEREL	 = "Causality"
			AEOUT	 = "Outcome of Adverse Event"
			AESTDTC	 = "Start Date/Time of Adverse Event"
			AEENDTC	 = "End Date/Time of Adverse Event"  
			AESTDY	 = "Study Day of Start of Adverse Event"
			AEENDY	 = "Study Day of End of Adverse Event" 
			AEENRTPT = "End Relative to Reference Time Point"  
			AEENTPT	 = "End Reference Time Point"
			; 
run;

data output.AE;
	set ae_final;
run;
