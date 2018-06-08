
% The purpose of this function is for the "Linecut" function.
% This function will find the values that match with the correspondig UID's
% This is the SECOND and LAST step to getting the values to be plotted with linecuts

% Parameters should be entered as followed:
% (UIDs of values, values to pick from, condition's UIDs)
% Output the values found with the UID's

function [newValues, UIDs] = brf_get_Values(varargin)
    valUID = varargin{1};
    values = varargin{2};
    conUID = varargin{3};
    key = length(conUID);
    newValues = {};
    UIDs = {};
    count = 1;
    
    a = msgbox('Finding Values...');
    for i = 1:length(values)
        index = mod(valUID(i), key);
        if conUID{index, 1, 1} > 1
            for k = 2:conUID{index, 1, 1}
                if conUID{index, 1, k} == valUID(i)
                    newValues{count} = values(i)
                    UIDs{count} = valUID(i);
                    count = count+1;
                    break;
                end
            end
        end
    end
    delete(a);
end