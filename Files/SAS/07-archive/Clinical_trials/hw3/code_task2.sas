proc printto log="E:\1 semestr\Clinical_Trials_Programming\Home Task 3\Team I\QC\hw3_2_qc.log";

/*========*/
/* Task 2 */
/*========*/

proc sort data=rawdata.ae out=ae;
	by SUBJID;
run;

data _null_;
	set ae;

	if missing(AESTOP) then do;
		putlog "W" "ARNING: AE Stop Date is empty. Subject = " SUBJID ", AE Name = " AENAME ", AE Start Date = " AESTART;
	end;
run;

proc printto;
run;
