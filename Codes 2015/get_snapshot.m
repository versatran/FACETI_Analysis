%single snapshot
function snapshot_image=get_snapshot(expt_str,date_str,dataset_str,camera)


close all

sebas_colors=sebasColorTable;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BEGIN USER INPUT
%See comment_repo_im_proc for other options.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set data path 
source_dir='/Volumes/LaCie1/FACET_data/2015/';
server_str='nas/nas-li20-pm00/';
%set to zero only if /nas is in the pwd
remote=1; 

outputdir=['/Users/Navid/Library/Mobile Documents/com~apple~CloudDocs/Lab Work/' date_str(1:4) ' FACET Analysis/'];

        
%default subplot column number
subplot_columns=20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Visualization properties
%see comment_repo_im_proc for other options.

skip_background_verification=0;

linearize=0;
%Do you want to run the remove_xray script
remove_xrays=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set camera properties

%NOTE: NOISE on every camera needs to be checked.
%Note: Verifying the zero GeV_pixel is up to the user
switch camera
    case 'CMOS_FAR'
%         zero_Gev_px=890; %For Apr 6
%         zero_Gev_px=902; %For Apr 6, 1232* series        
%         zero_Gev_px=149; %For Apr 6, QSBend -16
%         zero_Gev_px=241; %For Apr 6, QSBend -14
%         zero_Gev_px=365; %For Apr 6, QSBend -12
%         zero_Gev_px=434; %For Apr 6, QSBend -10
%         zero_Gev_px=530; %For Apr 6, QSBend -8
%         zero_Gev_px=414; %For Apr 6 half bend
%         zero_Gev_px=979; %for May 26+
%         zero_Gev_px=983; %for June 1, 13123
%         zero_Gev_px=965; %for June 25, 13123
        zero_Gev_px=935; %for Feb 2015
        %dipole_bend is the bend of the dipole compared to normal. Normal 
        %bend is defined as 1. half bend is 0.5, etc
%         dipole_bend=0.5; %for data between 12414 and 12422
        dipole_bend=1;
%         dipole_bend=(20.35-14)/20.35;
        energy_camera=1;
        y_label_text='Enegy (GeV)';
        rotate_image=1;
        rotate_noise=0;
    case 'CMOS_NEAR'
        zero_Gev_px=965; %for June 25, 13123
        dipole_bend=1;
        energy_camera=1;
        y_label_text='Enegy (GeV)';        
        rotate_noise=0;
    case 'ELANEX'
        energy_camera=0;
        y_label_text='Enegy (GeV)'; 
        rotate_noise=0;
    case 'CMOS_WLAN'
        energy_camera=0;
        y_label_text='Enegy (GeV)'; 
        rotate_noise=0;
        rotate_image=0;
    case 'SYAG'
        energy_camera=0;
        y_label_text='';
        curr_lim=[0 1000]; %for SYAG  
        %Too lazy to write a program for horizontal lineout. Much easier to
        %rotate the image and noise together by 90 degrees!
        rotate_image=1;
        rotate_noise=1;
    case 'E224_Probe'
        energy_camera=0;
        y_label_text='';
        curr_lim=[0 1000]; %
        rotate_noise=0;
    case 'CMOS_ELAN'
        energy_camera=0;
        y_label_text='';
        curr_lim=[0 1000]; %        
        rotate_noise=0;
    otherwise
        error('this part has not be written yet!')
        energy_camera=0;
end



% linear_low_E=8;
% linear_high_E=41;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%END USER INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Load dataset

[prefix,data,num_stacks,image_struc,num_images,stack_text] = ...
    nvn_load_data(expt_str,source_dir,server_str,date_str...
    ,dataset_str,camera,remote);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Process and visualization
background_checked=0;

for i=1:num_stacks    
    if energy_camera 
        if exist('variable_bend','var')
            dipole_bend=dipole_multiplier_values(i);
            zero_Gev_px=zero_Gev_px_vector(i);                        
        end
        if dipole_bend~=1
            stack_text{i}=['Dipole=' num2str(dipole_bend,2) ', ' stack_text{i}];
        end
    end
    for j=1:num_images        
        curr_image=(i-1)*num_images+j;
        load_noiseless_images_15  


        %%%%%%%%%%%%%%%%%
        %show the image 
        %         if show_image && mod(j,2)==1 %Fix For odd(1) or even(0)
        if curr_image ==1 
            main_canvas=figure(50);
            subplot_rows=ceil(num_images/subplot_columns);

            set(gcf,'position',[100 350 2400 1200])
%             set(gca,'position',[0.02 0.02 0.96 0.96])
        end
            

        subplot(subplot_rows,subplot_columns,curr_image)
        %make the original image if diagnostic is on, otherwise work
        %only with linearized (or otherwise processed?) image
        if energy_camera
            imagesc(image)
            set(gca,'YTick',energy_pixel);
            set(gca,'YTickLabel',energy_ticks);            
        else
            imagesc(this_image)
        end        
        colormap(sebas_colors)
        set(gca,'clim',[120 1000])
%         ylabel(y_label_text,'fontsize',15); 
%         xlabel('pixels','fontsize',15);
           
    end

end

snapshot_image=gcf;

