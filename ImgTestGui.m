% Note: This code is the main GUI that is first run in order to do image
% processing. This is based primarily off of image_processing_common_matter. 
% This is roughly the GUI version of that code.
function varargout = ImgTestGui(varargin)
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @ImgTestGui_OpeningFcn, ...
                       'gui_OutputFcn',  @ImgTestGui_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if (nargin && ischar(varargin{1}))
        gui_State.gui_Callback = str2func(varargin{1});
    end
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end % End initialization code - DO NOT EDIT
end

% --- Executes just before ImgTestGui is made visible.
function ImgTestGui_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % UIWAIT makes ImgTestGui wait for user response (see UIRESUME)
    % uiwait(handles.figureImgTestGui);

    % Choose default command line output for ImgTestGui
    handles.output = hObject;
    set(gcf, 'color', [1,1,1]);

    % set inital values for various variables used throughout this code. These
    % values can be changed in the options menu. See options();
    setappdata(0, 'remote', 1); 
    setappdata(0, 'skip_background_verification', 0);
    setappdata(0, 'linearize', 0);
    setappdata(0, 'show_image', 1);
    setappdata(0, 'DC_offset', 1);
    setappdata(0, 'save_video', 1);
    setappdata(0, 'save_data', 1);
    setappdata(0, 'save_override', 0);
    setappdata(0, 'show_noise_sample', 1);
    setappdata(0, 'remove_xrays', 1);
    setappdata(0, 'show_DC_sample', 0);
    setappdata(0, 'manual_energy', 1);
    setappdata(0, 'log_color', 0);
    setappdata(0, 'manual_set_figure_position', 1);
    setappdata(0, 'background_checked', 0);
    setappdata(0, 'scale_adjustment', 0.95);
    setappdata(0, 'curr_lim', [0 5000]);
    setappdata(0, 'curr_lim1', 0);
    setappdata(0, 'curr_lim2', 5000);

    % handle source directory selection
    if isunix
        % attempt to locate a default 'nas' directory using the macOS
        % 'mdfind' command (similar to Spotlight Search)
        [~, source_dir] = system('mdfind nas | grep nas$');
        
        % format the obtained source directory
        source_dir = strtrim(source_dir);
        [source_dir, ~, ~] = fileparts(source_dir);
        source_dir = [source_dir filesep];
        
        % check if an appropriate source directory was selected
        if exist(source_dir, 'dir') ~= 7
            % could not find default directory - allow the user to select a
            % source directory manually
            changeSourceDirectoryButton_Callback( ...
                handles.changeSourceDirectoryButton, eventdata, handles);
        else
            % valid source directory found

            % set these initial inputs for loading a dataset
            setappdata(0, 'source_dir', source_dir);

            % populate source directory text box with selected/default text
            set(handles.staticSourceDir, 'String', source_dir);

            % populate server pop-up menu with possible servers to choose from
            set(handles.serverPopUpMenu, 'String', ...
                getSubDirectoryList([source_dir 'nas']));
            set(handles.serverPopUpMenu, 'enable', 'on');

            % select the first list item by default
            set(handles.serverPopUpMenu, 'Value', 1);
            serverPopUpMenu_Callback(handles.serverPopUpMenu, eventdata, ...
                handles);
        end
    else
        % non-UNIX operating system; for now just allow user to select
        % source directory manually
        % TODO: perform non-UNIX equivalent of a Spotlight Search to find a
        % good default source directory
        
        % prompt the user to select a source directory
        uiwait(msgbox(['Please select the directory containing the ' ...
            'NAS (Network Attached Storage) you would like to use.']));
        % allow the user to select a source directory
        changeSourceDirectoryButton_Callback( ...
                handles.changeSourceDirectoryButton, eventdata, handles);
    end

    set(handles.figureImgTestGui, 'Resize', 'on');
    set(handles.figureImgTestGui, 'Position', [30 19.2308 150.8 45]);

    % Update handles structure
    guidata(hObject, handles);
end

