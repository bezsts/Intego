options missing = '';

libname train "E:\1 semestr\Students\Stanislav Bezsmertnyi\SAS\Data\sql-datasets";


/* Task 1 */
proc sql;
	create table task1 as
	select ae.usubjid, aeterm, aedecod, aebodsys, aesev, 
		aeser, aestdtc, aeendtc, lower(strip(sex)) as SEX, propcase(strip(race)) as RACE, brthdtc
	from train.ae_train as ae
	left join train.dm_train as dm on ae.usubjid = dm.usubjid
	; 
quit;

/* Task 2 */
proc sql;
	create table task2_1 as
	select usubjid from (
		select usubjid from train.ae_train
		union
		select usubjid from train.eg_train
		union
		select usubjid from train.lb_train
		union
		select usubjid from train.mh_train
		union
		select usubjid from train.pe_train
		union
		select usubjid from train.vs_train
	)
	where usubjid not in (select usubjid from train.dm_train)
	;
quit;

/* Task 3 */
proc sql;
	create table avg_weight as
	select usubjid, round(avg(vsstresn), 0.1) as AVG_WGT 
	from train.vs_train
	where vstestcd="WEIGHT"
	group by usubjid
	;

	create table max_pulse as
	select usubjid, max(vsstresn) as MAX_PLS 
	from train.vs_train
	where vstestcd="PULSE"
	group by usubjid
	;

	create table max_date as
	select usubjid, 
		put(max(lbdtc), is8601da.) as MAX_DATE length = 20 
											   label = "Maximum date of laboratory test"
	from train.lb_train
	group by usubjid
	;

	create table task3 as
	select dm.usubjid, AVG_WGT, MAX_PLS, MAX_DATE  
	from train.dm_train as dm
	left join avg_weight as aw on dm.usubjid = aw.usubjid
	left join max_pulse as mp on dm.usubjid = mp.usubjid
	left join max_date as md on dm.usubjid = md.usubjid
	;
quit;

/* Task 4 */
proc sql noprint;
	create table dm_age as
	select *,
		case
			when age <= 75 then "<=75"
			else ">75" 
		end
	as AGEGRP
	from train.dm_train as dm
	;

	create table dm_N as
	select agegrp, count(*) as N, CAT(agegrp, ' (N=', calculated N, ')') as age_desc
	from dm_age
	group by agegrp
	;
quit;

proc sql noprint;
	select distinct strip(age_desc) into :age_lab separated by '|'
	from dm_N
	;
quit;

%put &=age_lab;

proc sql noprint;
	select distinct strip(age_desc) into :age_desc1 - 
	from dm_N
	;
quit;

%put &=age_desc1;
%put &=age_desc2;
