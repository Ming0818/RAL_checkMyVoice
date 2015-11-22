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

% Last Modified by GUIDE v2.5 27-Oct-2015 21:48:57

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
    load('ral_settings.mat');
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

