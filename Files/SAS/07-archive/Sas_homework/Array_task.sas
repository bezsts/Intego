proc import 
	datafile="E:\1 semestr\Students\Stanislav Bezsmertnyi\SAS\Data\vitals.xlsx" 
	dbms=xlsx 
	out=work.vitals 
	replace;
run;

proc format;
	value $vsorresu		"bpm" = "beats/min"
						"mmHg" = "mmHG";
run;

proc sort data=vitals out=vitals_sort;
	by pt cpevent;
run;

data result(keep = SUBJID VISIT VSTESTCD VSORRES VSORRESU VSSTAT);
	set vitals_sort(rename=(PT=SUBJID CPEVENT=VISIT));

	array vstestcd_arr [3] $ ("SYSBP", "DIABP", "PULSE");
	array vstest_arr [3] $ 25 ("Systolic Blood Pressure", "Dyastolic Blood Pressure", "Pulse rate");
	array vsorres_arr [3] sysbp diabp pulse;
	array vsorresu_arr [3] $ bpu_s bpu_s plsu_s;
	
	attrib
		SUBJID	label = ''
		VISIT label = ''
		VSTESTCD length = $5 label = ''
		VSTEST length = $25 label = ''
		VSORRES length = 8 label = ''
		VSORRESU length = $10 label = ''
	;

	do i=1 to 3;
		VSTESTCD = vstestcd_arr[i];
		VSTEST = strip(vstest_arr[i]);
		if missing(vsorres_arr[i]) then do;
			call missing(VSORRES);
			call missing(VSORRESU);
			VSSTAT = "NOT DONE";
		end;
		else do;
			VSORRES = vsorres_arr[i];
			VSORRESU = strip(put(vsorresu_arr[i], vsorresu.));
			call missing(VSSTAT);
		end;	
		output;
	end;

run;