% --- Outputs from this function are returned to the command line.
function varargout = ImgTestGui_OutputFcn(~, ~, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end

% --- Executes when user attempts to close figureImgTestGui.
function figureImgTestGui_CloseRequestFcn(hObject, ~, ~)
    % Since I have set so many variables in the root directory using
    % setappdata/getappdata I need to eventually remove all of the data. Can be
    % fixed by setting the variables using setappdata(figureImgTestGui...)
    % which automatically deletes variables when the program closes.
    
    % inform user that the application is closing
    dialogue = msgbox('Cleaning up...');
    
    % delete app data
    deleteAppData();
    
    % close the dialogue if it is still open
    try
        close(dialogue);
    catch
        % user already closed the dialogue box
    end

    % close figure
    delete(hObject);
end


%==========================================================================
%=========================GUI Creation Functions===========================
%==========================================================================
% 
% These functions execute during object creation, after setting all
% properties
%
% Inputs:
%   hObject    handle to serverPopUpMenu (see GCBO)
%   eventdata  reserved - to be defined in a future version of MATLAB
%   handles    empty - handles not created until after all CreateFcns called


function sliderImageView_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), ...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

function editOfStack_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function editGoToShot_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function serverPopUpMenu_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function experimentPopUpMenu_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function yearPopUpMenu_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function datePopUpMenu_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function datasetPopUpMenu_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


%==========================================================================
%========================Callbacks=========================================
%==========================================================================
%
% These functions are called upon user interaction with the GUI.
%
% Inputs:
%   hObject    handle to serverPopUpMenu (see GCBO)
%   eventdata  reserved - to be defined in a future version of MATLAB
%   handles    structure with handles and user data (see GUIDATA)


function pushLoadDataSet_Callback(~, ~, ~)
    % inform user that camera selection dialog will pop up soon
    m1 = msgbox('Loading data, one moment please...');

    % get parts of path input by user from textboxes
    source_dir = getappdata(0, 'source_dir');
    server_str = getappdata(0, 'server_str');
    expt_str = getappdata(0, 'expt_str');
    date_str = getappdata(0, 'date_str');
    dataset_str = getappdata(0, 'dataset_str');

    % creates the path to dataset from user input
    data_path = [source_dir server_str expt_str filesep date_str(1:4) ...
        filesep date_str filesep expt_str '_' dataset_str filesep expt_str ...
        '_' dataset_str '.mat'];
    setappdata(0, 'data_path', data_path);

    % load data
    data = E200_load_data(data_path, expt_str);
    setappdata(0, 'data', data);
    setappdata(0, 'dataorig', data);

    cameraNames();
    
    % close the message box if it is still open
    try
        close(m1);
    catch
        % message box was closed by user - do not generate an error
    end
end

% This function creates a waterfall plot from sorted lineouts based on a
% specified parameter. Always creates a fresh set of lineouts before making
% a new plot.
function menuWaterfall_Callback(~, ~, ~)
    saveLineouts;
    sort_selected_snapshot_by_var_edited;
end

% This functions opens the options menu where variables that are not
% changed often are put
function menuOptions_Callback(~, ~, ~)
    % These set the checks in the checkboxes based on if the variables are 1 or
    % 0 and put current values for variables 
    optionsHandles = guihandles(options);
    optionsHandles.checkRemote.Value = getappdata(0, 'remote');
    optionsHandles.checkSkipBackground.Value = getappdata(0, ...
        'skip_background_verification');
    optionsHandles.checkLinearize.Value = getappdata(0, 'linearize');
    optionsHandles.checkShowImage.Value = getappdata(0, 'show_image');
    optionsHandles.checkDCOffset.Value = getappdata(0, 'DC_offset');
    optionsHandles.checkSaveVideo.Value = getappdata(0, 'save_video');
    optionsHandles.checkSaveData.Value = getappdata(0, 'save_data');
    optionsHandles.checkSaveOverride.Value = getappdata(0, 'save_override');
    optionsHandles.checkShowNoiseSample.Value = getappdata(0, ...
        'show_noise_sample');
    optionsHandles.checkRemoveXRays.Value = getappdata(0, 'remove_xrays');
    optionsHandles.checkShowDCSample.Value = getappdata(0, 'show_DC_sample');
    optionsHandles.checkManualEnergy.Value = getappdata(0, 'manual_energy');
    optionsHandles.checkLogColor.Value = getappdata(0, 'log_color');
    optionsHandles.checkManualSetFigure.Value = getappdata(0, ...
    'manual_set_figure_position');
    optionsHandles.checkBackgroundCheck.Value = getappdata(0, ...
        'background_checked');
    optionsHandles.editScaleAdjustment.String = getappdata(0, ...
        'scale_adjustment');
    optionsHandles.editCurrentLimit1.String = getappdata(0, 'curr_lim1');
    optionsHandles.editCurrentLimit2.String = getappdata(0, 'curr_lim2');

    options();
end

function menuLoadNewCamera_Callback(~, ~, ~)
    % This should be selected if you want to load a new camera from a data set 
    % that is already loaded
    cameraNames();
