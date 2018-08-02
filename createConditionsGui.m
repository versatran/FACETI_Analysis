function varargout = createConditionsGui(varargin)
% CREATECONDITIONSGUI MATLAB code for createConditionsGui.fig
%      CREATECONDITIONSGUI, by itself, creates a new CREATECONDITIONSGUI or raises the existing
%      singleton*.
%
%      H = CREATECONDITIONSGUI returns the handle to a new CREATECONDITIONSGUI or the handle to
%      the existing singleton*.
%
%      CREATECONDITIONSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATECONDITIONSGUI.M with the given input arguments.
%
%      CREATECONDITIONSGUI('Property','Value',...) creates a new CREATECONDITIONSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before createConditionsGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to createConditionsGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help createConditionsGui

% Last Modified by GUIDE v2.5 01-Aug-2018 11:25:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @createConditionsGui_OpeningFcn, ...
                   'gui_OutputFcn',  @createConditionsGui_OutputFcn, ...
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


% --- Executes just before createConditionsGui is made visible.
function createConditionsGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to createConditionsGui (see VARARGIN)
converted_param = getappdata(0, 'converted_param');
set(handles.expVar_popUpMenu, 'String', converted_param);
% Choose default command line output for createConditionsGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes createConditionsGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = createConditionsGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in expVar_popUpMenu.
function expVar_popUpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to expVar_popUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

index = get(handles.expVar_popUpMenu, 'Value');
machineCodes = getappdata(0, 'param');
machine = machineCodes(index);
set(handles.expMachineCode_text, 'String', machine);
% Hints: contents = cellstr(get(hObject,'String')) returns expVar_popUpMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from expVar_popUpMenu


% --- Executes during object creation, after setting all properties.
function expVar_popUpMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to expVar_popUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in export_pushButton.
function export_pushButton_Callback(hObject, eventdata, handles)
% hObject    handle to export_pushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
converted_param = get(handles.expVar_popUpMenu, 'String');
index = get(handles.expVar_popUpMenu, 'Value');
name = string(converted_param(index));
data = getappdata(0, 'data');
labels = {strcat('Export ', name, ' values as: ') ...
    strcat('Export ', name, ' UIDs as: ')};
var = {'export_data', 'export_UIDs'};
[UIDs, vals] = eda_extract_data(data, name, index);
vals = {vals, UIDs};
export2wsdlg(labels, var, vals);

% --- Executes on selection change in impVar_popUpMenu.
function impVar_popUpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to impVar_popUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns impVar_popUpMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from impVar_popUpMenu


% --- Executes during object creation, after setting all properties.
function impVar_popUpMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to impVar_popUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function impMachineName_edit_Callback(hObject, eventdata, handles)
% hObject    handle to impMachineName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of impMachineName_edit as text
%        str2double(get(hObject,'String')) returns contents of impMachineName_edit as a double


% --- Executes during object creation, after setting all properties.
function impMachineName_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to impMachineName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in import_pushButton.
function import_pushButton_Callback(hObject, eventdata, handles)
% hObject    handle to import_pushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
name = get(handles.impVarName_edit, 'String');
UID_name = get(handles.impUIDName_edit, 'String');
machine = get(handles.impMachineName_edit, 'String');
global VALs;
VALs = evalin('base', name);
global UIDs;
UIDs = evalin('base', UID_name);
msgbox('Successfully imported data');


% --- Executes on button press in save_pushButton.
function save_pushButton_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(0, 'data');
machine = get(handles.impMachineName_edit, 'String');
machine = string(machine);
global VALs
global UIDs
source_dir = getappdata(0, 'source_dir');
year_str = getappdata(0, 'year_str');
date_str = getappdata(0, 'date_str');
dataset_str = getappdata(0, 'dataset_str');
expt_str = getappdata(0, 'expt_str');
folderName = strcat(expt_str, '_', dataset_str);

beginingPath = strcat(source_dir, 'processed_data', filesep, expt_str, filesep, year_str, filesep);
middlePath = strcat(beginingPath, date_str, filesep);
endPath = strcat(middlePath, folderName, filesep);

if ~isempty(VALs)
    dat = struct('VALs', VALs, 'UIDs', UIDs);
    data.user.Machine.(machine) = dat;
    
    if 7 ~= exist(middlePath, 'dir')
       mkdir(middlePath, date_str);
    end
    if 7 ~= exist(endPath, 'dir')
        mkdir(endPath, folderName);
    end
    filename = strcat(folderName, '_processed.mat');
    path = strcat(endPath, filesep, filename); 
    
    save(path, 'data');
    setappdata(0, 'data', data);
    msg = 'Saved Successfully';
    msgbox(msg);
else
    
end

% --- Executes on button press in close_pushButton.
function close_pushButton_Callback(hObject, eventdata, handles)
% hObject    handle to close_pushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ans = questdlg('Are you sure you want to leave?', 'Close', 'Yes', 'No', 'Yes');
switch ans
    case 'Yes'
        close;
end


function impVarName_edit_Callback(hObject, eventdata, handles)
% hObject    handle to impVarName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of impVarName_edit as text
%        str2double(get(hObject,'String')) returns contents of impVarName_edit as a double


% --- Executes during object creation, after setting all properties.
function impVarName_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to impVarName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function impUIDName_edit_Callback(hObject, eventdata, handles)
% hObject    handle to impUIDName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of impUIDName_edit as text
%        str2double(get(hObject,'String')) returns contents of impUIDName_edit as a double


% --- Executes during object creation, after setting all properties.
function impUIDName_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to impUIDName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function impMachineNameUID_edit_Callback(hObject, eventdata, handles)
% hObject    handle to impMachineNameUID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of impMachineNameUID_edit as text
%        str2double(get(hObject,'String')) returns contents of impMachineNameUID_edit as a double


% --- Executes during object creation, after setting all properties.
function impMachineNameUID_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to impMachineNameUID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
