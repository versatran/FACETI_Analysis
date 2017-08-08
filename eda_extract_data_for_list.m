%READ
%This function converts the parameter strings and replaces them with
%something more familiar. This conversion is used when showing the listdlg of
%parameters to select from when sorting. 
%Based on non_BSA_list.m, BSA_list.m definitions and nvn_extract_data.m
%If parameters from nvn_extract_data and BSA_list or non_BSA_list
%overlapped, nvn_extract_data definition was used
function [vector]= eda_extract_data_for_list(name)

%%%%Dictionary construction
prmtr_extrct_name = name;
assignin('base', 'prmtr_extrct_name', prmtr_extrct_name);
switch prmtr_extrct_name  
    %%%%%%%%%%%%
    % BSA LIST 
    %%%%%%%%%%%%
    
    case 'BPMS_LI20_2445_X'
        vector = 'US_BPM1_X';
    case 'BPMS_LI20_2445_Y'
        vector = 'US_BPM1_Y';
    case 'BPMS_LI20_2445_TMIT'
        vector = 'US_BPM1';
    case 'BPMS_LI20_3156_X'
        vector = 'US_BPM2_X';
    case 'BPMS_LI20_3156_Y'
        vector = 'US_BPM2_Y'; 
    case 'BPMS_LI20_3156_TMIT'
        vector = 'US_BPM2';       
    case 'BPMS_LI20_3265_X'
        vector = 'DS_BPM1_X';
    case 'BPMS_LI20_3265_Y'
        vector = 'DS_BPM1_Y';
    case 'BPMS_LI20_3265_TMIT'
        vector = 'DS_BPM1';
    case 'BPMS_LI20_3315_X'
        vector = 'DS_BPM2_X';
    case 'BPMS_LI20_3315_Y'
        vector = 'DS_BPM2_Y';
    case 'BPMS_LI20_3315_TMIT'
        vector = 'DS_BPM2';
    
    case 'PATT_SYS1_1_PULSEID'
        vector = 'BSA PulseID PV';
%Raw Toroids           
    case 'GADC0_LI20_EX01_AI_CH0_'
        vector = 'US_toro1_raw';
    case 'GADC0_LI20_EX01_AI_CH2_'
        vector = 'US_toro2_raw';
    case 'GADC0_LI20_EX01_AI_CH3_'
        vector = 'DS_toro1_raw';
%Calibrated Toros        
    case 'GADC0_LI20_EX01_CALC_CH0_'
        vector = 'US_toro1';
    case  'GADC0_LI20_EX01_CALC_CH2_'
        vector = 'US_toro2';
    case 'GADC0_LI20_EX01_CALC_CH3_'
        vector = 'DS_toro';
%Calculating integrated pyro signal        
    case 'BLEN_LI20_3014_BRAW'
        vector = 'pyro_int';
