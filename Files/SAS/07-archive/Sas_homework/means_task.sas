dm 'odsresults; clear';	
dm 'log; clear';

options missing='';

proc datasets lib=work kill noprint; run;

data eg;
	length usubjid $4 egspid $200 egtestcd $8 egstresn 8 visitnum 8 visit $20 egtptnum 8 egtpt $20;
	infile datalines delimiter=",";
	input usubjid $ egspid $ egtestcd $ egstresn visitnum visit $ egtptnum egtpt $;

datalines;
1101,1,QTCFAG,390,-1,Screening,., ,
1101,2,QTCFAG,388,-1,Screening,., ,
1101,3,QTCFAG,391,-1,Screening,., ,
1101,1,QTCFAG,393,101,Visit 1,0,Pre-Dose,
1101,2,QTCFAG,391,101,Visit 1,0,Pre-Dose,
1101,3,QTCFAG,390,101,Visit 1,0,Pre-Dose,
1101,1,QTCFAG,430,101,Visit 1,120,2 Hours Post-Dose,
1101,2,QTCFAG,438,101,Visit 1,120,2 Hours Post-Dose,
1101,3,QTCFAG,422,101,Visit 1,120,2 Hours Post-Dose,
1101,1,QTCFAG,400,101,Visit 1,480,8 Hours Post-Dose,
1101,2,QTCFAG,401,101,Visit 1,480,8 Hours Post-Dose,
1101,3,QTCFAG,399,101,Visit 1,480,8 Hours Post-Dose,
1101,1,QTCFAG,401,102,Visit 2,0,Pre-Dose,
1101,2,QTCFAG,400,102,Visit 2,0,Pre-Dose,
1101,3,QTCFAG,398,102,Visit 2,0,Pre-Dose,
1101,1,QTCFAG,420,102,Visit 2,120,2 Hours Post-Dose,
1101,2,QTCFAG,418,102,Visit 2,120,2 Hours Post-Dose,
1101,3,QTCFAG,430,102,Visit 2,120,2 Hours Post-Dose,
1101,1,QTCFAG,402,102,Visit 2,480,8 Hours Post-Dose,
1101,2,QTCFAG,403,102,Visit 2,480,8 Hours Post-Dose,
1101,3,QTCFAG,405,102,Visit 2,480,8 Hours Post-Dose,
1101,1,QTCFAG,401,103,Visit 3,0,Pre-Dose,
1101,2,QTCFAG,405,103,Visit 3,0,Pre-Dose,
1101,3,QTCFAG,402,103,Visit 3,0,Pre-Dose,
1101,1,QTCFAG,456,103,Visit 3,120,2 Hours Post-Dose,
1101,2,QTCFAG,449,103,Visit 3,120,2 Hours Post-Dose,
1101,3,QTCFAG,455,103,Visit 3,120,2 Hours Post-Dose,
1101,1,QTCFAG,430,103,Visit 3,480,8 Hours Post-Dose,
1101,2,QTCFAG,435,103,Visit 3,480,8 Hours Post-Dose,
1101,3,QTCFAG,440,103,Visit 3,480,8 Hours Post-Dose,
1102,1,QTCFAG,399,-1,Screening,., ,
1102,2,QTCFAG,397,-1,Screening,., ,
1102,3,QTCFAG,399,-1,Screening,., ,
1102,1,QTCFAG,400,101,Visit 1,0,Pre-Dose,
1102,2,QTCFAG,400,101,Visit 1,0,Pre-Dose,
1102,3,QTCFAG,401,101,Visit 1,0,Pre-Dose,
1102,1,QTCFAG,.,101,Visit 1,120,2 Hours Post-Dose,
1102,2,QTCFAG,.,101,Visit 1,120,2 Hours Post-Dose,
1102,3,QTCFAG,.,101,Visit 1,120,2 Hours Post-Dose,
1102,1,QTCFAG,420,101,Visit 1,480,8 Hours Post-Dose,
1102,2,QTCFAG,421,101,Visit 1,480,8 Hours Post-Dose,
1102,3,QTCFAG,423,101,Visit 1,480,8 Hours Post-Dose,
1102,1,QTCFAG,401,102,Visit 2,0,Pre-Dose,
1102,2,QTCFAG,399,102,Visit 2,0,Pre-Dose,
1102,3,QTCFAG,398,102,Visit 2,0,Pre-Dose,
1102,1,QTCFAG,411,102,Visit 2,120,2 Hours Post-Dose,
1102,2,QTCFAG,412,102,Visit 2,120,2 Hours Post-Dose,
1102,3,QTCFAG,411,102,Visit 2,120,2 Hours Post-Dose,
1102,1,QTCFAG,405,102,Visit 2,480,8 Hours Post-Dose,
1102,2,QTCFAG,403,102,Visit 2,480,8 Hours Post-Dose,
1102,3,QTCFAG,402,102,Visit 2,480,8 Hours Post-Dose,
1102,1,QTCFAG,401,103,Visit 3,0,Pre-Dose,
1102,2,QTCFAG,403,103,Visit 3,0,Pre-Dose,
1102,3,QTCFAG,403,103,Visit 3,0,Pre-Dose,
1102,1,QTCFAG,421,103,Visit 3,120,2 Hours Post-Dose,
1102,2,QTCFAG,415,103,Visit 3,120,2 Hours Post-Dose,
1102,3,QTCFAG,417,103,Visit 3,120,2 Hours Post-Dose,
1102,1,QTCFAG,.,103,Visit 3,480,8 Hours Post-Dose,
1102,2,QTCFAG,.,103,Visit 3,480,8 Hours Post-Dose,
1102,3,QTCFAG,.,103,Visit 3,480,8 Hours Post-Dose,
1103,1,QTCFAG,370,-1,Screening,., ,
1103,2,QTCFAG,373,-1,Screening,., ,
1103,3,QTCFAG,372,-1,Screening,., ,
1103,1,QTCFAG,377,101,Visit 1,0,Pre-Dose,
1103,2,QTCFAG,372,101,Visit 1,0,Pre-Dose,
1103,3,QTCFAG,371,101,Visit 1,0,Pre-Dose,
1103,1,QTCFAG,456,101,Visit 1,120,2 Hours Post-Dose,
1103,2,QTCFAG,460,101,Visit 1,120,2 Hours Post-Dose,
1103,3,QTCFAG,461,101,Visit 1,120,2 Hours Post-Dose,
1103,1,QTCFAG,445,101,Visit 1,480,8 Hours Post-Dose,
1103,2,QTCFAG,446,101,Visit 1,480,8 Hours Post-Dose,
1103,3,QTCFAG,448,101,Visit 1,480,8 Hours Post-Dose,
1103,1,QTCFAG,435,102,Visit 2,0,Pre-Dose,
1103,2,QTCFAG,433,102,Visit 2,0,Pre-Dose,
1103,3,QTCFAG,436,102,Visit 2,0,Pre-Dose,
1103,1,QTCFAG,475,102,Visit 2,120,2 Hours Post-Dose,
1103,2,QTCFAG,481,102,Visit 2,120,2 Hours Post-Dose,
1103,3,QTCFAG,480,102,Visit 2,120,2 Hours Post-Dose,
1103,1,QTCFAG,455,102,Visit 2,480,8 Hours Post-Dose,
1103,2,QTCFAG,448,102,Visit 2,480,8 Hours Post-Dose,
1103,3,QTCFAG,450,102,Visit 2,480,8 Hours Post-Dose,
1105,1,QTCFAG,440,-1,Screening,., ,
1105,2,QTCFAG,442,-1,Screening,., ,
1105,3,QTCFAG,445,-1,Screening,., ,
2101,1,QTCFAG,.,-1,Screening,., ,
2101,2,QTCFAG,.,-1,Screening,., ,
2101,3,QTCFAG,.,-1,Screening,., ,
2101,1,QTCFAG,390,101,Visit 1,0,Pre-Dose,
2101,2,QTCFAG,391,101,Visit 1,0,Pre-Dose,
2101,3,QTCFAG,.,101,Visit 1,0,Pre-Dose,
2101,1,QTCFAG,420,101,Visit 1,120,2 Hours Post-Dose,
2101,2,QTCFAG,428,101,Visit 1,120,2 Hours Post-Dose,
2101,3,QTCFAG,.,101,Visit 1,120,2 Hours Post-Dose,
2101,1,QTCFAG,400,101,Visit 1,480,8 Hours Post-Dose,
2101,2,QTCFAG,.,101,Visit 1,480,8 Hours Post-Dose,
2101,3,QTCFAG,.,101,Visit 1,480,8 Hours Post-Dose,
2101,1,QTCFAG,401,102,Visit 2,0,Pre-Dose,
2101,2,QTCFAG,403,102,Visit 2,0,Pre-Dose,
2101,3,QTCFAG,398,102,Visit 2,0,Pre-Dose,
2101,1,QTCFAG,410,102,Visit 2,120,2 Hours Post-Dose,
2101,2,QTCFAG,415,102,Visit 2,120,2 Hours Post-Dose,
2101,3,QTCFAG,412,102,Visit 2,120,2 Hours Post-Dose,
2101,1,QTCFAG,402,102,Visit 2,480,8 Hours Post-Dose,
2101,2,QTCFAG,403,102,Visit 2,480,8 Hours Post-Dose,
2101,3,QTCFAG,400,102,Visit 2,480,8 Hours Post-Dose,
2101,1,QTCFAG,401,103,Visit 3,0,Pre-Dose,
2101,2,QTCFAG,400,103,Visit 3,0,Pre-Dose,
2101,3,QTCFAG,403,103,Visit 3,0,Pre-Dose,
2101,1,QTCFAG,420,103,Visit 3,120,2 Hours Post-Dose,
2101,2,QTCFAG,419,103,Visit 3,120,2 Hours Post-Dose,
2101,3,QTCFAG,417,103,Visit 3,120,2 Hours Post-Dose,
2101,1,QTCFAG,400,103,Visit 3,480,8 Hours Post-Dose,
2101,2,QTCFAG,412,103,Visit 3,480,8 Hours Post-Dose,
2101,3,QTCFAG,413,103,Visit 3,480,8 Hours Post-Dose,
2107,1,QTCFAG,.,-1,Screening,., ,
2107,2,QTCFAG,.,-1,Screening,., ,
2107,3,QTCFAG,.,-1,Screening,., ,
2107,1,QTCFAG,390,101,Visit 1,0,Pre-Dose,
2107,2,QTCFAG,391,101,Visit 1,0,Pre-Dose,
2107,3,QTCFAG,392,101,Visit 1,0,Pre-Dose
run;

