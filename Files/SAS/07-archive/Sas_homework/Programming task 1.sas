/*Task 1*/
data ID;
	infile datalines delimiter=',';
	length subjid $3 sex $1 race $30;
	input subjid $ sex $ age race $ date;
	datalines;
001,F,23,BLACK OR AFRICAN AMERICAN,20181018
002,f,31,ASIAN,20181010
003,M,20,OTHER,.
004,m,65,WHITE,20180813
005,F,65,ASIAN,20180825
	;
run;

proc print data=id;
run;

/*Task 2*/
data DM(keep=subjid agegrp race rfxstdtc rename=(subjid=id));
	length subjid $3 agegrp $20 race $25 rfxstdtc $20;
	label agegrp = "Age Group" race = "Race";
	set id(where=(age>22));
	
	day=mod(date,100);
    month=floor(mod(date / 100, 100));
	year=floor(date / 10000);

	new_date=mdy(month, day, year);
	rfxstdtc=put(new_date, is8601da.);  

	if age<=30 then agegrp="<=30";
	else if 30 < age < 65 then agegrp=">30 - <65";
	else agegrp = ">=65";
run;

proc print data=dm;
run;

/*Task 3*/
data hgwg;
	infile datalines dsd;
	input subjid : $3. visit : $10. hgt wght;
	datalines;
001, VISIT 1, 164, 56
001, VISIT 2, ., 58
001, VISIT 3, ., 59
002, VISIT 1, 174, 65
002, VISIT 2, 174, 63
002, VISIT 3, 174, 63
002, VISIT 4, ., 70
	;
run;

proc sort data=hgwg;
	by subjid visit;
run;

data vs(keep = subjid visit vstestcd vsorres);
	set hgwg;
	by subjid visit;

	retain _hgt sum_wght amount_wght;
	
	if first.subjid then do;
        call missing(_hgt);
		sum_wght = wght;
		amount_wght = 1;
    end;
	else do;
		sum_wght = sum_wght + wght;
		amount_wght = amount_wght + 1;
	end;
	
	if missing(hgt) then hgt=_hgt;
	else _hgt=hgt;

	vstestcd = "HEIGHT";
	vsorres = hgt;
	output;

	vstestcd = "WEIGHT";
	vsorres = wght;
	output;

	if last.subjid = 1 then do;
		vsorres = round(sum_wght / amount_wght, .1);
		call missing(visit);
		vstestcd = "AVGWGH";
		output;
	end;
run;

proc print data=vs;
run;


