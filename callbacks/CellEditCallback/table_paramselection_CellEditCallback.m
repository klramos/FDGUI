function table_paramselection_CellEditCallback(hObject, evt, handles)
	set_available_constraintbox(handles);
	
	try
		fcnNames = hObject.Data(:, 1)';
	catch
		fcnNames=hObject.Data';
	end
	peakHasFunc = ~cellfun(@isempty, fcnNames);
	
	
	setappdata(handles.uipanel3, 'PSfxn', fcnNames);
	setappdata(hObject, 'PSfxn', fcnNames);
	
	
	data.PSfxn = fcnNames;
	for i=2:length(hObject.ColumnName)
		data.(hObject.ColumnName{i}) = hObject.Data{:, i};	
	end
	
	% Enable buttons if all peaks have a fit function selected
	if isempty(find(~peakHasFunc, 1))
		set(handles.push_selectpeak, 'enable', 'on', 'visible', 'on');
		coeff = handles.xrd.getCoeff(fcnNames, handles.panel_constraints.UserData);
		setappdata(hObject, 'coeff', coeff);
		setappdata(handles.uipanel3, 'coeff', coeff);
		
	else
		set(handles.push_selectpeak, 'enable', 'off');
	end
	
	switch isempty(getappdata(handles.uipanel3, 'fit_initial'))
		case 1
			set(handles.push_cancelupdate, 'visible', 'off');
		case 0
			set(handles.push_cancelupdate, 'visible', 'on');
	end
	
	if ~isempty(getappdata(handles.uipanel3, 'PeakPositions'))
		set(handles.push_update,'enable', 'on')
	else
		set(handles.push_update,'enable', 'on')
	end
	
guidata(hObject, handles);