end

function pushPreviousShot_Callback(~, ~, handles)
    % assumes that there will always be a next shot if previous shot is pressed
    set(handles.pushNextShot, 'Visible', 'on');
    
    % get necessary variables
    camera = getappdata(0, 'camera');
    stack_text = getappdata(0, 'stack_text');
    bend_struc = getappdata(0, 'bend_struc');
    num_images = getappdata(0, 'num_images');
    i = getappdata(0, 'i');
    j = getappdata(0, 'j');
    axes = gca();
    CLim = axes.CLim;
    
    % set curr_lim (which may have changed if imcontrast was used)
    setappdata(0, 'curr_lim', CLim);
    
    if j == 1
        % if going to a new stack change camera structure if using energy
        % camera
        if camera.energy_camera 
            if (isfield(bend_struc, 'variable_bend') && ...
                    bend_struc.variable_bend)
                camera.dipole_bend = bend_struc.dipole_multiplier_values(i - 1);
                camera.zero_Gev_px = bend_struc.zero_Gev_px_vector(i - 1);                        
            end
            if camera.dipole_bend ~= 1
                if ~contains(stack_text{i - 1}, 'Dipole')
                    stack_text{i - 1} = ['Dipole=' ...
                        num2str(camera.dipole_bend, 2) ', ' stack_text{i - 1}];
                    setappdata(0, 'stack_text', stack_text);
                end
            end
        end
    end
    
    if j > 2
        % there is a previous image in the current stack to display
        j = j - 1;
        setappdata(0, 'j', j);
        ImgTestGui_ShowImage;
    elseif (j == 2 && i == 1)
        % the previous image is the first in the current stack and
        % there is no stack before the current one, so hide the 
        % 'Push Previous Shot' button
        set(handles.pushPreviousShot, 'Visible', 'off');
        j = j - 1;
        setappdata(0, 'j', j);
        ImgTestGui_ShowImage;
    elseif j == 2
        % there are more stacks before the current one, so do not hide the
        % 'Push Previous Shot' button
        j = j - 1;
        setappdata(0, 'j', j);
        ImgTestGui_ShowImage;
    else
        % the first image in the current stack is currently being
        % displayed and there is another stack before the current one, so
        % show the last image in the previous stack
        i = i - 1;
        j = num_images;
        setappdata(0, 'i', i);
        setappdata(0, 'j', j);
        ImgTestGui_ShowImage;
    end
end

function pushNextShot_Callback(~, ~, handles)
    % assumes that there will always be a previous shot if next shot is pressed
    set(handles.pushPreviousShot, 'Visible', 'on');

    % get necessary variables
    camera = getappdata(0, 'camera');
    num_stacks = getappdata(0, 'num_stacks');
    num_images = getappdata(0, 'num_images');
    stack_text = getappdata(0, 'stack_text');
    bend_struc = getappdata(0, 'bend_struc');
    i = getappdata(0, 'i');
    j = getappdata(0, 'j');
    axes = gca();
    CLim = axes.CLim;
    
    % set curr_lim (which may have changed if imcontrast was used)
    setappdata(0, 'curr_lim', CLim);
    
    if j == num_images
        % if going to a new stack change camera structure if using energy
        % camera
        if camera.energy_camera
            if (isfield(bend_struc, 'variable_bend') && ...
                    bend_struc.variable_bend)
                camera.dipole_bend = bend_struc.dipole_multiplier_values(i + 1);
                camera.zero_Gev_px = bend_struc.zero_Gev_px_vector(i + 1);
            end
            if camera.dipole_bend ~= 1
                if ~contains(stack_text{i + 1}, 'Dipole')
                    stack_text{i + 1} = ['Dipole=' ...
                        num2str(camera.dipole_bend, 2) ', ' stack_text{i + 1}];
                    setappdata(0, 'stack_text', stack_text);
                end
            end
        end
    end
    
    if (j == num_images - 1 && i == num_stacks)
        % second to last image is currently being displayed - hide 'Next
        % Shot' button so that the user cannot try to show image that don't
        % exist
        set(handles.pushNextShot, 'Visible', 'off');
    end
    
    if j == num_images
        % the last image of a stack is currently being displayed
        if i < num_stacks
            % there are more stacks, so go to the next one
            i = i + 1;
            j = 1;
            setappdata(0, 'i', i);
            setappdata(0, 'j', j);
            ImgTestGui_ShowImage;
        end
    else
        % there are more images in the current stack to display
        j = j + 1;
        setappdata(0, 'j', j);
        ImgTestGui_ShowImage;
    end
