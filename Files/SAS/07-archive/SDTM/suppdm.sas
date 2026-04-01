*****************************************
****** Name: Stanislav 			   ******
****** Program Name: suppdm        ******
****** Date: 16JAN2026             ******
*****************************************

****************************************************
               Version history 
Name            Version        Date         Comment
Stanislav       Initial        16JAN2026 
Stanislav                      18FEB2026    Changed QVAL logic 
****************************************************;

dm "log; clear";

libname raw "E:\1 semestr\Mentors\Oleksandra Smilyk\Share File\Rawdata";
libname out "E:\1 semestr\Mentors\Oleksandra Smilyk\Stanislav Bezsmertnyi\SUPP";

options missing = "";

proc datasets lib=work kill noprint;
run;

%let rdomain = DM;
%let keepvars = STUDYID RDOMAIN USUBJID IDVAR IDVARVAL QNAM QLABEL QVAL QORIG QEVAL;
%let seqsort = STUDYID RDOMAIN USUBJID IDVAR IDVARVAL QNAM;

%macro _attrib();
    attrib  
        STUDYID     length = $13    label = "Study Identifier"
        RDOMAIN     length = $2     label = "Related Domain Abbreviation"
        USUBJID     length = $24    label = "Unique Subject Identifier"
        IDVAR       length = $6     label = "Identifying Variable"
        IDVARVAL    length = $6     label = "Identifying Variable Value"
        QNAM        length = $8     label = "Qualifier Variable Name"
        QLABEL      length = $40    label = "Qualifier Variable Label"
        QVAL        length = $47    label = "Data Value"
        QORIG       length = $3     label = "Origin"
        QEVAL       length = $1     label = "Evaluator"
        ;
%mend _attrib;

proc format;
    value major_race_fmt
        1 = "WHITE"
        2 = "UNKNOWN"
        3 = "BLACK OR AFRICAN AMERICAN"
        5 = "AMERICAN INDIAN OR ALASKA NATIVE"
		6 = "OTHER"
        7 = "UNKNOWN";
        
/*    value $ ethnicity_fmt*/
/*        "WHITE" = "White"*/
/*        "BLACK" = "Black, African American, or Negro"*/
/*        "INDIAN" = "American Indian or Alaska Native";*/
run;

/*******************************************************************/
/* Transposing demog dataset to get each ethnicity in separate row */
/*******************************************************************/

proc sort data = rawdata.demog 
          out = demog 
          nodupkey;
    by SUBJID;
run;

data demog;
    length MJRRACEX HISPOTX ASIANOTX PACIFOTX RACEOTHX $200;
    set demog;
run;

proc transpose data = demog 
               out = demog_tr(rename = (STUDYID = _STUDYID))
               prefix = VAL;
    by SUBJID STUDYID SITEID PACIFIC ASIAN /*MJRRACEX -- RACEOTHX*/;
    var MAJRRACE -- RACENONE;
run;

/**************************/
/* Deriving all variables */
/**************************/

data supp&rdomain;
    length  STUDYID $13 RDOMAIN $2 USUBJID $24 IDVAR $6 IDVARVAL $6 
            QNAM $8 QLABEL $40 QVAL $47 QORIG $3 QEVAL $1;
    set demog_tr;
    
    if _NAME_ = "MAJRRACE" or VAL1 = 1 then
        do;
            if not missing(_STUDYID) then
                STUDYID = strip(_STUDYID);
                
            RDOMAIN = "&rdomain";
            
            USUBJID = catx("-", STUDYID, strip(put(SITEID, best.)), strip(put(SUBJID, z6.)));
            
            call missing(IDVAR);
            call missing(IDVARVAL);
            
            QNAM = _NAME_;
            QLABEL = _LABEL_;
            
            if _NAME_ = "MAJRRACE" and VAL1 ne 4 then
                QVAL = put(VAL1, major_race_fmt.);
			else if _NAME_ = "MAJRRACE" and VAL1 eq 4 then do;
				if ASIAN = 1 then QVAL = "ASIAN";
				else if PACIFIC = 1 then QVAL = "NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER";
			end;
            else
				QVAL = "Y";
             /* QVAL = put(_NAME_, $ethnicity_fmt.);*/
            
            QORIG = "CRF";
            call missing(QEVAL);

			output;
        end;
run;


/**********/
/* OUTPUT */
/**********/

proc sort data = supp&rdomain;
	by &seqsort;
run;

data supp&rdomain.(keep = &keepvars.);
	%_attrib();
	set supp&rdomain;
run;

proc contents data=supp&rdomain. varnum;
run;

data out.supp&rdomain.;
	set supp&rdomain;
run;
