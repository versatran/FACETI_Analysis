% Convenience script for deleting any and all app data that has been set in
% the current session with setappdata().
%
% Author: Elliot Tuck
% Date: 20170803
function deleteAppData()
    names = fieldnames(getappdata(0));
    for k = 1:length(names)
        rmappdata(0, names{k});
    end
end