end

% Implement viewing options here
% --------------------------------------------------------------------
% This function takes the stack number inputted by the user, the shot
% number taken from editGoToShot and displays the specified image
function menuViewAll_Callback(~, ~, ~)
    % allow user to select how many images to display
    num_img_shown = str2double(inputdlg(['How many images would you like ' ...
        'to show at once?']));
    
    % load necessary variables
    camera = getappdata(0, 'camera');
    num_images = getappdata(0, 'num_images');
    stack_text = getappdata(0, 'stack_text');
    bend_struc = getappdata(0, 'bend_struc');
    sebas_colors = sebasColorTable();
    subplot_columns = 5;

    i = 1;
    j = 1;
    counter = 1;
    if (j == num_images || (j == 1 && i == 1)) 
        % if going to a new stack change camera structure if using energy camera  
        % also acounts for the first stack
        if camera.energy_camera 
            if (isfield(bend_struc, 'variable_bend') && ...
                    bend_struc.variable_bend)
                camera.dipole_bend = bend_struc.dipole_multiplier_values(i);
                camera.zero_Gev_px = bend_struc.zero_Gev_px_vector(i);                        
            end
            if camera.dipole_bend ~= 1
                stack_text{i} = ['Dipole=' ...
                    num2str(camera.dipole_bend,2) ', ' stack_text{i}];
                setappdata(0, 'stack_text', stack_text);
            end
        end   
    end
    % sort shots option
    % sorts by taking the index values from sorting by a parameter (assumes
    % sort_selected_snapshot_by_var_edited is run beforehand)
    sort_q = questdlg('Would you like to see shots sorted');

    switch sort_q
        case 'Yes'
            for counter = 1:num_img_shown 
                index_sorted_UID = getappdata(0, 'index_sorted_UID');
                j = index_sorted_UID(counter);
                curr_image = j;
                setappdata(0, 'curr_image', curr_image);
                
                load_noiseless_images_15_edited;

                this_image = getappdata(0, 'this_image');
                %%%%%%%%%%%%%%%%%
                % show the image 
                %     if show_image && mod(j,2)==1 %Fix For odd(1) or even(0)
                if counter == 1 
                    main_canvas = figure(40);
                    subplot_rows = ceil(num_img_shown / subplot_columns);

                    set(main_canvas, 'position', [100 350 500 500])
                    set(main_canvas, 'color', [1 1 1]);
                    set(main_canvas, 'Name', ['Sorted by ' getappdata(0, ...
                        'sort_parameter')])
                    movegui(40);
                    % set(gca,'position',[0.02 0.02 0.96 0.96])
                end

                subplot(subplot_rows, subplot_columns, counter)
                % make the original image if diagnostic is on, otherwise work
                % only with linearized (or otherwise processed?) image
                if camera.energy_camera
                    imagesc(this_image)
                    energy_pixel = getappdata(0, 'energy_pixel');
                    energy_ticks = getappdata(0, 'energy_ticks');
                    set(gca, 'YTick', energy_pixel);
                    set(gca, 'YTickLabel', energy_ticks);            
                else
                    imagesc(this_image)
                end        
                colormap(sebas_colors)
                set(gca, 'clim', [120 1000])
                % ylabel(y_label_text,'fontsize',15); 
                % xlabel('pixels','fontsize',15);
                disp(num2str(j));
            end
        otherwise
            for j = 1:num_img_shown        
                curr_image = j;
                setappdata(0, 'curr_image', curr_image);
                
                load_noiseless_images_15_edited;

                this_image = getappdata(0, 'this_image');
                %%%%%%%%%%%%%%%%%
                % show the image 
                %     if show_image && mod(j,2)==1 %Fix For odd(1) or even(0)
                if counter == 1 
                    main_canvas = figure(40);
                    subplot_rows = ceil(num_img_shown / subplot_columns);

                    set(main_canvas, 'position', [100 350 500 500])
                    movegui(40);
                    % set(gca, 'position', [0.02 0.02 0.96 0.96])
                end

                subplot(subplot_rows, subplot_columns, j)
                % make the original image if diagnostic is on, otherwise work
                % only with linearized (or otherwise processed?) image
                if camera.energy_camera
                    imagesc(this_image)
                    energy_pixel = getappdata(0, 'energy_pixel');
                    energy_ticks = getappdata(0, 'energy_ticks');
                    set(gca, 'YTick', energy_pixel);
                    set(gca, 'YTickLabel', energy_ticks);            
                else
                    imagesc(this_image)
                end        
                colormap(sebas_colors)
                set(gca, 'clim', [120 1000])
                % ylabel(y_label_text,'fontsize',15); 
                % xlabel('pixels','fontsize',15);
                counter = counter + 1; 
                disp(num2str(j));
            end
    end