%Calculating integrated pyro signal
    case 'BLEN_LI20_3014_BIMAX'
        vector = 'pyro_peak';
    
    case 'PMTR_LA20_10_PWR'
        vector = 'LaserE';
    case 'TCAV_LI20_2400_P'
        vector = 'TCAV phase';
    case  'TCAV_LI20_2400_A'
        vector = 'TCAV amplitude';
    case 'IP330_LI20_EX01_CH01'
        vector = 'E201 energy pyro';
    case  'IP330_LI20_EX01_CH02'
        vector = 'E201 ref pyro';
    case 'IP330_LI20_EX01_CH03'
        vector = 'E201 signal pyro';
        
    %%%%%%%%%%%%%%    
    %Non BSA List
    %%%%%%%%%%%%%%
    case 'PATT_SYS1_1_PULSEIDBR'
        vector = 'Non BSA PulseID PV';
    case 'SIOC_SYS1_ML00_AO007'
        vector = 'Non BSA Pyro';
    case 'SIOC_SYS1_ML00_AO028'
        vector = 'Non BSA Pyro updating with spyro.m';
    case 'SIOC_SYS1_ML00_AO019'
        vector = 'Non BSA S02 Gap monitor';
        
    case 'DR12_PHAS_61_VDES'
        vector = 'Phase ramp set [deg]'; 
    case 'DR12_PHAS_61_VACT'
        vector = 'Phase ramp read back [deg]';       
    case 'DR13_AMPL_11_VDES'
        vector = 'Compressor amplitude set [deg]';
    case 'DR13_AMPL_11_VACT'
        vector = 'Compressor amplitude read back [deg]';
        
    case 'LI20_LGPS_3011_BDES'
        vector = 'QFF 1 [kG]';
    case 'LI20_LGPS_3031_BDES'
        vector = 'QFF 2 [kG]';
    case 'LI20_LGPS_3091_BDES'
        vector = 'QFF 4 [kG]';
    case 'LI20_LGPS_3141_BDES'
        vector = 'QFF 5 [kG]';
    case 'LI20_LGPS_3151_BDES'
        vector = 'QFF 6 [kG]';
    case 'LI20_LGPS_3261_BDES'
        vector = 'QS 1  [kG]';
    case 'LI20_LGPS_3311_BDES'
        vector = 'QS 2  [kG]';
    case 'LI20_LGPS_3330_BDES'
        vector = 'Spectromter dipole magnet [kG m]';
    
    case 'TCAV_LI20_2400_Q_ADJUST'
        vector = 'TCAV desired Q';
    case 'TCAV_LI20_2400_I_ADJUST'
        vector = 'TCAV desired I';
    case 'SIOC_SYS1_ML02_AO002'
        vector = '<-depreciated-> TCAV phase [deg]';
    case 'SIOC_SYS1_ML02_AO003'
        vector = '<-depreciated-> TCAV amplitude [a.u.]';
    case 'SIOC_SYS1_ML02_AO004'
        vector = '<-depreciated-> TCAV calculated power [MW]';
        
    case 'TCAV_LI20_2400_PDES'
        vector = 'TCAV desired phase [deg]';
    case 'TCAV_LI20_2400_ADES'
        vector = 'TCAV desired kick amp [MV]';
    case 'TCAV_LI20_2400_S_PV'
        vector = 'TCAV "slow" avg. phase [deg]';
    case 'TCAV_LI20_2400_S_AV'
        vector = 'TCAV "slow" avg. kick amp [MV]';
        
    case 'TCAV_LI20_2400_0_S_PACTUAL'
        vector = 'TCAV PAD: XTCAV In - Phase [deg]';
    case 'TCAV_LI20_2400_0_S_AACTUAL'
        vector = 'TCAV PAD: XTCAV In - Voltage [MV]';
    case 'TCAV_LI20_2400_0_S_WACTUAL'
        vector = 'TCAV PAD: XTCAV In - Power[MW]';
    case 'TCAV_LI20_2400_1_S_PACTUAL'
        vector = 'TCAV PAD: XTCAV Out - Phase [deg]';
    case 'TCAV_LI20_2400_1_S_AACTUAL'
        vector = 'TCAV PAD: XTCAV Out - Voltage [MV]';
    case 'TCAV_LI20_2400_1_S_WACTUAL'
        vector = 'TCAV PAD: XTCAV Out - Power[MW]';
    case 'TCAV_LI20_2400_2_S_PACTUAL'
        vector = 'TCAV PAD: Waveguide Ref - Phase [deg]';
    case 'TCAV_LI20_2400_2_S_AACTUAL'
        vector = 'TCAV PAD: Waveguide Ref - Voltage [MV]';
    case 'TCAV_LI20_2400_2_S_WACTUAL'
        vector = 'TCAV PAD: Waveguide Ref - Power[MW]';
    case 'TCAV_LI20_2400_3_S_PACTUAL'
        vector = 'TCAV PAD: X-Band Ref - Phase [deg]';
    case 'TCAV_LI20_2400_3_S_AACTUAL'
        vector = 'TCAV PAD: X-Band Ref - Voltage [MV]';
    case 'TCAV_LI20_2400_3_S_WACTUAL'
        vector = 'TCAV PAD: X-Band Ref - Power[MW]';
    case 'KLYS_LI20_K4_0_S_PACTUAL'
        vector = 'KLY PAD: PAC Out - Phase [deg]';
    case 'KLYS_LI20_K4_0_S_AACTUAL'
        vector = 'KLY PAD: PAC Out - Voltage [MV]';
    case 'KLYS_LI20_K4_0_S_WACTUAL'
        vector = 'KLY PAD: PAC Out - Power [MW]';
    case 'KLYS_LI20_K4_1_S_PACTUAL'
        vector = 'KLY PAD: Kly Drive - Phase [deg]';
    case 'KLYS_LI20_K4_1_S_AACTUAL'
        vector = 'KLY PAD: Kly Drive - Voltage [MV]';
    case 'KLYS_LI20_K4_1_S_WACTUAL'
        vector = 'KLY PAD: Kly Drive - Power [MW]';
    case 'KLYS_LI20_K4_2_S_SACTUAL'
        vector = 'KLY PAD: Kly Beam V - Voltage[MV]';
    case 'KLYS_LI20_K4_3_S_PACTUAL'
        vector = 'KLY PAD: Kly Fwd - Phase [deg]';
    case 'KLYS_LI20_K4_3_S_AACTUAL'
        vector = 'KLY PAD: Kly Fwd - Voltage [MV]';
    case 'KLYS_LI20_K4_3_S_WACTUAL'
        vector = 'KLY PAD: Kly Fwd - Power [MW]';
        
    case 'SIOC_SYS1_ML00_AO074'
        vector = 'S20 Energy relative to 20.35 GeV readback [MeV]';
    case 'SIOC_SYS1_ML00_AO079'
        vector = 'S20 Energy relative to 20.35 GeV setpoint [MeV]';
    case 'SIOC_SYS1_ML00_AO099'
        vector = 'EP01 ENGY.MKB knob value [deg]';
    case 'SIOC_SYS1_ML00_AO061'
        vector = 'EP01 Energy relative to 20.35 GeV setpoint [MeV]';
    case 'SIOC_SYS1_ML00_AO063'
        vector = 'EP01 Energy relative to 20.35 GeV readback [MeV]';
        
    case 'COLL_LI20_2070_MOTR'
        vector = 'Notch Jaw 2, Fine Y motion';
    case 'COLL_LI20_2071_MOTR'
        vector = 'Notch Jaw 3, X';
    case 'COLL_LI20_2072_MOTR'
        vector = 'Notch Jaw 4, Coarse Y motion';
    case 'COLL_LI20_2073_MOTR'
        vector = 'Notch Jaw 5, Rotation [deg]';
        
    case 'EVNT_SYS1_1_INJECTRATE'
        vector = 'Rate to Linac [Hz]';
    case 'EVNT_SYS1_1_SCAVRATE'
        vector = 'Rate to scav line [Hz]';
    case 'EVNT_SYS1_1_BEAMRATE'
        vector = 'Rate to FACET [Hz]';
        
    case 'YAGS_LI20_2434_MOTR'
        vector = 'YAG Position';
    case 'OTRS_LI20_3070_MOTR'
        vector = 'USTHz foil position';
    case 'OTRS_LI20_3075_MOTR'
        vector = 'DSTHz foil position';
    case 'OTRS_LI20_3158_MOTR'
        vector = 'USOTR foil position';
    case 'OTRS_LI20_3175_MOTR'
        vector = 'Spoiler Foil position';
    case 'OTRS_LI20_3180_MOTR'
        vector = 'IPOTR foil position';
    case 'OTRS_LI20_3206_MOTR'
        vector = 'DSOTR foil position';
    case 'OTRS_LI20_3202_MOTR'
        vector = 'IP2A foil position';
    case 'OTRS_LI20_3230_MOTR'
        vector = 'IP2B foil position';
        
    case 'OVEN_LI20_3185_TC1'
        vector = 'Oven Temp 1 [C]';
    case 'OVEN_LI20_3185_TC2'
        vector = 'Oven Temp 2 [C]';
    case 'OVEN_LI20_3185_TC3'
        vector = 'Oven Temp 3 [C]';
    case 'OVEN_LI20_3185_TC4'
        vector = 'Oven Temp 4 [C]';
    case 'OVEN_LI20_3185_TC5'
        vector = 'Oven Temp 5 [C]';
    case 'OVEN_LI20_3185_H2OTEMP1'
        vector = 'Water jacket temp [C]';
    case 'OVEN_LI20_3185_H2OTEMP2'
        vector = 'Water jacket temp [C]';
        
    case 'VGCM_LI20_M3201_PMONRAW'
        vector = 'CM Gauge [1000 Torr]';
    case 'VGCM_LI20_M3202_PMONRAW'
        vector = 'CM Gauge [100 Torr]';
        
    case 'OVEN_LI20_3185_MOTR'
        vector = 'Oven motor position'; 
        
