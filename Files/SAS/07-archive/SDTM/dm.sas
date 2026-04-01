dm 'log; clear';
libname raw "E:\1 semestr\Mentors\Oleksandra Smilyk\Share File\Rawdata";

proc datasets library=work kill noprint;
quit;

/* Sorting raw datasets to merge them later and keep only necessary variables */
proc sort data=raw.demog out=demog_s(keep = STUDYID SITEID SUBJID BIRTHDT GENDER MAJRRACE ASIAN PACIFIC VISITDT) nodupkey;
	by SUBJID;
run;

proc sort data=raw.rdmcode out=rdmcode_s(keep = SUBJID DATERANDOMIZED TRTMT XTRTMT);
	by SUBJID;
run;

proc sort data=raw.endtrial out=endtrial_s(keep = SUBJID LASTVSDT);
	by SUBJID;
run;

proc sort data=raw.invagt out=invagt_s(keep = SUBJID DAYDATE TIMEADM);
	by SUBJID DAYDATE;
run;

proc sort data=raw.death out=death_s(keep = SUBJID DEATHDT);
	by SUBJID;
run; 

/*Creating dataset to determine ACTARM variable*/
data invagt_isTreated(keep = SUBJID TRT where = (TRT eq 1));
	set invagt_s;
	if not missing(daydate) then TRT = 1;
	else TRT = 0;
run;

proc sort data=invagt_isTreated nodupkey;
	by SUBJID;
run;

/*Creating datasets to find RFXSTDTC and RFXENDTC variables*/
data invagt_first(keep = SUBJID datetime_first);
	set invagt_s;
	by SUBJID;
	
	time = input(timeadm, time5.);
	datetime_first = dhms(daydate, 0, 0, time);
		
	if first.SUBJID;
run;

data invagt_last(keep = SUBJID datetime_last);
	set invagt_s;
	by SUBJID;
	
	time = input(timeadm, time5.);
	datetime_last = dhms(daydate, 0, 0, time);
		
	if last.SUBJID;
run;

/*Merging all datasets from above in one source dataset*/
data invagt_src;
	merge invagt_first invagt_last invagt_isTreated;
	by SUBJID;
run;

data src;
	merge demog_s(in = inDem) rdmcode_s(in = inR) endtrial_s(in = inE) invagt_src(in = inI) death_s(in = inDth);
	by SUBJID;
	if inDem;
run;

