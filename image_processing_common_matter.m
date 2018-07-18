%Image related Processing 
clear all
% clearvars -except E200_vector ii
close all
sebas_colors=sebasColorTable;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BEGIN USER INPUT
%See comment_repo_im_proc for other options.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set data path & process type
% PC
source_dir = strcat('H:', filesep, 'FACET_data', filesep);
% MAC
% source_dir='/Volumes/LaCie/FACET_data/';
% source_dir='/Volumes/LaCie1/FACET_data/';
% source_dir='/Volumes/LaCie2/FACET_data/';
% source_dir='/Volumes/LaCie 2/FACET_data/2015/';

server_str=strcat('nas', filesep, 'nas-li20-pm00', filesep);
% server_str='nas/nas-li20-pm01/';
% 
% expt_str='E217';
expt_str='E200';

% date_str='20150606';
% date_str='20140315';
% date_str='20140424';
% date_str='20141213';
% date_str='20140406';
% date_str='20140406';
% date_str='20140526';
% date_str='20141213';
date_str='20140601';
% date_str='20140606';
% date_str='20140530';
% date_str='20130515';

dataset_str = '13135';
% dataset_str='12380';
% dataset_str='12409';
% dataset_str='12581';
% dataset_str='13531';
% dataset_str='12986';
% dataset_str='12390'; %
% dataset_str='12414'; %half bend
% dataset_str='12340'; %half bend
% dataset_str='12979'; %
% dataset_str='13124';
% dataset_str='13222';
% dataset_str='13009';
% dataset_str='13123';
% dataset_str='13130';
% dataset_str='13122';
% dataset_str='12415';
% dataset_str='13117';
% dataset_str='12987';
% dataset_str='12407';
% dataset_str='11183';y
% dataset_str='14308';
% dataset_str='15362';
% dataset_str='17984';
% dataset_str='17983';

lpaw_image_display_mode=0;

%process type identifies what it is that is supposed to happen to an image.
%process type =1 For lineouts
%process type =2 For Multibox
%process type =3 for slice fitting 
processtype=1;

% purpose='LaserE_by_Probe';
purpose='lineout';
% purpose='NoDCOffset';
% purpose='sample';
% purpose='high_res';
% purpose='charge_injected';

