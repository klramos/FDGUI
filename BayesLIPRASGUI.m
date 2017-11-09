function varargout = BayesLIPRASGUI(varargin)
% BAYESLIPRASGUI MATLAB code for BayesLIPRASGUI.fig
%      BAYESLIPRASGUI, by itself, creates a new BAYESLIPRASGUI or raises the existing
%      singleton*.
%
%      H = BAYESLIPRASGUI returns the handle to a new BAYESLIPRASGUI or the handle to
%      the existing singleton*.
%
%      BAYESLIPRASGUI('CALLBACK',hObject,eventData,handlesB,...) calls the local
%      function named CALLBACK in BAYESLIPRASGUI.M with the given input arguments.
%
%      BAYESLIPRASGUI('Property','Value',...) creates a new BAYESLIPRASGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BayesLIPRASGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BayesLIPRASGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BayesLIPRASGUI

% Last Modified by GUIDE v2.5 08-Nov-2017 22:03:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BayesLIPRASGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BayesLIPRASGUI_OutputFcn, ...
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


% --- Executes just before BayesLIPRASGUI is made visible.
function BayesLIPRASGUI_OpeningFcn(hObject, eventdata, handlesB, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)
% varargin   command line arguments to BayesLIPRASGUI (see VARARGIN)

% Choose default command line output for BayesLIPRASGUI
handlesB.output = hObject;
handlesB.OD=evalin('base','handles');
idBkg=handlesB.OD.profiles.xrd.getBackgroundOrder+2; % to remove Bkg Coeffs since they will not be in Bayesian analysis
handlesB.uitable1.RowName=handlesB.OD.profiles.FitInitial.coeffs;
handlesB.uitable1.Data=[handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'...
    handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'-handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)'...
    handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'+handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)' handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)'/1.96];
handlesB.radiobutton3.Value=1;

handlesB.uitable2.ColumnName='Acc. Ratio';
handlesB.uitable2.RowName=handlesB.OD.profiles.FitInitial.coeffs;


handlesB.listbox1.String=handlesB.OD.profiles.FileNames;

% Default from LIPRAS Results on StartUp
    idBkg=handlesB.OD.profiles.xrd.getBackgroundOrder+2; % to remove Bkg Coeffs since they will not be in Bayesian analysis
    if handlesB.OD.profiles.xrd.BkgLS==1
    else
        idBkg=1;
    end
    handlesB.uitable1.Data=[handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'...
    handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'-handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)'...
    handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'+handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)' handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)'/1.96];

% Check to see if Statistics Toolbox is Installed
CTB1=license('test','Statistics_toolbox');
if CTB1==0
    pp=ver;
    po=struct2cell(pp);

    for k=1:length(pp)
        ct(k)=strcmp(po{1,1, k},'Statistics and Machine Learning Toolbox');
    end
    CTB2=any(ct);
else 
    CTB2=1;
end

if and(CTB1==0, CTB2==0)
    warndlg('Statistics and Machine Learning Toolbox not found! You will not be able to run a Bayesian analysis until this is installed!','!! Warning !!')
    close(handlesB.figure1)
    return
end
% Update handlesB structure
assignin('base','handlesB',handlesB);
guidata(hObject, handlesB);

% UIWAIT makes BayesLIPRASGUI wait for user response (see UIRESUME)
% uiwait(handlesB.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BayesLIPRASGUI_OutputFcn(hObject, eventdata, handlesB) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)
if isempty(handlesB)
    return
end
% Get default command line output from handlesB structure
varargout{1} = handlesB.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handlesB)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handlesB)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    empty - handlesB not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit1_Callback(hObject, eventdata, handlesB)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)
handlesB.iterations=str2double(hObject.String);

guidata(hObject, handlesB)
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handlesB)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    empty - handlesB not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handlesB)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handlesB)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    empty - handlesB not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handlesB)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)
if handlesB.radiobutton2.Value
    handlesB.radiobutton1.Value=1;
   handlesB.radiobutton2.Value=0;