end

% Creates lineouts for each shot and saves them in data structure
function menuSaveLineouts_Callback(~, ~, ~)
    dataset_str = getappdata(0, 'dataset_str');
    outputdir = ['E:/Sorting Output Directory/' dataset_str '/'];
    % outputdir = ['/Users/Navid/Library/Mobile Documents/' ...
    %    'com~apple~CloudDocs/Lab Work/' date_str(1:4) ' FACET Analysis/'];
    % % for confirmation of outputdir but not needed when only saving lineouts in
    % % data structure
    % q1 = questdlg(['The output directory is ' outputdir ...
    %     ' Would you like to change it?']);
    % switch q1
    %     case 'Yes'
    %         q1 = uigetdir;
    %         setappdata(0, 'outputdir', q1)
    %         saveLineouts;
    %     case 'No'
    %         saveLineouts;
    %     otherwise   
    %         msgbox(['Please confirm the output directory where ' ...
    %             'data will be saved']);
    % end
    setappdata(0, 'outputdir', outputdir);
    saveLineouts;
end

function menuViewLineouts_Callback(~, ~, ~)
    % prompt user for starting line and ending line of region of interest for 
    % lineout
    name = 'Range of Lineout'; 
    a = inputdlg('Enter start of lineout:', name);
    box_region_start = a{1};
    b = inputdlg('Enter end of lineout:', name);
    box_region_end = b{1};
    box_region = str2double(box_region_start):str2double(box_region_end);
    setappdata(0, 'box_region', box_region);
    m3_cmt = ['lineout of range ' box_region_start ':' box_region_end];
    setappdata(0, 'cmt_str', m3_cmt);
    uiwait(msgbox(m3_cmt, 'Range of Lineout'));
    
    lineouts();
end

% This function calculates energies with 0.02 contour of lineouts.
% saveLineouts must run before this.
function menuEnergyLimits_Callback(~, ~, ~)
    eda_energy_limits;
end

% Plots calcualted energy gain/loss with sorted parameter. saveLineouts,
% sort_selected_snapshot_by_var_edited, and eda_energy_limits must run before
% this in that order
function menuPlotEnergyWithSortedValue_Callback(~, ~, ~)
    plot_energy_with_sorted_value;
end

