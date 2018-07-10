
function varargout = UpNum(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UpNum_OpeningFcn, ...
                   'gui_OutputFcn',  @UpNum_OutputFcn, ...
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

% --- Executes just before UpNum is made visible.
function UpNum_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;


num = 1;
    
assignin('base', 'num', num);

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = UpNum_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% Start initialization code

% --- Executes during object creation, after setting all properties.
function editNum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% End initialization code - DO NOT EDIT


% --- Executes on button press in pushbuttonUp.
function pushbuttonUp_Callback(hObject, eventdata, handles)
num = str2double(get(handles.editNum,'String'));
addNum = num + 1;
set(handles.editNum, 'String', addNum);
guidata(hObject, handles);

function editNum_Callback(hObject, eventdata, handles)

num = str2double(get(handles.editNum, 'String'));
assignin('base', 'num', num);
guidata(hObject, handles);

% --- Executes on key press with focus on editNum and none of its controls.
function editNum_KeyPressFcn(hObject, eventdata, handles)
