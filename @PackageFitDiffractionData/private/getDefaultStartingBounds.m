function output = getDefaultStartingBounds(Stro)
output = [];
if isempty(Stro.FitFunctions) || ~isempty(find(cellfun(@isempty,Stro.FitFunctions),1))
    return
elseif isempty(Stro.PeakPositions) || ~isempty(find(Stro.PeakPositions==0,1))
    return
end

coefflist = Stro.getCoeffs;
result = zeros(1, length(coefflist));
for i=1:length(Stro.FitFunctions)
    Stro.FitFunctions{i}.PeakPosition = Stro.PeakPositions(i);
end

for i=1:length(coefflist)
    c = coefflist{i};
    % Finds the first function to have a coefficient with the same name
    for j=1:length(Stro.FitFunctions)
        fcn = Stro.FitFunctions{j};
        fcn.RawData = [Stro.getTwoTheta; Stro.getDataNoBackground()];
        
        vals = fcn.getDefaultInitialValues(fcn.RawData);
        fc = fcn.getCoeffs;
        idx = find(strcmpi(fc, c), 1);
        
        if ~isempty(idx)
            result(i) = vals.(c(1));
            break
        end
    end
    
end
output = result;
end

