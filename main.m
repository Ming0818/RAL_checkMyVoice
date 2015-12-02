function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 28-Nov-2015 21:23:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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

% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% =========================================================================
%   Initialize all required files
% =========================================================================
ral_initialize();


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in listboxUsers.
function listboxUsers_Callback(hObject, eventdata, handles)
% hObject    handle to listboxUsers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxUsers contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxUsers

% Load user database
load('ral_settings.mat');
load(settings.path_user_database);
nbUsers = size(users, 1);
if nbUsers > 0
    handles.names = users(:,2);
    set(handles.listboxUsers,'String',handles.names);
end

% --- Executes during object creation, after setting all properties.
function listboxUsers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxUsers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on key press with focus on listboxUsers and none of its controls.
function listboxUsers_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to listboxUsers (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case 'delete'
        %Removes user from the database 
        nameList = get(handles.listboxUsers, 'String');
        userNameToDelete = nameList(get(handles.listboxUsers,'Value'));
        user_delete(userNameToDelete{1});
        %Removes user from the list
        selectedValue = get(handles.listboxUsers,'Value'); 
        prevValue = get(handles.listboxUsers, 'String'); 
        len = length(prevValue); 
        if len > 0
          index = 1:len;
          prevValue = prevValue(find(index ~= selectedValue),1);
          set(handles.listboxUsers, 'String', prevValue, 'Value', min(selectedValue, length(prevValue))); 
        end
end

% =========================================================================
%   BUTTON ACTIONS
% =========================================================================

% --- Executes on button press in getMFCCButton.
function getMFCCButton_Callback(hObject, eventdata, handles)
% hObject    handle to getMFCCButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

audioFiles = file_getFilesForAction('train');
for audioFile = audioFiles
    % === Init user : add the user if not created ===
    user_initUser(audioFile{3});
    % === Add MFCC to the database ===
    mfcc_add( audioFile )
    % === Delete the training file ===
    % file_deleteInputFile(audioFile{1});
end


% --- Executes on button press in recognizeButton.
function recognizeButton_Callback(hObject, eventdata, handles)
% hObject    handle to recognizeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('ral_settings.mat');
load(settings.path_mfcc_database);
if size(mfcc_features_data, 1) >= 1
    % === Get the audio file with the prefix "recognize"
    inputsPath = settings.path_audio_inputs;
    audioFile = file_getFilesForAction('recognize');
    % === Try to recognize the user with this audio file
    userPseudo = ral_recogniseUser(audioFile);
    % === Send the user to NAO
    fprintf('RAL : Recognized user : %s\n', userPseudo);
    % === Delete the audio file
    % file_deleteInputFile(audioFile{1});
else
    fprintf('ERROR : not enought entries to recognize anyone\n');
end


% --- Executes on button press in trainButton.
function trainButton_Callback(hObject, eventdata, handles)
% hObject    handle to trainButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%===================================================
load('ral_settings.mat');
fprintf('NN : begin train\n');
% Load mfcc features datas
load(settings.path_mfcc_database);
featuresData = mfcc_features_data;
featuresSize = size(featuresData, 1);
% Load user database
load(settings.path_user_database);
nbUsers = size(users, 1);
listIDsUsers = users(:,2);

% Prepare the inputs and outputs data
nnInputs = [];
nnOutnputs = [];

for iFeatureData=1:featuresSize
    aFeature = featuresData{iFeatureData,2};
    [dimx,dimy] = size(aFeature);
    nnInputs = [nnInputs aFeature'];

    % Create an array of 0
    userFeaturesArray   = zeros(nbUsers, dimx);
    idUserFeature =  featuresData{iFeatureData,1};
    % Associate the feature with the right user :
    % IF the user ID on the feature is the same as the ID in the
    % database line
    % THEN 
    %   the value becomes 1.
    % ELSE 
    %   the value becomes -1.
    % FI
    for listIDsUsers=1:(nbUsers)
        if listIDsUsers==idUserFeature
            userFeaturesArray(listIDsUsers,:) = 1;
        else
            userFeaturesArray(listIDsUsers,:) = -1;
        end
    end
    nnOutnputs = [nnOutnputs userFeaturesArray];
end

%Normalization
nnInputsNormalized = nnInputs;
for iFeatureData=1:size(nnInputsNormalized,1)
    v = nnInputsNormalized(iFeatureData,:);
    v = v(:);
    maxFeatureData = max([v;1]);
    minFeatureData = min([v;-1]);
    nnInputsNormalized(iFeatureData,:) = 2*(nnInputsNormalized(iFeatureData,:)-minFeatureData)/(maxFeatureData-minFeatureData)-1;
end

% Create and train the neural network
net = nn_create(nnInputsNormalized,nnOutnputs);
% Save the neural network for futur uses
save('net.mat', 'net');
fprintf('NN : end train\n');
%===================================================
