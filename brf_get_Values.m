
% The purpose of this function is for the "Linecut" function.
% This function will find the values that match with the correspondig UID's
% This is the SECOND and LAST step to getting the values to be plotted with linecuts

% Parameters should be entered as followed:
% (UIDs of values, values to pick from, condition's UIDs)
% Output the values found with the UID's

function newValues = brf_get_Values(varargin)
    valUID = varargin{1};
    values = varargin{2};
    conUID = varargin{3};
    key = size(conUID);
    newValues = {};

    index = 1;
    
    msgbox('Finding Values...');
    for i = 1:size(values)
        if ~isempty(conUID{mod(key,valUID{i}), 1})
            newValues{index} = values{i};
            index = index + 1;
        end
    end
end