% This function allows you to create a correlation plot of any two
% parameters in dataset. You can sort by the x parameter chosen
function menuCorrelate_Callback(~, ~, ~)
    dataset_str = getappdata(0, 'dataset_str');
    data = getappdata(0, 'data');

    % get parameter names for data set
    scalar_struc = data.raw.scalars;
    scalars = fieldnames(scalar_struc);
    num_parameters = length(scalars);
    
    % create empty cell array for converted parameters with more user friendly 
    % definitions
    
    converted_parameters = cell(num_parameters + 3,1);
    
    % convert to user friendly defined parameters
    for i = 1:num_parameters
            converted_parameters{i} = eda_extract_data_for_list(scalars{i});
    end
    
    % these are calculated in nvn_extract_data, they are not parameters in data
    converted_parameters{num_parameters + 1, 1} = 'excess_charge_USBPM1_DSBPM1';
    converted_parameters{num_parameters + 2, 1} = 'excess_charge_USBPM1_DSBPM2';
    converted_parameters{num_parameters + 3, 1} = ...
        'excess_charge_UStoro1_DStoro1';
    
    % prompt user to select x and y parameters
    [s, ~] = listdlg('PromptString', 'Select x-axis parameter', ...
        'SelectionMode', 'single', 'ListString', converted_parameters);
    x_param = converted_parameters{s};
    [a, ~] = listdlg('PromptString', 'Select y-axis parameter', ...
        'SelectionMode', 'single', 'ListString', converted_parameters);
    y_param = converted_parameters{a};

    % get x and y values
    [x_UID, x_values] = eda_extract_data(data, x_param, s);
    [y_UID, y_values] = eda_extract_data(data, y_param, a);

    % ask to sort x parameter. If selected, sorts x parameter and rearranges y
    % parameter values following the sorted indexes
    sort_q = questdlg('Would you like your x_parameter sorted?');

    switch sort_q
        case 'Yes'
            % make the sort vector from x parameter
            unique_sort_id = unique(x_UID);
            if length(unique_sort_id) ~= length(x_UID)
                error(['repetative UIDs exist in the sort dataset. Program ' ...
                    'terminated']);
            end
            [Y1, I1] = sort(x_values);        
            sorted_UID = x_UID(I1);

            % match the UIDs with the parameter values. This discards parameter
            % values that do not have an associated shot to create vectors of
            % same length
             j = 1;
             [~, index_y_UID_matched, index_sorted_UID] = ...
                 intersect(sorted_UID, y_UID(j, :), 'stable');

            matched_y_values(j, :) = y_values(j, index_sorted_UID);    
            revised_UID(j, :) = sorted_UID(index_y_UID_matched);
            sorted_x_values(j, :) = Y1(index_y_UID_matched);

            % creates plot
            c = figure('Name', ['Correlation Plot of ' x_param ' with ' ...
                y_param ' ' dataset_str]);
            
            set(c, 'color', [1,1,1]);
            plot(sorted_x_values, matched_y_values);
            plot_title = title([x_param ' vs. ' y_param]);
            plot_xlabel = xlabel(x_param);
            plot_ylabel = ylabel(y_param);
            set(plot_xlabel, 'Interpreter', 'none');
            set(plot_title, 'Interpreter', 'none');
            set(plot_ylabel, 'Interpreter', 'none');
        otherwise
            % creates non-sorted plot. The lengths of these parameters are
            % longer than the number of shots taken for the dataset
            c = figure('Name', ['Correlation Plot of ' x_param ' with ' ...
                y_param ' ' dataset_str]);
            set(c, 'color', [1,1,1]);
            scatter(x_values, y_values);
            plot_title = title([x_param ' vs. ' y_param]);
            plot_xlabel = xlabel(x_param);
            plot_ylabel = ylabel(y_param);
            set(plot_xlabel, 'Interpreter', 'none');
            set(plot_title, 'Interpreter', 'none');
            set(plot_ylabel, 'Interpreter', 'none');
    end
    % creates the "linecut" option in the taskbar
    linecut_option = uimenu(c, 'Text', 'Linecut');
    uimenu(linecut_option, 'Text', 'Apply Current Conditions', 'Callback', @apply_Callback);
    uimenu(linecut_option, 'Text', 'Save Conditions', 'Callback', @openSave);
    uimenu(linecut_option, 'Text', 'Load Conditions', 'Callback', @openLoad);
    uimenu(linecut_option, 'Text', 'View Conditions', 'Separator', 'on', 'Callback', @openViewConditions);
    uimenu(linecut_option,'Label','Add Conditions', 'Callback', @openAddConditions);       
    item_deleteConditions = uimenu(linecut_option, 'Label', 'Delete');
    uimenu(item_deleteConditions, 'Label', 'Delete All Conditions', ... 
        'Callback', @deleteAll_Callback);
    uimenu(item_deleteConditions, 'Label', 'Delete a Condition', 'Callback', @deleteOne);
    
    % opens "addConditionsGui"
    function apply_Callback(~,~,~)
        linecutOptions('get_x', x_UID, x_values);
        linecutOptions('get_y', y_UID, y_values);
    end
    function openAddConditions(~,~,~)
        linecutOptions('add', converted_parameters);
    end
    function openSave(~,~,~)
        linecutOptions('save');
    end
    function openLoad(~,~,~)
        linecutOptions('load');
    end
    function deleteAll_Callback(~,~,~)
        linecutOptions('deleteAll');
    end
    function openViewConditions(~,~,~)
        linecutOptions('view');
    end
    function deleteOne(~,~,~)
        linecutOptions('delete');
    end
end





function serverPopUpMenu_Callback(hObject, eventdata, handles)
    expPopUpMenu = handles.experimentPopUpMenu;
    source_dir = getappdata(0, 'source_dir');
    
    
    values = get(hObject, 'String');
    server_str = ['nas' filesep values{get(hObject, 'Value')} filesep];
    setappdata(0, 'server_str', server_str);
    set(expPopUpMenu, 'String', getSubDirectoryList([source_dir server_str]));
    set(expPopUpMenu, 'enable', 'on');
    set(expPopUpMenu, 'Value', 1);
    experimentPopUpMenu_Callback(handles.experimentPopUpMenu, eventdata, ...
        handles);
    %deleting the above line of code will properly grab a path but will not
    %load dataset
end


