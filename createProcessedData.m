% Create the temporary data struct that is used to quickly save/load data,
% such as processed images.
%
% Author: Elliot Tuck
% Date: 20170803
function processed_data = createProcessedData()
    data = getappdata(0, 'data');
    fields = fieldnames(data.processed);
    for k = 1:length(fields)
        processed_data.(fields{k}) = struct();
    end
    setappdata(0, 'processed_data', processed_data);
end