proc format;
     value trts
     1 = "Treatment"
     0 = "Placebo";
	 
     value params
     1 = "First"
     2 = "Second"
     3 = "Third";
run;

* please do not alter this piece of code. it does nothing except generating of training results;
data admock(drop = lowerlimit upperlimit i j k);
	length subjid $3 trt $10;

	lowerlimit = 10; *lower limit for aval values;
	upperlimit = 200; * upper limit for aval values;

	do i = 1 to 100; * there will be created 100 subjects;
	    subjid = strip(put(i, z3.)); * unique subject's id assigning;

		* each subject has equal possibility to be assigned to either treatment or placebo;
		trt = strip(put(rand("BINOMIAL", 0.5, 1), trts.)); 

		do j = 1 to 3; * each subject will have 4 different visits;
			param = put(j, params.);

			do k = 1 to 3; * each visit will have 3 time points;
				avisitn = k;

				* generate pretty results for aval and chg variables;
	    		aval = lowerlimit + floor((1 - lowerlimit + upperlimit) * rand("UNIFORM"));
	    		chg = rand("UNIFORM") * 10; 
				format chg 4.2;

	    		output;
			end;
		end;
	end;
run;

/*==========================================*/

proc means data=eg n min max mean median q1 q3 noprint;
	class EGSPID;
	var EGSTRESN;
	output out = means_11 n = n 
						 min = min 
						 max = max 
						 mean = mean 
						 median = median 
						 q1 = q1 
						 q3 = q3;
