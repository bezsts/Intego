*****************************************
****** Name: Stanislav Bezsmertnyi ******
****** Program Name: cm.sas        ******
****** Date: 20DEC2025             ******
*****************************************

**************************************************************************
               Version history 
Name             Version        Date         Comment
Stanislav        Initial        20DEC2025
Stanislav		 				11JAN2026	 Updated CMSTRF CMENRF logic: 
											 added "AFTER" category
**************************************************************************;

dm "log; clear";

libname raw "E:\1 semestr\Mentors\Oleksandra Smilyk\Share File\Rawdata";
libname sdtm "E:\1 semestr\Mentors\Oleksandra Smilyk\Stanislav Bezsmertnyi\DM";
libname out "E:\1 semestr\Mentors\Oleksandra Smilyk\Stanislav Bezsmertnyi\CM";

options missing = "";

proc datasets lib=work kill noprint;
run;

%let domain = CM;
%let keepvars = STUDYID DOMAIN USUBJID CMSEQ CMTRT CMINDC 
				CMDOSE CMDOSU CMDOSFRQ CMROUTE CMSTDTC CMENDTC 
				CMSTDY CMENDY CMSTRF CMENRF;
%let seqsort = STUDYID USUBJID CMTRT CMSTDTC;

proc format;
	value $dosu
		"CAP" = "CAPSULE"
		"g" = "g"
		"GR" = "grain"
		"GTT" = "DROP"
		"ug" = "ug"
		"uL" = "uL"
		"mg" = "mg"
		"mL" = "mL"
		"OZ" = "oz"
		"PUF" = "PUFF"
		"SPY" = "SPRAY/SQUIRT"
		"SUP" = "SUPPOSITORY"
		"TSP" = "tsp"
		"TBS" = "Tbsp"
		"TAB" = "TABLET"
		"UNK" = "UNKNOWN"
		"OTH" = "OTHER"
		;

	value $route
		"PO" = "ORAL"
		"TD" = "TRANSDERMAL"
		"INH" = "RESPIRATORY (INHALATION)"
		"IM" = "INTRAMUSCULAR"
		"IV" = "INTRAVENOUS"
		"REC" = "RECTAL"
		"VAG" = "VAGINAL"
		"SQ" = "SUBCUTANEOUS"
		"SL" = "SUBLINGUAL"
		"AUR" = "AURICULAR (OTIC)"
		"IA" = "INTRA-ARTICULAR"
		"NAS" = "NASAL"
		"IO" = "INTRAOCULAR"
		"UNK" = "UNKNOWN"
		"OTH" = "OTHER"
		;
run; 

%macro _attrib();
	attrib 	STUDYID 	length =  $13 	label = "Study Identifier"
			DOMAIN 		length =  $2 	label = "Domain Abbreviation"
			USUBJID 	length =  $24 	label = "Unique Subject Identifier"
			CMSEQ 		length =  8 	label = "Sequence Number"
			CMTRT 		length =  $30 	label = "Reported Name of Drug, Med, or Therapy"
			CMINDC 		length =  $30 	label = "Indication"
			CMDOSE 		length =  8 	label = "Dose per Administration"
			CMDOSU 		length =  $40 	label = "Dose Units"
			CMDOSFRQ 	length =  $4 	label = "Dosing Frequency Per Interval"
			CMROUTE 	length =  $30 	label = "Route of Administration"
			CMSTDTC 	length =  $10 	label = "Start Date/Time of Medication"
			CMENDTC 	length =  $10 	label = "End Date/Time of Medication"
			CMSTDY 		length =  8 	label = "Study Day of Start of Medication"
			CMENDY 		length =  8 	label = "Study Day of End of Medication"
			CMSTRF 		length =  $7 	label = "Start Relative to Reference Period"
			CMENRF 		length =  $7 	label = "End Relative to Reference Period"
	;
%mend _attrib;

/*============================================*/
/* Set conmeds priormed datasets from rawdata */
/*============================================*/

data cm1;
	set raw.conmeds(rename = (STUDYID = _STUDYID CMDOSE = _CMDOSE CMROUTE = _CMROUTE));
run;

