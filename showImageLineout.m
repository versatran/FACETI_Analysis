% READ
% This is a script that is called in lineouts.m under the functions
% pushNextShot_Callback, pushPreviousShot_Callback, editOfStack_Callback,
% and lineouts_OpeningFcn. 
% This script cannot run on its own. 
% The purpose of this script is to visually show the lineout in a figure.
% Based on image_processing_common_matter

% load necessary variables
num_stacks = getappdata(0,'num_stacks');
num_images = getappdata(0, 'num_images');
curr_lim = getappdata(0, 'curr_lim'); % for long oven sent to Mike
sebas_colors = sebasColorTable();
box_region = getappdata(0, 'box_region');
linearize = getappdata(0, 'linearize');
remove_xrays = getappdata(0, 'remove_xrays');
show_image = getappdata(0, 'show_image');
log_color = getappdata(0, 'log_color');
show_DC_sample = getappdata(0, 'show_DC_sample');
camera = getappdata(0, 'camera');
i = getappdata(0, 'i');
j = getappdata(0, 'j');

% get the current figure's handles
handles = guidata(gcf);

if (i == 1 && j == 1)
    % first image is being displayed - hide 'Push Previous Shot' button
    set(handles.pushPreviousShot, 'Visible', 'off');
end

% this checkpoint is for right after setting the ROI for linearizing 
if linearize
    check_linearize_ROI = getappdata(0, 'check_linearize_ROI');
    load_linearize_ROI = getappdata(0, 'load_linearize_ROI');
    
    if check_linearize_ROI
        draw_ROI = getappdata(0, 'draw_ROI');
        setappdata(0, 'load_linearize_ROI', 1);
        load_linearize_ROI = getappdata(0, 'load_linearize_ROI');
    end
end

curr_image = (i - 1) * num_images + j;
setappdata(0, 'curr_image', curr_image);

load_noiseless_images_15_edited(curr_image);

this_image = getappdata(0, 'this_image');

% first do the process
lineout(i, j, :) = sum(this_image(:, box_region), 2);

% show the image 
if show_image % fix for odd(1) or even(0)
    image_axis = subplot(1, 2, 1);
    if curr_image == 1
        if exist('draw_ROI', 'var')
            display_width = draw_ROI(3);
            display_height = draw_ROI(4);
            width_start = 1;
            height_start = 1;
            setappdata(0, 'height_start', height_start);
            setappdata(0, 'width_start', width_start);
            
            if exist('axis_limits_lineout', 'var')
                axis_limits_lineout(3) = draw_ROI(3);
                axis_limits_lineout(4) = draw_ROI(4);
            end
        else
            horizsize = getappdata(0, 'horizsize');
            vertsize = getappdata(0, 'vertsize');
            display_width = horizsize;
            display_height = vertsize;
            setappdata(0, 'display_width', display_width);
            setappdata(0, 'display_height', display_height);
            width_start = 1;
            height_start = 1;
            setappdata(0, 'height_start', height_start);
            setappdata(0, 'width_start', width_start);
        end
        
        % TODO: this will need to be set by me eventially!
        contained_p = get(handles.figureLineouts, 'position');
        sub_p = get(image_axis, 'position');
        sub_width = sub_p(3) * contained_p(3);
        sub_height = sub_p(4) * contained_p(4);
        r1 = sub_width / sub_height;
        r2 = display_width / display_height;

        setappdata(0, 'contained_p', contained_p);
        setappdata(0, 'r1', r1);
        setappdata(0, 'r2', r2);
        
%         % into the large container
%         if (manual_set_figure_position)
%             % TODO: this was written for positron lineout images. 
%             % will eventually need to make this run auto. 
%             set(gcf,'position',[360   335   728   479])
%         else
%             contained_p = getappdata(0, 'contained_p');
%             r1 = getappdata(0, 'r1');
%             r2 = getappdata(0, 'r2');
%            
%             set(gcf,'position',[contained_p(1) contained_p(2) contained_p(3) contained_p(4)*r1/r2]);
%         end

        set(gca, 'fontsize', 15); 
        
        %If the resizing pushes the window out of the border, this
        %command brings it back
        movegui(handles.figureLineouts);
    end        
    % make the original image if diagnostic is on, otherwise work
    % only with linearized (or otherwise processed?) image
    if log_color
        imagesc(log10(abs(this_image)))
        hC = colorbar;
        set(hC, 'Ytick', log_range);
        set(hC, 'YTicklabel', 10 .^ log_range);
    else
        imagesc(this_image)
        colorbar
    end
    
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
    height_start = getappdata(0, 'height_start');
    display_height = getappdata(0, 'display_height');
    display_width = getappdata(0, 'display_width');
    width_start = getappdata(0, 'width_start');
    rectangles= [box_region(1) height_start box_region(end) - box_region(1) ...
        display_height];                    
    size_rectangles = size(rectangles);
    
    for k = 1:size_rectangles(1)
        rectangle('position', rectangles(k, :), 'edgecolor', 'k', ...
            'linewidth', 1.5, 'linestyle', '--')
    end
    
%             if manual_energy
%                 if j==1
%                     disp('Select y location for energy gain, then energy loss.\n');
%                 end
%                 [~,energy_y,button]=ginput(2);
%                 if button(1)==1
%                     top_frac(i,j)=round(energy_y(1));
%                     bottom_frac(i,j)=round(energy_y(2));
%                 else
%                     top_frac(i,j)=round(interp1(linear_energy_scale,1:vertsize,...
%                         energy_calib_vector(camera.zero_Gev_px)));
%                     bottom_frac(i,j)=top_frac(i,j);
%                     if exist('noint_shot','var')
%                         noint_shot(end+1)=j;
%                     else
%                         noint_shot=j;
%                     end
%                 end
%             end

    if (show_DC_sample && ~linearize)
        rectangle('position', DC_sample, 'linewidth', 2, 'linestyle', '--');
    end
    
    text(.02 * display_width + width_start, .03 * display_height + ...
        height_start, ['Shot: ' int2str(j) '/' int2str(num_images)], ...
        'color', 'w', 'backgroundcolor', 'b');
    
    if exist('stack_text', 'var')
        text(.02 * display_width + width_start, .1 * display_height + ...
            height_start, stack_text{i}, 'color', 'w', 'backgroundcolor', ...
            'blue');
    end
    
    subplot(1, 2, 2)
    plot(squeeze(lineout(i, j, :)), 1:length(squeeze(lineout(i, j, :))), ...
        'linewidth', 2.5);
    set(gca, 'fontsize', 15);
    % NOTE: following line of code can result in an error if the max value
    % for a given lineout is non-positive
    %axis([0, max(lineout(i, j, :)), 0, length(squeeze(lineout(i, j, :)))])
    % ADDED: let's try the following to see if it will fix this issue
    if (max(lineout(i, j, :)) <= 0)
        axis([max(lineout(i, j, :)), 0, 0, length(squeeze(lineout(i, j, :)))]);
    else
        axis([0, max(lineout(i, j, :)), 0, length(squeeze(lineout(i, j, :)))]);
    end
    set(gca, 'YDir', 'reverse')
    
    if exist('axis_limits_lineout', 'var')
        axis(axis_limits_lineout);
    end
    
    if camera.energy_camera  
        set(gca, 'YTick', energy_pixel)
    end
    
    grid
end