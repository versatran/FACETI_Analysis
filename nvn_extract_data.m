function [uid_vector,prmtr_vector]= nvn_extract_data(data_struc,prmtr_extrct_name)

% % Nate's EPICS -> AIDA TORO calibration

% BSA_list{end+1,1} = 'GADC0:LI20:EX01:AI:CH0:'; % TORO:LI:2452 
% BSA_list{end+1,1} = 'GADC0:LI20:EX01:AI:CH2:'; % TORO:LI:3163
% BSA_list{end+1,1} = 'GADC0:LI20:EX01:AI:CH3:'; % TORO:LI:3255
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO033';       % GADC CH0 -> TORO 2452 Slope
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO034';       % GADC CH0 -> TORO 2452 Offset
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO035';       % GADC CH2 -> TORO 3163 Slope
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO036';       % GADC CH2 -> TORO 3163 Offset
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO037';       % GADC CH3 -> TORO 3255 Slope
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO038';       % GADC CH3 -> TORO 3255 Offset
% 
% % Spencer's EPICS -> AIDA calibration
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO001';       % BPM 2445 X SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO002';       % BPM 2445 X OFFSET
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO003';       % BPM 2445 Y SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO004';       % BPM 2445 Y OFFSET
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO005';       % BPM 2445 TMIT SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO006';       % BPM 2445 TMIT OFFSET
% 
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO007';       % BPM 3156 X SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO008';       % BPM 3156 X OFFSET
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO009';       % BPM 3156 Y SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO010';       % BPM 3156 Y OFFSET
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO011';       % BPM 3156 TMIT SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO012';       % BPM 3156 TMIT OFFSET
% 
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO013';       % BPM 3265 X SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO014';       % BPM 3265 X OFFSET
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO015';       % BPM 3265 Y SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO016';       % BPM 3265 Y OFFSET
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO017';       % BPM 3265 TMIT SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO018';       % BPM 3265 TMIT OFFSET
% 
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO019';       % BPM 3315 X SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO020';       % BPM 3315 X OFFSET
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO021';       % BPM 3315 Y SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO022';       % BPM 3315 Y OFFSET
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO023';       % BPM 3315 TMIT SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO024';       % BPM 3315 TMIT OFFSET
% 
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO025';       % TORO 2452 TMIT SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO026';       % TORO 2452 TMIT OFFSET
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO027';       % TORO 3163 TMIT SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO028';       % TORO 3163 TMIT OFFSET
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO029';       % TORO 3255 TMIT SLOPE
% nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO030';       % TORO 3255 TMIT OFFSET

scalar_struc=data_struc.raw.scalars;
E200_state=data_struc.raw.metadata.E200_state;
%%%toros
% toro_2452.slope=E200_state.SIOC_SYS1_ML00_AO033.dat;
% toro_2452.offset=E200_state.SIOC_SYS1_ML00_AO034.dat;
% 
% toro_3255.slope=E200_state.SIOC_SYS1_ML00_AO037.dat;
% toro_3255.offset=E200_state.SIOC_SYS1_ML00_AO038.dat;
% %%%BPMs
% bpm_2445.tmit.slope = E200_state.SIOC_SYS1_ML01_AO005.dat;
% bpm_2445.tmit.offset = E200_state.SIOC_SYS1_ML01_AO006.dat;
% 
% bpm_3156.tmit.slope=E200_state.SIOC_SYS1_ML01_AO011.dat;
% bpm_3156.tmit.offset=E200_state.SIOC_SYS1_ML01_AO012.dat;
% 
% bpm_3265.tmit.slope=E200_state.SIOC_SYS1_ML01_AO017.dat;
% bpm_3265.tmit.offset=E200_state.SIOC_SYS1_ML01_AO018.dat;
% 
% bpm_3315.tmit.slope=E200_state.SIOC_SYS1_ML01_AO023.dat;
% bpm_3315.tmit.offset=E200_state.SIOC_SYS1_ML01_AO024.dat;

%These values are assumed to be normalized to 2.0e10 using the datasets
%12387-12389. See the July 2014 Logbook, page 3.
% US_BPM1_norm=1.9920e10;
% US_BPM2_norm=2.0036e10;
% DS_BPM1_norm=1.9911e10;
% DS_BPM2_norm=2.9538e10;
% 
% US_toro1_norm=199.76;
% US_toro2_norm=195.93;
% DS_toro1_norm=202.47;
%%%%Dictionary construction

switch prmtr_extrct_name        
    %%%Raw BPMs
    case 'US_BPM1_raw'
        uid_vector=scalar_struc.BPMS_LI20_2445_TMIT.UID;
        prmtr_vector=scalar_struc.BPMS_LI20_2445_TMIT.dat;
    case 'US_BPM2_raw'
        uid_vector=scalar_struc.BPMS_LI20_3156_TMIT.UID;
        prmtr_vector=scalar_struc.BPMS_LI20_3156_TMIT.dat;
    case 'DS_BPM1_raw'
        uid_vector=scalar_struc.BPMS_LI20_3265_TMIT.UID;
        prmtr_vector=scalar_struc.BPMS_LI20_3265_TMIT.dat;
    case 'DS_BPM2_raw'
        uid_vector=scalar_struc.BPMS_LI20_3315_TMIT.UID;
        prmtr_vector=scalar_struc.BPMS_LI20_3315_TMIT.dat;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Raw Toroids    
    case 'US_toro1_raw'
        uid_vector=scalar_struc.GADC0_LI20_EX01_AI_CH0_.UID;
        prmtr_vector=scalar_struc.GADC0_LI20_EX01_AI_CH0_.dat;
    case 'US_toro2_raw'
        uid_vector=scalar_struc.GADC0_LI20_EX01_AI_CH2_.UID;
        prmtr_vector=scalar_struc.GADC0_LI20_EX01_AI_CH2_.dat;
    case 'DS_toro1_raw'
        uid_vector=scalar_struc.GADC0_LI20_EX01_AI_CH3_.UID;
        prmtr_vector=scalar_struc.GADC0_LI20_EX01_AI_CH3_.dat;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Calibrated BPMs
    case 'US_BPM1'
        uid_vector=scalar_struc.BPMS_LI20_2445_TMIT.UID;