% Sextupole movers- GUI must be run for these to update    
    case 'SIOC_SYS1_ML00_AO501'
        vector = 'SEXT 2165 X setpoint';
    case 'SIOC_SYS1_ML00_AO503'
        vector = 'SEXT 2165 X pot val';
    case 'SIOC_SYS1_ML00_AO506'
        vector = 'SEXT 2165 Y setpoint';
    case 'SIOC_SYS1_ML00_AO508'
        vector = 'SEXT 2165 Y pot val';
    case 'SIOC_SYS1_ML00_AO511'
        vector = 'SEXT 2165 Roll setpoint';
    case 'SIOC_SYS1_ML00_AO513'
        vector = 'SEXT 2165 Roll pot val';
    case 'SIOC_SYS1_ML00_AO516'
        vector = 'SEXT 2335 X setpoint';
    case 'SIOC_SYS1_ML00_AO518'
        vector = 'SEXT 2335 X pot val';
    case 'SIOC_SYS1_ML00_AO521'
        vector = 'SEXT 2335 Y setpoint';
    case 'SIOC_SYS1_ML00_AO523'
        vector = 'SEXT 2335 Y pot val';
    case 'SIOC_SYS1_ML00_AO526'
        vector = 'SEXT 2335 Roll setpoint';
    case 'SIOC_SYS1_ML00_AO528'
        vector = 'SEXT 2335 Roll pot val';
    case 'SIOC_SYS1_ML00_AO551'
        vector = 'SEXT 2145 X setpoint';
    case 'SIOC_SYS1_ML00_AO553'
        vector = 'SEXT 2145 X pot val';
    case 'SIOC_SYS1_ML00_AO556'
        vector = 'SEXT 2145 Y setpoint';
    case 'SIOC_SYS1_ML00_AO558'
        vector = 'SEXT 2145 Y pot val';
    case 'SIOC_SYS1_ML00_AO561'
        vector = 'SEXT 2145 Roll setpoint';
    case 'SIOC_SYS1_ML00_AO563'
        vector = 'SEXT 2145 Roll pot val';
    case 'SIOC_SYS1_ML00_AO566'
        vector = 'SEXT 2365 X setpoint';
    case 'SIOC_SYS1_ML00_AO568'
        vector = 'SEXT 2365 X pot val';
    case 'SIOC_SYS1_ML00_AO571'
        vector = 'SEXT 2365 Y setpoint';
    case 'SIOC_SYS1_ML00_AO573'
        vector = 'SEXT 2365 Y pot val';
    case 'SIOC_SYS1_ML00_AO576'
        vector = 'SEXT 2365 Roll setpoint';
    case 'SIOC_SYS1_ML00_AO578'
        vector = 'SEXT 2365 Roll pot val';
