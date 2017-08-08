%READ
%*This code is based on energy_limits.m, but this is called in a GUI framework. 
%Cannot run on its own
%must need saveLineouts to run beforehand.
%linearization produces correct energy gain/loss values 
%energy_limits
%Finds the energy limits and saves the values

clear all
% clearvars -except E200_vector ii
%close all

%Get user to specify the dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BEGIN USER INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
camera=getappdata(0, 'camera'); 
save_data=getappdata(0, 'save_data');
initial_energy=20.35;

% set path to data
% source_dir='/Volumes/LaCie 1/FACET_data/2014/';
source_dir=getappdata(0,'source_dir');
server_str=getappdata(0,'server_str');
expt_str=getappdata(0,'expt_str');
date_str=getappdata(0,'date_str');
dataset_str=getappdata(0,'dataset_str');
linearize = getappdata(0, 'linearize');
%set to zero only if /nas is in the pwd
remote=getappdata(0, 'remote');

bottom_cutoff=0.02;
top_cutoff=0.02;
diagnostic=0;

save_override=getappdata(0,'save_override');
%this parameter is necessary if there is a floor of noise that needs to be
%subtracted
% designated_floor=3.5e5; %used for 14614
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%END USER INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Load dataset
% load data
data = getappdata(0, 'data');
% Get prefix - if not remote, there is no prefix.
if remote
    prefix=get_remoteprefix();
else
    prefix='';
end

%check that the prefix is actually right! if it isn't, fix it! 
if ~strcmp(prefix,source_dir(1:end-1))
    setpref('FACET_data','prefix',source_dir(1:end-1));
    prefix=get_remoteprefix();
end

% data.processed.vectors = rmfield(data.processed.vectors, 'CMOS_FAR_lineouts_300_550');
% data.processed.vectors = rmfield(data.processed.vectors, 'CMOS_FAR_lineouts_150_350_linearized');
%look for a lineout structure.
processed_fields=fieldnames(data.processed.vectors);
match=[];

% for i=1:length(processed_fields)
%     if strfind(processed_fields{i},[camera '_lineouts'])>0
%         match=[match i];
%     end
% end
% %If more than one lineout structure is found, ask user which to use. Show
% %the example image for each of them 
% if length(match)>1
%     error('this part is not written yet!')
% end

lineout_struc=data.processed.vectors.(getappdata(0, 'save_struc_str'));
% lineout=lineout_struc.lineout-designated_floor;
%lineout = lineout_struc.lineout;
%remove negative numbers
% if designated_floor>0
%     lineout(lineout<0)=0;
% end
lineout = getappdata(0, 'lineout');
[num_stacks,num_images,lineout_length]=size(lineout);
if linearize
    energy_vector=data.processed.vectors.(getappdata(0, 'save_struc_str')).linear_energy_vector;
else
    energy_vector=data.processed.vectors.(getappdata(0, 'save_struc_str')).energy_vector;
end
%There will be num_stacks x num_images values for each energy gain, loss
%pixel and energy 

start_pixel_top=zeros(num_stacks,num_images);
start_pixel_bottom=zeros(num_stacks,num_images);
start_energy_top=zeros(num_stacks,num_images);
start_energy_bottom=zeros(num_stacks,num_images);


%Find the top and bottom energy range
%top_charge_fraction=zeros(1,ROI_region(3));
%bottom_charge_fraction=zeros(1,ROI_region(3));
for i=1:num_stacks
    for j=1:num_images
        image_integral=sum(lineout(i,j,:));
        top_reached =0;
        bottom_reached=0;
        for k=1:lineout_length
            top_image_integral=sum(lineout(i,j,1:k));
            bottom_image_integral=sum(lineout(i,j,lineout_length-k+1:lineout_length));
            top_charge_fraction=top_image_integral/image_integral;
            bottom_charge_fraction=bottom_image_integral/image_integral;
            if (top_charge_fraction > top_cutoff)&&(~top_reached)
                start_pixel_top(i,j)=k;
                start_energy_top(i,j)=energy_vector(k);
                top_reached=1;
            end
            if (bottom_charge_fraction > bottom_cutoff)&&(~bottom_reached)
                start_pixel_bottom(i,j)=lineout_length-k;
                start_energy_bottom(i,j)=energy_vector(lineout_length-k);
                bottom_reached=1;
            end
            if (~diagnostic) && (bottom_reached) && (top_reached)
                break;
            end            
        end
        if diagnostic
            %need to rewrite this
            figure
            imagesc(ROI_region(1):ROI_region(1)+ROI_region(3),energy_linear,linearized_image)
            colorbar
            hold
            line=linspace(ROI_region(1),ROI_region(1)+ROI_region(3),200);
            plot(line,start_energy_top(j),'w')
            plot(line,start_energy_bottom(j),'w')
            xlabel('Pixels','fontsize',15)
            ylabel('Energy (GeV)','fontsize',15)
            title(strcat('Linearized image #',num2str(j),'for shot ',num2str(file_number(i))),'fontsize',15)
            set(gcf,'position',plot_location2)
            a=get(gcf,'currentaxes');
            set(a,'fontsize',15);
            hold
            
            figure
            plot(energy_linear,top_charge_fraction)
            grid
            xlabel('Energy (Gev)','fontsize',15)
            ylabel('Charge fraction','fontsize',15)
            title('Charge fraction counting from the lowest energy','fontsize',15)
            set(gcf,'position',plot_location1)
            a=get(gcf,'currentaxes');
            set(a,'fontsize',15);

            figure
            plot(fliplr(energy_linear),bottom_charge_fraction)
            grid
            xlabel('Energy (GeV)','fontsize',15)
            ylabel('Charge fraction','fontsize',15)
            title('Charge fraction counting from the highest energy','fontsize',15)
            %set(gcf,'position',plot_location2)
            a=get(gcf,'currentaxes');
            set(a,'fontsize',15);
            waitforbuttonpress;
