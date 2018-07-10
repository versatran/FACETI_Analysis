% sort_by_acquired_data
% This function takes in a 3D or more vector, e.g.
% lineout(num_stack,num_images,rows,columns) and sorts them by aquired data
% such as BPMs, or Toroids, which are 2D vectors with dimentions
% num_stack x num_images
function [sorted_UID,sorting_values,sorted_vector] = sort_processed_by_acquired_data(data,want_sorted,sort_parameter)
%load the processed structures 
processed_fields=fieldnames(data.processed.vectors);

%%
%Make the sort vector
[sort_id,sort_values]=nvn_extract_data(data,sort_parameter);
unique_sort_id=unique(sort_id);
if length(unique_sort_id)~=length(sort_id)
    error('repetative UIDs exist in the sort dataset. Program terminated')        
end

[Y1,I1]=sort(sort_values);        
sorted_UID=sort_id(I1);
%%
%Sort the lineouts
%j will be looping over the stack numbers

wanted_sort_structure=find_exact_string(processed_fields,want_sorted);
%get what user wants sorted    
if findstr(wanted_sort_structure,'lineout')>0
    variable_to_sort='lineout';
elseif findstr(wanted_sort_structure,'special_shots')>0
    variable_to_sort='special_indecies';
else
    error('don''t know what you want sorted!')
end
initial_vector=data.processed.vectors.(genvarname(wanted_sort_structure)).(genvarname(variable_to_sort));
initial_UID=data.processed.vectors.(genvarname(wanted_sort_structure)).UID;
[num_stacks,num_images,lineout_length]=size(initial_vector);

for j=1:num_stacks
    %     sorted_vector=initial_vector(I1);
    %this command finds the initial UID that intersects with sorted_ID
    %while keeping the order of sorted_UID intact (using the 'stable' flag)
    [UID_values,index_sorted_UID,index_initial_UID_matched]=intersect(sorted_UID,initial_UID,'stable');
    sorted_vector=initial_vector(j,index_initial_UID_matched,:);
    sorted_UID=sorted_UID(index_sorted_UID);
    sorting_values=Y1(index_sorted_UID);
%     figure(1)
%     imagesc(squeeze(sorted_vector)')
end