run;

data means_11(drop = EGSPID _TYPE_ _FREQ_);
	length CLASS $10;
	set means_11;

	if missing(EGSPID) then CLASS = "All egspid";
	else CLASS = cat("Egspid=", strip(EGSPID));
run;

proc sort data=eg out=eg_sort;
	by EGSPID;
run;

proc means data=eg_sort n min max mean median q1 q3 noprint;
	by EGSPID;
	var EGSTRESN;
	output out = means_12 n = n 
						 min = min 
						 max = max 
						 mean = mean 
						 median = median 
						 q1 = q1 
						 q3 = q3;
run;

data means_12(drop = EGSPID _TYPE_ _FREQ_);
	length GROUP $10;
	set means_12;

	GROUP = cat("Egspid=", strip(EGSPID));
run;

/*==========================================*/

proc means data=eg(where = (strip(EGSPID) eq "1")) n mean std median min max noprint;
	var EGSTRESN;
	output out = mean_egspid_1(drop = _TYPE_ _FREQ_)
						 n = n
						 mean = mean
						 std = sd
						 median = median 
						 min = min 
						 max = max;
run;

data mean_egspid_1;
	set mean_egspid_1;

	length nc mean_sd medianc min_max $30;
	label nc = "N"
		  mean_sd = "Mean (SD)"
		  medianc = "Median"
		  min_max = "Min, Max";

	nc = strip(put(n, best.));
	mean_sd = cat(strip(put(mean, 8.1)), " (", strip(put(sd, 8.2)), ")");
	medianc = strip(put(median, 8.1));
	min_max = cat(strip(put(min, best.)), ", ", strip(put(max, best.)));
