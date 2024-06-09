function varargout = recordtool(varargin)
% RECORDTOOL M-file for recordtool.fig
%      RECORDTOOL, by itself, creates a new RECORDTOOL or raises the existing
%      singleton*.
%
%      H = RECORDTOOL returns the handle to a new RECORDTOOL or the handle to
%      the existing singleton*.
%
%      RECORDTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECORDTOOL.M with the given input arguments.
%
%      RECORDTOOL('Property','Value',...) creates a new RECORDTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before recordtool_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to recordtool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help recordtool

% Last Modified by GUIDE v2.5 01-Feb-2004 18:45:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @recordtool_OpeningFcn, ...
                   'gui_OutputFcn',  @recordtool_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before recordtool is made visible.
function recordtool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to recordtool (see VARARGIN)

% Choose default command line output for recordtool
handles.output = hObject;

%set listbox
set(handles.File,'Min',2,'Max',1);

%init params
handles.time = 1.5;

handles.X = zeros(1,1);
handles.number = 1;
handles.filename = sprintf('pattern_%d',handles.number);
set(handles.stext,'String',handles.filename)
colormap(bone);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes recordtool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = recordtool_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in recordbutton.
function recordbutton_Callback(hObject, eventdata, handles)
% hObject    handle to recordbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.X = recordMelMatrix(handles.time);
guidata(hObject, handles);
plotData(handles);


% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
X = handles.X;
save (handles.filename, 'X');

% --- Executes during object creation, after setting all properties.
function File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in File.
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns File contents as cell array
%        contents{get(hObject,'Value')} returns selected item from File
number = get(handles.File,'Value');
if (number == 10)
    number = 0;
end;
handles.filename = sprintf('pattern_%d',number);
set(handles.stext,'String',handles.filename)
guidata(hObject, handles);


function plotData(handles)
axes(handles.axes1);
imagesc(flipud(handles.X));


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load (handles.filename, 'X');
handles.X = X;
guidata(hObject, handles);
plotData(handles);