%BRIANNA NOTE: can we document what each function does
function experimentPopUpMenu_Callback(hObject, eventdata, handles)
    yearPopUpMenu = handles.yearPopUpMenu;
    source_dir = getappdata(0, 'source_dir');
    server_str = getappdata(0, 'server_str');
    values = get(hObject, 'String');
    expt_str = values{get(hObject, 'Value')};
    setappdata(0, 'expt_str', expt_str);
    set(yearPopUpMenu, 'String', ...
        getSubDirectoryList([source_dir server_str expt_str]));
    set(yearPopUpMenu, 'enable', 'on');
    set(yearPopUpMenu, 'Value', 1);
    yearPopUpMenu_Callback(handles.yearPopUpMenu, eventdata, handles);
end

function yearPopUpMenu_Callback(hObject, eventdata, handles)
    datePopUpMenu = handles.datePopUpMenu;
    source_dir = getappdata(0, 'source_dir');
    server_str = getappdata(0, 'server_str');
    expt_str = getappdata(0, 'expt_str');
    values = get(hObject, 'String');
    year_str = values{get(hObject, 'Value')};
    setappdata(0, 'year_str', year_str);
    set(datePopUpMenu, 'String', ...
        getSubDirectoryList([source_dir server_str expt_str filesep year_str]));
    set(datePopUpMenu, 'enable', 'on');
    set(datePopUpMenu, 'Value', 1);
    datePopUpMenu_Callback(handles.datePopUpMenu, eventdata, handles);
end

function datePopUpMenu_Callback(hObject, eventdata, handles)
    datasetPopUpMenu = handles.datasetPopUpMenu;
    source_dir = getappdata(0, 'source_dir');
    server_str = getappdata(0, 'server_str');
    expt_str = getappdata(0, 'expt_str');
    year_str = getappdata(0, 'year_str');
    values = get(hObject, 'String');
    date_str = values{get(hObject, 'Value')};
    setappdata(0, 'date_str', date_str);
    subDirList = getSubDirectoryList([source_dir server_str expt_str filesep ...
        year_str filesep date_str]);
    formattedSubDirList = cell(1, length(subDirList));
    for k = 1:length(subDirList)
        formattedSubDirList{k} = getDatasetString(subDirList{k});
    end
    set(datasetPopUpMenu, 'String', formattedSubDirList);
    set(datasetPopUpMenu, 'enable', 'on');
    set(datasetPopUpMenu, 'Value', 1);
    datasetPopUpMenu_Callback(handles.datasetPopUpMenu, eventdata, handles);
end
    
function datasetPopUpMenu_Callback(hObject, ~, handles)
    values = get(hObject, 'String');
    dataset_str = values{get(hObject, 'Value')};
    setappdata(0, 'dataset_str', dataset_str);
    % set output directory 
    outputdir = ['R:/Lab Work/FACET Analysis/' dataset_str '/'];
    setappdata(0, 'outputdir', outputdir);
    % enable 'load dataset' button
    set(handles.pushLoadDataSet, 'enable', 'on');
    % save 'handles' struct changes
    guidata(hObject, handles);
end

function changeSourceDirectoryButton_Callback(~, eventdata, handles)
    % populate source directory text box with selected/default text
    source_dir = getSourceDirectory(); 
    set(handles.staticSourceDir, 'String', source_dir);

    % populate server pop-up menu with possible servers to choose from
    set(handles.serverPopUpMenu, 'String', getSubDirectoryList([source_dir ...
        'nas']));
    set(handles.serverPopUpMenu, 'enable', 'on');

    % select the first list item by default
    
    set(handles.serverPopUpMenu, 'Value', 1);
    
    
    % set these initial inputs for loading a dataset
    % BRIANNA NOTE: Switched the following two lines of code and fixed an
    % error. 
    setappdata(0, 'source_dir', source_dir);
    
    serverPopUpMenu_Callback(handles.serverPopUpMenu, eventdata, handles); 

end

