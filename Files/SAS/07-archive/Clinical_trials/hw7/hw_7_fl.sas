dm 'log; clear';

options missing='';

proc datasets lib=work kill noprint; run;

/**********/
/* TASK 1 */
/**********/

data task1(keep = SUBJID SITEID VISID LABDATE USUBJID LBDTC VISIT VISITNUM);
    set rawdata.labtrack;
    
    attrib  USUBJID     length = $50    label = "Unique Subject Identifier"
            LBDTC       length = $19    label = "Date/Time of Specimen Collection"
            VISIT       length = $200   label = "Visit Name"
            VISITNUM    length = 8      label = "Visit Number"            
            ;
    
    USUBJID = catx("-", strip(STUDYID), put(SITEID, best.), put(SUBJID, z6.));
    
    if not missing(LABDATE) then
        LBDTC = put(LABDATE, is8601da.);
        
    if not missing(VISID) then do;
        if VISID = "SCRNBASE" then
            do;
                VISIT = "Screening";
                VISITNUM = -999;
            end;
        else 
            do;
                VISITNUM = input(substr(VISID, 4), best.);

                if VISITNUM eq 0 then 
                    do;
                        call missing(VISIT);
                        call missing(VISITNUM);
                        putlog "WARNING: VISID = DAY0! Check USUBJID = " USUBJID;
                    end;
                else if VISITNUM < 1 then VISIT = "Screening";
                else if VISITNUM < 40 then VISIT = catx(" ", "DAY", compress(VISID, , 'kd'));
                else VISIT = "Day 40 onwards";
                
                VISID = tranwrd(VISID, "DAY", "DAY ");
            end;
    end;     
run;

/**********/
/* TASK 2 */
/**********/

proc format;
    value age_group
        low -< 38 = "<38 years"
        38 -< 42 = "38-<42 years"
        42 - high = ">=42 years"
        ;
run;    

data task2(keep = STUDYID SUBJID SITEID BIRTHDT USUBJID AGE AAGE);
    set rawdata.demog;
    
    attrib  USUBJID length = $50    label = "Unique Subject Identifier"
            AGE     length = 8      label = "Age"
            AAGE    length = $50    label = "Analysis Age"            
            ;
    
    USUBJID = catx("-", strip(STUDYID), put(SITEID, best.), put(SUBJID, z6.));
    
    AGE = int((VISITDT - BIRTHDT + 1) / 365.25);
    AAGE = put(AGE, age_group.);
run;

proc sort data=task2 nodupkey;
    by USUBJID;
run;

/**********/
/* TASK 3 */
/**********/

proc sort data=rawdata.followup out=followup;
    by SUBJID;
run;

data cocdays(keep = SUBJID COCDAYS);
    set followup;
    by SUBJID;
    
    length COCDAYS 8;
    
    if first.SUBJID then
        COCDAYS = IFN(missing(COCAIN_D), 0, COCAIN_D);
    else if not missing(COCAIN_D) then 
        COCDAYS + COCAIN_D;
        
    if last.subjid;
run;

data task3;
    merge task2(in = a) cocdays(in = b);
    by SUBJID;
    if a;
run;

/**********/
/* OUTPUT */
/**********/

libname out "E:\1 semestr\Clinical_Trials_Programming\Home Task 7\Team G\FL";

data out.hw7_1_fl;
    set task1;
run;

data out.hw7_2_fl;
    set task2;
run;

data out.hw7_3_fl;
    set task3;
run;
