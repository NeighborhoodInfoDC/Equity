data city_ward;
	set equity.equity_profile_city
			equity.equity_profile_wd12;

			if city=1 then ward2012=0;

run; 

proc transpose data=city_ward out=race ; 
var PctAlone: NumFamilies: ;
id ward2012; 
run; 

data race2 (where=(category ~=.));
	set race;

black=index(_name_, "B_2010_14");
if black=0 then black=index(_name_,"B_m_2010_14");

white=index(_name_, "W_2010_14");
if white=0 then white=index(_name_,"W_m_2010_14");


hispanic=index(_name_, "H_2010_14");
if hispanic=0 then hispanic=index(_name_,"H_m_2010_14");

AIOM=index(_name_, "AIOM_2010_14");
if AIOM=0 then AIOM=index(_name_,"AIOM_m_2010_14");

if black > 0 then category=5;
if white > 0 then category=2;
if hispanic > 0 then category=4; 
if AIOM  > 0 then category=6; 

 if _name_ in("NumFamilies_2010_14") then category=1;

 *looks like there are some you'll have to fix individually;
 if _name_ ="NumFamiliesOwnChildrenFH_2010_14" then do; hispanic=0; category=.; end;


order=.;

*Add gap calculation - code forthcoming;

run;



  /*

  proc format;
  	value category
   	1= "Total"
  	2= "Non-Hispanic White"
    3= "Non-Hispanic All Other"
	4= "Hispanic"
	5= "Black Alone"
 	6= "Asian, American Indian, Other Alone and Multiple Race"
	7= "White Alone"
 	8= "Foreign Born";

