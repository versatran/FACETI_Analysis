function image_processing_GUI(varargin)
    background_checked = 1;
    skip_DCOffset = 1;
    horizsize = getappdata(0, 'horizsize');
    vertsize = getappdata(0, 'vertsize');
    %retrieve specific data for image and dataset location
    source_dir = getappdata(0, 'source_dir');
    server_str = getappdata(0, 'server_str');
    expt_str = getappdata(0, 'expt_str');
    date_str = getappdata(0, 'date_str');
    dataset_str = getappdata(0, 'dataset_str');
    camera = getappdata(0, 'camera');
    save_struc_str = camera.name;
    
    %checking type of image processing
    processtype = varargin{1};
    switch processtype
        case 1 %lineouts
            % allow user to input the box region
            prompt = {'Enter box region 1: ', 'Enter box region 2: '};
            title = 'Lineout';
            dims = [1 35];
            definput = {'300', '500'};
            box_region = inputdlg(prompt, title, dims, definput);
            box_region = str2double(box_region{1}):str2double(box_region{2});
             
        case 2 %multibox
            % allow user to input the amount of boxes vvv
            prompt = {'Enter amount of boxes: '};
            title = 'Multibox';
            dims = [1 35];
            definput = {'1'};
            rect_option = inputdlg(prompt, title, dims, ...
                definput);
            rect_option = rect_option{1};
            rect_option = -str2double(rect_option);
            % sees if its continual multiboxes or static
            choiceStr = varargin{2};
            switch choiceStr
                case 'continual'
                    isContinual = 1;
                case 'static'
                    isContinual = 0;
                otherwise
                    error('wrong input. must be "static" or "continual"');
            end
        case 3 %slicefitting
            % allow user to input # of lines and box width
            prompt = {'Enter number of lines: ', 'Enter box width: '};
            title = 'Slice Fitting';
            dims = [1 35];
            definput = {'10', '5'};
            items = inputdlg(prompt, title, dims, ...
                definput);
            number_of_lines = str2double(items{1});
            box_width = str2double(items{2}); 
        otherwise %error
            error('process type is unknown');
    end
    
    
    %Construct the output and saved variables
%    if exist('purpose','var')
%        save_struc_str=[save_struc_str,'_',purpose];
%    end
%    if processtype==1
%        save_struc_str=[save_struc_str '_' num2str(box_region(1)),'_',num2str(box_region(end))];
%    end
    linearize = getappdata(0, 'linearize');
    if linearize
        save_struc_str=[save_struc_str '_linear']; 
    end
    
    
    %load dataset
    [prefix,data,num_stacks,image_struc,num_images,stack_text,func_name,...
    bend_struc]= nvn_load_data(expt_str,source_dir,server_str,date_str...
    ,dataset_str,camera.name);
    
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
            show_image = getappdata(0, 'show_image');
            if show_image %Fix For odd(1) or even(0)
                if curr_image==1
                    main_canvas=figure(50);
                    setappdata(0, 'main_canvas', main_canvas);
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
%                     colorbar
                    if exist('draw_ROI','var')
%                      axis(image_axis,draw_ROI);
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
                    manual_set_figure_position = getappdata(0, 'manual_set_figure_position');
                    
%                    if (manual_set_figure_position)
%                        %TODO: this was written for positron lineout images. 
                    %   Will eventually need to make this run auto. 
