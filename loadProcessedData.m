% Load processed_data if it exists. If it does not already exist, do
% nothing.
%
% Author: Elliot Tuck
% Date: 20170804
function loadProcessedData()
    % see if processed data for this dataset exists, and load it in if it
    % does
    processed_data_path = getProcessedDataPath();
    if (exist(processed_data_path, 'file'))
        % processed_data exists, so load it in
        load(processed_data_path);
        
        % save processed_data to app data
        setappdata(0, 'processed_data', processed_data);
    end
end