% outputdir=['/Users/Navid/Lab Work/' date_str(1:4) ' FACET Analysis/'];
outputdir=['~/Library/Mobile Documents/com~apple~CloudDocs/Lab Work/' date_str(1:4) ' FACET Analysis/'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Processtype Properties

switch processtype
    case 1
        %Edit If processtype =1, otherwise ignore
        % box_region=200:420; %14610
%         box_region=40:160; %12023 CMOS_FAR
        box_region=300:550; %12023 CMOS_FAR
        % box_region=100:500; %14610 CMOS_FAR
        % box_region=100:300; %14610 CMOS_WLAN
        % box_region=300:600; %17982 CMOS_FAR
        % box_region=100:400; %CMOS_FAR
%         box_region=400:1200; %ELANEX May 2014

        % box_region=400:700; %CEGAIN 2013
        % box_region=240:300; %CMOS_FAR
        % box_region=85:125; %CMOS_FAR
    case 2
        %Edit If processtype =2, otherwise ignore
%         rect_option=1; %means you are picking the ROI for (a number of rectengles for) each data
        rect_option=0; %means you don't want any ROI
        %rect_oprion>1 means that you have a specific (number of) ROI in mind, 
        %which you should introduce using the parameter "rectangles"
%         rect_option=-1; %select rectangles

        % rectangles=[200 800 160 350;
        %     1 1 745 1935] %unaffected 14614

        rectangles=[300 1 400 150] %E224 Probe side 140601
    case 3
        %Edit If processtype =3, otherwise ignore        
        number_of_lines=10;
        box_width=5;
    otherwise 
        error('process type is not known')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Visualization properties
%see comment_repo_im_proc for other options.

skip_background_verification=0;

%%Camera
%Which camera do you want to look at--> Set Dependent property below
% camera='CMOS_WLAN'; 
% camera='BETAL'; 
% camera='AX_IMG1'; 
camera='CMOS_FAR'; 
% camera='E224_Probe'; 
% camera='CMOS_NEAR'; 
% camera='ELANEX';
% camera='CEGAIN'; 
% %if equal to 1, a linearized version of a energy camera will be displayed
linearize=0;
%show image or run process in background
show_image=1;
%Asjusts how the noise is scale, so it doesn't cut into data
scale_adjustment= 1;
skip_DCOffset=1;
%saves video
save_video=0;
%save data to the original dataset--> Set Dependent property below
save_data=0;
%overrides parameters if one with the smame name already exists
save_override=0;
%Do you want to run the remove_xray script
remove_xrays=1;

manual_set_figure_position=1;
% manual_positon=[360   335   728   479];
% manual_positon=[360   335   380   480]; %CMOS FAR May 2014
manual_positon=[1000 619 696 712]; %CMOS FAR Mar 2014, lineout
% manual_positon=[1181 549 526 371];%ELANEX May 2014
% manual_positon=[777   336   835   910]; %for large view of qs +4 spot
% manual_positon=[1034 432 292 667];% CMOS_FAR_LPAW_images
% manual_positon=[1178 523 292 555];% CMOS_FAR_LPAW_images plasma-less data
% manual_positon=[1125 773 320 300]; %LPAW quadrant position
%these two coordinates are for setting the limits for the image and its lineout
%for image
%format is [x0 y0 w h]

% draw_ROI=[150 750 500 700];%CMOS_FAR
% draw_ROI=[250 200 250 250];%WLANEX 
% draw_ROI=[100 450 500 2159];%CMOSFAR 2014 
% draw_ROI=[200 1425 350 1134];%CMOSFAR 2014 Arp 6 lowE bend=1
% draw_ROI=[150 505 500 2050];%CMOSFAR 2014 8 up to 35 GeV
% draw_ROI=[0 180 465 1000];%CMOS_NEAR 2014 
draw_ROI=[100 550 500 1000];%CMOSFAR 2014 15 up to 35 GeV 13128 close up
% draw_ROI=[100 550 300 1000];%CMOSFAR 2014 15 up to 35 GeV 12979_93 close up
% draw_ROI=[1 650 500 1950];%CMOSFAR 14285 (positrons)
% draw_ROI=[150 650 400 500];%CMOSFAR 2014 close up near 0

%LPAW PAPER draw_ROIs
% draw_ROI=[100 300 500 2560];%for half dipole 
% draw_ROI=[100 664 500 2560];%for plasma-less
% draw_ROI=[100 670 500 2560];%for plasam-less with zero px 895
% draw_ROI=[230 750 200 700];%CMOS_FAR for Mar 15 2014 Lithium 0.5 Hz
% draw_ROI=[230 550 200 700];%CMOS_FAR for Mar 15 2014 Lithium 0.5 Hz
% draw_ROI=[100 1275 500 1284];%for quadrant short oven
% draw_ROI=[50 550 500 2000];%12409 CMOSFAR bottom to 35 GeV
% draw_ROI=[0 550 500 1000];%CMOSFAR 2014 15 up to 35 GeV
% draw_ROI=[150 550 500 1000];%CMOSFAR 2014 15 up to 35 GeV 13123



%for lineout, note, the last two numbers are replaced by the image limit,
%if it exists.
% axis_limits_lineout=[0 1e5 800 1344]; %laser on

% curr_lim=[1100 3000];%for long oven sent to Mike
% curr_lim=[130 3000];%for long oven sent to Mike
% curr_lim=[0 3e4];%WLANEX not_trapped charge
% curr_lim=[0 5000];%WLANEX trapped charge
% curr_lim=[6 70]; %CEGAIN in 2013
% curr_lim=[0 1200] %CMOS_FAR for Mar 2014
% curr_lim=[0 2500] %CMOS_FAR for April 2014 2 bunch
% curr_lim=[0 2000] %CMOS_FAR for trapped 2014
% curr_lim=[0 2500] %CMOS_FAR for trapped 2014 12984
% curr_lim=[0 17500] %CMOS_FAR for trapped 2014 12984
% curr_lim=[0 100] %ELANEX 2014
% curr_lim=[0 800];%BETAL DEC 2014
curr_lim=[0 1050];%
% curr_lim=[0 1000];%BETAL DEC 2014 High Contrast
% curr_lim='auto';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set camera properties
camera=load_camera_config(camera);

% linear_low_E=8;
% linear_high_E=41;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%END USER INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
source_dir=[source_dir date_str(1:4) '/'];
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
    cmt_str=purpose;
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
    outputFileName=[outputFileName '_linear'];
    save_struc_str=[save_struc_str '_linear'];
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

%Go over scan steps, if no scan, only one loop iteration
for i=1:num_stacks
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
%     for j=1:1
        curr_image=(i-1)*num_images+j;
        if j==2 || j==64 || j==77|| j==89|| j==93
            %j==26 || j==4 || j==47            
            breaking_point=1;
        end
        load_noiseless_images_15  


        %%%%%%%%%%%%%%%%%
        %show the image 
        %         if show_image && mod(j,2)==1 %Fix For odd(1) or even(0)
        if show_image %Fix For odd(1) or even(0)
            if curr_image==1
                main_canvas=figure(50);
            end
            switch processtype
                case 1                    
                    image_axis=subplot(1,2,1);
                case 2
                    image_axis=gca;
                case 3
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
                    set(main_canvas,'position',manual_positon)
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
            if camera.energy_camera
                imagesc(this_image)
                set(gca,'YTick',energy_pixel);
                set(gca,'YTickLabel',energy_ticks);            
            else
                imagesc(this_image)
            end
            xlabel('pixels','fontsize',15);
            ylabel(camera.y_label_text,'fontsize',15); 
            
            %redo colortable for meaningful values
            if lpaw_image_display_mode
                %pico Coulomb conversion factor: 35 e/px*charge/e/(DxDy)
                %Gives charge in pC/GeV/mm
                pC_conversion_factor=3500*1.6e-19*1e12/(resolution*1e-3*...
                    (linear_energy_scale(2)-linear_energy_scale(3)));                
                imagesc(this_image*pC_conversion_factor);
          
                
                if j==1                    
                    if ~strcmp(curr_lim,'auto')
                        curr_lim0=curr_lim;
                    else
                        curr_lim0=get(gca,'clim')/pC_conversion_factor;
                    end
                
                    curr_lim=curr_lim0*pC_conversion_factor;
                end
                the_lebles=round([0 100 300 500]*resolution/100)/10;
                set(gca,'YTick',energy_pixel);
                set(gca,'YTickLabel',energy_ticks)
                set(gca,'XTick',[0 100 300 500]);
                set(gca,'XTickLabel',the_lebles);
                xlabel('mm')
                ylabel('Energy (GeV)')
            end
            
            set(gca,'fontsize',15)            
            colormap(sebas_colors)
            colorbar


            
            if ~strcmp(curr_lim,'auto')
                set(gca,'CLim',curr_lim);
            end
            if exist('axis_limits_image','var')
                axis(draw_ROI);
            end
%             grid

            %%%%
            %Do the process & Write and draw on the image
            switch processtype
                case 1
                    lineout(i,j,:)=sum(this_image(:,box_region),2);
                    rectangles= [box_region(1) height_start ...
                        box_region(end)-box_region(1) display_height];                    
                    size_rectangles=size(rectangles);
                    for k=1:size_rectangles(1)
                        rectangle('position',rectangles(k,:),'edgecolor','k','linewidth',1.5,'linestyle','--')
                    end
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
                    else
                        counts=0; 
                        rectangles=[];
                    end
                case 3
                    %Run this function while paused on your favorite picture!
                    % vertical_points=[1836]
                    if curr_image==1
                        warning on
                        warning 'waiting for button press. y for lineout'
                    end
                    waitforbuttonpress
                    keyval=double(get(50,'CurrentCharacter'));
                    if keyval~=121 && keyval~=89
                        continue
                    end                    
%                     vertical_points=[1830 1900 1970 2009 2052]
%                     vertical_points=y;
                    
                    horiz_length=60;
                    lower3=[100 0 0];
                    upper3=[1e4 horiz_length 500];

                    width=zeros(1,number_of_lines);
                    curr_y=zeros(1,number_of_lines);
                    for ii=1:number_of_lines
                        [x,y]=ginput(1);
                        x=round(x);
                        y=round(y);
                        horiz_lim=x-floor(horiz_length/2):x+floor(horiz_length/2);
                        vert_lim=y-floor(box_width/2):y+floor(box_width/2);
                        curr_lineout=sum(this_image(vert_lim,horiz_lim),1);
                        [width(ii),fitted_gauss{ii}]=find_rms(1:length(curr_lineout),curr_lineout'...
                            ,lower3,upper3);
                        figure(100)
                        plot(fitted_gauss{ii},1:length(curr_lineout),curr_lineout);
                        waitforbuttonpress
                        keyval=double(get(100,'CurrentCharacter'));
                        if keyval==120 || keyval==88
                            width(ii)=nan;
                            curr_y(ii)=nan;
                            figure(50)
                            continue
                        end  
                        curr_y(ii)=y;                        
                        figure(50)
                        hold on
                        plot(horiz_lim,y*ones(length(horiz_lim)),'k','linewidth',2);
                        hold off
                    end
                    collect_width(i,j,:)=width;
                    y_loc(i,j,:)=curr_y;
                    
                otherwise
                    error('haven''t written this part yet')
            end
            text(.02*display_width+width_start,.02*display_height+height_start,['Shot # ' int2str(j)],'color','w','backgroundcolor','b');
            if exist('stack_text','var')
                text(.02*display_width+width_start,.06*display_height+height_start,stack_text{i},'color','w','backgroundcolor','blue');
            end
            

%                 text(.02*horizsize,.08*vertsize,['Pyro ' int2str(current_pyro)],'color','w');
%                 text(.02*horizsize,1392-.08*vertsize,['Shot # ' int2str(j)],'color','w');
%             text(650,1392-.08*vertsize,['Shot # ' int2str(j)],'color','w');
%                 text(.02*horizsize,1392-.04*vertsize,['Pyro ' int2str(current_pyro)],'color','w');
            if ~skip_DCOffset
                rectangle('position',[sample_vector(1),sample_vector(3),sample_vector(2)-sample_vector(1),...
                    sample_vector(4)-sample_vector(3)])
            end
            %draw lineout if required by process type
            if processtype==1
                subplot(1,2,2)
                plot(squeeze(lineout(i,j,:)),1:length(squeeze(lineout(i,j,:))),'linewidth',2.5);
                set(gca,'fontsize',15);
                %used -1e4 in order to see the tail going to zero.
%                 axis([-1e4,max(lineout(i,j,:)),0,length(squeeze(lineout(i,j,:)))])
                axis([-10,max(lineout(i,j,:)),0,length(squeeze(lineout(i,j,:)))])
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
                vidObj2=VideoWriter(videofilename,'MPEG-4');
        elseif ispc
            if num_stacks>1
    %             vidObj = VideoWriter([outputdir 'comparative even odd lineouts for ' data_name ' oddx' num2str(multiplier) '_' num2str(i)],'MPEG-4');
                vidObj2=VideoWriter([outputFileName '_' num2str(i)],'MPEG-4');
            else
                vidObj = VideoWriter([outputdir 'comparative even odd lineouts for ' data_name ' oddx' num2str(multiplier)],'MPEG-4');
                vidObj2=VideoWriter([outputFileName],'MPEG-4');
            end
        else
            error('Congragulations, you live in an era of new operating systems, rewrite directory line')
        end
        

        %prone Emovie
        counter=0;
        for k=1:length(Emovie)
            if isempty(Emovie(k).cdata)
                continue
            end
            counter=counter+1;
            Emovie_clean(counter)=Emovie(k);
        end
        Emovie=Emovie_clean;
        vidObj2.FrameRate=4;
        vidObj2.Quality=100;
        open(vidObj2);
        writeVideo(vidObj2,Emovie)
        close(vidObj2);
             
    end

end

if save_data
    process_struc.camera=camera.name;
    process_struc.linearized=linearize;
    process_struc.readme_comment=cmt_str;
    process_struc.remove_xrays=remove_xrays;
    process_struc.UID=image_struc.UID;
    process_struc.date=date;
    switch processtype
        case 1
            process_struc.lineout=lineout;
            process_struc.box_region=box_region;
        case 2            
            process_struc.counts=counts;
            process_struc.rectangles=rectangles;
            process_struc.rect_option=rect_option;
            process_struc.example_image=Emovie(j).cdata;
        case 3
            process_struc.box_width=box_width;
            process_struc.num_lines_summed=number_of_lines;
            process_struc.width=collect_width;
            process_strucy.yloc=y_loc;
            process_struc.roi=draw_ROI;
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