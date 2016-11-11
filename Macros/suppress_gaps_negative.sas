/**************************************************************************
 Program:  suppress_gaps_negative.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/12/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Suppresses racial gaps if inverse to equity indicator 
			   (e.g. for poverty, gaps should be negative to indicate reduction in poverty; 
			    gaps would be suppressed if values were positive)
**************************************************************************/

%macro suppress_gaps_negative;

		%do r=1 %to 4;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

			array p_gap&race. {7} 
				Gap25andOverWHS&race._2010_14
				Gap25andOverWSC&race._2010_14
				Gap16andOverEmploy&race._2010_14
				GapEmployed16to64&race._2010_14
				Gap16andOverWages&race._2010_14
				Gap16andOverWorkFT&race._2010_14
				GapOwnerOccupiedHU&race._2010_14
				;

		 	do p=1 to 7; 
						if p_gap&race.{p} < 0 then p_gap&race.{p} = .a; 

       		end;

			array n_gap&race. {8} 
				Gap25andOverWoutHS&race._2010_14
				GapFamilyLT75000&race._2010_14
				GapPoorPersons&race._2010_14
				GapPoorChildren&race._2010_14
				GapUnemployed&race._2010_14
				Gap16andOverWorkFT&race._2010_14
				GapWorkFTLT35k&race._2010_14
				GapWorkFTLT75k&race._2010_14
				;

		 	do n=1 to 8; 
						if n_gap&race.{n} > 0 then n_gap&race.{n} = .a; 

			end;

			%end;
					

	%mend suppress_gaps_negative;