% Sextupole strengths   
    case 'LI20_LGPS_2145_BDES'
        vector = 'SXTS 2145 [kG/m?]';
    case 'LI20_LGPS_2165_BDES'
        vector = 'SXTS 2165 [kG/m?]';
    case 'LI20_LGPS_2195_BDES'
        vector = 'SXTS 2195 [kG/m?]';
    case 'LI20_LGPS_2275_BDES'
        vector = 'SXTS 2275 [kG/m?]';
    case 'LI20_LGPS_2335_BDES'
        vector = 'SXTS 2335 [kG/m?]';
    case 'LI20_LGPS_2365_BDES'
        vector = 'SXTS 2365 [kG/m?]'; 
        
% EPICS -> AIDA TORO calibration    
    case 'SIOC_SYS1_ML00_AO033'
        vector = 'GADC CH0 -> TORO 2452 Slope';
    case 'SIOC_SYS1_ML00_AO034'
        vector = 'GADC CH0 -> TORO 2452 Offset';
    case 'SIOC_SYS1_ML00_AO035'
        vector = 'GADC CH2 -> TORO 3163 Slope';
    case 'SIOC_SYS1_ML00_AO036'
        vector = 'GADC CH2 -> TORO 3163 Offset';
    case 'SIOC_SYS1_ML00_AO037'
        vector = 'GADC CH3 -> TORO 3255 Slope';
    case 'SIOC_SYS1_ML00_AO038'
        vector = 'GADC CH3 -> TORO 3255 Offset';
        
 %-------------------------------------------------------------------------%
