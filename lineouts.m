function varargout = lineouts(varargin)
    % LINEOUTS MATLAB code for lineouts.fig
    %      LINEOUTS, by itself, creates a new LINEOUTS or raises the existing
    %      singleton*.
    %
    %      H = LINEOUTS returns the handle to a new LINEOUTS or the handle to
    %      the existing singleton*.
    %
    %      LINEOUTS('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in LINEOUTS.M with the given input arguments.
    %
    %      LINEOUTS('Property','Value',...) creates a new LINEOUTS or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before lineouts_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to lineouts_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help lineouts

    % Last Modified by GUIDE v2.5 09-Aug-2017 10:38:58

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @lineouts_OpeningFcn, ...
                       'gui_OutputFcn',  @lineouts_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if (nargin && ischar(varargin{1}))
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT
end

% --- Executes just before lineouts is made visible.
function lineouts_OpeningFcn(hObject, ~, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to lineouts (see VARARGIN)
    set(0, 'CurrentFigure', handles.figureLineouts);
    set(handles.figureLineouts, 'Resize', 'on');
    set(handles.figureLineouts, 'Position', [80 19.2308 168.8 45]);

    % choose default command line output for lineouts
    handles.output = hObject;

    % update handles structure
    guidata(hObject, handles);

    set(gcf, 'color', [1,1,1]);

    showImageLineout;

    % UIWAIT makes lineouts wait for user response (see UIRESUME)
    % uiwait(handles.figureLineouts);
end

% --- Outputs from this function are returned to the command line.
function varargout = lineouts_OutputFcn(~, ~, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
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


function editOfStack_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject, 'BackgroundColor'), ...
            get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', 'white');
    end
end

function editGoToShot_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject, 'BackgroundColor'), ...
            get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', 'white');
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


function pushPreviousShot_Callback(~, ~, handles)
    % assumes that there will always be a next shot if previous shot is pressed
    set(handles.pushNextShot, 'Visible', 'on');
    
    % get necessary variables
    camera = getappdata(0, 'camera');
    num_images = getappdata(0, 'num_images');
    stack_text = getappdata(0, 'stack_text');
    bend_struc = getappdata(0, 'bend_struc');
    i = getappdata(0, 'i');
    j = getappdata(0, 'j');
    axes = subplot(1, 2, 1);
    CLim = axes.CLim;
    
    % set curr_lim (which may have changed if imcontrast was used)
    setappdata(0, 'curr_lim', CLim);
    
    if (j == 1)
        % if going to a new stack change camera structure if using energy camera
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
        % there is a previous image to display
        j = j - 1;
        setappdata(0, 'j', j);
        showImageLineout;
    elseif (j == 2 && i == 1)
        % the previous image is the first in the current stack and
        % there is no stack before the current one, so hide the 
        % 'Push Previous Shot' button
        set(handles.pushPreviousShot, 'Visible', 'off');
        j = j - 1;
        setappdata(0, 'j', j);
        showImageLineout;
    elseif j == 2
        % there are more stacks before the current one, so do not hide the
        % 'Push Previous Shot' button
        j = j - 1;
        setappdata(0, 'j', j);
        showImageLineout;
    else
        % the first image in the current stack is currently being
        % displayed and there is another stack before the current one, so
        % show the last image in the previous stack
        i = i - 1;
        j = num_images;
        setappdata(0, 'i', i);
        setappdata(0, 'j', j);
        showImageLineout;
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
    axes = subplot(1, 2, 1);
    CLim = axes.CLim;
    
    % set curr_lim (which may have changed if imcontrast was used)
    setappdata(0, 'curr_lim', CLim);
    
    if j == num_images
        % if going to a new stack change camera structure if using energy camera
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
            showImageLineout;
        end
    else
        % there are more images in the current stack to display
        j = j + 1;
        setappdata(0, 'j', j);
        showImageLineout;
    end
end

function menuSaveLineouts_Callback(~, ~, ~)
    % when pressed this menu creates all of the lineouts for a dataset and
    % saves them in data structure
    saveLineouts;
end

function editGoToShot_Callback(~, ~, ~)
end

function editOfStack_Callback(~, ~, ~)
end

function jumpToShotButton_Callback(~, ~, handles)
    % get necessary variables
    camera = getappdata(0, 'camera');
    num_stacks = getappdata(0, 'num_stacks');
    num_images = getappdata(0, 'num_images');
    stack_text = getappdata(0, 'stack_text');
    bend_struc = getappdata(0, 'bend_struc');
    axes = subplot(1, 2, 1);
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

        % display the image and lineout
        showImageLineout;

        if (j == num_images && i == num_stacks) % removes button to prevent user 
                                                % from clicking onward
            set(handles.pushNextShot, 'visible', 'off')
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

% --- Executes on key press with focus on figureLineouts or any of its controls.
function figureLineouts_WindowKeyPressFcn(~, eventdata, handles)
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