else handlesB.radiobutton2.Value==0 && handlesB.radiobutton1.Value==0;
    handlesB.radiobutton1.Value=1;
end
% Hint: get(hObject,'Value') returns toggle state of radiobutton1

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handlesB)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)
if handlesB.radiobutton1.Value
    handlesB.radiobutton2.Value=1;
    handlesB.radiobutton1.Value=0;
elseif handlesB.radiobutton2.Value==0 && handlesB.radiobutton1.Value==0;
    handlesB.radiobutton2.Value=1;
end
% Hint: get(hObject,'Value') returns toggle state of radiobutton2

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handlesB)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)
NewDat=evalin('base','handles');
Sig2=str2double(handlesB.edit2.String);
Sig2SD=str2double(handlesB.edit7.String);
Sig2LB=str2double(handlesB.edit5.String);
Sig2UB=str2double(handlesB.edit6.String);
iterations=str2double(handlesB.edit1.String);
burnin=str2double(handlesB.edit3.String);

if handlesB.radiobutton5.Value
    Naive='on';
    handlesB.radiobutton3.Value=1;
    handlesB.radiobutton4.Value=0;
else
    Naive='off';
end
if handlesB.radiobutton3.Value; Default='on'; else; Default='off'; end

SP=handlesB.uitable1.Data(:,1)';
LB=handlesB.uitable1.Data(:,2)';
UB=handlesB.uitable1.Data(:,3)';
SD=handlesB.uitable1.Data(:,4)';
BD=BayesianLIPRAS_F(NewDat, SP, LB, UB, SD, Sig2, Sig2SD, Sig2UB, Sig2LB,iterations, burnin,Naive, Default,handlesB);
handlesB.BD=BD;

if BD.fault==1
    return
end
handlesB.uitable2.Data=BD.acc_ratio;
handlesB.uitable2.Data(:,2:end)=[];
handlesB.uitable2.RowName=handlesB.OD.profiles.FitInitial.coeffs;
handlesB.listbox1.String=handlesB.OD.profiles.FileNames;
handlesB.uitable1.RowName=handlesB.OD.profiles.FitInitial.coeffs;
handlesB.uitable1.Data=[handlesB.BD.SP' handlesB.BD.LB' handlesB.BD.UB' handlesB.BD.param_sd'];

% to update if user changes profile and runs Bayesian, otherwise leave it
% if the user is using "Custom Bounds"

handlesB.edit2.String=handlesB.BD.sigma2;
handlesB.edit7.String=handlesB.BD.sigma2sd;
handlesB.edit5.String=handlesB.BD.sigma2lb;
handlesB.edit6.String=handlesB.BD.sigma2ub;


idBkg=handlesB.OD.profiles.xrd.getBackgroundOrder+2;
    if handlesB.OD.profiles.xrd.BkgLS==1
    else
        idBkg=1;
    end
if length(handlesB.uitable1.Data(:,1))~=length(handlesB.OD.profiles.FitResults{1}{1}.CoeffNames(idBkg:end))
try
    handlesB.uitable1.Data=[handlesB.BD.SP' handlesB.BD.LB' handlesB.BD.UB' handlesB.BD.param_sd'];
catch
    handlesB.uitable1.Data=[handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'...
    handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'-handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)'...
    handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'+handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)' handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)'/1.96];

end
end

idF=handlesB.listbox1.Value; % this will be based on which file to view
subD=5;
nbins=20;

handlesB.text11.String=round(BD.accS(:,1),4); % sigma for model

try
    delete(handlesB.ax(2:end))
catch
end
if handlesB.radiobutton1.Value

for k=1:length(BD.SP)
handlesB.ax1(k)=subplot(subD,subD,k);
histogram(handlesB.ax1(k),BD.param_trace(BD.burnin:end,k),nbins)
title(handlesB.ax1(k),BD.coeffOrig{k})

