% READ
% This is a script that is called in ImgTestGui.m under the functions
% pushNextShot_Callback, pushPreviousShot_Callback, editOfStack_Callback,

% This script cannot run on its own. 
% The purpose of this script is to visually show the image in the ImgTestGui
% figure 
% Based on image_processing_common_matter
function ImgTestGui_ShowImage(app_data)
    % must make figure and axis current and selected when loading image
    mainGUI = findobj('Tag', 'figureImgTestGui');
    axesImage = findobj('Tag', 'axesImage');
    set(groot, 'CurrentFigure', mainGUI)

    % load necessary variables not previously loaded
    % curr_lim = getappdata(0, 'curr_lim');
    curr_lim = app_data.curr_lim;
%     linearize = getappdata(0, 'linearize');
%     remove_xrays = getappdata(0, 'remove_xrays');
%     num_images = getappdata(0, 'num_images');
%     i = getappdata(0, 'i');
%     j = getappdata(0, 'j');
    linearize = app_data.linearize;
    num_images = app_data.num_images;
    i = app_data.i;
    j = app_data.j;
    sebas_colors = sebasColorTable();

    % this checkpoint is for right after setting the ROI for linearizing 
    if linearize
%         check_linearize_ROI = getappdata(0, 'check_linearize_ROI');
        check_linearize_ROI = app_data.check_linearize_ROI;
        if check_linearize_ROI
%             draw_ROI = getappdata(0, 'draw_ROI');
%             setappdata(0, 'load_linearize_ROI', 1);
            draw_ROI = app_data.draw_ROI;
            app_data.load_linearize_ROI = 1;
        end
    end

    %%%%%%%%%%%%%%%%%
    %allows option to view only laser on/off shots
    %laser select code (not done)
    % if (laser_select)
    % laser_list = cell(3,1);
    % laser_list{1,1} = 'laser on';
    % laser_list{2,1} = 'laser off';
    % laser_list{3,1} = 'all shots';
    % setappdata(0, 'laser_list', laser_list);
    % [s, ok] = listdlg('PromptString','Please select image type', ...
    %   'SelectionMode', 'single', 'ListString',laser_list);
    % setappdata(0, 's' , s);
    % end
    % s  = getappdata(0, 's');
    % getappdata(0, 'laser_list');
    % switch laser_list{s}
    %     case 'laser on'
    %         setappdata(0, 'j', 1);
    %     case 'laser off'
    %         setappdata(0, 'j', 2);
    %     case 'all shots'
    %         
    % end
    %         j = getappdata(0, 'j');

    curr_image = (i - 1) * num_images + j; 
%     setappdata(0, 'curr_image', curr_image);
    app_data.curr_image = curr_image;

    % load the current image
    load_noiseless_images_15_edited(app_data);

%     this_image = getappdata(0, 'this_image'); % from load_noiseless_images_15_edited
    this_image = app_data.this_image;

    % show the image
    show_image = app_data.show_image;
    if show_image % fix for odd(1) or even(0)
        image_axis = axesImage;
        set(mainGUI, 'CurrentAxes', image_axis)
        if curr_image == 1
            set(mainGUI, 'Position', [30 19.2308 150.2 45]);
            if exist('draw_ROI', 'var')
                display_width = draw_ROI(3);
                display_height = draw_ROI(4);
                setappdata(0, 'display_width', display_width);
                setappdata(0, 'display_height', display_height);
                width_start = 1;
                height_start = 1;
%                 setappdata(0, 'height_start', height_start);
%                 setappdata(0, 'width_start', width_start);
                app_data.height_start = height_start;
                app_data.width_start = width_start;
                if exist('axis_limits_lineout', 'var')
                    axis_limits_lineout(3) = draw_ROI(3);
                    axis_limits_lineout(4) = draw_ROI(4);
                end
            else
%                 horizsize = getappdata(0, 'horizsize');
%                 vertsize = getappdata(0, 'vertsize');
                horizsize = app_data.horizsize;
                vertsize = app_data.vertsize;
                display_width = horizsize;
                display_height = vertsize;