run;

proc transpose data=mean_egspid_1 out = mean_egspid_1_transp;
	var nc mean_sd medianc min_max;
run;

data means_2(drop = _NAME_ rename = (_LABEL_ = STATISTIC COL1 = VALUE));
	set mean_egspid_1_transp;

	label _LABEL_ = ' ';
run;

/*==========================================*/

proc means data=admock n mean std median min max noprint;
	class param avisitn trt;
	types param*avisitn*trt;
	var aval;
	output out = mean_admock(drop = _TYPE_ _FREQ_)
						 n = n
						 mean = mean
						 std = sd
						 median = median 
						 min = min 
						 max = max;
run;

data mean_admock_prep;
	set mean_admock;
	
	/*length param_tpt $200;
	label param_tpt = "Parameter (unit) Time Point";

	param_tpt = cat("Parameter ", strip(param), " (unit) ", "Time Point ", avisitn);*/

	length nc mean_sd medianc min_max $30;
	label nc = "N"
		  mean_sd = "Mean (SD)"
		  medianc = "Median"
		  min_max = "Min, Max";

	nc = strip(put(n, best.));
	mean_sd = cat(strip(put(mean, 8.1)), " (", strip(put(sd, 8.2)), ")");
	medianc = strip(put(median, 8.1));
	min_max = cat(strip(put(min, best.)), ", ", strip(put(max, best.)));
run;

proc sort data=mean_admock_prep out=mean_admock_prep_sort;
	*by param_tpt;
	by param avisitn;
run;

proc transpose data=mean_admock_prep_sort out = mean_admock_transp;
	*by param_tpt;
	by param avisitn;
	var nc mean_sd medianc min_max;
	id trt;
run;

data means_3(keep = Param_TPT Treatment Placebo);
	length Param_TPT $200 Treatment Placebo $50;
	set mean_admock_transp;
	by param avisitn;

	label Param_TPT = "Parameter (unit) Time Point";

	if first.param then do;
		Param_TPT = cat("Parameter ", strip(param), " (unit)");
		call missing(Treatment);
		call missing(Placebo);
		output;
	end;

	if first.avisitn then do;
		Param_TPT = cat("    Time Point ", strip(put(avisitn, best.)));
		call missing(Treatment);
		call missing(Placebo);
		output;
	end;

	Param_TPT = cat("        ", strip(_LABEL_));
	output;
run;
