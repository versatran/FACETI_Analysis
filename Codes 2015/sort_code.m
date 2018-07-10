% sort code bits

% %Sort images by some variable--> Set Dependent property below
% do_sort=0;

% % sort_parameter='excess_charge_USBPM1_DSBPM2';
% % sort_parameter='excess_charge_UStoro1_DStoro1';
% sort_parameter = 'pyro_int';


% if do_sort
%     switch sort_parameter
%         case 'excess_charge_USBPM1_DSBPM2'
%             sort_string='DSBPM2-USBPM1';
%         case 'excess_charge_UStoro1_DStoro1'
%             sort_string='DStoro1-UStoro1';
%         case 'pyro_int'
%             sort_string='pyro';
%         otherwise
%             error('have not written this part yet!')
%     end
%     outputFileName=[outputFileName '_' sort_string '_sorted'];
% end


%load sort information here
%Only images are sorted here. A specialized function will be written so
%that general sorting and cutting of various variables with respect to
%other variables could be implemented.
% if do_sort
% %     [sort_id,sort_values,overage]=nvn_extract_data_stacked(data,sort_parameter);
%     [sort_id,sort_values]=nvn_extract_data(data,sort_parameter);
%     %warning for higher sort than image data
%     if ~(length(sort_id)==num_images*num_stacks)
%         overage=length(sort_id)-num_images*num_stacks;
%         warning([num2str(overage) ' extra data is recorded in this dataset'])
%     end
% 
%     %TODO: deal with unique IDs better
%     unique_sort_id=unique(sort_id);
%     if length(unique_sort_id)~=length(sort_id)
%         error('repetative UIDs exist in the sort dataset. Program terminated')        
%     end
%     sort_values_image_matched=zeros(num_stacks,num_images);
% end


%this was a per image script
            if do_sort
                %Find UID for this image
                image_UID=image_struc.UID(curr_image);
                %find equivalent sort id. 
                curr_sort_uid=find(sort_id==image_UID);
                if length(curr_sort_uid)>1
                    error('too many matching IDs!')
                end
                % construct a sort_value matrix with imageUID. If sort_id
                %equivalent not found, set the value to -1.
                if ~isempty(curr_sort_uid)
                    sort_values_image_matched(i,j)=sort_values(curr_sort_uid);
                else
                    sort_values_image_matched(i,j)=-1;
                end
%                 text(.02*display_width+width_start,.1*display_height+height_start,[regexprep(sort_parameter,'_',' ') '='],'color','w','backgroundcolor','b');
                text(.02*display_width+width_start,.1*display_height+height_start,sort_string,'color','w','backgroundcolor','b');
                text(.02*display_width+width_start,.14*display_height+height_start,num2str(sort_values_image_matched(i,j),'%g'),'color','w','backgroundcolor','b');
            end
            
            
