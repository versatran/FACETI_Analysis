
% The purpose of this function is for the "Linecut" function.
% This function will find the UID's that match with the corresponding
% condition
% This is the FIRST step to getting the values to be plotted with linecuts

% Parameters should be entered as followed:
% (UID's, values, condition)
% Output the UID's found from the corresponding values
function newUIDs = brf_get_UIDs(varargin)
    UIDs = varargin{1};
    values = varargin{2};
    condition = varargin{3};
    min = condition{2};
    max = condition{3};
    key = 9999999992999999999;
    newUIDs = cell(key, 1);
    msgbox('Finding UIDs...');
    for i = 1:size(values)
        if values{i} > min && values{i} < max
            newUIDs{mod(key,UIDs{i}), 1} = UIDs{i};
        end
    end
    if isempty(newUIDs)
        error('No matching UIDs for this condition');
    end
end