%             close all
        end
    end
end

lineout = getappdata(0, 'lineout');

%calculate energy gain/loss
energy_gain = start_energy_top-initial_energy;
energy_loss = initial_energy-start_energy_bottom;
%reshape vectors to be 1D for plotting multiple stacks
energy_loss = reshape(energy_loss, [1, num_images*num_stacks]);
energy_gain = reshape(energy_gain, [1, num_images*num_stacks]);
start_energy_top = reshape(start_energy_top, [1, num_images*num_stacks]);
start_energy_bottom = reshape(start_energy_bottom, [1, num_images*num_stacks]);

setappdata(0, 'start_energy_top',start_energy_top);
setappdata(0, 'start_energy_bottom',start_energy_bottom);

setappdata(0, 'energy_loss',energy_loss);
setappdata(0, 'energy_gain', energy_gain);
transformer_ratio=(start_energy_top-initial_energy)./(initial_energy-start_energy_bottom);
linear_energy_scale = getappdata(0 ,'linear_energy_scale');
figure('Name', getappdata(0, 'save_struc_str'));
% imagesc(squeeze(lineout(end,:,:))')
% lineout = data.processed.vectors.(getappdata(0, 'save_struc_str')).lineout;
lineout = reshape(lineout, [1,num_stacks*num_images, lineout_length]);
 imagesc(squeeze(lineout(end,:,:))')
% imagesc(linear_energy_scale, linspace(0,num_images*num_stacks,10), squeeze(lineout(end,:,:))')
sebas_colors=sebasColorTable;
colormap(sebas_colors);
%figure('Name', getappdata(0, 'save_struc_str'));
hold on
if (num_stacks>1)
    start_pixel_bottom = reshape(start_pixel_bottom, [1,num_images*num_stacks]);
    start_pixel_top = reshape(start_pixel_top, [1,num_images*num_stacks]);
    setappdata(0, 'start_pixel_top',start_pixel_top);
    setappdata(0, 'start_pixel_bottom',start_pixel_bottom);

end
plot(1:num_images*num_stacks,start_pixel_bottom(1,:),'k')
plot(1:num_images*num_stacks,start_pixel_top(1,:),'k')
hold off

if save_data
    save_struc_str = strrep((getappdata(0, 'save_struc_str')),'lineouts','energy_limits');
    
    process_struc.bottom_cutoff=bottom_cutoff;
    process_struc.top_cutoff=top_cutoff;
    process_struc.start_pixel_top=start_pixel_top;
    process_struc.start_pixel_bottom=start_pixel_bottom;
    process_struc.start_energy_top=start_energy_top;
    process_struc.start_energy_bottom=start_energy_bottom;
    process_struc.transformer_ratio=transformer_ratio;
    process_struc.energy_loss = energy_loss;
    process_struc.energy_gain = energy_gain;
   % process_struc.designated_floor=designated_floor;
    process_struc.parent_data=(getappdata(0, 'save_struc_str'));
    process_struc.date=date;
    process_struc.UID=lineout_struc.UID;
    %TODO: modify for linearized energy scale
    
    data.processed.vectors.(genvarname(save_struc_str))=process_struc;
    E200_save_remote(data,save_override)
    setappdata(0, 'data', data)
    setappdata(0, 'save_struc_str', save_struc_str);
    display('Data saved!') 
end
        
%Save as an energy structure called energy limits, e.g.
%CMOS_FAR_energy_limits_53_420
