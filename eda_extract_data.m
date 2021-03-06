%READ
%This function takes in the data, parameter name, and the index of the
%parameter in the list of parameters located in data.raw.scalars
%Because the location of the paramaeter is the same in the listdlg of converted parameter names 
%and the original names in data.raw.scalars, this number is used to extract
%the dat/UID files for that parameter. 

%Some exceptions are made to this way of extraction,(excess_charge etc.),
%because these are calculated(not raw) parameters

%This function is based on nvn_extract_data

function [uid_vector,prmtr_vector]= eda_extract_data(data_struc,prmtr_extrct_name,index_sort_parameter)

scalar_struc = data_struc.raw.scalars;
user_struc = data_struc.user;
switch prmtr_extrct_name
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Calculating excess charge
    case 'excess_charge_USBPM1_DSBPM1'
        [US_BPM1_ID,US_BPM1_value]=nvn_extract_data(data_struc,'US_BPM1');            
        [DS_BPM1_ID,DS_BPM1_value]=nvn_extract_data(data_struc,'DS_BPM1');
        %UID Check
        assert(sum(DS_BPM1_ID==US_BPM1_ID)==length(US_BPM1_ID))
        uid_vector=US_BPM1_ID;
       %prmtr_vector=DS_BPM1_value-US_BPM1_value + 3e+09; 
        prmtr_vector=DS_BPM1_value-US_BPM1_value;
    case 'excess_charge_USBPM1_DSBPM2'
        [US_BPM1_ID,US_BPM1_value]=nvn_extract_data(data_struc,'US_BPM1');            
        [DS_BPM2_ID,DS_BPM2_value]=nvn_extract_data(data_struc,'DS_BPM2');
        %UID Check
        assert(sum(DS_BPM2_ID==US_BPM1_ID)==length(US_BPM1_ID))
        uid_vector=US_BPM1_ID;
   %    prmtr_vector=DS_BPM2_value - US_BPM1_value + 6e+09; 
        prmtr_vector=DS_BPM2_value - US_BPM1_value; 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Calculating excess charge toro:(US1,DS1)
    case 'excess_charge_UStoro1_DStoro1'
        [US_toro1_ID,US_toro1_value]=nvn_extract_data(data_struc,'US_toro1');            
        [DS_toro1_ID,DS_toro1_value]=nvn_extract_data(data_struc,'DS_toro1');
        %UID Check
        assert(sum(DS_toro1_ID==US_toro1_ID)==length(US_toro1_ID))
        uid_vector=US_toro1_ID;
        prmtr_vector=DS_toro1_value-US_toro1_value; 
    otherwise
        if isfield(user_struc, 'Machine')
            if isfield(user_struc.Machine, prmtr_extrct_name)
                scalars=fieldnames(user_struc.Machine);
                index_sort_parameter = index_sort_parameter - numel(fieldnames(data_struc.raw.scalars)) - 3;
            end
        else
            %extract data method for rest of parameters
            scalars=fieldnames(data_struc.raw.scalars);
        end
        prmtr_cell = scalars(index_sort_parameter);
        prmtr_str = prmtr_cell{1};
        if isfield(user_struc, 'Machine')
            if isfield(user_struc.Machine, prmtr_extrct_name)
                uid_vector=user_struc.Machine.(prmtr_str).UIDs;
                prmtr_vector=user_struc.Machine.(prmtr_str).VALs;
            end
        else
            uid_vector=scalar_struc.(prmtr_str).UID;
            prmtr_vector=scalar_struc.(prmtr_str).dat;
        end
end