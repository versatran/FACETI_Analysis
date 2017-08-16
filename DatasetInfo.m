% Contains information about a particular dataset, such as the source
% directory, server, experiment number, etc.
%
% Author: Elliot Tuck
% Date: 20170815
classdef DatasetInfo < handle
    properties
        source_dir
        server_str
        expt_str
        year_str
        date_str
        dataset_str
        data_path
    end
    methods
        function obj = DatasetInfo()
            % default constructor
        end
    end
end