%                 setappdata(0, 'display_width', display_width);
%                 setappdata(0, 'display_height', display_height);
                app_data.display_width = display_width;
                app_data.display_height = display_height;
                width_start = 1;
                height_start = 1;
%                 setappdata(0, 'height_start', height_start);
%                 setappdata(0, 'width_start', width_start);
                app_data.height_start = height_start;
                app_data.width_start = width_start;
            end
            %TODO:This will need to be set by me eventually!
            contained_p = get(mainGUI, 'position');
            sub_p = get(gca, 'position');
            sub_width = sub_p(3) * contained_p(3);
            sub_height = sub_p(4) * contained_p(4);
            r1 = sub_width / sub_height;
            r2 = display_width / display_height;

%             setappdata(0, 'contained_p', contained_p);
%             setappdata(0, 'r1', r1);
%             setappdata(0, 'r2', r2);
            app_data.contained_p = contained_p;
            app_data.r1 = r1;
            app_data.r2 = r2;

            set(gca, 'fontsize', 15); 
            % if the resizing pushes the window out of the border, this
            % command brings it back
            movegui(mainGUI);
        end

        % make the original image if diagnostic is on, otherwise work
        % only with linearized (or otherwise processed?) image
        log_color = app_data.log_color;
        if log_color
            imagesc(log10(abs(this_image)))
            hC = colorbar;
            set(hC, 'Ytick', log_range);
            set(hC, 'YTicklabel', 10 .^ log_range);
        else
            imagesc(this_image)
            colorbar
        end

        camera = app_data.camera;
        if camera.energy_camera
            energy_pixel = getappdata(0, 'energy_pixel');
            energy_ticks = getappdata(0, 'energy_ticks');
            set(gca, 'YTick', energy_pixel);
            set(gca, 'YTickLabel', energy_ticks);
        end

        colormap(sebas_colors)
        ylabel(camera.y_label_text, 'fontsize', 15); 
        xlabel('Pixels', 'fontsize', 15);

        if log_color
            set(gca, 'CLim', [log_range(1) log_range(end)]);
        elseif ~strcmp(curr_lim, 'auto')
            set(gca, 'CLim', curr_lim);
        end

        if exist('axis_limits_image', 'var')
            axis(draw_ROI);
        end

        % writing and drawing on the image
%         height_start = getappdata(0, 'height_start');
%         display_height = getappdata(0, 'display_height');
%         width_start = getappdata(0, 'width_start');
%         display_width = getappdata(0, 'display_width');
        height_start = app_data.height_start;
        display_height = app_data.display_height;
        width_start = app_data.width_start;
        display_width = app_data.display_width;

        % draws shot number textbox and stack specific setting if
        % multiple stacks            
        text(.02 * display_width + width_start, .03 * display_height + ...
            height_start, ['Shot: ' int2str(j) '/' int2str(num_images)], ...
            'color', 'w', 'backgroundcolor', 'b');

        if exist('stack_text','var')
            text(.02 * display_width + width_start, .1 * display_height ...
                + height_start, stack_text{i}, 'color', 'w', ...
                'backgroundcolor', 'blue');
        end
    end

    % linearizes by allowing user to select region of interest
    if linearize
        if (camera.energy_camera && ~check_linearize_ROI)    
            message = sprintf(['Please select region of interest to adjust ' ...
                'energy axis.\n Then double click on selection.']);
            b = msgbox(message, 'modal');
            set(groot, 'CurrentFigure', mainGUI);
            h = imrect;
            fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
            setPositionConstraintFcn(h,fcn);
            draw_ROI = wait(h);
%             setappdata(0, 'draw_ROI', draw_ROI);
%             setappdata(0, 'check_linearize_ROI', 1);
            app_data.draw_ROI = draw_ROI;
            app_data.check_linearize_ROI = 1;
            pushLoadImages_Callback(hObject, eventdata, handles);   
        end    
    end    

    % creates context menu to allow for displaying the current shot in a
    % seperate figure to enable figure tools
    m = uicontextmenu(mainGUI);
    z = uimenu(m, 'Label', 'Show Shot in New Figure', 'Callback', ...
        'showCurrentShotForNewFigure');
    set(mainGUI, 'uicontextmenu', m);
end