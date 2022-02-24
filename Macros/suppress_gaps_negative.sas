/**************************************************************************
 Program:  suppress_gaps_negative.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  09/12/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Suppresses racial gaps if inverse to equity indicator 
			   (e.g. for poverty, gaps should be negative to indicate reduction in poverty; 
			    gaps would be suppressed if values were positive)
			    
 Modifications: LH 02/24/22 Update for 6 race categories
**************************************************************************/

%macro suppress_gaps_negative;

		%do r=1 %to 6;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

			array p_gap&race. {7} 
				Gap25andOverWHS&race._&_years.
				Gap25andOverWSC&race._&_years.
				Gap16andOverEmploy&race._&_years.
				GapEmployed16to64&race._&_years.
				Gap16andOverWages&race._&_years.
				Gap16andOverWorkFT&race._&_years.
				GapOwnerOccupiedHU&race._&_years.
				;

		 	do p=1 to 7; 
						if p_gap&race.{p} < 0 then p_gap&race.{p} = .a; 

       		end;

			array n_gap&race. {7} 
				Gap25andOverWoutHS&race._&_years.
				GapFamilyLT75000&race._&_years.
				GapPoorPersons&race._&_years.
				GapPoorChildren&race._&_years.
				GapUnemployed&race._&_years.
				GapWorkFTLT35k&race._&_years.
				GapWorkFTLT75k&race._&_years.
				;

		 	do n=1 to 7; 
						if n_gap&race.{n} > 0 then n_gap&race.{n} = .a; 

			end;

			%end;
					

	%mend suppress_gaps_negative;

