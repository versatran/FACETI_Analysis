% Given the full name of a dataset directory, return just the number of the
% dataset itself.
%
% Author: Elliot Tuck
% Date: 20170728
function dataset_str = getDatasetString(fullString)
    underscoreIndex = regexp(fullString, '_', 'once');
    dataset_str = fullString(underscoreIndex(1) + 1:end);
end