function jumpToShotButton_Callback(~, ~, handles)
    % get necessary variables
    camera = getappdata(0, 'camera');
    num_stacks = getappdata(0, 'num_stacks');
    num_images = getappdata(0, 'num_images');
    stack_text = getappdata(0, 'stack_text');
    bend_struc = getappdata(0, 'bend_struc');
    axes = gca();
    CLim = axes.CLim;
    
    % set curr_lim (which may have changed if imcontrast was used)
    setappdata(0, 'curr_lim', CLim);
    
    i = str2double(get(handles.editOfStack, 'String'));
    j = str2double(get(handles.editGoToShot, 'String'));
    if (~isnan(i) && ~isnan(j) && validImageIndices(i, j))
        % image indices are valid - jump to the requested image
        newStack = i ~= getappdata(0, 'i');   % indicates jumping to a new stack
        setappdata(0, 'i', i);
        setappdata(0, 'j', j);
        
        % if user specified the first shot of first stack, previous shot button 
        % disappears
        if (j == 1 && i ==1) 
           set(handles.pushPreviousShot, 'Visible', 'off');
        else 
           set(handles.pushPreviousShot, 'Visible', 'on');
        end

        if newStack
            % if going to a new stack change camera structure if using energy 
            % camera also acounts for the first stack
            if camera.energy_camera 
                if (isfield(bend_struc, 'variable_bend') && ...
                        bend_struc.variable_bend)
                    camera.dipole_bend = bend_struc.dipole_multiplier_values(i);
                    camera.zero_Gev_px = bend_struc.zero_Gev_px_vector(i);                        
                end
                if camera.dipole_bend ~= 1
                    if ~contains(stack_text{i}, 'Dipole')
                        stack_text{i} = ['Dipole=' ...
                            num2str(camera.dipole_bend, 2) ', ' stack_text{i}];
                        setappdata(0, 'stack_text', stack_text);
                    end
                end
            end
        end
        
        % display the image
        ImgTestGui_ShowImage;

        if (j == num_images && i == num_stacks) % removes button to prevent user 
                                                % from clicking onward
            set(handles.pushNextShot, 'visible', 'off');
        else
            set(handles.pushNextShot, 'visible', 'on');
        end
    else
        % image indices are invalid, either because they are not numbers
        % (e.g. user entered 'one' instead of '1') or because they do not
        % fall within the valid range of indices for the current dataset
        
        % determine the cause of the invalid indices, and inform the user
        % accordingly
        if (isnan(i) && isnan(j))
            % text entered in both stack index and image index boxes
            % cannot be converted to a number
            uiwait(msgbox('Both shot and stack indices must be numbers.'));
        elseif (isnan(i) && ~isnan(j))
            % text entered in image index box can be converted to a
            % number, but text entered in stack index box cannot
            uiwait(msgbox('Stack index must be a number.'));
        elseif (~isnan(i) && isnan(j))
            % text entered in stack index box can be converted to a
            % number, but text entered in image index box cannot
            uiwait(msgbox('Image index must be a number.'));
        else
            % text entered in both stack index and image index boxes can be
            % converted to numbers, but the numbers themselves are not
            % valid for the current image/stack ranges
            uiwait(msgbox(sprintf(['Image indices are invalid. This ' ...
                'dataset contains %d stack(s) and %d image(s) per stack.'], ...
                num_stacks, num_images)));
        end
    end
end

% Executes on key press with focus on figureImgTestGui or any of its controls.
function figureImgTestGui_WindowKeyPressFcn(~, eventdata, handles)
    key = eventdata.Key;
    if (strcmp(key, 'rightarrow') && ...
            strcmp(get(handles.pushNextShot, 'Visible'), 'on') && ...
            strcmp(get(handles.pushNextShot, 'Enable'), 'on'))
        pushNextShot_Callback(handles.pushNextShot, eventdata, handles);
    elseif (strcmp(key, 'leftarrow') && ...
            strcmp(get(handles.pushPreviousShot, 'Visible'), 'on') && ...
            strcmp(get(handles.pushPreviousShot, 'Enable'), 'on'))
        pushPreviousShot_Callback(handles.pushPreviousShot, eventdata, handles);
    end
end

% --------------------------------------------------------------------
function menuFile_Callback(~, ~, ~)
end
% --------------------------------------------------------------------
function menuSave_Callback(~, ~, ~)
end
% --------------------------------------------------------------------
function menuOperations_Callback(~, ~, ~)
end
% --------------------------------------------------------------------
function menuLineout_Callback(~, ~, ~)
end
% --------------------------------------------------------------------
function menuSettings_Callback(~, ~, ~)
end
% --------------------------------------------------------------------
function menuView_Callback(~, ~, ~)
end
% --------------------------------------------------------------------
function editGoToShot_Callback(~, ~, ~)
end
% --------------------------------------------------------------------
function editOfStack_Callback(~, ~, ~)
end


%==========================================================================
%========================GUI Deletion Functions============================
%==========================================================================


% --- Executes during object deletion, before destroying properties.
function serverPopUpMenu_DeleteFcn(~, ~, ~)
end
