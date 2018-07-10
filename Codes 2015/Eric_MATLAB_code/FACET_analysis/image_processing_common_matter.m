%Image related Processing 
clearvars
% clearvars -except E200_vector ii
close all
sebas_colors=sebasColorTable();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BEGIN USER INPUT
%See comment_repo_im_proc for other options.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set data path & process type
% source_dir='S:/FACET_data/2015/';
% source_dir='/Volumes/Transfer/FACET_data/2014/'
% source_dir='/Volumes/Elements/FACET_data/2014/'
% source_dir='/Volumes/LaCie2/FACET_data/2014/';
source_dir='/Volumes/LaCie/FACET_data/2014/';

server_str='nas/nas-li20-pm00/';
%set to zero only if /nas is in the pwd
remote=1;

% expt_str='E200';
expt_str='E217';

% date_str='20150328';
% date_str='20150329';
date_str='20140601';
% date_str='20140406';
% date_str='20140530';
% date_str='20141212';

% dataset_str='12333';
% dataset_str='13054';
dataset_str='13117';
% dataset_str='13144';
% dataset_str='15229';
% dataset_str='18010';
% dataset_str='15362';
% dataset_str='14285';


%process type identifies what it is that is supposed to happen to an image.
%process type =1 For lineouts
%process type =2 For Multibox
processtype=2;

% purpose='lineouts';
purpose='emit_calc';