end
else
    handlesB.radiobutton2.Value=1;
for k=1:length(BD.SP)
handlesB.ax(k)=subplot(subD,subD,k);
plot(BD.param_trace(BD.burnin:end,k))
title(BD.coeffOrig{k})
end
handlesB.ax(k+1)=subplot(subD,subD,k+1);
plot(handlesB.ax(k+1),BD.logp_trace(BD.burnin:end,1,idF))
title('LogLikelihood')
linkaxes(handlesB.ax,'x')
end

numC=length(handlesB.BD.coeff);
numAx=length(handlesB.ax);
if numC~=numAx && numC+1<numAx    
    dif=numAx-numC-2;
    
    delete(handlesB.ax(end-dif:end))
end

assignin('base','handlesB',handlesB);
guidata(hObject, handlesB);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handlesB)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)

% disp('button2')
idF=handlesB.listbox1.Value;
subD=5;
nbins=20;

try
numC=length(handlesB.BD.coeff);
numAx=length(handlesB.ax);
catch
    warndlg('Run a Bayesian Analysis before attemping to plot','!! Warning !!')
    return
end
if numC~=numAx && numC<numAx    
    dif=numAx-numC;
    delete(handlesB.ax(end-dif:end))
end

if handlesB.radiobutton1.Value
linkaxes(handlesB.ax,'off')

for k=1:length(handlesB.BD.SP)
handlesB.ax1(k)=subplot(subD,subD,k);
histogram(handlesB.ax1(k),handlesB.BD.param_trace(handlesB.BD.burnin:end,k,idF),nbins)
title(handlesB.ax1(k),handlesB.BD.coeffOrig{k})
end
else
    handlesB.radiobutton2.Value=1;
for k=1:length(handlesB.BD.SP)
handlesB.ax(k)=subplot(subD,subD,k);
plot(handlesB.BD.param_trace(handlesB.BD.burnin:end,k,idF))
title(handlesB.BD.coeffOrig{k})
end
handlesB.ax(k+1)=subplot(subD,subD,k+1);
plot(handlesB.BD.logp_trace(handlesB.BD.burnin:end,1,idF))
title('LogLikelihood')
linkaxes(handlesB.ax,'x')

end
handlesB.uitable2.Data(:,1)=handlesB.BD.acc_ratio(:,idF);
handlesB.text11.String=round(handlesB.BD.accS(idF),4);

if handlesB.radiobutton6.Value
    x=handlesB.OD.profiles.FitResults{1}{idF}.TwoTheta;
    curve=handlesB.OD.profiles.xrd.getData(idF);
    if any(contains(handlesB.OD.profiles.FitResults{1}{1}.CoeffNames,'bkg'))
    curve1 = handlesB.OD.profiles.FitResults{1}{idF}.FData;
    else
    curve1 = handlesB.OD.profiles.FitResults{1}{idF}.FData+handlesB.OD.profiles.FitResults{1}{idF}.Background;
    end
    curve2 = handlesB.BD.fit_mean(idF,:)+handlesB.OD.profiles.FitResults{1}{idF}.Background;
    curve3 = handlesB.BD.fit_low(idF,:)+handlesB.OD.profiles.FitResults{1}{idF}.Background;
    curve4 = handlesB.BD.fit_high(idF,:)+handlesB.OD.profiles.FitResults{1}{idF}.Background;

    handlesB.Fig3=figure(3);
    clf(handlesB.Fig3)
    hold on;    
    plot(x, curve, 'o','Color', [0 0.17 0.5], 'MarkerFaceColor',[0 0.17 0.5], 'MarkerSize',4)
    plot(x, curve1, 'Color',[0 0.5 0],'LineWidth',1.5);

    plot(x, curve2, 'black', 'LineWidth',1.5);
    plot(x,curve3, '-b', 'LineWidth',1.5);
    plot(x,curve4,'-r','LineWidth',1.5);
   x2=[x fliplr(x)];
   inBetween=[curve2 fliplr(curve3)];
   inBetweenUp=[curve2, fliplr(curve4)];
   fill(x2, inBetween, [0.5 0.5 0.5]);
   fill(x2, inBetweenUp, [0.5 0.5 0.5]);
   alpha(0.25)

   xlabel('2\theta (�)')
   ylabel('Intensity (a.u.)')
    box('on')
    title(['Comparing Fits ' 'for ' handlesB.OD.profiles.FileNames{idF}])
    legend('Obs', 'LS Fit','Bayesian','Low', 'High')
