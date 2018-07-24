function varargout = brf_cameraSettings(varargin)
% BRF_CAMERASETTINGS MATLAB code for brf_cameraSettings.fig
%      BRF_CAMERASETTINGS, by itself, creates a new BRF_CAMERASETTINGS or raises the existing
%      singleton*.
%
%      H = BRF_CAMERASETTINGS returns the handle to a new BRF_CAMERASETTINGS or the handle to
%      the existing singleton*.
%
%      BRF_CAMERASETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BRF_CAMERASETTINGS.M with the given input arguments.
%
%      BRF_CAMERASETTINGS('Property','Value',...) creates a new BRF_CAMERASETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before brf_cameraSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to brf_cameraSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help brf_cameraSettings

% Last Modified by GUIDE v2.5 23-Jul-2018 16:40:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @brf_cameraSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @brf_cameraSettings_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before brf_cameraSettings is made visible.
function brf_cameraSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to brf_cameraSettings (see VARARGIN)

% Choose default command line output for brf_cameraSettings
handles.output = hObject;
camera_struc = getappdata(0, 'camera');
set(handles.listbox1, 'String', fieldnames(camera_struc));
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes brf_cameraSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = brf_cameraSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
camera_struc = getappdata(0, 'camera');
index = get(hObject, 'Value');
cameraFields = fieldnames(camera_struc);
fieldName = cameraFields{index};
setappdata(0, 'fieldName', fieldName);
fieldVal = camera_struc.(fieldName);
label = strcat(fieldName, ':');
set(handles.text_fieldName, 'String', label);
set(handles.text_fieldVal, 'String', string(fieldVal));
set(handles.pushbutton_editVal, 'Visible', 'on');
set(handles.text_newVal, 'Visible', 'off');
set(handles.edit_enterVal, 'Visible', 'off');
set(handles.pushbutton_setVal, 'Visible', 'off');


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_editVal.
function pushbutton_editVal_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_editVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text_newVal, 'Visible', 'on');
set(handles.edit_enterVal, 'Visible', 'on');
set(handles.pushbutton_setVal, 'Visible', 'on');
set(hObject, 'Visible', 'off');


function edit_enterVal_Callback(hObject, eventdata, handles)
% hObject    handle to edit_enterVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_enterVal as text
%        str2double(get(hObject,'String')) returns contents of edit_enterVal as a double


% --- Executes during object creation, after setting all properties.
function edit_enterVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_enterVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_setVal.
function pushbutton_setVal_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_setVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(0, 'data');
newVal = get(handles.edit_enterVal, 'String');
fieldName = getappdata(0, 'fieldName');
camera = getappdata(0, 'camera');
oldVal = camera.(fieldName);
question = strcat('Are you sure you want ', fieldName, ' to be ', newVal, '?');
choice = questdlg(question, 'Confirmation', 'Yes', 'No', 'Yes');
if strcmp(choice, 'Yes')
    if isa(oldVal, 'double')
        newVal = str2double(newVal);
    end
    setappdata(0, 'newVal', newVal);
    camera.(fieldName) = newVal;
    data.raw.camera.(camera.name).(fieldName) = camera.(fieldName);
    % try to save it first to the drive
    data_path = getappdata(0, 'data_path');
    save(data_path, 'data');
    setappdata(0, 'data', data);
    setappdata(0, 'camera', camera);
    msgbox('Saved successfully', 'Saved');
    uiwait();
    close;
end