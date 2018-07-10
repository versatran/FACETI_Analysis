function varargout = imgGui(varargin)
% IMGGUI MATLAB code for imgGui.fig
%      IMGGUI, by itself, creates a new IMGGUI or raises the existing
%      singleton*.
%
%      H = IMGGUI returns the handle to a new IMGGUI or the handle to
%      the existing singleton*.
%
%      IMGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMGGUI.M with the given input arguments.
%
%      IMGGUI('Property','Value',...) creates a new IMGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imgGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imgGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imgGui

% Last Modified by GUIDE v2.5 23-Jun-2016 16:00:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imgGui_OpeningFcn, ...
                   'gui_OutputFcn',  @imgGui_OutputFcn, ...
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


% --- Executes just before imgGui is made visible.
function imgGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imgGui (see VARARGIN)

% Choose default command line output for imgGui
handles.output = hObject;

I = imread('img1.jpg');
imagesc(I);


% UIWAIT makes imgGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


guidata(hObject, handles);
% --- Outputs from this function are returned to the command line.
function varargout = imgGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Get default command line output from handles structure
varargout{1} = handles.output;
guidata(hObject, handles);
% --- Executes on button press in pushCrop.
function pushCrop_Callback(hObject, eventdata, handles)
% hObject    handle to pushCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = imread('img1.jpg');
[I2, rect] = imcrop(I);

subplot(1,2,1)
imagesc(I)
title('Original Image')
subplot(1,2,2)
imagesc(I2)
title('Cropped Image')

colorbar
guidata(hObject, handles);
