scaler=1;

PARAMETER
output_%1(SOCECO,CLP,Smodel,REMF,Y)
;

	output_%1(SOCECO,CLP,Smodel,REMF,Y)=Pedited_data(SOCECO,CLP,Smodel,REMF,"%1",Y)*scaler;


file results_%1 /%output_dir%\%1.txt/;
results_%1.pc=6;
put results_%1;
loop((SOCECO,CLP,Smodel,REMF,Y)$(output_%1(SOCECO,CLP,Smodel,REMF,Y)),
     put SOCECO.tl,CLP.tl,Smodel.tl,REMF.tl,Y.tl, output_%1(SOCECO,CLP,Smodel,REMF,Y):10:4/
);