end

assignin('base','handlesB',handlesB);
guidata(hObject, handlesB);

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handlesB)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)

disp('button 3')
if handlesB.radiobutton3.Value==0
    handlesB.uitable1.RowName=handlesB.OD.profiles.FitInitial.coeffs;

    idBkg=handlesB.OD.profiles.xrd.getBackgroundOrder+2; % to remove Bkg Coeffs since they will not be in Bayesian analysis
    if handlesB.OD.profiles.xrd.BkgLS==1
    else
        idBkg=1;
    end
    handlesB.uitable1.Data=[handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'...
    handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'-handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)'...
    handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'+handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)' handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)'/1.96];
msgbox('Bounds reset')
end

if handlesB.radiobutton4.Value
    handlesB.radiobutton3.Value=1;
   handlesB.radiobutton4.Value=0;
elseif handlesB.radiobutton3.Value==0 && handlesB.radiobutton4.Value==0
    handlesB.radiobutton3.Value=1;
end
assignin('base','handlesB',handlesB);
guidata(hObject, handlesB);
% Hint: get(hObject,'Value') returns toggle state of radiobutton3

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handlesB)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)
% disp('button 4')
if handlesB.radiobutton3.Value
    handlesB.radiobutton4.Value=1;
   handlesB.radiobutton3.Value=0;
elseif handlesB.radiobutton3.Value==0 && handlesB.radiobutton4.Value==0;
    handlesB.radiobutton4.Value=1;
end

function edit3_Callback(hObject, eventdata, handlesB)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handlesB)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    empty - handlesB not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handlesB)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handlesB)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    empty - handlesB not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handlesB)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handlesB)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    empty - handlesB not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_Callback(hObject, eventdata, handlesB)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handlesB)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    empty - handlesB not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handlesB)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesB    structure with handlesB and user data (see GUIDATA)
if hObject.Value
    if any(contains(handlesB.OD.profiles.FitResults{1}{1}.CoeffNames,'bkg'))
        calc=handlesB.OD.profiles.FitResults{1}{1}.FData;
    else
        calc=handlesB.OD.profiles.FitResults{1}{1}.FData+handlesB.OD.profiles.FitResults{1}{1}.Background;
    end
nint=handlesB.OD.profiles.xrd.getData(1);
handlesB.edit2.String=round(std((nint-calc))^2, 3);
handlesB.edit7.String= round(sqrt(str2double(handlesB.edit2.String))*2,3);
handlesB.edit5.String= round(prctile(std([nint; calc],0,1),5)^2,3);
handlesB.edit6.String=round(prctile(std([nint; calc],0,1),95)^2,3);
    
end


function bi=BayesianLIPRAS_F(class, SP, LB, UB, SD, Sig2, Sig2SD, Sig2UB, Sig2LB,iterations, burnin,Naive,Default,handlesB)
handles=class;
h=waitbar(0,'Bayesian analysis running...','CreateCancelBtn','delete(gcf)');

numFile=length(handles.profiles.FitResults{1});
bi.burnin=burnin;
bi.iterations=iterations;

for f=1:numFile
 
