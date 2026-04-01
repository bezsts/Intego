dm 'log; clear';
options missing = '';
proc datasets lib=work kill noprint; run;

/*========*/
/* TASK 1 */
/*========*/

proc sql;
    create table task1 as
    select distinct AENAME from rawdata.ae
    where AELLT not in (select distinct input(LOW_LEVEL_TERM_CODE, best.) from rawdata.meddrasub);
quit;

proc datasets lib=work noprint;
    save task1;
run;

/*========*/
/* TASK 2 */
/*========*/
dm 'log; clear';

proc format;
    value aesev_fmt 
            1 = "MILD" 
            2 = "MODERATE" 
            3 ="SEVERE";

    value aerel_fmt
            1 = "DEFINITELY"
            2 = "PROBABLY"
            3 = "POSSIBLY"
            4 = "REMOTELY"
            5 = "DEFINITELY NOT"
            6 = "UNKNOWN";

    value aeout_fmt
            1 = "RECOVERED/RESOLVED"
            2 = "NOT RECOVERED/NOT RESOLVED"
            3 = "RECOVERING/RESOLVING"
            4 = "RECOVERED/RESOLVED WITH SEQUELAE"
            5 = "RECOVERED/RESOLVED WITH SEQUELAE"
            6 = "FATAL"
            7 = "UNKNOWN";
            
    value aeacn_fmt
            1 = "DOSE NOT CHANGED"
            2 = "DRUG WITHDRAWN"
            3 = "DRUG INTERRUPTED"
            4 = "DOSE REDUCED"
            5 = "DOSE INCREASED"
            6 = "DRUG INTERRUPTED";
run;

proc sort data=rawdata.ae out=ae; by SUBJID AENAME; run;

data ae_new_vars;
    length AESEV AEREL AEOUT AEACN $200;
	
	set ae;

    AESEV = put(AESEVERE, aesev_fmt.);
    AEREL = put(AERELATE, aerel_fmt.);
    AEOUT = put(AEOUTCOM, aeout_fmt.);
    AEACN = put(AEACTION, aeacn_fmt.);
run;

proc sql;
    create table trtmt as
	select distinct subjid, xtrtmt from rawdata.rdmcode;
quit;

%let datasets =;

%macro check(var);
    %if %length(&&&var.) > 0 %then %do;
        %let condition = &condition. and %str(a.AE&var. = "&&&var.");
        %let category_clean = &category_clean._%sysfunc(compress(&&&var., ' /'));
    %end;
%mend check;    

%macro count_category(category_text, SEV=, REL=, OUT=, ACN=);
	%let category_clean =; 
    %let condition =;

    %check(SEV);
    %check(REL);
    %check(OUT);
    %check(ACN);

    proc sql;
        create table &category_clean. as
        select &category_text. as CATEGORY length = 100, t.XTRTMT, count(distinct a.subjid) as COUNT
        from ae_new_vars as a
		right join trtmt as t on a.SUBJID = t.SUBJID &condition.
        group by XTRTMT;
    quit;

    %let datasets = &datasets. &category_clean.;
	%put &datasets.;
%mend count_category;

%count_category("AEs With Moderate Severity", SEV=MODERATE);
%count_category("AEs With Not Recovered/Not Resolved Outcome", OUT=NOT RECOVERED/NOT RESOLVED);
%count_category("AEs Possibly Related to Treatment", REL=POSSIBLY);
%count_category("AEs With Moderate Severity and Possibly Related to Treatment", SEV=MODERATE, REL=POSSIBLY);
%count_category("AEs With Drug Withdrawn Action Taken", ACN=DRUG WITHDRAWN);
%count_category("AEs With Moderate Severity and Drug Withdrawn Action Taken", SEV=MODERATE, ACN=DRUG WITHDRAWN);

data task2;
	set &datasets.;
run;

proc sort data=task2; by category xtrtmt; run;

proc datasets lib=work noprint;
    save task1 task2;
run;

/*========*/
/* TASK 3 */
/*========*/
dm 'log; clear';

proc sort data = rawdata.invagt out = invagt_sort(keep = subjid daydate numtab); by subjid daydate; run;

data invagt_dosenum;
	set invagt_sort;
	by subjid daydate;

	length DOSENUM 8;

	if first.subjid then DOSENUM = NUMTAB;
	else DOSENUM + NUMTAB;
run;

proc sql;
    create table task3 as
    select a.subjid, a.aename, COALESCE(MAX(i.DOSENUM), 0) as DOSENUM from rawdata.ae as a
    left join invagt_dosenum as i on a.SUBJID = i.SUBJID and a.AESTART >= i.DAYDATE
	group by a.subjid, a.aename, a.aestart
    order by a.subjid, a.aename;
quit;

proc datasets lib=work noprint;
    save task1 task2 task3;
run;

/*========*/
/* TASK 4 */
/*========*/
dm 'log; clear';

proc sql noprint;
    select count(distinct subjid) into: pat_num 
	from rawdata.demog;
quit;

proc sql;
	create table task4 as
    select aename, round((count(distinct subjid) / &pat_num.) * 100, 0.01) as PCT
    from rawdata.ae
	group by aename
	having (calculated PCT) > 10;
quit;

proc datasets lib=work noprint;
    save task1 task2 task3 task4;
run;

/*========*/
/* TASK 5 */
/*========*/
dm 'log; clear';

%macro convert_dates(lib, ds);
	proc sql noprint;
        select name into :vars separated by ' ' 
        from dictionary.columns
        where libname = upcase("&lib") 
          and memname = upcase("&ds")
		  and format LIKE 'DATE%';
    quit;

    data &ds._iso;
        set &lib..&ds.;

        %do i=1 %to %sysfunc(countw(&vars.));
            %let next_var = %scan(&vars., &i.);

            &next_var._C = put(&next_var., is8601da.);
        %end;
    run;
%mend convert_dates;
%convert_dates(rawdata, Ae);

proc datasets lib=work noprint;
    save task1 task2 task3 task4 Ae_iso;
run;

/*===========================================================================================================*/

libname out "E:\1 semestr\Clinical_Trials_Programming\Home Task 11\Team D\QC\QC1";

/*data out.hw11_1_qc;*/
/*    set task1;*/
/*run;*/

/*data out.hw11_2_qc;*/
/*    set task2;*/
/*run;*/

data out.hw11_3_qc;
    set task3;
run;

/*data out.hw11_4_qc;*/
/*    set task4;*/
/*run;*/

/*data out.hw11_5_qc;*/
/*    set Ae_iso;*/
/*run;*/