outputdir='~/Library/Mobile Documents/com~apple~CloudDocs/Lab Work/2014 FACET Analysis/Emittance Measurement/';
% outputdir=['/Users/Navid/Lab Work/' date_str(1:4) ' FACET Analysis/'];
% outputdir=['E:/Lab Work/FACET Analysis/' dataset_str '/'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Processtype Properties

%Edit If processtype =1, otherwise ignore
% box_region=200:420; %14610
% box_region=250:600; %15362
box_region=200:400;

%actually not necessary if defining the actual rectangles
%Edit If processtype =2, otherwise ignore
% rect_option=9 %means you are picking the ROI for each data
% rect_option=17 %means you are picking the ROI for each data
rect_option=15 %means you are picking the ROI for each data
selection=1:20:734-6;
% rect_option=length(selection);
% rect_option=11
% rect_option=2 % 
% rect_option=31 %means you don't want any ROI
%rect_oprion>1 means that you have a specific (number of) ROI in mind, 
%which you should introduce using the parameter "rectangles"
% rect_option=-1; %select rectangles

% 15362
% rectangles=[260 200 100 1060;... % energy gain
%             150 1260 300 140;... % non-participating
%             260 1400 100 700]    % energy loss

% 15229
% rectangles=[1 200 600 1390;...   % energy gain
%             1 1590 600 80;... % non-participating
%             1 1670 600 520]   % energy loss

% 15229/15230 CMOS_FAR
% rectangles=[1 24 600 48;...
%             1 12 600 48;...
%             1 0 600 48;...
%             1 -12 600 48;...
%             1 -24 600 48;...
%             1 -36 600 48;...
%             1 -48 600 48;...
%             1 -60 600 48;...
%             1 -72 600 48]

% 15229/15230 CMOS_ELAN +4
% rectangles=[1 137 1400 6;...
%             1 117 1400 6;...
%             1 97 1400 6;...
%             1 77 1400 6;...
%             1 57 1400 6;...
%             1 37 1400 6;...
%             1 17 1400 6;...
%             1 -3 1400 6;...
%             1 -23 1400 6;...
%             1 -43 1400 6;...
%             1 -63 1400 6;...
%             1 -83 1400 6;...
%             1 -103 1400 6;...
%             1 -123 1400 6;...
%             1 -143 1400 6;...
%             1 -163 1400 6;...
%             1 -183 1400 6;...
%             1 -203 1400 6;...
%             1 -223 1400 6;...
%             1 -243 1400 6;...
%             1 -263 1400 6];
        
% 15229/15230 CMOS_ELAN -4
% rectangles=[1 43 1400 3;...
%             1 21 1400 3;...
%             1 -1 1400 3;...
%             1 -23 1400 3;...
%             1 -45 1400 3;...
%             1 -66 1400 3;...
%             1 -88 1400 3;...
%             1 -110 1400 3;...
%             1 -132 1400 3;...
%             1 -154 1400 3;...
%             1 -176 1400 3;...
%             1 -197 1400 3;...
%             1 -219 1400 3;...
%             1 -241 1400 3;...
%             1 -263 1400 3;...
%             1 -285 1400 3;...
%             1 -307 1400 3;...
%             1 -328 1400 3;...
%             1 -350 1400 3];

% 13123 ELANEX injected charge
% rectangles=[1 171 1291 6;...
%             1 150 1291 6;...
%             1 128 1291 6;...
%             1 106 1291 6;...
%             1 84 1291 6;...
%             1 62 1291 6;...
%             1 41 1291 6;...
%             1 19 1291 6;...
%             1 -3 1291 6;...
%             1 -25 1291 6;...
%             1 -47 1291 6;...
%             1 -68 1291 6;...
%             1 -90 1291 6;...
%             1 -112 1291 6;...
%             1 -134 1291 6;...
%             1 -156 1291 6;...
%             1 -177 1291 6];


% rectangles(:,1)=1*(ones(length(selection),1));
% rectangles(:,2)=selection;
% rectangles(:,3)=1291*(ones(length(selection),1)); 
% rectangles(:,4)=6*(ones(length(selection),1)); 
% % 13123 ELANEX laser off
% rectangles=[1 62 1291 6;...
%             1 52 1291 6;...
%             1 41 1291 6;...
%             1 30 1291 6;...
%             1 19 1291 6;...
%             1 8 1291 6;...
%             1 -3 1291 6;...
%             1 -14 1291 6;...
%             1 -25 1291 6;...
%             1 -36 1291 6;...
%             1 -47 1291 6;...
%             1 -58 1291 6;...
%             1 -68 1291 6];

% 13116 ELANEX beam
rectangles=[1 68 1291 6;...
            1 44 1291 6;...
            1 21 1291 6;...
            1 -3 1291 6;...
            1 -27 1291 6;...
            1 -50 1291 6;...
            1 -74 1291 6;...
            1 -98 1291 6;...
            1 -122 1291 6;...
            1 -145 1291 6;...
            1 -169 1291 6;...
            1 -193 1291 6;...
            1 -216 1291 6;...
            1 -240 1291 6;...
            1 -264 1291 6];

% 13284 Mike Litos comparison Qs +4.5
% rectangles=[1 152 1291 6;...
%             1 142 1291 6;...
%             1 131 1291 6;...
%             1 121 1291 6;...
%             1 111 1291 6;...
%             1 100 1291 6;...
%             1 90 1291 6;...
%             1 80 1291 6;...
%             1 69 1291 6;...
%             1 59 1291 6;...
%             1 49 1291 6;...
%             1 38 1291 6;...
%             1 28 1291 6;...
%             1 18 1291 6;...
%             1 7 1291 6;...
%             1 -3 1291 6;...
%             1 -13 1291 6;...
%             1 -24 1291 6];

% 13284 Qs +7.5
% rectangles=[1 129 1291 6;...
%             1 112 1291 6;...
%             1 96 1291 6;...
%             1 79 1291 6;...
%             1 63 1291 6;...
%             1 46 1291 6;...
%             1 30 1291 6;...
%             1 13 1291 6;...
%             1 -3 1291 6;...
%             1 -19 1291 6;...
%             1 -36 1291 6;...
%             1 -52 1291 6;...
%             1 -69 1291 6;...
%             1 -85 1291 6];

% %12979 cmos_far
% rectangles=[1 106 351 6;...
%             1 97 351 6;...
%             1 87 351 6;...
%             1 77 351 6;...
%             1 68 351 6;...
%             1 58 351 6;...
%             1 48 351 6;...
%             1 38 351 6;...
%             1 29 351 6;...
%             1 19 351 6;...
%             1 9 351 6;...
%             1 0 351 6;...
%             1 -10 351 6;...
%             1 -20 351 6;...
%             1 -29 351 6;...
%             1 -39 351 6;...
%             1 -49 351 6;...
%             1 -58 351 6;...
%             1 -68 351 6;...
%             1 -78 351 6;...
%             1 -88 351 6];
        
%12979 cmos_far Drive beam
% rectangles=[1 106 351 2;...
%             1 97 351 2;...
%             1 87 351 2;...
%             1 77 351 2;...
%             1 68 351 2;...
%             1 58 351 2;...
%             1 48 351 2;...
%             1 38 351 2;...
%             1 29 351 2;...
%             1 19 351 2;...
%             1 9 351 2;...
%             1 0 351 2;...
%             1 -10 351 2;...
%             1 -20 351 2;...
%             1 -29 351 2;...
%             1 -39 351 2;...
%             1 -49 351 2;...
%             1 -58 351 2;...
%             1 -68 351 2;...
%             1 -78 351 2;...
%             1 -88 351 2;...
%             1 -98 351 2;...
%             1 -108 351 2;...
%             1 -118 351 2];


%12979 cmos_far Injected beam
% rectangles=[1 48 351 2;...
%             1 38 351 2;...
%             1 29 351 2;...
%             1 19 351 2;...
%             1 9 351 2;...
%             1 0 351 2;...
%             1 -10 351 2;...
%             1 -20 351 2;...
%             1 -29 351 2;...
%             1 -39 351 2;...
%             1 -49 351 2];

%for 14285 CMOS_FAR
% rectangles=[1 145 351 2;...
%             1 135 351 2;...
%             1 126 351 2;...
%             1 116 351 2;...
%             1 106 351 2;...
%             1 97 351 2;...
%             1 87 351 2;...
%             1 77 351 2;...
%             1 68 351 2;...
%             1 58 351 2;...
%             1 48 351 2;...
%             1 38 351 2;...
%             1 29 351 2;...
%             1 19 351 2;...
%             1 9 351 2;...
%             1 0 351 2;...
%             1 -10 351 2;...
%             1 -20 351 2;...
%             1 -29 351 2;...
%             1 -39 351 2;...
%             1 -49 351 2;...
%             1 -58 351 2;...
%             1 -68 351 2;...
%             1 -78 351 2;...
%             1 -88 351 2;...
%             1 -98 351 2;...
%             1 -108 351 2;...
%             1 -118 351 2;...
%             1 -128 351 2;...
%             1 -138 351 2;...
%             1 -147 351 2];
% shift starting point to center energy pixel
% rectangles(:,2)=rectangles(:,2)+1133

% for 13117
rectangles(:,2)=rectangles(:,2)+264+150;

%for 13144-145
% rectangles(:,2)=rectangles(:,2)+720
% rectangles(:,1)=rectangles(:,1)+100

% for 13123
% rectangles(:,2)=rectangles(:,2)+440

% %for 13054
% rectangles(:,2)=rectangles(:,2)+790
% rectangles(:,1)=rectangles(:,1)+100

%For 13120
% rectangles(:,2)=rectangles(:,2)+1000
% rectangles(:,1)=rectangles(:,1)+125

%for 12979_CMOS_FAR Drive beam
% rectangles(:,2)=rectangles(:,2)+293
%for 12979_CMOS_FAR injected beam
% rectangles(:,2)=rectangles(:,2)+94

%for CMOS_FAR on 14285 (positrons)
% rectangles(:,2)=rectangles(:,2)+623

%CMOS_FAR on 12332
% rectangles(:,2)=rectangles(:,2)+810
% rectangles(:,1)=rectangles(:,1)+50

% CMOS_FAR on 12333
% rectangles(:,2)=rectangles(:,2)+644
% rectangles(:,1)=rectangles(:,1)+50


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Visualization properties
%see comment_repo_im_proc for other options.

skip_background_verification=0;

%%Camera
%Which camera do you want to look at--> Set Dependent property below
% camera='CMOS_ELAN';
%camera='CMOS_NEAR';
% camera='AX_IMG1'; 
% camera='CMOS_FAR'; 
camera='ELANEX';
% %if equal to 1, a linearized version of a energy camera will be displayed
linearize=0;
%show image or run process in background
show_image=1;
%Asjusts how the noise is scaled, so it doesn't cut into data
scale_adjustment=0.95;
%Subtracts nonzero offset from entire image
DC_offset=0;
%saves video
save_video=1;
%save data to the original dataset--> Set Dependent property below
save_data=0;
%overrides parameters if one with the smame name already exists
save_override=0;
%Do you want to run the remove_xray script
remove_xrays=1;
%Show where samples are taken for noise subtraction
show_noise_sample=1;
%Show where sample is taken to calculate DC offset (linearize must be 0)
show_DC_sample=0;
%Allow for clicking graph to obtain energy gain / loss (in that order)
%(non-mouse1 buttons indicate no interaction took place)
manual_energy=0;
%display images with a logscale colorbar 10.^(log_range)
log_color=0;
log_range=[1:4];
%if [1,#,#], graphics set with image [~,i,j]
%Keep this [1,i,1], and run it once to get the visualization intialized 
%then interrupt the program on line "curr_image=(i-1)*num_images+j;" and
%set j to whatever you want
mid_start=[1,3,1];

manual_set_figure_position=1;
%these two coordinates are for setting the limits for the image and its lineout
%for image
%format is [x0 y0 w h]
% draw_ROI=[200 500 400 1500];
% draw_ROI=[1 650 600 500]; % 15229/15230 CMOS_FAR
% draw_ROI=[1 650 400 1900]; % 14308 (positrons Dec 2014)
% draw_ROI=[1 1 1400 2040];
% draw_ROI=[300 1 650 734];
% draw_ROI=[50 500 350 1000];
% draw_ROI=[100 550 300 1000]; %140526_12979 CMOS_FAR
% draw_ROI=[100 550 500 2000]; %140406_12332

%define sample box used to calculate DC offset 
%format is [x0 y0 w h] defined from ROI (if set)
% DC_sample=[1 1 100 200]; %CMOS_FAR
% DC_sample=[1850 700 150 300]; %CMOS_ELAN
DC_sample=[1 600 200 100]; %ELANEX

%for lineout, note, the last two numbers are replaced by the image limit,
%if it exists.
% axis_limits_lineout=[0 1e5 800 1344]; %laser on

% curr_lim=[1100 3000];%for long oven sent to Mike
% curr_lim=[0 5000];%for long oven sent to Mike
curr_lim=[0 1500];

plot_location1=[360   547   560   559]; %for squished long oven sent to Mike
plot_location2=[1,1,560,420];

% Electron energy limit fractions
top_cutoff = 0.01;
bottom_cutoff = 0.01;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set camera properties
camera=load_camera_config(camera);

% linear_low_E=8;
% linear_high_E=36;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%END USER INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch purpose
    case 'unaff_n_he'
        cmt_str='unaffected charge and helium box as well as total box'
    case 'unaff'
        cmt_str='unaffected charge as well as total box'
    case 'he_select'
        cmt_str='helium box, hand selected'
    case 'lineouts'
        cmt_str=['lineout of range [' num2str(box_region(1)),':',num2str(box_region(end)) ']']
    otherwise
    cmt_str='test script'
end

%Construct the output and saved variables
outputFileName=[outputdir,date_str(3:end),'_',dataset_str,'_',camera.name];
save_struc_str=camera.name;

if exist('purpose','var')
    outputFileName=[outputFileName,'_',purpose];
    save_struc_str=[save_struc_str,'_',purpose];
end
if processtype==1
    outputFileName=[outputFileName '_' num2str(box_region(1)),'_',num2str(box_region(end))];
    save_struc_str=[save_struc_str '_' num2str(box_region(1)),'_',num2str(box_region(end))];
end
if linearize
    outputFileName=[outputFileName '_linearized'];
    save_struc_str=[save_struc_str '_linearized'];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Load dataset
%Since there were a bunch of lines commonly used after a load, I put
%everything together in this function
[prefix,data,num_stacks,image_struc,num_images,stack_text,func_name,...
    bend_struc]= nvn_load_data(expt_str,source_dir,server_str,date_str...
    ,dataset_str,camera.name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Process and visualization
background_checked=0;

% num_stacks=1;
% num_images=2;
bottom_frac=zeros(num_stacks,num_images);
top_frac=bottom_frac;
total_gain=top_frac;
total_loss=total_gain;

%Go over scan steps, if no scan, only one loop iteration
for i=3
    if camera.energy_camera 
        if exist('variable_bend','var')
            camera.dipole_bend=bend_struc.dipole_multiplier_values(i);
            zero_Gev_px=bend_struc.zero_Gev_px_vector(i);                        
        end
        if camera.dipole_bend~=1
            stack_text{i}=['Dipole=' num2str(camera.dipole_bend,2) ', ' stack_text{i}];
        end
    end
    %go through images in each scan step
    for j=1:num_images
        curr_image=(i-1)*num_images+j;
        if j==78 || j==79 || j==4 
            %j==26 || j==4 || j==47            
            breaking_point=1;
        end
        load_noiseless_images_15

        %%%%%%%%%%%%%%%%%
        %First do the process
        switch processtype
            case 1
                lineout(i,j,:)=sum(this_image(:,box_region),2);
%                 lineout_UID(i,j)=image_UID;
                %lineout rectangle
                %text? universal?
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%
                % Eric energy limmits code
                if ~manual_energy
    %                 index=find(smooth(lineout(i,j,11:end-5),100)>top_cutoff*max(lineout(i,j,:)));
    %                 top_frac(i,j)=index(1)+10;
    %                 index=find(smooth(lineout(i,j,11:end-5),100)>bottom_cutoff*max(lineout(i,j,:)));
    %                 bottom_frac(i,j)=index(end)+10;
                    total=sum(lineout(i,j,:));
                    for k=1:vertsize
                        bottom_integral=sum(lineout(i,j,vertsize:-1:vertsize-k+1));
                        top_integral=sum(lineout(i,j,1:k));
                        if (bottom_integral>(total*bottom_cutoff) && ~bottom_frac(i,j))
                            bottom_frac(i,j)=vertsize-k+1;
                        end
                        if (top_integral>(total*top_cutoff) && ~top_frac(i,j))
                            top_frac(i,j)=k;
                        end
                        if (top_frac(i,j) && bottom_frac(i,j))
                            break;
                        end
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%
                
            case 2
                if (rect_option>0)
                    for k=1:rect_option
                        counts(i,j,k)=sum(sum(imcrop(this_image,rectangles(k,:))));
                        rlineout(i,j,k,:)=sum(imcrop(this_image,rectangles(k,:)),1);
                    end
                elseif (rect_option<0)
                    if ~show_image
                        error('Need an image to select the rectangles!')
                    end
                    error('this part isn''t written yet!')
                else
                    counts=0; 
                    rectangles=[];
                end
                
            otherwise
                error('process code not found')
        end
        
        %%%%%%%%%%%%%%%%%
        %show the image 
        %         if show_image && mod(j,2)==1 %Fix For odd(1) or even(0)
        if show_image %Fix For odd(1) or even(0)
            if mid_start(1)*(i==mid_start(2))*(j==mid_start(3))
                curr_image=1;
            end
            if curr_image==1
                main_canvas=figure(50);
            end
            switch processtype
                case 1                    
                    image_axis=subplot(1,2,1);
                case 2
                    image_axis=gca;
                otherwise
                    error('process code not found')
            end

            
            %%%%set upimage containers
            %I want to balance the shape of the figure with the pixel size
            %of the image. I can use get(suplot,'position') to get the the
            %position as a function of the larger box. e.g. 0.1 means 0.1
            if curr_image==1
%                 colorbar
                set(main_canvas,'position',plot_location1)
                if exist('draw_ROI','var')
%                     axis(image_axis,draw_ROI);
%                     display_width=draw_ROI(3)-draw_ROI(1);
%                     display_height=draw_ROI(4)-draw_ROI(2);
                    display_width=draw_ROI(3);
                    display_height=draw_ROI(4);
%                     width_start=draw_ROI(1);
%                     height_start=draw_ROI(3);
                    width_start=1;
                    height_start=1;
    %                 lineout(i,j,:)=sum(image(:,box_region),2);
                    if exist('axis_limits_lineout','var')
                        axis_limits_lineout(3)=draw_ROI(3);
                        axis_limits_lineout(4)=draw_ROI(4);
                    end
                else
                    display_width=horizsize;
                    display_height=vertsize;
                    width_start=1;
                    height_start=1;
                end
                %TODO:This will need to be set by me eventially!
                contained_p=get(main_canvas,'position');
                sub_p=get(image_axis,'position');
                sub_width=sub_p(3)*contained_p(3);
                sub_height=sub_p(4)*contained_p(4);
                r1=sub_width/sub_height;
                r2=display_width/display_height;
                %into the large container
                if (manual_set_figure_position)
                    %TODO: this was written for positron lineout images. 
                    %Will eventually need to make this run auto. 
                    set(main_canvas,'position',[360   335   728   479])
                else
                    set(main_canvas,'position',[contained_p(1) contained_p(2) contained_p(3) contained_p(4)*r1/r2]);
                end
                set(gca,'fontsize',15); 
                %If the resizing pushes the window out of the border, this
                %command brings it back
                movegui(50)
            end           

            
            %make the original image if diagnostic is on, otherwise work
            %only with linearized (or otherwise processed?) image
            if log_color
                imagesc(log10(abs(this_image)))
                hC=colorbar;
                set(hC,'Ytick',log_range);
                set(hC,'YTicklabel',10.^log_range);
            else
                imagesc(this_image)
                colorbar
            end
            if camera.energy_camera
                set(gca,'YTick',energy_pixel);
                set(gca,'YTickLabel',energy_ticks);
            end
            colormap(sebas_colors)
            ylabel(camera.y_label_text,'fontsize',15); 
            xlabel('Pixels','fontsize',15);
            
            if log_color
                set(gca,'CLim',[log_range(1) log_range(end)]);
            elseif ~strcmp(curr_lim,'auto')
                set(gca,'CLim',curr_lim);
            end
            if exist('axis_limits_image','var')
                axis(draw_ROI);
            end
%             grid
            
            %%%%
            %Writing and drawing on the image
            switch processtype
                case 1
                    rectangles= [box_region(1) height_start ...
                        box_region(end)-box_region(1) display_height];                    
                    size_rectangles=size(rectangles);
                    for k=1:size_rectangles(1)
                        rectangle('position',rectangles(k,:),'edgecolor','k','linewidth',1.5,'linestyle','--')
                    end
                    if manual_energy
                        if j==1
                            disp('Select y location for energy gain, then energy loss.\n');
                        end
                        [~,energy_y,button]=ginput(2);
                        if button(1)==1
                            top_frac(i,j)=round(energy_y(1));
                            bottom_frac(i,j)=round(energy_y(2));
                        else
                            top_frac(i,j)=round(interp1(linear_energy_scale,1:vertsize,...
                                energy_calib_vector(camera.zero_Gev_px)));
                            bottom_frac(i,j)=top_frac(i,j);
                            if exist('noint_shot','var')
                                noint_shot(end+1)=j;
                            else
                                noint_shot=j;
                            end
                        end
                    end
                    if (show_DC_sample && ~linearize)
                        rectangle('position',DC_sample,'linewidth',2,'linestyle','--');
                    end
%                     line(box_region,top_frac(j)*ones(size(box_region)),'color','k','linewidth',2);
%                     line(box_region,bottom_frac(j)*ones(size(box_region)),'color','k','linewidth',2);
                case 2
                    if (rect_option>0)
                        for k=1:rect_option
                            rectangle('position',rectangles(k,:),'edgecolor','k','linewidth',1.5,'linestyle','--')
                        end
                    elseif (rect_option<0)
                        for k=1:-rect_option
                            [I,rect]=imcrop;
                            rectangles(i,j,k,1:4)=rect;
    %                         cropped(i,j,k)={I};
                            counts(i,j,k)=sum(sum(I));
                            if rect(3)>0 && rect(4)>0
                                rectangle('position',rectangles(i,j,k,:),'edgecolor','k','linewidth',1.5,'linestyle','--')
                            end
                        end
                    end
                otherwise
                    error('haven''t written this part yet')
            end
            text(.02*display_width+width_start,.03*display_height+height_start,['Shot # ' int2str(j)],'color','w','backgroundcolor','b');
            if exist('stack_text','var')
                text(.02*display_width+width_start,.1*display_height+height_start,stack_text{i},'color','w','backgroundcolor','blue');
            end
            

%                 text(.02*horizsize,.08*vertsize,['Pyro ' int2str(current_pyro)],'color','w');
%                 text(.02*horizsize,1392-.08*vertsize,['Shot # ' int2str(j)],'color','w');
%             text(650,1392-.08*vertsize,['Shot # ' int2str(j)],'color','w');
%                 text(.02*horizsize,1392-.04*vertsize,['Pyro ' int2str(current_pyro)],'color','w');
            
            %draw lineout if required by process type
            if processtype==1
                subplot(1,2,2)
                plot(squeeze(lineout(i,j,:)),1:length(squeeze(lineout(i,j,:))),'linewidth',2.5);
                set(gca,'fontsize',15);
                axis([0,max(lineout(i,j,:)),0,length(squeeze(lineout(i,j,:)))])
                set(gca,'YDir','reverse')
                if exist('axis_limits_lineout','var')
                    axis(axis_limits_lineout);
                end
                if camera.energy_camera  
                    set(gca,'YTick',energy_pixel)
                end
                grid
            end
            Emovie(j)=getframe(50);    
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        %Energy conservation check
        if camera.energy_camera
            if linearize
                for k=1:energy_pixel(energy_ticks==20.35)
                    total_gain(i,j)=total_gain(i,j)+sum(this_image(k,:))*...
                        (linear_energy_scale(k)-20.35);
                end
                for k=energy_pixel(energy_ticks==20.35):vertsize
                    total_loss(i,j)=total_loss(i,j)+sum(this_image(k,:))*...
                        (20.35-linear_energy_scale(k));
                end
            else
                for k=1:energy_pixel(energy_ticks==20.35)
                    total_gain(i,j)=total_gain(i,j)+sum(this_image(k,:))*...
                        (energy_calib_vector(k)-20.35);
                end
                for k=energy_pixel(energy_ticks==20.35):vertsize
                    total_loss(i,j)=total_loss(i,j)+sum(this_image(k,:))*...
                        (20.35-energy_calib_vector(k));
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    if save_video
        if isunix
            if num_stacks>1
    %             vidObj = VideoWriter([outputdir 'comparative even odd lineouts for ' data_name ' oddx' num2str(multiplier) '_' num2str(i)],'MPEG-4');
                videofilename=[outputFileName '_' num2str(i)];
            else
    %         vidObj = VideoWriter([outputdir 'comparative even odd lineouts for ' data_name ' oddx' num2str(multiplier)],'Motion JPEG AVI');
    %             vidObj2 = VideoWriter(outputFileName,'Motion JPEG AVI');
                videofilename=outputFileName;
            end
            vidObj=VideoWriter(videofilename,'MPEG-4');
        elseif ispc
            if num_stacks>1
    %             vidObj = VideoWriter([outputdir 'comparative even odd lineouts for ' data_name ' oddx' num2str(multiplier) '_' num2str(i)],'MPEG-4');
                videofilename=[outputFileName '_' num2str(i)];
            else
                videofilename=outputFileName;
            end
            vidObj=VideoWriter(videofilename,'MPEG-4');
        else
            error('Congragulations, you live in an era of new operating systems, rewrite directory line')
        end
        
        vidObj.FrameRate=4;
        vidObj.Quality=100;
        open(vidObj);
        writeVideo(vidObj,Emovie)
        close(vidObj);
             
    end

end

if save_data
    process_struc.camera=camera.name;
    process_struc.linearized=linearize;
    process_struc.readme_comment=cmt_str;
    process_struc.remove_xrays=remove_xrays;
    process_struc.UID=image_struc.UID;
    process_struc.date=date;
    if exist('noint_shot','var')
        process_struc.noint_shot=noint_shot;
    end
    if exist('draw_ROI','var')
        process_struc.ROI=draw_ROI;
    end
    switch processtype
        case 1
            process_struc.lineout=lineout;
            process_struc.Egain=linear_energy_scale(top_frac)-20.35;
            process_struc.Eloss=20.35-linear_energy_scale(bottom_frac);
            process_struc.box_region=box_region;
        case 2            
            process_struc.counts=counts;
            process_struc.rlineout=rlineout;
            process_struc.rectangles=rectangles;
            process_struc.rect_option=rect_option;
            process_struc.example_image=Emovie(j).cdata;
        otherwise
            error('this part is not written yet!')    
    end
    
    if camera.energy_camera
        process_struc.energy_vector=energy_calib_vector;
        if linearize
            process_struc.linear_energy_vector=linear_energy_scale;
        end
    end
    
    data.processed.vectors.(genvarname(save_struc_str))=process_struc;
    E200_save_remote(data,save_override)
    display('Data saved!')
end

QS_BDES=[data.raw.scalars.LI20_LGPS_3261_BDES.dat{1} data.raw.scalars.LI20_LGPS_3311_BDES.dat{1}];

save([outputFileName,'.mat'],'rlineout','rectangles','rect_option','counts','camera','linearize','cmt_str','remove_xrays','image_struc','resolution','energy_calib_vector','draw_ROI','DC_offset','noise','QS_BDES')

% %Code to save single images
% 
% pos1 =[859   744   678   183]
% enhanced_image=image';
% imagesc(enhanced_image)
% set(gcf,'position',pos1)
% axis([500 2500 200 500])
% energy_ticks
% %gives you a result like this:
% % energy_ticks =
% % 
% %   Columns 1 through 7
% % 
% %    40.3500   24.3500   22.3500   20.3500   18.3500   16.3500   14.3500
% % 
% %   Columns 8 through 12
% % 
% %    12.3500   10.3500    8.3500    6.3500    4.3500
% 
% %pick the energies you need, e.g.
% picked_energy=[1 4 7 9:12]
% 
% % picked_energy =
% % 
% %      1     4     7     9    10    11    12
% 
% set(gca,'XTick',energy_pixel(picked_energy));
% set(gca,'XTickLabel',energy_ticks(picked_energy));
% xlabel('Energy (GeV)')
% set(gca,'YTickLabel',round([200 300 400 500]*resolution/1000*10)/10);
% ylabel('mm','fontsize',15)