bi.Eqn=formula(handles.profiles.FitResults{1}{f}.Fmodel); % for when to include Bkg in Bayesian
bi.Eqn_noBkg=handles.profiles.xrd.getEqnStr; % use this to avoid bkg included in Bayesian
bi.Eqn=bi.Eqn_noBkg;

bi.ntt=handles.profiles.FitResults{1}{f}.TwoTheta;
bi.nint=handles.profiles.xrd.getData(f);
bi.nintS(f,:)=bi.nint;
bi.coeff=coeffnames(handles.profiles.FitResults{1}{f}.Fmodel)';

if or(strcmp(Default,'on'), strcmp(Naive,'on'))
bi.SP=handles.profiles.FitResults{1}{f}.CoeffValues;
bi.Err=handles.profiles.FitResults{1}{f}.CoeffError;
bi.m=4;
bi.UB=bi.SP+bi.Err*bi.m;
bi.LB=bi.SP-bi.Err*bi.m;
bi.param_sd=bi.Err/handlesB.mS;

if any(contains(bi.coeff,'bkg') )% ignore Bkg coeffs in Bayesian
bi.coeff(1:handles.profiles.xrd.getBackgroundOrder+1)=[];
bi.SP(1:handles.profiles.xrd.getBackgroundOrder+1)=[];
bi.LB(1:handles.profiles.xrd.getBackgroundOrder+1)=[];
bi.UB(1:handles.profiles.xrd.getBackgroundOrder+1)=[];
bi.param_sd(1:handles.profiles.xrd.getBackgroundOrder+1)=[];
bi.Err(1:handles.profiles.xrd.getBackgroundOrder+1)=[];
end

else
    bi.SP=SP;
    bi.Err=SD*handlesB.mS;
    bi.UB=UB;
    bi.LB=LB;
    bi.param_sd=SD;
    
    if any(contains(bi.coeff,'bkg') )% ignore Bkg coeffs in Bayesian
    bi.coeff(1:handles.profiles.xrd.getBackgroundOrder+1)=[];
    end
end

if any(isnan(bi.Err))
bi.Err(isnan(bi.Err))=.01;
disp('Fixed NaN in Err')
end 

bi.coeffOrig=bi.coeff;
Fxn=bi.Eqn;
Fxn=strrep(Fxn,'*','.*');
Fxn=strrep(Fxn,'^','.^');
Fxn=strrep(Fxn,'/','./');
bb=strcat(bi.coeff,',');
coeff=strcat(bb{:});
jp=strcat('@(', coeff,'xv) ');

FxnF = str2func([jp Fxn]);
xv=bi.ntt;

if strcmp(Naive,'on')
    if any(contains(handles.profiles.FitResults{1}{1}.CoeffNames,'bkg') )% ignore Bkg coeffs in Bayesian
    calc=handles.profiles.FitResults{1}{f}.FData;
    else
    calc=handles.profiles.FitResults{1}{f}.FData+handles.profiles.FitResults{1}{f}.Background;
    end
bi.sigma2 = std((bi.nint-calc))^2;
bi.sigma2sd = sqrt(bi.sigma2)*2;
bi.sigma2ub= prctile(std([bi.nint; calc],0,1),95)^2;
bi.sigma2lb= prctile(std([bi.nint; calc],0,1),5)^2;
else
    bi.sigma2 = Sig2;
    bi.sigma2sd = Sig2SD;
    bi.sigma2ub= Sig2UB;
    bi.sigma2lb= Sig2LB;
end

acc=zeros(length(bi.SP),1); % need to reset for every file
accS=0;

if f==1
param=bi.SP;
acc=zeros(length(bi.SP),1);
logp_trace=zeros(bi.iterations,1);
param_trace = zeros(bi.iterations, length(param),numFile);
sigma2_trace = zeros(bi.iterations,1, numFile);
fit_trace = zeros(bi.iterations-bi.burnin,length(bi.nint));
logp=zeros(bi.iterations,1);
logp_new=zeros(bi.iterations,1);
ob_count = zeros(length(param),1); % counter when random parameters are out of bound
num_var=length(param);
sigma2Orig=bi.sigma2;
end

