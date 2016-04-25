SET
Sr106	AIM106 rergions
Sf	Flow
Sp	Products
EMSC	emission source of EDGAR
Sr17(Sregion)/
$include ../prog/define/region17.set
/
SPOLL/
BC
CO
NOX
OC
SO2
VOC
NMVOC
CO2
/
Si_eco/TOT/
Sj_eco/DEF_PPP,VAD_M/
Su_dr Unit /1000P,USD,US2005D,HA,NON/
Ss_dr Statistics /ST_WPP08,ST_TSYI,ST_WB_PCS,ST_UNNA_agg,ST_WPP10_M,ST_FAO07,ST_wdi08/

;

$gdxin '../prog/data/Energy.gdx'
$load Sf,Sp,Sr106=Sr

$gdxin '../prog/data/EDGAR.gdx'
$load EMSC=Ss

ALIAS(Sr106,Sr106P);

SET
Map106_17(Sr106,Sregion)/
$include ../prog/define/region17.map
/
Map106_5(Sr106,Sregion)	106 to 5 region
EMSC_trf(EMSC)	Energy Transfformtaion/
        1A1a        Public electricity and heat production
        1A1bc        Other Energy Industries
/
EMSC_ene_ind(EMSC)/
        1A1a        Public electricity and heat production
        1A1bc        Other Energy Industries
        1A2        Manufacturing Industries and Construction
        1A3a        Domestic aviation
        1A3b        Road transportation
        1A3c        Rail transportation
        1A3d        Inland navigation
        1A3e        Other transportation
        1A4        Residential and other sectors
1B1
1B2
2A1
2A2
2A7
2G
         /

;

Map106_5(Sr106,Sregion)$(Map106_17(Sr106,Sregion))=YES;
Map106_5(Sr106,Sregion1)$(SUM(Sregion$(Map106_17(Sr106,Sregion) AND MAPR(Sregion,Sregion1)),1))=YES;
Map106_5(Sr106,"World")=YES;

PARAMETER
Energy(Sr106,Sy,Sf,Sp,*,*)
PDriver(Sr106,Sy,*,*,*,*)
Pedgar42(Sr106,SPOLL,EMSC,Sy)
Peconomy(Sr106,SY,Sj_eco,Si_eco,Su_dr,Ss_dr)
Pindicator_hist(Sr106,Sy,Svariable)	Histrorical data in 106 regions
Pintensity_hist(Sregion,Sy,Sinten,Sint_ind)	Historical intensity
Pintensity_hist_out(Sregion,Sinten,Sy_ciei,Sint_ind)	Historical intensity change rate
;


$gdxin '../prog/data/Energy.gdx'
$load Energy

$gdxin '../prog/data/Economy.gdx'
$load Peconomy

$gdxin '../prog/data/Driver.gdx'
$load Pdriver

$gdxin '../prog/data/EDGAR.gdx'
$load Pedgar42

Pindicator_hist(Sr106,Sy,"iiasadatabase_var0233")=Peconomy(Sr106,Sy,"VAD_M","TOT","US2005D","st_unna_agg")*Peconomy(Sr106,Sy,"DEF_PPP","TOT","NON","st_wdi08");
Pindicator_hist(Sr106,Sy,"iiasadatabase_var0273")=Energy(Sr106,Sy,"TPE","TOT","ktoe","ST_IEA");
Pindicator_hist(Sr106,Sy,"iiasadatabase_var0057")=SUM(EMSC_ene_ind(EMSC),Pedgar42(Sr106,"CO2",EMSC,Sy));
Pindicator_hist(Sr106,Sy,"iiasadatabase_var0153")=Energy(Sr106,Sy,"TFC","TOT","ktoe","ST_IEA");
Pindicator_hist(Sr106,Sy,"iiasadatabase_var0058")=SUM(EMSC$(EMSC_ene_ind(EMSC) AND NOT EMSC_trf(EMSC)),Pedgar42(Sr106,"CO2",EMSC,Sy));
Pindicator_hist(Sr106,Sy,"iiasadatabase_var0262")=PDriver(Sr106,Sy,"SOC_POP","CA_SOC_TPOP","1000P","ST_WPP10_M");


Pintensity_hist(Sregion,sy,"Energy_Intensity","TPE")$(SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0233")))=SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0273"))/SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0233"));
Pintensity_hist(Sregion,Sy,"Carbon_Intensity","TPE")$(SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0273")))=SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0057"))/SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0273"));
Pintensity_hist(Sregion,sy,"Energy_Intensity","TFC")$(SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0233")))=SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0153"))/SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0233"));
Pintensity_hist(Sregion,Sy,"Carbon_Intensity","TFC")$(SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0153")))=SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0058"))/SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0153"));

Pintensity_hist(Sregion,Sy,"GDP_cap","-")$(SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0262")))=SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0233"))/SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0262"));
*Pintensity_hist(Sregion,Sy,"GDP","-")=SUM(Sr106$(Map106_5(Sr106,Sregion)),Pindicator_hist(Sr106,Sy,"iiasadatabase_var0233"));

Pintensity_hist_out(Sregion,Sinten,"hist",Sint_ind)$(Pintensity_hist(Sregion,"1971",Sinten,Sint_ind) AND Pintensity_hist(Sregion,"2005",Sinten,Sint_ind))=
((Pintensity_hist(Sregion,"2005",Sinten,Sint_ind)/Pintensity_hist(Sregion,"1971",Sinten,Sint_ind))**(1/(2005-1971))-1)*100;

file results_EI_CI_hist /%output_dir%\hist_txt\EI_CI_hist.txt/;
results_EI_CI_hist.pc=6;
put results_EI_CI_hist;
loop((Sregion,Sy_ciei,Sinten,Sint_ind)$(Pintensity_hist_out(Sregion,Sinten,Sy_ciei,Sint_ind)),
     put Sregion.tl,Sinten.tl,Sy_ciei.tl,Sint_ind.tl, Pintensity_hist_out(Sregion,Sinten,Sy_ciei,Sint_ind):10:4/
);
