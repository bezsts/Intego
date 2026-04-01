dm 'log; clear';

proc datasets lib=work kill noprint;
quit;

%macro task1(dataset, sortord=subjid);
	proc sort data=&dataset;
		by &sortord;
	run;
%mend task1;

data input_data;
   infile datalines dsd;
   length subjid $5 sex $1 age 8 race $30 startdate enddate 8;
   format startdate enddate date9.;
   input subjid $ sex $ age race $ startdate enddate;
   datalines;
01001, M, 43, ASIAN, 22412, 22413
01002, F, 51, WHITE, 22493, 22495
01005, M, 27, OTHER, 22285, 22325
04002, F, 23, BLACK OR AFRICAN AMERICAN, 22580, 22582
04003, F, 31, WHITE, 22479, 22527
04003, M, 40, BLACK OR AFRICAN AMERICAN, 22392, 22392
;
run;

%task1(input_data, sortord=age);

data _null_;
	set input_data end = eof;
	
	if _N_ eq 1 then do;
		call symput("first_subj", subjid);
	end;

	if eof then	do;
		call symput("obs_num", strip(put(_N_, best.)));
		call symput("last_subj", subjid);
	end;
run;

proc sql noprint;
	select min(startdate), max(enddate) into: stdt, :endt
	from input_data
	;
quit;

data _null_;
	call symput("stdt", strip(put(&stdt, date9.)));
	call symput("endt", strip(put(&endt, date9.)));
run;

data _null_;
	putlog "Number of observations is - &obs_num";
	putlog "Id of the first subject in the data is - &first_subj";
	putlog "Id of the last subject in the data is - &last_subj";
	putlog "The earlist start date is - &stdt";
	putlog "The latest end date is - &endt";
run;