Bkg=handles.profiles.FitResults{1}{f}.Background;

for RBay=1:1 % for future release, allow repetitions of Bayesian analysis
    if RBay>1
    param=[p1.mu p2.mu p3.mu p4.mu p5.mu p6.mu p7.mu p8.mu];
    param_sd=[p1.sigma p2.sigma p3.sigma p4.sigma p5.sigma p6.sigma p7.sigma p8.sigma];
    end
tic
for i=1:bi.iterations
        inp=[num2cell(param,1) {xv}];
        fit_total=FxnF(inp{:});
        fit_total=fit_total(1,:);
        logp(i)=LogLike(bi.nint, fit_total(1,:)+Bkg,bi.sigma2);
%% Cycle Through Indiv. Params 
    for j=1:num_var
        param_new= param;
        rand_param=normrnd(param(j),bi.param_sd(j)); % generate random number from norm distribution with mean param(j) and sigma sd
            if rand_param>bi.UB(j) || rand_param<bi.LB(j) % check to make sure they are within the UB and LB
                ob_count(j)=ob_count(j)+1; % counts how many times parameters are generated outside UB and LB
                prob=1E-100; % sets Prob to zero 
            else
            param_new(j)=rand_param;   % Newly generated parameter substitutes into array of parameters that describe the model       
            inp_new=[num2cell(param_new,1) {xv}]; % Formatting for vectorization
            fit_total_new=FxnF(inp_new{:}); % Computes the model for all 2theta values
            fit_total_new=fit_total_new(1,:);
            logp_new(i)=LogLike(bi.nint, fit_total_new(1,:)+Bkg, bi.sigma2); % calculates loglikelihood using MATLAB's pdf function using 'Normal' distribution
            prob=min(exp(logp_new(i)-logp(i)),1); % calculate probability, 
            end
    r=rand(1); % generate random number
    if r<=prob %  accepts the new parameters
    param=param_new;
    fit_total=fit_total_new;
    logp(i)=logp_new(i); % store calculated loglikelihood 
    if i>=bi.burnin
    acc(j)=acc(j)+1; % acceptance 
    end
    end         
            logp_trace(i,1,f)=logp(i); % stores loglikelihood into trace of loglikelihood
            param_trace(i,:,f)=param; % stores params in fit trace
    end % ends the for loop for cycling through each variable in the model
    
%% Draw New Sigma2
% bi.sigma2_new=gamrnd(0.1+length(bi.nint)/2, 1/(0.1+(0.5*sum((bi.nint-fit_total_new).^2))^-1)); % new sigma2 from normal distribution with mean(sigma2) and sigma(sigma2sd)
% sigma2_new=1./gamrnd(0.001+length(nint)/2, (0.001+0.5*sum((nint-fit_total_new).^2))^-1);
% sigma2_new=1/gamrnd(0.1+length(nint)/2, (0.1+0.5*sum((nint-fit_total_new).^2))^-1);
% tau is sigma to -2 which has gamma(a,b), prob

bi.sigma2_new=normrnd(bi.sigma2,bi.sigma2sd); % new sigma2 from normal distribution with mean(sigma2) and sigma(sigma2sd)
   
   % autocorrelation, correlation between samples as a function lag (how
   % far apart they are). Have autocorrelation plot for every parameter.
   % calculate of an effective sample size, if its its high its good or
   % close to the number of actual samples you drew
   
    if bi.sigma2_new>bi.sigma2ub || bi.sigma2_new < bi.sigma2lb % checks to insure newly generated variable is withing range 
        ob_count(num_var)=ob_count(num_var)+1;
        prob=1E-100;
    else
        % This is for sigma2 so param is used instead of param_new, param is newly accepted or previously accepted list of params in iteration
        inp_new=[num2cell(param,1) {xv}];  % Formatting for vectorization
        fit_total_new=FxnF(inp_new{:}); % Compute the model with current parameters
        fit_total_new=fit_total_new(1,:);
        logp_new(i)=LogLike(bi.nint, fit_total_new(1,:)+Bkg, bi.sigma2_new);  % calculate Loglikelihood
        prob=min(exp(logp_new(i)-logp(i)),1); % calculate probability

    end