%                        set(main_canvas,'position',manual_positon)
%                    else
%                        set(main_canvas,'position',[contained_p(1) contained_p(2) contained_p(3) contained_p(4)*r1/r2]);
%                    end
                    set(gca,'fontsize',15); 
                    %If the resizing pushes the window out of the border, this
                    %command brings it back
                    movegui(50)
                end           

            
                %make the original image if diagnostic is on, otherwise work
                %only with linearized (or otherwise processed?) image
                energy_pixel = getappdata(0, 'energy_pixel');                if camera.energy_camera
                energy_ticks = getappdata(0, 'energy_ticks');
                    imagesc(this_image)
                
                
                yt = get(gca, 'YTick');
                energy_pixel2 = compose('%d', energy_pixel);
                set(gca, 'YTick', yt, 'YTickLabel',energy_ticks);
                
                % set(gca,'YTick',energy_pixel);
                % set(gca,'YTickLabel',energy_ticks);            
            else
                imagesc(this_image)
            end
            xlabel('pixels','fontsize',15);
            ylabel(camera.y_label_text,'fontsize',15); 
            
            %redo colortable for meaningful values
%            if lpaw_image_display_mode
                %pico Coulomb conversion factor: 35 e/px*charge/e/(DxDy)
                %Gives charge in pC/GeV/mm
%                pC_conversion_factor=3500*1.6e-19*1e12/(resolution*1e-3*...
%                    (linear_energy_scale(2)-linear_energy_scale(3)));                
%                imagesc(this_image*pC_conversion_factor);
          
                curr_lim = getappdata(0, 'curr_lim');
                if j==1                    
%                    if ~strcmp(curr_lim,'auto')
%                        curr_lim0=curr_lim;
%                    else
%                        curr_lim0=get(gca,'clim')/pC_conversion_factor;
%                    end
                
%                    curr_lim=curr_lim0*pC_conversion_factor;
                end
                resolution = getappdata(0, 'resolution');
                the_lebles=round([0 100 300 500]*resolution/100)/10;
                set(gca,'YTick',energy_pixel);
                set(gca,'YTickLabel',energy_ticks)
                set(gca,'XTick',[0 100 300 500]);
                set(gca,'XTickLabel',the_lebles);
                xlabel('mm')
                ylabel('Energy (GeV)')
            end
            sebas_colors = sebasColorTable;
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
                            if isContinual
                                image = getimage(main_canvas.CurrentAxes); 
                                [I,rect]=imcrop;
                                rect_pos(k) = {rect};
                                counts(i,j,k)=sum(sum(I));
                                rectangles(i,j,k,1:4)=rect;
                                if (3)>0 && rect(4)>0
                                    rectangle('position',rectangles(i,j,k,:),'edgecolor','k','linewidth',1.5,'linestyle','--')
                                end
                            else
                                if j == 1
                                    [I,rect]=imcrop;
                                    rect_pos(k) = {rect};
                                    if k == -rect_option
                                        setappdata(0, 'rect_pos', rect_pos);
                                    end
                                else
                                    rect_pos = getappdata(0, 'rect_pos');
                                    image = getimage(main_canvas.CurrentAxes);
                                    I = imcrop(image, rect_pos{k});
                                end
                                rectangles(i,j,k,1:4)=rect;
    %                           cropped(i,j,k)={I};
                                counts(i,j,k)=sum(sum(I));
                                rect = rect_pos{k};
                                if (3)>0 && rect(4)>0
                                    rectangle('position',rectangles(i,j,k,:),'edgecolor','k','linewidth',1.5,'linestyle','--')
                                end
                            end
                            setappdata(0, 'counts', counts);
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
            setappdata(0, 'Emovie', Emovie);
        end
    end
    if processtype == 2
        export_opt = uimenu(main_canvas, 'Text', 'Export');
        uimenu(export_opt, 'Text', 'Export Counts', 'Callback', @export_counts);
    end
    uimenu(main_canvas, 'Text', 'Save as Movie', 'Callback', @save_video_Callback);
end

function export_counts(~,~,~)
   labels = {'Export counts as: ', 'Export UIDs as: '};
   counts = getappdata(0, 'counts');
   data = getappdata(0, 'data');
   camera = getappdata(0, 'camera');
   camera = camera.name;
   UIDs = data.raw.images.(camera).UID;
   var = {'counts', 'count_UIDs'};
   vals = {counts, UIDs};
   export2wsdlg(labels, var, vals);
end