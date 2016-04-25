*Energy intensity and carbon intensity analysis
Pintensity(Smodel,Sscenario,Sregion,"Energy_Intensity",Sy,"TPE")$(Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0233","billion US$2005/yr",Sy) AND Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0273","EJ/yr",Sy))=Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0273","EJ/yr",Sy)/Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0233","billion US$2005/yr",Sy);
Pintensity(Smodel,Sscenario,Sregion,"Carbon_Intensity",Sy,"TPE")$(Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0273","EJ/yr",Sy) AND (Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0057","Mt CO2/yr",Sy)+Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0055","Mt CO2/yr",Sy)))=(Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0057","Mt CO2/yr",Sy)+Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0055","Mt CO2/yr",Sy))/Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0273","EJ/yr",Sy);
Pintensity(Smodel,Sscenario,Sregion,"Energy_Intensity",Sy,"TFC")$(Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0233","billion US$2005/yr",Sy) AND Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0153","EJ/yr",Sy))=Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0153","EJ/yr",Sy)/Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0233","billion US$2005/yr",Sy);
Pintensity(Smodel,Sscenario,Sregion,"Carbon_Intensity",Sy,"TFC")$(Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0153","EJ/yr",Sy) AND Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0058","Mt CO2/yr",Sy))=Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0058","Mt CO2/yr",Sy)/Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0153","EJ/yr",Sy);

Pintensity(Smodel,Sscenario,Sregion,"GDP_CAP",Sy,"-")$(Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0233","billion US$2005/yr",Sy) AND Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0262","million",Sy))=Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0233","billion US$2005/yr",Sy)/Pload(Smodel,Sscenario,Sregion,"iiasadatabase_var0262","million",Sy);

Pintensity_out(Smodel,Sscenario,Sregion,Sinten,"2005_2100",Sint_ind)$(Pintensity(Smodel,Sscenario,Sregion,Sinten,"2100",Sint_ind)>0 AND Pintensity(Smodel,Sscenario,Sregion,Sinten,"2005",Sint_ind)>0)=
((Pintensity(Smodel,Sscenario,Sregion,Sinten,"2100",Sint_ind)/Pintensity(Smodel,Sscenario,Sregion,Sinten,"2005",Sint_ind))**(1/(2100-2005))-1)*100;

Pintensity_out_data(SOCECO,CLP,MODEL_ren,Sregion,Sinten,Sy_ciei,Sint_ind)$(SUM((Smodel,Sscenario)$Scenariomap(Smodel,Sscenario,SOCECO,CLP,MODEL_ren),Pintensity_out(Smodel,Sscenario,Sregion,Sinten,Sy_ciei,Sint_ind)))
=SUM((Smodel,Sscenario)$Scenariomap(Smodel,Sscenario,SOCECO,CLP,MODEL_ren),Pintensity_out(Smodel,Sscenario,Sregion,Sinten,Sy_ciei,Sint_ind));

file results_EI_CI /%output_dir%\txt\EI_CI.txt/;
results_EI_CI.pc=6;
put results_EI_CI;
loop((SOCECO,CLP,MODEL_ren,Sregion,Sy_ciei,Sinten,Sint_ind)$(Pintensity_out_data(SOCECO,CLP,MODEL_ren,Sregion,"Energy_Intensity",Sy_ciei,Sint_ind) AND Pintensity_out_data(SOCECO,CLP,MODEL_ren,Sregion,"Carbon_Intensity",Sy_ciei,Sint_ind) AND Pintensity_out_data(SOCECO,CLP,MODEL_ren,Sregion,Sinten,Sy_ciei,Sint_ind)),
     put SOCECO.tl,CLP.tl,MODEL_ren.tl,Sregion.tl,Sinten.tl,Sy_ciei.tl,Sint_ind.tl, Pintensity_out_data(SOCECO,CLP,MODEL_ren,Sregion,Sinten,Sy_ciei,Sint_ind):10:4/
);
$exit
file results_CI /%output_dir%\txt\CI.txt/;
results_CI.pc=6;
put results_CI;
loop((SOCECO,CLP,MODEL_ren,Sregion,Sy_ciei)$(Pintensity_out_data(SOCECO,CLP,MODEL_ren,Sregion,"Carbon_Intensity",Sy_ciei)),
     put SOCECO.tl,CLP.tl,MODEL_ren.tl,Sregion.tl,Sy_ciei.tl, Pintensity_out_data(SOCECO,CLP,MODEL_ren,Sregion,"Carbon_Intensity",Sy_ciei):10:4/
);

file results_EI /%output_dir%\txt\EI.txt/;
results_EI.pc=6;
put results_EI;
loop((SOCECO,CLP,MODEL_ren,Sregion,Sy_ciei)$(Pintensity_out_data(SOCECO,CLP,MODEL_ren,Sregion,"Energy_Intensity",Sy_ciei)),
     put SOCECO.tl,CLP.tl,MODEL_ren.tl,Sregion.tl,Sy_ciei.tl, Pintensity_out_data(SOCECO,CLP,MODEL_ren,Sregion,"Energy_Intensity",Sy_ciei):10:4/
);