r=rand(1); % generate random number 
if r<=prob % accepts sigma2 if prob is greater than or equal to r
bi.sigma2=bi.sigma2_new;
fit_total=fit_total_new;
logp(i)=logp_new(i);
    if i>=burnin
    accS=accS+1;
    end
end
       
sigma2_trace(i,1,f)=bi.sigma2; % store sigma2

if i>bi.burnin
    fit_trace(i-bi.burnin,:,f)=fit_total(1,:); % stores fit_trace after burnin has been met
end
% Status
if rem(i,1000)==0 
    numera(f)=i;
    perc=(sum(numera))/(iterations*numFile)*100;
    try
        waitbar(perc/100,h, sprintf('%s %.2f%%','Bayesian analysis running...',perc),'CreateCancelBtn');
        BD.fault=0;
    catch
        bi.fault=1;
        return
        h=waitbar(perc/100,sprintf('%s %.2f%%','Bayesian analysis running...',perc));
    end
    disp(i)
end        
end
end

% Timer
et(f)=toc;
toc

atime(f)=(length(handles.profiles.FitResults{1})-f)*mean(et);
disp(['Time left= ',num2str(atime(f)) 'secs']);

% Acceptance Ratio
bi.acc_ratio(:,f) = acc/(bi.iterations-bi.burnin);
bi.accS(:,f)=accS/(bi.iterations-bi.burnin);
% Fit, Error, Sigma
    bi.fit_mean(f,:)=mean(fit_trace(:,:,f));
    bi.fit_sigma(f,:) =std(fit_trace(:,:,f)); % this assumes a normal distributon for resulting parameters, needs to change
    bi.fit_low(f,:) = prctile(fit_trace(:,:,f),2.5); % takes percentiles to represent std of parameters
    bi.fit_high(f,:) = prctile(fit_trace(:,:,f),97.5);
end
fprintf('%s %f\n','Acceptance for Sigma= ',bi.accS)
for f=1:f
% File Writer
filess=handles.gui.FileNames{f};
nf=strsplit(filess,'.');
nfs{f}=nf{1};
masterfilename1 = [handles.gui.DataPath nf{1} '_Bayesian_Param_Trace' '.Bayes'];
masterfilename2= [handles.gui.DataPath nf{1} '_Bayesian_LogP_Sigma2_Trace' '.Bayes'];
masterfilename3= [handles.gui.DataPath nf{1} '_Bayesian_Fit_Mean_Error_Sigma' '.Bayes'];

fidmaster1 = fopen(masterfilename1, 'w');
       fprintf(fidmaster1,'%s\t', bi.coeffOrig{:});
       fprintf(fidmaster1, '\n');

fidmaster2 = fopen(masterfilename2, 'w');
    fprintf(fidmaster2, 'LogLikelihood Trace\t Sigma Trace \n');
    
fidmaster3 = fopen(masterfilename3, 'w');
    fprintf(fidmaster3, '2-theta \t Fit Mean\t Fit High\t Fit Low\t Sigma \n');

       for i=1:length(param_trace)
           % Param_trace
           line = param_trace(i,:,f);
           fprintf(fidmaster1, '%2.8f\t', line(:));
           fprintf(fidmaster1, '\n');
           % Likelihood trace
           line2 = [logp_trace(i,1,f) sigma2_trace(i,1,f)];
           fprintf(fidmaster2, '%2.8f\t', line2(:));
           fprintf(fidmaster2, '\n');            
       end
       
       for o=1:length(bi.ntt)
                       % Fit trace
           line3 = [bi.ntt(o) bi.fit_mean(f,o) bi.fit_high(f,o) bi.fit_low(f,o) bi.fit_sigma(f,o)];
           fprintf(fidmaster3, '%2.8f\t', line3(:));
           fprintf(fidmaster3, '\n');   
       end
       
