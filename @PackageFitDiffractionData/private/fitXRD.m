function fitXRD(Stro, data, position, filenum)

% BACKGROUND FITTING
R = 1; %in points each direction for the background averaging, must be integer
for i=1:length(Stro.bkgd2th);
		bkgd2thX(i)=Stro.Find2theta(data(1,:),Stro.bkgd2th(i));
end;

for i=1:length(Stro.bkgd2th); bkgdInt(i)=mean(data(2,(bkgd2thX(i)-R:bkgd2thX(i)+R))); end;
% Added by Klarissa to  get rid of centering and scaling warning
[P, S, U] = polyfit(Stro.bkgd2th,bkgdInt,Stro.PolyOrder);

% FOR GUI, BACKGROUND
hold on
plot(data(1,:),polyval(P,data(1,:),S,U),'k-') %to check okay
plot(Stro.bkgd2th,bkgdInt,'ro','MarkerSize',6,'LineWidth',1.5, 'MarkerFaceColor','auto');
%END

% Make new matrix with NB ("no background")
dataNB = data;
dataNB(2,:) = data(2,:) - polyval(P,data(1,:),S,U);
% Stro.fit_results{i}
% column 1 = 2theta
% column 2 = raw data
% column 3 = background function
% column 4 = Overall fit w/o background
% column 5 = 1st peak w/o background...
% column 6+ = next peak w/o background..., etc.
fitteddata=data;
fitteddata(3,:)=polyval(P,data(1,:),S,U);

% Size of array to fit
fitrangeX=length(dataNB(1,:));

% ITERATE PEAK FITTING PER PROFILE
for i=1:size(position,1)
		% Add CuKa if statement here
		avg = mean(position(i,:)); % average of all peaks
		positionX(i) = PackageFitDiffractionData.Find2theta(dataNB(1,:),avg); % index into dataNB array
		minr=positionX(i)-floor(fitrangeX(i)/2);
		if minr<1; minr=1; end
		maxr=positionX(i)+ceil(fitrangeX(i)/2);
		if maxr>fitrangeX; maxr=fitrangeX; end
		fitdata{i} = dataNB(:,minr:maxr);
		assignin('base','fitdata',fitdata) % ADDED BY GIO
		%                 figure(3);
		%                 plot(fitdata{filenum,i}(1,:),fitdata{filenum,i}(2,:));
		
		g=Stro.makeFunction(Stro.PSfxn(i,:),fitdata{i},position(i,:));
		
		coefficients{i}=coeffnames(g);
		len=length(coefficients{1});
		if exist('InputPSfxn','var')==1
				InputPSfxn=evalin('base','InputPSfxn');
		end
	
		SP = Stro.fit_initial{1,filenum};
		UB = Stro.fit_initial{2};
		LB = Stro.fit_initial{3};
		
		s = fitoptions('Method','NonlinearLeastSquares','StartPoint',SP,'Lower',LB,'Upper',UB);
		[fittedmodel{i},fittedmodelGOF{i}]=fit(fitdata{i}(1,:)',fitdata{i}(2,:)',g,s);
		fittedmodelCI{i} = confint(fittedmodel{i}, Stro.level);
		% store fitted data, aligned appropriately in the column
		fitteddata(i+3,minr:maxr)=fittedmodel{i}(fitdata{i}(1,:));
		assignin('base','fitteddata',fitteddata)
		cla
		% FOR GUI, FIT
		plot(fitdata{i}(1,:),fittedmodel{i}(fitdata{i}(1,:))'+polyval(P,fitdata{i}(1,:),S,U),'-g','LineWidth',0.5);
		pause(0.05);
		%END
		
		% FOR GUI, DATA
		plot(data(1,:),data(2,:),'x','MarkerSize',6,'LineWidth',1,'MarkerEdgeColor','b', 'MarkerFaceColor','auto') % CHANGES MARKER COLOR
		% END
		
		% FOR GUI DIFFERENCE PLOT
		evalin('base','axes(handles.axes2)')
		cla
		for j=1:size(position,1);
				plot(fitdata{j}(1,:),fitdata{j}(2,:)-fittedmodel{j}(fitdata{j}(1,:))','-r');
		end
		xlim([Stro.Min2T Stro.Max2T])
		
		evalin('base', 'linkaxes([handles.axes1 handles.axes2],''x'')')
		evalin('base','axes(handles.axes1)')
		% END
		
		% 				if strcmp(Stro.plotyn,'y')
		% 					plot(fitdata{i}(1,:),fittedmodel{i}(fitdata{i}(1,:))'+polyval(P,fitdata{i}(1,:)),'-g');
		% 					pause(0.05);
		% 				end
end

Stro.Fdata = fitteddata;
Stro.Fcoeff = coefficients;

for i=1:size(position,1)
		Stro.Fmodel{filenum,i} = fittedmodel{i};
		Stro.FmodelGOF{filenum,i} = fittedmodelGOF{i};
		Stro.FmodelCI{filenum,i} = fittedmodelCI{i};
end

end