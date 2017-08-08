function varargout = options(varargin)
    % OPTIONS MATLAB code for options.fig
    %      OPTIONS, by itself, creates a new OPTIONS or raises the existing
    %      singleton*.
    %
    %      H = OPTIONS returns the handle to a new OPTIONS or the handle to
    %      the existing singleton*.
    %
    %      OPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in OPTIONS.M with the given input arguments.
    %
    %      OPTIONS('Property','Value',...) creates a new OPTIONS or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before options_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to options_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help options

    % Last Modified by GUIDE v2.5 17-Aug-2016 18:08:54

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @options_OpeningFcn, ...
                       'gui_OutputFcn',  @options_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end % End initialization code - DO NOT EDIT

% --- Executes just before options is made visible.
function options_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to options (see VARARGIN)

    % Choose default command line output for options
    handles.output = hObject;

    % UIWAIT makes options wait for user response (see UIRESUME)
    % uiwait(handles.figureOptions);

    % Update handles structure
    guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = options_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% These functions just create the different GUI components
%==========================================================================
%===========================Create Function================================
%==========================================================================

% --- Executes during object creation, after setting all properties.
function editCurrentLimit1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function editCurrentLimit2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function editScaleAdjustment_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

%==========================================================================
%========================Callbacks=========================================
%==========================================================================
%
% These functions execute upon user interation with the options menu.

function checkRemote_Callback(hObject, ~, ~)
    remote = hObject.Value;
    setappdata(0, 'remote', remote);

function checkSkipBackground_Callback(hObject, ~, ~)
    skip_background_verification = hObject.Value;
    setappdata(0, 'skip_background_verification', skip_background_verification);

function checkLinearize_Callback(hObject, ~, ~)
    linearize = hObject.Value;
    setappdata(0, 'linearize', linearize);

function checkShowImage_Callback(hObject, ~, ~)
    show_image = hObject.Value;
    setappdata(0, 'show_image', show_image);

function checkDCOffset_Callback(hObject, ~, ~)
    DC_offset = hObject.Value;
    setappdata(0, 'DC_offset', DC_offset);

function checkSaveVideo_Callback(hObject, ~, ~)
    save_video = hObject.Value;
    setappdata(0, 'save_video', save_video);

function checkSaveData_Callback(hObject, ~, ~)
    save_data = hObject.Value;
    setappdata(0, 'save_data', save_data);

function checkSaveOverride_Callback(hObject, ~, ~)
    save_override = hObject.Value;
    setappdata(0, 'save_override', save_override);

function checkShowNoiseSample_Callback(hObject, ~, ~)
    show_noise_sample = hObject.Value;
    setappdata(0, 'show_noise_sample', show_noise_sample);

function checkRemoveXRays_Callback(hObject, ~, ~)
    remove_xrays = hObject.Value;
    setappdata(0, 'remove_xrays', remove_xrays);

function checkShowDCSample_Callback(hObject, ~, ~)
    show_DC_sample = hObject.Value;
    setappdata(0, 'show_DC_sample', show_DC_sample);

function checkManualEnergy_Callback(hObject, ~, ~)
    manual_energy = hObject.Value;
    setappdata(0, 'manual_energy', manual_energy);

function checkLogColor_Callback(hObject, ~, ~)
    log_color = hObject.Value;
    setappdata(0, 'log_color', log_color);

function checkManualSetFigure_Callback(hObject, ~, ~)
    manual_set_figure_position = hObject.Value;
    setappdata(0, 'manual_set_figure_position', manual_set_figure_position);

function checkBackgroundCheck_Callback(hObject, ~, ~)
    background_checked = hObject.Value;
    setappdata(0, 'background_checked', background_checked);

function editScaleAdjustment_Callback(hObject, ~, ~)
    scale_adjustment = str2double(hObject.String);
    setappdata(0, 'scale_adjustment', scale_adjustment);

function editCurrentLimit1_Callback(hObject, ~, ~)
    curr_lim1 = str2double(hObject.String);
    setappdata(0, 'curr_lim1', curr_lim1);

function editCurrentLimit2_Callback(hObject, ~, ~)
    curr_lim2 = str2double(hObject.String);
    setappdata(0, 'curr_lim2', curr_lim2);

function pushSaveOptions_Callback(~, ~, ~)
    % curr_lim1 and curr_lim2 are obtained from seperate textboxes and these
    % numbers are put together to create curr_lim, the range on the
    % colorbar. Closes options when pressed.
    curr_lim1 = getappdata(0, 'curr_lim1');
    curr_lim2 = getappdata(0, 'curr_lim2');
    curr_lim = [curr_lim1 curr_lim2];
    setappdata(0, 'curr_lim', curr_lim);
    close(gcf);