fclose('all');

obs=bi.nintS(f,:);
calc=bi.fit_mean(f,:)+Bkg;

Rp(f)=sum(abs(obs-calc))/sum(obs)*100; % caculate a goodness-of-fit value, the lower the better
w(:,f)=handles.profiles.FitResults{1}{f}.LSWeights;
Rwp(f)=sqrt(sum(w(:,f)'.*(obs-calc).^2)/sum(w(:,f)'.*(obs).^2))*100; % caculate a goodness-of-fit value, the lower the better
fprintf('%s %.4f %s\n','LSRp=',handles.profiles.FitResults{1}{f}.Rp,'%')
fprintf('%s %.4f %s\n','BayesRp=',Rp(f),'%')
end

bi.param_trace=param_trace;
bi.sigma2_trace=sigma2_trace;
bi.logp_trace=logp_trace;
bi.numFile=numFile;
bi.Rp=Rp;
bi.Rwp=Rwp;
bi.fault=0;
bi.sigma2=sigma2Orig; % this is so the sigma2 value that was used as a starting parameter is not erased in edit box
close(h)


function [logp]=LogLike(nint,fit_total,sigma)
sd=sqrt(sigma);
logp=sum(log(pdf('Normal',nint, fit_total, sd)));


function edit7_Callback(hObject, eventdata, handlesB)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double

function PlotSigma2Trace(hObject,eventdata, handlesB)
try
handlesB.BD;
catch
    warndlg('Run a Bayesian Analysis before attemping to plot','!! Warning !!')
    return
end

handlesB.Fig4=figure(4);
clf(handlesB.Fig4)
id=handlesB.BD.burnin;
plot(handlesB.BD.sigma2_trace(id:end,1,handlesB.listbox1.Value))
xlabel('Iterations- Burnin')
ylabel('\sigma^2')
title(['\sigma^2 Trace ' 'for ' handlesB.OD.profiles.FileNames{handlesB.listbox1.Value}])



% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handlesB)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handlesB.m=str2double(hObject.String{hObject.Value});

    idBkg=handlesB.OD.profiles.xrd.getBackgroundOrder+2; % to remove Bkg Coeffs since they will not be in Bayesian analysis
    if handlesB.OD.profiles.xrd.BkgLS==1
    else
        idBkg=1;
    end
    handlesB.uitable1.Data(:,2:3)=[handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'-handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)'*handlesB.m...
    handlesB.OD.profiles.FitResults{1}{1}.CoeffValues(idBkg:end)'+handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)'*handlesB.m];


assignin('base','handlesB',handlesB);
guidata(hObject, handlesB);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handlesB)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hObject.Value=7;
handlesB.m=str2double(hObject.String{hObject.Value});
assignin('base','handlesB',handlesB);
guidata(hObject, handlesB);
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handlesB)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handlesB.mS=str2double(hObject.String{hObject.Value});


    idBkg=handlesB.OD.profiles.xrd.getBackgroundOrder+2; % to remove Bkg Coeffs since they will not be in Bayesian analysis
    if handlesB.OD.profiles.xrd.BkgLS==1
    else
        idBkg=1;
    end
    handlesB.uitable1.Data(:,4)=handlesB.OD.profiles.FitResults{1}{1}.CoeffError(idBkg:end)'/handlesB.mS;



assignin('base','handlesB',handlesB);
guidata(hObject, handlesB);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handlesB)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hObject.Value=7;
handlesB.mS=str2double(hObject.String{hObject.Value});

assignin('base','handlesB',handlesB);
guidata(hObject, handlesB);
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end