data pm1;
	set raw.priormed(rename = (STUDYID = _STUDYID));
run;

/*================================================================*/
/* Deriving all variables except CMSE CMSTDY CMENDY CMSTRF CMENRF */
/*================================================================*/

data cm_setall;
	length 	STUDYID $13 DOMAIN $2 USUBJID $24 CMTRT $30 CMINDC $30 CMDOSE 8 CMDOSU $40
			CMDOSFRQ $4 CMROUTE $30 CMSTDTC $10 CMENDTC $10;
	set cm1(in = a)
		pm1(in = b)
	;

	if not missing(_STUDYID) then STUDYID = strip(_STUDYID);
	DOMAIN = "&domain";
	USUBJID = catx("-", STUDYID, strip(put(SITEID, best.)), strip(put(SUBJID, z6.)));

	if a then do;
		if not missing(CMNAME) then CMTRT = strip(CMNAME);

		if not missing(CMINDCTN) then CMINDC = strip(CMINDCTN);

		if not missing(_CMDOSE) then CMDOSE = _CMDOSE;
		
		if not missing(CMUNIT) then CMDOSU = put(strip(CMUNIT), dosu.);

		if not missing(CMFREQ) then CMDOSFRQ = strip(CMFREQ);

		if not missing(_CMROUTE) then CMROUTE = put(strip(_CMROUTE), route.);

		if not missing(CMSTRTDT) then CMSTDTC = strip(put(CMSTRTDT, is8601da.));

		if not missing(CMSTOPDT) then CMENDTC = strip(put(CMSTOPDT, is8601da.));
	end;

	if b then do;
		if not missing(PMNAME) then CMTRT = strip(PMNAME);

		if not missing(PMINDCTN) then CMINDC = strip(PMINDCTN);

		if not missing(PMDOSE) then CMDOSE = input(PMDOSE, best.);
		
		if not missing(PMUNIT) then CMDOSU = put(strip(PMUNIT), dosu.);

		if not missing(PMFREQ) then CMDOSFRQ = strip(PMFREQ);

		if not missing(PMROUTE) then CMROUTE = put(strip(PMROUTE), route.);

		if not missing(PMSTRTDT) then CMSTDTC = strip(put(PMSTRTDT, is8601da.));

		if not missing(PMSTOPDT) then CMENDTC = strip(put(PMSTOPDT, is8601da.));
	end;

	if not missing(CMTRT) then output;
run;

/*===========================================================*/
/* Merge DM dataset and deriving CMSTDY CMENDY CMSTRF CMENRF */
/*===========================================================*/

proc sort data = sdtm.DM out = dm;
	by USUBJID;
run;

proc sort data = cm_setall;
	by USUBJID;
run;

data &domain.;
	length CMSTDY 8 CMENDY 8 CMSTRF $7 CMENRF $7;
	merge cm_setall(in = a) dm(in = b keep = USUBJID RFSTDTC RFENDTC);
	by USUBJID;
	if a;

	if length(CMSTDTC) >= 10 and length(RFSTDTC) >= 10 then do;
		CMSTDY = input(substr(strip(CMSTDTC), 1, 10), is8601da.) - input(substr(strip(RFSTDTC), 1, 10), is8601da.) 
					+ (CMSTDTC >= RFSTDTC);
		
		if CMSTDTC < RFSTDTC then
			CMSTRF = "BEFORE";
		else if CMSTDTC >= RFSTDTC and CMSTDTC <= RFENDTC then
			CMSTRF = "DURING";
		else
			CMSTRF = "AFTER";
	end;

	if length(CMENDTC) >= 10 and length(RFSTDTC) >= 10 then do;
		CMENDY = input(substr(strip(CMENDTC), 1, 10), is8601da.) - input(substr(strip(RFSTDTC), 1, 10), is8601da.) 
					+ (CMENDTC >= RFSTDTC);
		
		if CMENDTC < RFSTDTC then
			CMENRF = "BEFORE";
		else if CMENDTC >= RFSTDTC and CMENDTC <= RFENDTC then
			CMENRF = "DURING";
		else
			CMENRF = "AFTER";
	end;
run;

/*==================================*/
/* Deriving CMSEQ and final dataset */
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
