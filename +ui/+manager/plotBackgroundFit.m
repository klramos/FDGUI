function handles = plotBackgroundFit( handles )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here


plotBkPoints(handles);





function plotBkPoints(handles) % plots points and BkgFit

[points, idx] = handles.xrd.getBkgdPoints();

% The current file TODO: "getCurrentFile(handles.popup_filename)"
iFile = handles.popup_filename.Value;
data = handles.xrd.getRangedData(iFile);
[P, S, U] = PackageFitDiffractionData.fitBkgd(data, handles.xrd.bkgd2th, handles.xrd.PolyOrder);
bkgdArray = polyval(P,data(1,:),S,U);

cla(handles.axes1)

hold on
plot(handles.axes1,data(1,:),data(2,:),'-o','LineWidth',0.5,'MarkerSize',4, 'MarkerFaceColor', [0 0 0])
plot(handles.axes1, points, data(2,idx), 'rd', 'markersize', 5, ...
    'markeredgecolor', 'r', 'markerfacecolor','r');
plot(handles.axes1,data(1,:),bkgdArray,'--')

