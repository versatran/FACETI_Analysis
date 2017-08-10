% Set any given application data.
% INPUT:
%   set_app_data    Application data that needs to be set using
%                   setappdata()
%
% Author: Elliot Tuck
% Date: 20170810
function setApplicationData(set_app_data)
    names = fieldnames(set_app_data);
    for k = 1:length(names)
        setappdata(0, names{k}, set_app_data.(names{k}));
    end
end