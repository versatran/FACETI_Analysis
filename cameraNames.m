function varargout = cameraNames(varargin)
    % CAMERANAMES MATLAB code for cameraNames.fig
    %      CAMERANAMES, by itself, creates a new CAMERANAMES or raises the existing
    %      singleton*.
    %
    %      H = CAMERANAMES returns the handle to a new CAMERANAMES or the handle to
    %      the existing singleton*.
    %
    %      CAMERANAMES('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in CAMERANAMES.M with the given input arguments.
    %
    %      CAMERANAMES('Property','Value',...) creates a new CAMERANAMES or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before cameraNames_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to cameraNames_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help cameraNames

    % Last Modified by GUIDE v2.5 20-Jul-2016 10:05:11

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @cameraNames_OpeningFcn, ...
                       'gui_OutputFcn',  @cameraNames_OutputFcn, ...
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

% --- Executes just before cameraNames is made visible.
function cameraNames_OpeningFcn(hObject, ~, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to cameraNames (see VARARGIN)

    % Choose default command line output for cameraNames
    handles.output = hObject;

    % get data created from Load Data Set
    data = getappdata(0, 'data');
    % gets the camera names from data set
    Cams_str = fieldnames(data.raw.images);
    set(handles.listCameraNames, 'String', Cams_str);

    % UIWAIT makes cameraNames wait for user response (see UIRESUME)
    % uiwait(handles.figure1);

    % Update handles structure
    guidata(hObject, handles);
end

% --- Outputs from this function are returned to the command line.
function varargout = cameraNames_OutputFcn(~, ~, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function listCameraNames_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, ...
            'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', 'white');
    end
    set(hObject, 'Value', 1);
end

% --- Executes on selection change in listCameraNames.
function listCameraNames_Callback(~, ~, ~)
end

% --- Executes on button press in pushLoadImages.
function pushLoadImages_Callback(hObject, ~, handles)
    % This function only shows the first shot of the first stack on ImgTestGui
    % Going through shots is done by buttons in ImgTestGui
    
    % get listCameraNames contents as cell array
    contents = cellstr(get(handles.listCameraNames, 'String'));
    % get selected item from listCameraNames
    camera = contents{get(handles.listCameraNames, 'Value')};
    % get camera structure associated with inputted camera string
    camera = load_camera_config(camera);
    if (camera.energy_camera)
        % these are for setting initial condition on these variables when
        % creating linear energy scale 
        setappdata(0, 'check_linearize_ROI', 0);
        setappdata(0, 'load_linearize_ROI', 0);
        % this is for allowing noise to be updated with new camera load and
        % for linearizing
        setappdata(0, 'background_checked', 0);
    end
    setappdata(0, 'camera', camera);

    % import GUI handles of ImgTestGui
    figureImgTestGui = findobj('Tag', 'figureImgTestGui');
    pushPreviousShot = findobj('Tag', 'pushPreviousShot');
    pushNextShot = findobj('Tag', 'pushNextShot');
    textGoToShot = findobj('Tag', 'textGoToShot');
    editGoToShot = findobj('Tag', 'editGoToShot');
    textOfStack = findobj('Tag', 'textOfStack');
    editOfStack = findobj('Tag', 'editOfStack');
    jumpToShotButton = findobj('Tag', 'jumpToShotButton');
    axesImage = findobj('Tag', 'axesImage');
    set(groot, 'CurrentFigure', figureImgTestGui);
    figure(gcf);
    set(figureImgTestGui, 'CurrentAxes', axesImage);

    % get necessary variables
    source_dir = getappdata(0, 'source_dir');
    date_str = getappdata(0, 'date_str');
    camera = getappdata(0, 'camera');

    % removes previous shot button since this is the first image
    set(pushPreviousShot, 'Visible', 'off');
    
    % set position to keep ImgTestGui from resizing itself
    set(figureImgTestGui, 'Position', [30 19.2308 150.8 45]);
    
    % eda_load_data is slightly modified version of nvn_load_data except
    % E200_load_data is not run here, it was run in pushLoadDataSet in
    % ImgTestGUI
    [prefix, num_stacks, image_struc, num_images, stack_text, func_name, ...
        bend_struc] = eda_load_data(source_dir, date_str, camera.name);

    % set eda_load_data outputs into appdata for use by other functions
    setappdata(0, 'prefix', prefix);
    setappdata(0, 'num_stacks', num_stacks);
    setappdata(0, 'image_struc', image_struc);
    setappdata(0, 'num_images', num_images);
    setappdata(0, 'stack_text', stack_text);
    setappdata(0, 'func_name', func_name);
    setappdata(0, 'bend_struc', bend_struc);

     % since this is the first image, i and j are set to 1 
    [i, j] = deal(1);
    setappdata(0, 'i', i);
    setappdata(0, 'j', j);

    if camera.energy_camera 
        if (isfield(bend_struc, 'variable_bend') && bend_struc.variable_bend)
            camera.dipole_bend = bend_struc.dipole_multiplier_values(i);
            camera.zero_Gev_px = bend_struc.zero_Gev_px_vector(i);                        
        end
        if camera.dipole_bend ~= 1
            stack_text{i} = ['Dipole=' num2str(camera.dipole_bend, 2) ', ' ...
                stack_text{i}];
            setappdata(0, 'stack_text', stack_text);
        end
    end

    % enable 'Next Shot' and 'Previous Shot' buttons
    set(pushNextShot, 'enable', 'on');
    set(pushPreviousShot, 'enable', 'on');
    
    % enable 'Jump to Shot' button and associated GUI components, and clear
    % the text areas from any previous text
    set(jumpToShotButton, 'enable', 'on');
    set(textGoToShot, 'enable', 'on');
    set(editGoToShot, 'String', '');
    set(editGoToShot, 'enable', 'on');
    set(textOfStack, 'enable', 'on');
    set(editOfStack, 'String', '');
    set(editOfStack, 'enable', 'on');

    % close camera-selection dialog when a camera has been selected
    close(hObject.Parent);

    % sets current image to be used by load_noiseless_images_15_edited
    ImgTestGui_ShowImage;
end