% String PVs - can't do a combined lcaGet with string PVs and number PVs   
    case 'PROF_LI20_45_TGT_STS'
        vector = 'PMON IN/OUT';
    case 'OTRS_LI20_3070_TGT_STS'
        vector = 'USTHz foil IN/OUT';
    case 'IP445_LI20_EX01_Bo0'
        vector = 'USTHz splitter [High = out/Low = in]';
    case 'OTRS_LI20_3075_TGT_STS'
        vector = 'DSTHz foil IN/OUT';
    case 'OTRS_LI20_3158_TGT_STS'
        vector = 'USOTR foil IN/OUT';
    case 'OTRS_LI20_3206_TGT_STS'
        vector = ' DSOTR foil IN/OUT';
    case 'MIRR_LI20_3202_TGT_STS'
        vector = 'IP2A window IN/OUT';
    case 'OTRS_LI20_3208_TGT_STS'
        vector = 'Kraken foil IN/OUT';
    case 'MIRR_LI20_3230_TGT_STS'
        vector = 'IP2B window IN/OUT';
    case 'OVEN_LI20_3185_POSITIONSUM'
        vector = 'Oven IN/OUT';
    case 'VVFL_LI20_M3200_GAS_TYPE'
        vector = 'Gas type PV';
    case 'VVFL_LI20_M3201_GAS_TYPE'
        vector = 'Gas type PV';
        
        
    
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%Raw Toroids    
%     case 'US_toro1_raw'
%         uid_vector=scalar_struc.GADC0_LI20_EX01_AI_CH0_.UID;
%         prmtr_vector=scalar_struc.GADC0_LI20_EX01_AI_CH0_.dat;
%     case 'US_toro2_raw'
%         uid_vector=scalar_struc.GADC0_LI20_EX01_AI_CH2_.UID;
%         prmtr_vector=scalar_struc.GADC0_LI20_EX01_AI_CH2_.dat;
%     case 'DS_toro1_raw'
%         uid_vector=scalar_struc.GADC0_LI20_EX01_AI_CH3_.UID;
%         prmtr_vector=scalar_struc.GADC0_LI20_EX01_AI_CH3_.dat;
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%Calibrated BPMs
%     case 'US_BPM1'
%         uid_vector=scalar_struc.BPMS_LI20_2445_TMIT.UID;
% %         prmtr_vector=2e10*scalar_struc.BPMS_LI20_2445_TMIT.dat./US_BPM1_norm;
%         prmtr_vector=scalar_struc.BPMS_LI20_2445_TMIT.dat;
%     case 'US_BPM1_X'
%         uid_vector=scalar_struc.BPMS_LI20_2445_X.UID;
%         prmtr_vector=scalar_struc.BPMS_LI20_2445_X.dat;
%     case 'US_BPM1_Y'
%         uid_vector=scalar_struc.BPMS_LI20_2445_Y.UID;
%         prmtr_vector=scalar_struc.BPMS_LI20_2445_Y.dat;
%     case 'US_BPM2'
% %             US_BPM2=scalar_struc.BPMS_LI20_3156_TMIT.dat(range).*bpm_3156.tmit.slope...
% %                 +bpm_3156.tmit.offset;
%         uid_vector=scalar_struc.BPMS_LI20_3156_TMIT.UID;
% %         prmtr_vector=2e10*scalar_struc.BPMS_LI20_3156_TMIT.dat./US_BPM2_norm;
%         prmtr_vector=scalar_struc.BPMS_LI20_3156_TMIT.dat;
%     case 'DS_BPM1'
%         uid_vector=scalar_struc.BPMS_LI20_3265_TMIT.UID;
% %         prmtr_vector=2e10*scalar_struc.BPMS_LI20_3265_TMIT.dat./DS_BPM1_norm;
%         prmtr_vector=scalar_struc.BPMS_LI20_3265_TMIT.dat;
%     case 'DS_BPM2'
%         uid_vector=scalar_struc.BPMS_LI20_3315_TMIT.UID;
% %         prmtr_vector=2e10*scalar_struc.BPMS_LI20_3315_TMIT.dat./DS_BPM2_norm;
%         prmtr_vector=scalar_struc.BPMS_LI20_3315_TMIT.dat;
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%Calibrated toros
%     case 'US_toro1'
%         uid_vector=scalar_struc.GADC0_LI20_EX01_CALC_CH0_.UID;
% %         prmtr_vector=2e10*scalar_struc.GADC0_LI20_EX01_AI_CH0_.dat./US_toro1_norm;
%         prmtr_vector=scalar_struc.GADC0_LI20_EX01_CALC_CH0_.dat;
%     case 'US_toro2'
%         uid_vector=scalar_struc.GADC0_LI20_EX01_CALC_CH2_.UID;
%         prmtr_vector=scalar_struc.GADC0_LI20_EX01_CALC_CH2_.dat;
% %         prmtr_vector=2e10*scalar_struc.GADC0_LI20_EX01_AI_CH2_.dat./US_toro2_norm;
%     case 'DS_toro1'
%         uid_vector=scalar_struc.GADC0_LI20_EX01_CALC_CH3_.UID;
%         prmtr_vector=scalar_struc.GADC0_LI20_EX01_CALC_CH3_.dat;
% %         prmtr_vector=2e10*scalar_struc.GADC0_LI20_EX01_AI_CH0_.dat./US_toro1_norm;
% 
% %         prmtr_vector=2e10*scalar_struc.GADC0_LI20_EX01_AI_CH3_.dat./DS_toro1_norm;
% %         prmtr_vector=scalar_struc.GADC0_LI20_EX01_AI_CH3_.dat*toro_3255.slope+toro_3255.offset;
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%Calculating excess charge
%     case 'excess_charge_USBPM1_DSBPM2'
%         [US_BPM1_ID,US_BPM1_value]=nvn_extract_data(data_struc,'US_BPM1');            
%         [DS_BPM2_ID,DS_BPM2_value]=nvn_extract_data(data_struc,'DS_BPM2');
%         %UID Check
%         assert(sum(DS_BPM2_ID==US_BPM1_ID)==length(US_BPM1_ID))
%         uid_vector=US_BPM1_ID;
%         prmtr_vector=DS_BPM2_value-US_BPM1_value;        
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%Calculating excess charge toro_(US1,DS1)
%     case 'excess_charge_UStoro1_DStoro1'
%         [US_toro1_ID,US_toro1_value]=nvn_extract_data(data_struc,'US_toro1');            
%         [DS_toro1_ID,DS_toro1_value]=nvn_extract_data(data_struc,'DS_toro1');
%         %UID Check
%         assert(sum(DS_toro1_ID==US_toro1_ID)==length(US_toro1_ID))
%         uid_vector=US_toro1_ID;
%         prmtr_vector=DS_toro1_value-US_toro1_value;        
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%Calculating integrated pyro signal
%     case 'pyro_int'
%         uid_vector=scalar_struc.BLEN_LI20_3014_BRAW.UID;
%         prmtr_vector=scalar_struc.BLEN_LI20_3014_BRAW.dat;
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%Calculating integrated pyro signal
%     case 'pyro_peak'
%         uid_vector=scalar_struc.BLEN_LI20_3014_BIMAX.UID;
%         prmtr_vector=scalar_struc.BLEN_LI20_3014_BIMAX.dat;
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%Laser Energy
%     case 'LaserE'
%         uid_vector=scalar_struc.PMTR_LA20_10_PWR.UID;
%         prmtr_vector=scalar_struc.PMTR_LA20_10_PWR.dat;        
    otherwise
        vector = name;
end