/*Creating dm dataset*/
data DM(keep = STUDYID DOMAIN USUBJID SUBJID RFSTDTC RFENDTC RFXSTDTC RFXENDTC RFICDTC RFPENDTC 
		DTHDTC DTHFL SITEID BRTHDTC AGE AGEU SEX RACE ETHNIC ARMCD ARM ACTARM ACTARMCD COUNTRY DMDTC DMDY);
	set src(rename=(STUDYID = STUDYID_original SITEID = SITEID_original SUBJID = SUBJID_original));
	
	attrib 
		STUDYID  length = $13	label = "Study Identifier" 
		DOMAIN 	 length = $2 	label = "Domain Abbreviation"
		USUBJID  length = $24	label = "Unique Subject Identifier"
		SUBJID 	 length = $6	label = "Subject Identifier for the Study"
		RFSTDTC  length = $19	label = "Subject Reference Start Date/Time"
		RFENDTC  length = $19	label = "Subject Reference End Date/Time"
		RFXSTDTC length = $19	label = "Date/Time of First Study Treatment"
		RFXENDTC length = $19	label = "Date/Time of Last Study Treatment"
		RFICDTC  length = $19	label = "Date/Time of Informed Consent"
		RFPENDTC length = $19	label = "Date/Time of End of Participation"
		DTHDTC	 length = $19	label = "Date/Time of Death"
		DTHFL	 length = $1	label = "Subject Death Flag"
		SITEID	 length = $3	label = "Study Site Identifier"
		BRTHDTC  length = $19	label = "Date/Time of Birth"
		AGE		 length = 8		label = "Age"
		AGEU	 length = $5	label = "Age Units"
		SEX		 length = $1	label = "Sex"
		RACE	 length = $41	label = "Race"
		ETHNIC	 length = $22	label = "Ethnicity"
		ARMCD	 length = $8	label = "Planned Arm Code"
		ARM	 	 length = $200	label = "Description of Planned Arm"
		ACTARM	 length = $200	label = "Description of Actual Arm"
		ACTARMCD length = $8	label = "Actual Arm Code"
		COUNTRY  length = $3	label = "Country"
		DMDTC	 length = $19	label = "Date/Time of Collection"
		DMDY	 length = 8		label = "Study Day of Collection"
		;
			
	STUDYID = STUDYID_original;
	DOMAIN = "DM";
	USUBJID = catx('-', STUDYID_original, SITEID_original, put(SUBJID_original, z6.));
	SUBJID = put(SUBJID_original, z6.);
	RFSTDTC = put(DATERANDOMIZED, is8601da.);
	RFENDTC = put(LASTVSDT, is8601da.);
	RFXSTDTC = put(datetime_first, is8601dt20.);
	RFXENDTC = put(datetime_last, is8601dt20.);
	call missing(RFICDTC);
	RFPENDTC = put(LASTVSDT, is8601da.);
	
	if not missing(DEATHDT) then DTHDTC = put(DEATHDT, is8601da.);
	else call missing(DTHDTC);
	
	if not missing(DTHDTC) then DTHFL = "Y";
	else call missing(DTHFL);

	SITEID = strip(put(SITEID_original, best.));
	BRTHDTC = put(BIRTHDT, is8601da.);

	AGE = floor((input(RFSTDTC, is8601da.) - input(BRTHDTC, is8601da.) + 1) / 365.25);
	AGEU = "YEARS";

	if GENDER = 1 then SEX = "M";
	else if GENDER = 2 then SEX = "F";

	if MAJRRACE = 1 then do;
		RACE = "WHITE";
		ETHNIC = "NOT HISPANIC OR LATINO";
	end;
	else if MAJRRACE = 2 then do; 
		RACE = "UNKNOWN";
		ETHNIC = "HISPANIC OR LATINO";
	end;
	else if MAJRRACE = 3 then do;
		RACE = "BLACK OR AFRICAN AMERICAN";
		ETHNIC = "NOT HISPANIC OR LATINO";
	end;
	else if MAJRRACE = 4 and ASIAN = 1 then do;
		RACE = "ASIAN";
		ETHNIC = "UNKNOWN";
	end;
	else if MAJRRACE = 4 and PACIFIC = 1 then do;
		RACE = "NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER";
		ETHNIC = "UNKNOWN";
	end;
	else if MAJRRACE = 5 then do;
		RACE = "AMERICAN INDIAN OR ALASKA NATIVE";
		ETHNIC = "UNKNOWN";
	end;
	else if MAJRRACE = 6 then do;
		RACE = "OTHER";
		ETHNIC = "OTHER";
	end;
	else if MAJRRACE = 7 then do;
		RACE = "UNKNOWN";
		ETHNIC = "UNKNOWN";
	end;
	
	if missing(TRTMT) then ARMCD = "NOTASSGN";
	else ARMCD = TRTMT;

	if missing(XTRTMT) then ARM = "NOTASSGN";
	else ARM = XTRTMT;
	
	if TRT = 1 then ACTARM = ARM;
	else if not missing(ARM) then ACTARM = "Not Treated";
	else ACTARM = "Not Assigned";

	if ACTARM = "Not Treated" then ACTARMCD = "NOTTRT";
	else if ACTARM = "Not Assigned" then ACTARMCD = "NOTASSGN";
	else ACTARMCD = ARMCD;

	COUNTRY = "UNK";

	DMDTC = put(VISITDT, is8601da.);
	
	if VISITDT < DATERANDOMIZED then DMDY = VISITDT - DATERANDOMIZED;
	else if VISITDT >= DATERANDOMIZED then DMDY = VISITDT - DATERANDOMIZED + 1;

	/*format _ALL_;
	informat _ALL_;*/
run;

libname out "E:\1 semestr\Mentors\Oleksandra Smilyk\Stanislav Bezsmertnyi\DM";

data out.DM;
	set dm;
run;