%         prmtr_vector=2e10*scalar_struc.BPMS_LI20_2445_TMIT.dat./US_BPM1_norm;
        prmtr_vector=scalar_struc.BPMS_LI20_2445_TMIT.dat;
    case 'US_BPM1_X'
        uid_vector=scalar_struc.BPMS_LI20_2445_X.UID;
        prmtr_vector=scalar_struc.BPMS_LI20_2445_X.dat;
    case 'US_BPM1_Y'
        uid_vector=scalar_struc.BPMS_LI20_2445_Y.UID;
        prmtr_vector=scalar_struc.BPMS_LI20_2445_Y.dat;
    case 'US_BPM2'
%             US_BPM2=scalar_struc.BPMS_LI20_3156_TMIT.dat(range).*bpm_3156.tmit.slope...
%                 +bpm_3156.tmit.offset;
        uid_vector=scalar_struc.BPMS_LI20_3156_TMIT.UID;
%         prmtr_vector=2e10*scalar_struc.BPMS_LI20_3156_TMIT.dat./US_BPM2_norm;
        prmtr_vector=scalar_struc.BPMS_LI20_3156_TMIT.dat;
    case 'DS_BPM1'
        uid_vector=scalar_struc.BPMS_LI20_3265_TMIT.UID;
%         prmtr_vector=2e10*scalar_struc.BPMS_LI20_3265_TMIT.dat./DS_BPM1_norm;
        prmtr_vector=scalar_struc.BPMS_LI20_3265_TMIT.dat;
    case 'DS_BPM2'
        uid_vector=scalar_struc.BPMS_LI20_3315_TMIT.UID;
%         prmtr_vector=2e10*scalar_struc.BPMS_LI20_3315_TMIT.dat./DS_BPM2_norm;
        prmtr_vector=scalar_struc.BPMS_LI20_3315_TMIT.dat;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Calibrated toros
    case 'US_toro1'
        uid_vector=scalar_struc.GADC0_LI20_EX01_CALC_CH0_.UID;
%         prmtr_vector=2e10*scalar_struc.GADC0_LI20_EX01_AI_CH0_.dat./US_toro1_norm;
        prmtr_vector=scalar_struc.GADC0_LI20_EX01_CALC_CH0_.dat;
    case 'US_toro2'
        uid_vector=scalar_struc.GADC0_LI20_EX01_CALC_CH2_.UID;
        prmtr_vector=scalar_struc.GADC0_LI20_EX01_CALC_CH2_.dat;
%         prmtr_vector=2e10*scalar_struc.GADC0_LI20_EX01_AI_CH2_.dat./US_toro2_norm;
    case 'DS_toro'
        uid_vector=scalar_struc.GADC0_LI20_EX01_CALC_CH3_.UID;
        prmtr_vector=scalar_struc.GADC0_LI20_EX01_CALC_CH3_.dat;
%         prmtr_vector=2e10*scalar_struc.GADC0_LI20_EX01_AI_CH0_.dat./US_toro1_norm;

%         prmtr_vector=2e10*scalar_struc.GADC0_LI20_EX01_AI_CH3_.dat./DS_toro1_norm;
%         prmtr_vector=scalar_struc.GADC0_LI20_EX01_AI_CH3_.dat*toro_3255.slope+toro_3255.offset;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Calculating excess charge
    case 'excess_charge_USBPM1_DSBPM2'
        [US_BPM1_ID,US_BPM1_value]=nvn_extract_data(data_struc,'US_BPM1');            
        [DS_BPM2_ID,DS_BPM2_value]=nvn_extract_data(data_struc,'DS_BPM2');
        %UID Check
        assert(sum(DS_BPM2_ID==US_BPM1_ID)==length(US_BPM1_ID))
        uid_vector=US_BPM1_ID;
        prmtr_vector=DS_BPM2_value-US_BPM1_value;        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Calculating excess charge toro:(US1,DS1)
    case 'excess_charge_UStoro1_DStoro1'
        [US_toro1_ID,US_toro1_value]=nvn_extract_data(data_struc,'US_toro1');            
        [DS_toro1_ID,DS_toro1_value]=nvn_extract_data(data_struc,'DS_toro1');
        %UID Check
        assert(sum(DS_toro1_ID==US_toro1_ID)==length(US_toro1_ID))
        uid_vector=US_toro1_ID;
        prmtr_vector=DS_toro1_value-US_toro1_value;        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Calculating integrated pyro signal
    case 'pyro_int'
        uid_vector=scalar_struc.BLEN_LI20_3014_BRAW.UID;
        prmtr_vector=scalar_struc.BLEN_LI20_3014_BRAW.dat;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Calculating integrated pyro signal
    case 'pyro_peak'
        uid_vector=scalar_struc.BLEN_LI20_3014_BIMAX.UID;
        prmtr_vector=scalar_struc.BLEN_LI20_3014_BIMAX.dat;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Laser Energy
    case 'LaserE'
        uid_vector=scalar_struc.PMTR_LA20_10_PWR.UID;
        prmtr_vector=scalar_struc.PMTR_LA20_10_PWR.dat;        
    otherwise
        error('parameter is unknown')
end