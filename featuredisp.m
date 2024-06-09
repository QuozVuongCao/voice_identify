function varargout = featuredisp(varargin)
% FEATUREDISP M-file for featuredisp.fig
%      FEATUREDISP, by itself, creates a new FEATUREDISP or raises the existing
%      singleton*.
%
%      H = FEATUREDISP returns the handle to a new FEATUREDISP or the handle to
%      the existing singleton*.
%
%      FEATUREDISP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FEATUREDISP.M with the given input arguments.
%
%      FEATUREDISP('Property','Value',...) creates a new FEATUREDISP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before featuredisp_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to featuredisp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help featuredisp

% Last Modified by GUIDE v2.5 18-Jan-2004 22:08:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @featuredisp_OpeningFcn, ...
                   'gui_OutputFcn',  @featuredisp_OutputFcn, ...
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


% --- Executes just before featuredisp is made visible.
function featuredisp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to featuredisp (see VARARGIN)

% Choose default command line output for featuredisp
handles.output = hObject;

%seconds to record
handles.T = 4;

%sampling frequency
handles.fs = 8000;

%number of samples to record
handles.samples = handles.T * handles.fs;

%fft length
handles.N=256;

%time shift is 10ms
handles.shift = 10*handles.fs/1000;

%number of mel filter channels
handles.nofChannels = 24;

%default number of frames to display
handles.nofFramesDisp = 50;
%minimum number of frames to display
handles.minFramesDisp = 20;
% first frame to display in window
handles.startFrame = 1;

%compute matrix of mel filter coefficients
handles.W = melFilterMatrix(handles.fs,handles.N,handles.nofChannels);

% Update handles structure
guidata(hObject, handles);

%init colormap to bone
colormap(bone);


% UIWAIT makes featuredisp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = featuredisp_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function timeslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function timeslider_Callback(hObject, eventdata, handles)
% hObject    handle to timeslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%plot data
handles.startFrame = get(handles.timeslider,'value');
guidata(hObject, handles);
plotData(handles);



% --- Executes on button press in Record.
function Record_Callback(hObject, eventdata, handles)
% hObject    handle to Record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.s = wavrecord(handles.samples,handles.fs,'double');
wavplay(handles.s,handles.fs);

% compute spectra
handles.SPEC = computeSpectrum(handles.N,handles.shift,handles.s);
handles.SPEC.X = loglimit(handles.SPEC.X,10.0e-3);
handles.nofSpecCoeff = size(handles.SPEC.X,1);

%compute mel spectra
handles.MEL = computeMelSpectrum(handles.W,handles.shift,handles.s);
handles.nofFrames = size(handles.MEL.M,2);
handles.nofMelChannels = size(handles.MEL.M,1);

%normalize energy of mel spectra
%take log value
epsilon = 10e-5;
for k = 1:handles.nofFrames
    for c = 1:handles.nofMelChannels
        %normalize energy
        handles.MEL.M(c,k) = handles.MEL.M(c,k)/handles.MEL.e(k);
        %take log energy
        handles.MEL.M(c,k) = loglimit(handles.MEL.M(c,k),epsilon);
    end %for c
end %for k

%compute MFCC
%handles.MFCC = computeMFCC(handles.fs,handles.s);
%nofMFCCChannels = size(handles.MFCC,1);

guidata(hObject, handles);

%set slider properties

%set scale slider properties
min = handles.minFramesDisp;
%allow minimum of two frames for timeslider
max = handles.nofFrames-2;
set(handles.scaleSlider,'sliderstep',[0.01 0.1],...
      'max',max,'min',min,'Value',1);
set(handles.scaleSlider,'value',max);

%set time slider properties
handles.nofFramesDisp = get(handles.scaleSlider,'value');
min = 1;
max = handles.nofFrames-handles.nofFramesDisp;
set(handles.timeslider,'sliderstep',[0.01 0.1],...
      'max',max,'min',min,'Value',min);
handles.startFrame = min;

guidata(hObject, handles);
plotData(handles);


function plotData(handles)

%--------------plot results
nofFrames = handles.nofFrames;
nofMelChannels = handles.nofMelChannels;

startFrame=handles.startFrame;
stopFrame=startFrame+handles.nofFramesDisp-1;
%plot power spectrum
axes(handles.specwin);
imagesc(flipud(handles.SPEC.X));
axis([startFrame,stopFrame,-Inf,Inf]);
%colormap(jet);

%plot energy
axes(handles.energywin);
plot(loglimit(handles.SPEC.e,0.001));
axis([startFrame,stopFrame,-Inf,Inf]);

%plot mel spectrum
axes(handles.melspecwin);
imagesc(flipud(handles.MEL.M));
axis([startFrame,stopFrame,-Inf,Inf]);
%colormap(jet);

%plot mfcc
%axes(handles.mfccwin);
%imagesc(flipud(handles.MFCC.C(2:15,:)));
%plot(handles.MFCC)
%colormap(jet);



% --- Executes on button press in color.
function color_Callback(hObject, eventdata, handles)
% hObject    handle to color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of color
colorState = get(hObject,'Value')
if (colorState == get(hObject,'Max'))
    colormap(jet);        
else
    colormap(bone);    
end


% --- Executes during object creation, after setting all properties.
function scaleSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scaleSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function scaleSlider_Callback(hObject, eventdata, handles)
% hObject    handle to scaleSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.nofFramesDisp = get(handles.scaleSlider,'value');
%update time slider properties
min = 1;
max = handles.nofFrames-handles.nofFramesDisp;
set(handles.timeslider,'sliderstep',[0.01 0.1],...
      'max',max,'min',1,'Value',min);
handles.startFrame = min;

guidata(hObject, handles);
plotData(handles);




