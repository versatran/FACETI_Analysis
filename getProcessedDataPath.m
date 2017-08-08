% Get the appropriate path to save processed_data to.
%
% Author: Elliot Tuck
% Date: 20170804
function processed_data_path = getProcessedDataPath()
    data_path = getappdata(0, 'data_path');
    [path, name, ext] = fileparts(data_path);
    processed_data_path = [path filesep name '_processed' ext];
end