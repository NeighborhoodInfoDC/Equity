/**************************************************************************
 Program:  Round_output.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  07/25/17
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Rounds variables in the output to the nearest 0.1, 1, 10 or 100. 
**************************************************************************/

%macro round_output(in=,out=);

proc contents data = &in. out = cont noprint;
run;

data contents;
	set cont;
	if name in("councildist", "county") then delete;
	mflag = index(name,'_m_');
	keep name mflag; 
run;

proc sql noprint;
select name
into :varlist separated by " "
from contents
where mflag = 0;
quit;

proc sql noprint;
select name
into :mlist separated by " "
from contents
where mflag > 0;
quit;
	
%put &varlist.;


data &out.;
	set profile_tabs_ACS_suppress_&ct.;

	%macro round();
			%let i = 1;
				%do %until (%scan(&varlist,&i,' ')=);
					%let var=%scan(&varlist,&i,' ');

		/* Don't touch missing values or codes */
		if &var. in (.,.s,.n,.a) then do;
			&var. = &var.;
		end;

		/* Round positive values */
		else if 0 < &var. < 100 then do;
			&var. = round(&var.,1);
		end;
		else if 100 <= &var. < 1000 then do;
			&var. = round(&var.,10);
		end;
		else if &var. >= 1000 then do;
			&var. = round(&var.,100);
		end;

		/* Round negative values */
		else if 0 > &var. > -100 then do;
			&var. = round(&var.,1);
		end;
		else if -100 >= &var. > -1000 then do;
			&var. = round(&var.,10);
		end;
		else if &var. <= -1000 then do;
			&var. = round(&var.,100);
		end;

		%let i=%eval(&i + 1);
				%end;
			%let i = 1;
				%do %until (%scan(&varlist,&i,' ')=);
					%let var=%scan(&varlist,&i,' ');
		%let i=%eval(&i + 1);
				%end;
	%mend round;
	%round;


	%macro round_moe();
			%let i = 1;
				%do %until (%scan(&mlist,&i,' ')=);
					%let var=%scan(&mlist,&i,' ');

		/* Don't touch missing values or codes */
		if &var. in (.,.s,.n,.a) then do;
			&var. = &var.;
		end;

		/* Round positive values */
		else if 0 < &var. < 100 then do;
			&var. = round(&var.,.1);
		end;
		else if &var. >= 100 then do;
			&var. = round(&var.,10);
		end;

		/* Round negative values */
		else if 0 > &var. > -100 then do;
			&var. = round(&var.,.1);
		end;
		else if &var. <= -100 then do;
			&var. = round(&var.,10);
		end;

		%let i=%eval(&i + 1);
				%end;
			%let i = 1;
				%do %until (%scan(&mlist,&i,' ')=);
					%let var=%scan(&mlist,&i,' ');
		%let i=%eval(&i + 1);
				%end;
	%mend round_moe;
	%round_moe;

run;

%mend round_output;
