% Create the temporary data struct that is used to quickly save/load data,
% such as processed images.
%
% Author: Elliot Tuck
% Date: 20170803
function set_app_data = createProcessedData(data, set_app_data)
    fields = fieldnames(data.processed);
    for k = 1:length(fields)
        processed_data = set_app_data.processed_data;
        processed_data.(fields{k}) = struct();
        set_app_data.processed_data = processed_data;
    end
end