data auto;
input make $ mpg rep78 weight foreign;
cards;
Chev.   22 2 3220 0
AMC     17 3 3350 0
AMC     22 . 2640 0
audi    17 5 2830 1
Audi    23 3 2070 1
BMW     . 4 2650 1
BMW     25 4 2650 1
Buick   20 3 3250 0
Buick   15 4 4080 0
Audi    23 3 2070 1
Buick   26 . 2230 0
Datsun  20 3 3280 0
buick   16 3 3880 0
Buick   . . 3400 0
Cad.    14 3 4330 0
Cad.    14 2 3900 0
Cad.    21 3 4290 0
Chev.   29 3 2110 0
chev.   16 4 3690 0
AMC     22 3 2930 0
Chev.   22 2 3220 0
Chev.   24 2 2750 0
Chev.   19 3 3430 0
Datsun  23 4 2370 1
datsun  35 5 2020 1
Datsun  24 4 2280 1
datsun  21 4 2750 1
Buick   18 3 3670 0
Chev.   22 2 3220 0
Datsun  23 4 2370 1
;
run;
/*First Task*/
proc sort data=auto(where=(foreign=0)) sortseq=linguistic(strength=primary) out=not_foreign_makers(keep=make) nodupkey;
	by make;
run;

proc print data=not_foreign_makers;
run;
 
/*Second Task*/
proc sort data=auto out=auto2(where=(make~="" AND mpg>. AND rep78>. AND weight>.) drop=foreign);
	by make DESCENDING mpg DESCENDING rep78 DESCENDING weight;
run;

proc print data=auto2;
run;

/*Third Task*/
proc sort data=auto out=auto3 nodupkey;
	by _ALL_;
run;

proc sort data=auto3;
	by mpg;
run;

proc print data=auto3;
run;
