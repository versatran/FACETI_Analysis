%make stacked variable
function [stack_index,stacked_numbers,stack_UID]=create_stacked_values(data,camera,...
    parameter_name,num_stacks,num_images)

%load the image UIDS
if strcmp(camera,'CMOS_WLAN')
    desired_UID = data.raw.images.(genvarname(camera)).UID-1;
else
    desired_UID = data.raw.images.(genvarname(camera)).UID;
end

%get the variable vector
[extract_id,extract_values]=nvn_extract_data(data,parameter_name);
unique_id=unique(extract_id);
if length(unique_id)~=length(extract_id)
    error('repetative UIDs exist in the sort dataset. Program terminated')        
end


%go down in stacks
for i=1:num_stacks
    walking_index=(i-1)*num_images+1:i*num_images;
    stack_desired_ID=desired_UID(walking_index);
    [UID_values,index_desired,index_parameter]=...
        intersect(stack_desired_ID,unique_id,'stable');
    stacked_numbers{i}=extract_values(index_parameter);
    stack_index{i}=walking_index(index_desired);
    stack_UID{i}=UID_values;
end