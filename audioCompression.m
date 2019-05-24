function varargout = audioCompression(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @audioCompression_OpeningFcn, ...
                   'gui_OutputFcn',  @audioCompression_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before audioCompression is made visible.
function audioCompression_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


function varargout = audioCompression_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the file
[file,path] = uigetfile('*.wav');
myAudio=fullfile(path, file);
[test, f] = wavread(myAudio);


%chosing a block size 
windowSize = 88192;

%changing compression  percentages
samplesHalf = windowSize / 2;
samplesQuarter = windowSize / 4;
samplesEighth = windowSize / 8;

%initializing compressed matrice
testCompressed2 = [];
testCompressed4 = [];
testCompressed8 = [];

%actual compression
for i=1:windowSize:length(test)-windowSize
    windowDCT = dct(test(i:i+windowSize-1));
    testCompressed2(i:i+windowSize-1) = idct(windowDCT(1:samplesHalf), windowSize);
    testCompressed4(i:i+windowSize-1) = idct(windowDCT(1:samplesQuarter), windowSize);
    testCompressed8(i:i+windowSize-1) = idct(windowDCT(1:samplesEighth), windowSize);
end

%convert the chanall to victor
testl = test(:);

%plotting audio signals
axesHandle1 = findobj('Tag', 'axes1');
plot(axesHandle1,test(1000:2000));
axesHandle3 = findobj('Tag', 'axes3');
plot(axesHandle3,testCompressed2(1000:2000));
axesHandle5 = findobj('Tag', 'axes5');
plot(axesHandle5,testCompressed4(1000:2000));
axesHandle7 = findobj('Tag', 'axes7');
plot(axesHandle7,testCompressed8(1000:2000));
%test with (1000:2000)

%spectrogram of audio signals
axes(handles.axes2);
specgram(testl, 1024, f);

axes(handles.axes4);
specgram(testCompressed2, 1024, f);

axes(handles.axes6);
specgram(testCompressed4, 1024, f);

axes(handles.axes8);
specgram(testCompressed8, 1024, f);


%making the main variables global
handles.test=test;
handles.f=f;
handles.testCompressed2=testCompressed2;
handles.testCompressed4=testCompressed4;
handles.testCompressed8=testCompressed8;
guidata(hObject,handles)


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%saving to WAV files
wavwrite(handles.testCompressed2, handles.f, 'Compressed2')
wavwrite(handles.testCompressed4, handles.f, 'Compressed4')
wavwrite(handles.testCompressed8, handles.f, 'Compressed8')

% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%playing WAV files
wavplay(handles.test, handles.f);
wavplay(handles.testCompressed2, handles.f);
wavplay(handles.testCompressed4, handles.f);
wavplay(handles.testCompressed8, handles.f);
