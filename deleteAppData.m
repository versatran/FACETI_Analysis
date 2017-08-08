% Convenience script for deleting app data (except processed_data) that has 
% been set in the current session with setappdata().
%
% Author: Elliot Tuck
% Date: 20170808
function deleteAppData()
    names = fieldnames(getappdata(0));
    for k = 1:length(names)
        if (~isequal(names{k}, 'processed_data'))
            rmappdata(0, names{k});
        end
    end
end