% This function determines which gui to open from the task menu
% The reason this was created was so that the conditions could be passed
% through multiple options instead of being saved through one gui and
% having to be consistantly passed through

% Author: Brianna Florio
function linecutOptions(varargin)
    initializeGlobal();
    input = varargin{1};
    global count;
    global conditions;
    switch input
        case 'set'
            if ~isempty(varargin{2}) && ~isempty(varargin{3})
                setGlobal(varargin{2}, varargin{3});
            end
        case 'add'
            addConditionsGui(varargin{2}, count, conditions);
        case 'view'
            viewConditionsGui(conditions);
    end
end
    
    
function initializeGlobal()
    global count;
    if isempty(count) 
        count = 1;
    end
    global conditions;
    if isempty(conditions)
        conditions = {};
    end
end

function setGlobal(conval, countval)
    global count;
    global conditions;
    if ~isempty(conval)
        conditions = conval;
    end;
    count = countval;
end