
function varargout = addConditionsGui(varargin)
% ADDCONDITIONSGUI MATLAB code for addConditionsGui.fig
%      ADDCONDITIONSGUI, by itself, creates a new ADDCONDITIONSGUI or raises the existing
%      singleton*.
%
%      H = ADDCONDITIONSGUI returns the handle to a new ADDCONDITIONSGUI or the handle to
%      the existing singleton*.
%
%      ADDCONDITIONSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADDCONDITIONSGUI.M with the given input arguments.
%
%      ADDCONDITIONSGUI('Property','Value',...) creates a new ADDCONDITIONSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before addConditionsGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to addConditionsGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help addConditionsGui

% Last Modified by GUIDE v2.5 01-Jun-2018 15:39:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @addConditionsGui_OpeningFcn, ...
                   'gui_OutputFcn',  @addConditionsGui_OutputFcn, ...
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

% --- Executes just before addConditionsGui is made visible.
function addConditionsGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to addConditionsGui (see VARARGIN)

converted_parameters = varargin{1};
global count;
global conditions;
count = varargin{2};
conditions = varargin{3};
set(handles.popupmenu1, 'String', converted_parameters);
% Choose default command line output for addConditionsGui

handles.output = hObject;



% Update handles structure
guidata(hObject, handles);



% UIWAIT makes addConditionsGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = addConditionsGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minimum_edit_Callback(hObject, eventdata, handles)
% hObject    handle to minimum_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minimum_edit as text
%        str2double(get(hObject,'String')) returns contents of minimum_edit as a double


% --- Executes during object creation, after setting all properties.
function minimum_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minimum_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maximum_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maximum_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maximum_edit as text
%        str2double(get(hObject,'String')) returns contents of maximum_edit as a double


% --- Executes during object creation, after setting all properties.
function maximum_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maximum_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% add conditions to global variable "conditions"
function addCondition(item, min, max)
    global count;
    global conditions;
    if max < min
        uiwait (msgbox('ERROR: Maximum value is less then minimum value. Please try again', 'Cannot Add Condition'));
    else
        cell = {item, min, max};
        count = count + 1;
        conditions{count} = cell; 
        linecutOptions('set', conditions, count);
        close;
    end
 
function deleteAllConditions() 
    global count;
    global conditions;
    conditions = {};
    count = 1;
    linecutOptions('set', count, conditions);

%pandacorn delete condition vs delete all conditions
    
% --- Executes on button press in addCondition_pushButton.
function addCondition_pushButton_Callback(hObject, eventdata, handles)
% hObject    handle to addCondition_pushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

min = str2double(get(handles.minimum_edit, 'String'));
max = str2double(get(handles.maximum_edit, 'String'));
allConditions = get(handles.popupmenu1, 'String');
condition_index = get(handles.popupmenu1, 'Value');
condition = allConditions{condition_index}
addCondition(condition, min, max);