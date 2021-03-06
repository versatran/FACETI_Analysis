
% The purpose of this function is for the "Linecut" function.
% This function will find the UID's that match with the corresponding
% condition
% This is the FIRST step to getting the values to be plotted with linecuts

% Parameters should be entered as followed:
% (parameters, condition)

% Output the UID's **in a chained hash tabled** found from the 
% corresponding values
function newUIDs = brf_get_UIDs(varargin)

    %initializes the parameters
    parameters = varargin{1};
    condition = varargin{2};

    data = getappdata(0, 'data');
    param_str = string(parameters);
    
    % pulls the index in where the condition is stored in the data's
    % parameters
    
    if iscell(condition)
        index = find(param_str==condition{1});
        condition_name = condition{1};
    else
        index = find(param_str==condition);
        condition_name = condition;
    end
    
    % gets the UIDs and values for that condition
    [UIDs, values] = eda_extract_data(data, condition_name, index);
    
    if iscell(condition)
        minimum = condition{2};
        maximum = condition{3};
    else
        minimum = min(values);
        maximum = max(values);
    end
    % this is where chained hashing takes place
    key = 1999;
    a = msgbox('Initializing matrix...');
    
    % initializes each position in the output argument to be one on the
    % first page
    for i = 1:key
        newUIDs{i, 1, 1} = 1;
    end
    
    UID_index = 1;
    delete(a);
    b = msgbox('Finding UIDs...');
    
    % repeats for how many values there are
    for i = 1:length(values)
        % checks if the value falls inbetween the set min and max of the
        % condition
        if values(i) > minimum && values(i) < maximum
            % hashes and places in possition according to the remainder
            UID_index = mod(UIDs(i), key) + 1;
            list_index = newUIDs{UID_index, 1, 1} + 1;
            newUIDs{UID_index, 1, list_index} = UIDs(i);
            newUIDs{UID_index, 1, 1} = list_index;
        end
    end
    delete(b);
end