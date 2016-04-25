scaler=1;

PARAMETER
output_%1_area(SOCECO,CLP,Smodel,REMF,AREA_SET,Y)
;

	output_%1_area(SOCECO,CLP,Smodel,REMF,AREA_SET,Y)=Parea_data(SOCECO,CLP,Smodel,REMF,"%1",AREA_SET,Y)*scaler;


file results_%1_area /%output_dir%\%1_area.txt/;
results_%1_area.pc=6;
put results_%1_Area;
loop((SOCECO,CLP,Smodel,REMF,AREA_SET,Y)$(output_%1_area(SOCECO,CLP,Smodel,REMF,AREA_SET,Y)),
     put SOCECO.tl,CLP.tl,Smodel.tl,REMF.tl,AREA_SET.tl,Y.tl,AREA_SET_ORD(AREA_SET), output_%1_area(SOCECO,CLP,Smodel,REMF,AREA_SET,Y):10:4/
);

