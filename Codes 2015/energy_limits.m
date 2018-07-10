%energy_limits
%Finds the energy limits and saves the values

clear all
% clearvars -except E200_vector ii
close all

%Get user to specify the dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BEGIN USER INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
camera='CMOS_FAR'; 
save_data=1;
initial_energy=20.35;

% set path to data
% source_dir='/Volumes/LaCie 1/FACET_data/2014/';
source_dir='/Volumes/LaCie1/FACET_data/2015/';
% source_dir='/';
server_str='nas/nas-li20-pm00/';
% expt_str='E217';
expt_str='E200';

date_str='20150228';

dataset_str='14614';

%set to zero only if /nas is in the pwd
remote=1;


bottom_cutoff=0.02;
top_cutoff=0.02;
diagnostic=0;


save_override=1;
%this parameter is necessary if there is a floor of noise that needs to be
%subtracted
designated_floor=3.5e5; %used for 14614
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%END USER INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Load dataset
data_path=[source_dir server_str expt_str '/' date_str(1:4) '/' date_str '/' ...
    expt_str '_' dataset_str '/' expt_str '_' dataset_str '.mat'];

% load data
data=E200_load_data(data_path,expt_str);
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


%look for a lineout structure.
processed_fields=fieldnames(data.processed.vectors);
match=[];

for i=1:length(processed_fields)
    if findstr(processed_fields{i},[camera '_lineouts'])>0
        match=[match i];
    end
end
%If more than one lineout structure is found, ask user which to use. Show
%the example image for each of them 
if length(match)>1
    error('this part is not written yet!')
end

lineout_struc=data.processed.vectors.(genvarname(processed_fields{match}));
lineout=lineout_struc.lineout-designated_floor;
%remove negative numbers
if designated_floor>0
    lineout(lineout<0)=0;
end
[num_stacks,num_images,lineout_length]=size(lineout);

energy_vector=data.processed.vectors.(genvarname(processed_fields{match})).energy_vector;

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
            close all
        end
    end
end
transformer_ratio=(start_energy_top-initial_energy)./(initial_energy-start_energy_bottom);

figure(5)
imagesc(squeeze(lineout(end,:,:))')
sebas_colors=sebasColorTable;
colormap(sebas_colors)
hold on
plot(1:num_images,start_pixel_bottom(end,:),'k')
plot(1:num_images,start_pixel_top(end,:),'k')
hold off

if save_data
    save_struc_str = strrep(processed_fields{match},'lineouts','energy_limits');
    
    process_struc.bottom_cutoff=bottom_cutoff;
    process_struc.top_cutoff=top_cutoff;
    process_struc.start_pixel_top=start_pixel_top;
    process_struc.start_pixel_bottom=start_pixel_bottom;
    process_struc.start_energy_top=start_energy_top;
    process_struc.start_energy_bottom=start_energy_bottom;
    process_struc.transformer_ratio=transformer_ratio;
    process_struc.designated_floor=designated_floor;
    process_struc.parent_data=processed_fields{match};
    process_struc.date=date;
    process_struc.UID=lineout_struc.UID;
    %TODO: modify for linearized energy scale
    
    data.processed.vectors.(genvarname(save_struc_str))=process_struc;
    E200_save_remote(data,save_override)
    display('Data saved!') 
end
        
%Save as an energy structure called energy limits, e.g.
%CMOS_FAR_energy_limits_53_420

