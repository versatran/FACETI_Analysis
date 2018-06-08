
% The purpose of this function is for the "Linecut" function.
% This function will find the UID's that match with the corresponding
% condition
% This is the FIRST step to getting the values to be plotted with linecuts

% Parameters should be entered as followed:
% (parameters, condition)
% Output the UID's found from the corresponding values
function newUIDs = brf_get_UIDs(varargin)
    parameters = varargin{1};
    condition = varargin{2};
    min = condition{2};
    max = condition{3};
    data = getappdata(0, 'data');
    param_str = string(parameters);
    
    index = find(param_str==condition{1});
    
    [UIDs, values] = eda_extract_data(data, condition{1}, index);
    
    key = 1999;
    a = msgbox('Initializing matrix...');
    for i = 1:key
        newUIDs{i, 1, 1} = 1;
    end
    UID_index = 1;
    delete(a);
    b = msgbox('Finding UIDs...');
    
    for i = 1:length(values)
        if values(i) > min && values(i) < max
            UID_index = mod(UIDs(i), key);
            list_index = newUIDs{UID_index, 1, 1} + 1;
            newUIDs{UID_index, 1, list_index} = UIDs(i);
            newUIDs{UID_index, 1, 1} = list_index;
        end
    end
    delete(b);
end