proc printto log="E:\1 semestr\Clinical_Trials_Programming\Home Task 3\Team I\QC\hw3_1_qc.log";

/*========*/
/* Task 1 */
/*========*/

proc sort data = rawdata.vitals out=vitals;
	by DESCENDING VSTEMP;
run;

data _null_;
	set vitals;
	if _N_ = 1 then do;
		putlog "NOTE: Highest Temperature is " VSTEMP ", Subject = " SUBJID;
	end;
run;

proc printto;
run;
