function varargout = viewConditionsGui(varargin)
% VIEWCONDITIONSGUI MATLAB code for viewConditionsGui.fig
%      VIEWCONDITIONSGUI, by itself, creates a new VIEWCONDITIONSGUI or raises the existing
%      singleton*.
%
%      H = VIEWCONDITIONSGUI returns the handle to a new VIEWCONDITIONSGUI or the handle to
%      the existing singleton*.
%
%      VIEWCONDITIONSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWCONDITIONSGUI.M with the given input arguments.
%
%      VIEWCONDITIONSGUI('Property','Value',...) creates a new VIEWCONDITIONSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewConditionsGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewConditionsGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewConditionsGui

% Last Modified by GUIDE v2.5 05-Jun-2018 12:00:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewConditionsGui_OpeningFcn, ...
                   'gui_OutputFcn',  @viewConditionsGui_OutputFcn, ...
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


% --- Executes just before viewConditionsGui is made visible.
function viewConditionsGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewConditionsGui (see VARARGIN)
global conditions;
conditions = varargin{1};
separateCells();
global names;
set(handles.conditionsPopUpMenu, 'String', names); 
% Choose default command line output for viewConditionsGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes viewConditionsGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function separateCells() 
    global conditions;
    global names;
    names = {};
    global min;
    min = {};
    global max;
    max = {};
    [~, length] = size(conditions);
    for i = 1:length
        items = conditions{i};
        names{i} = items(1);
        min{i} = items(2);
        max{i} = items(3);
    end
    names = string(names);
    
% --- Outputs from this function are returned to the command line.
function varargout = viewConditionsGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in savePushButton.
function savePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to savePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
linecutOptions('save');
close;

% --- Executes on button press in closePushButton.
function closePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to closePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on selection change in conditionsPopUpMenu.
function conditionsPopUpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to conditionsPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns conditionsPopUpMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from conditionsPopUpMenu
index = get(handles.conditionsPopUpMenu, 'Value');
global min;
global max;
minimum = string(min(index));
maximum = string(max(index));
set(handles.minimum_text, 'String', minimum);
set(handles.maximum_text, 'String', maximum);

% --- Executes during object creation, after setting all properties.
function conditionsPopUpMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conditionsPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
