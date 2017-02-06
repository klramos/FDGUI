classdef DiffractionData
    %DIFFRACTIONDATA Contains the raw data to be used for fitting.
    
    properties
        FileName
        DataPath
        Min2T
        Max2T
    end
    
    properties (Hidden, GetAccess = protected, SetAccess = immutable)
        FullTwoTheta
        FullIntensityData
    end
    
    properties (Hidden)
        
        
    end
    
    methods
        function this = DiffractionData(data, filename, fileIndex)
        % Constructor
        this.FullTwoTheta = data.two_theta(fileIndex,:);
        this.FullIntensityData = data.data_fit(fileIndex,:);
        this.FileName = filename;
        this.Min2T = this.FullTwoTheta(1);
        this.Max2T = this.FullTwoTheta(end);
        end
    end
    
    methods
        
        function result = getDataIntensity(this, range)
        %GETDATAINTENSITY Returns the intensity data in the range specified by
        %   the argument 'range'. If the range isn't specified, it uses the
        %   Min2T and Max2T properties.
        %
        %RANGE - 1x2 numeric array of the two theta range
        if nargin < 2
            range = [this.Min2T this.Max2T];
        end
        
        indices = utils.findIndex(this.FullTwoTheta, range);
        
        result = this.FullIntensityData(indices(1):indices(2));
        end
        
        function result = getDataTwoTheta(this, range)
        %GETDATATWOTHETA Returns the two theta points in the range specified in the
        %   argument 'range'. If the range isn't specified, it uses the Min2T
        %   and Max2T properties.
        %
        %RANGE - 1x2 numeric array of the two theta range
        if nargin < 2
            range = [this.Min2T this.Max2T];
        end
        
        indices = utils.findIndex(this.FullTwoTheta, range);
        
        result = this.FullTwoTheta(indices(1):indices(2));
        end
        
        
    end
    
    methods (Static)
        
        
        
    end
    
end

