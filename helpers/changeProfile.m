function handles = changeProfile(hObject, handles)
% hObject is handles.profiles(i) where i=profile number to change
profile = find(hObject==handles.profiles,1);
filenum = handles.popup_filename.Value;

% uipanels
handles.uipanel3 = hObject;
handles.uipanel10 = findobj(hObject.Children,'tag','uipanel10');
handles.uipanel16=findobj(hObject.Children,'tag','uipanel16'); 
handles.uipanel17 = findobj(hObject.Children,'tag','uipanel17');
handles.uipanel18 = findobj(hObject.Children,'tag','uipanel18');
handles.uipanel1 = findobj(hObject.Children,'Tag','uipanel1'); % background 
handles.uipanel4 = findobj(hObject.Children,'Tag','uipanel4'); % table
handles.uipanel5 = findobj(hObject.Children,'Tag','uipanel5'); % constraints
handles.uipanel6 = findobj(hObject.Children,'Tag','uipanel6'); % peak functions 

% edit fields
handles.edit_bkgdpoints = findobj(hObject.Children,'Tag','edit_bkgdpoints');
handles.edit_polyorder = findobj(hObject.Children,'Tag','edit_polyorder');
handles.edit_max2t = findobj(hObject.Children,'Tag','edit_max2t');
handles.edit_min2t = findobj(hObject.Children,'Tag','edit_min2t');
handles.edit7 = findobj(hObject.Children,'Tag','edit7'); % fit range box
handles.edit_lambda=findobj(hObject.Children,'tag','edit_lambda');

% popupmenus
handles.popup_function1 = findobj(handles.uipanel6.Children,'Tag','popup_function1');
handles.popup_function2 = findobj(handles.uipanel6.Children,'Tag','popup_function2');
handles.popup_function3 = findobj(handles.uipanel6.Children,'Tag','popup_function3');
handles.popup_function4 = findobj(handles.uipanel6.Children,'Tag','popup_function4');
handles.popup_function5 = findobj(handles.uipanel6.Children,'Tag','popup_function5');
handles.popup_function6 = findobj(handles.uipanel6.Children,'Tag','popup_function6');
handles.popup_numpeaks = findobj(hObject.Children,'Tag','popup_numpeaks');

% pushbuttons
handles.push_newbkgd = findobj(handles.uipanel3.Children,'Tag','push_newbkgd');
handles.pushbutton15 = findobj(hObject.Children,'Tag','pushbutton15'); % Update button
handles.push_nextprofile = findobj(hObject.Children,'Tag','push_nextprofile');
handles.push_prevprofile = findobj(hObject.Children,'Tag','push_prevprofile');
handles.pushbutton17 = findobj(handles.uipanel4.Children,'Tag','pushbutton17');
handles.push_fitdata = findobj(handles.uipanel4.Children,'Tag','push_fitdata');
handles.push_default = findobj(handles.uipanel4.Children,'Tag','push_default');

% checkboxes
handles.checkboxm = findobj(handles.uipanel5.Children,'Tag','checkboxm');
handles.checkboxw = findobj(handles.uipanel5.Children,'Tag','checkboxw');
handles.checkboxf = findobj(handles.uipanel5.Children,'Tag','checkboxf');
handles.checkboxN = findobj(handles.uipanel5.Children,'Tag','checkboxN');
handles.checkbox_lambda=findobj(hObject.Children,'tag','checkbox_lambda');

% static texts
handles.text_numprofile = findobj(hObject.Children,'Tag','text_numprofile');
handles.text18 = findobj(handles.uipanel6.Children,'Tag','text18');
handles.text17 = findobj(handles.uipanel6.Children,'Tag','text17');
handles.text15 = findobj(handles.uipanel6.Children,'Tag','text15');
handles.text14 = findobj(handles.uipanel6.Children,'Tag','text14');
handles.text13 = findobj(handles.uipanel6.Children,'Tag','text13');
handles.text7 = findobj(handles.uipanel6.Children,'Tag','text7');
handles.text_wavelength=findobj(hObject.Children,'tag','text_wavelength');

% uitable
handles.uitable1 = findobj(handles.uipanel4.Children,'Tag','uitable1');

% tabs
handles.tabgroup=findobj(handles.profiles(profile).Children,'tag','tabgroup');
handles.tab_setup=findobj(handles.profiles(profile).Children,'tag','tab_setup');
handles.tab_peak=findobj(handles.profiles(profile).Children,'tag','tab_peak');

% xrd
handles.xrd = handles.xrdContainer(profile);

set(handles.text_numprofile,'string',...
	['Profile ',num2str(profile),' of ', 'TO DO']);

plotX(handles);

assignin('base','handles',handles)

guidata(hObject,handles)
