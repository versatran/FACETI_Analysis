% This function determines which gui to open from the task menu
% The reason this was created was so that the conditions could be passed
% through multiple options instead of being saved through one gui and
% having to be consistantly passed through

% Author: Brianna Florio
function varargout = linecutOptions(varargin)
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
        case 'delete'
            deleteConditionGui(count, conditions);
        case 'deleteAll'
            deleteAll();
        case 'deleteCondition'
            deleteCondition(varargin{2});
        case 'save'
            saveConditions();
        case 'load'
            loadConditions();
        case 'reset'
            conditions = {};
            count = 0;
        case 'get'
            UIDs = varargin{2};
            values = varargin{3};
            param = varargin{4};
            newValues = cell(1, length(conditions));
            newUIDs = cell(1, length(conditions));
            for i = 1:count
                conUIDs = brf_get_UIDs(param, conditions{i});
                [newValues{1, i}, newUIDs{1, i}] = brf_get_Values(UIDs, values, conUIDs);
                if i > 1
                    [val, uid] = common_UIDs(newValues{1, 1}, newUIDs{1, 1}, newValues{1, i}, newUIDs{1, i});
                    newValues{1, 1} = val;
                    newUIDs{1, 1} = uid;
                end
            end
            varargout = [newValues(1, 1), newUIDs(1, 1)];
        otherwise
            msgbox('Code error: Input was not a proper command', 'Fix Error');
    end
end

function deleteCondition(index)
    global count;
    global conditions;
    leftOver = index - size(conditions);
    conditions(index) = [];
    for i = index:(leftOver-1)
        conditions{i} = conditions{i+1};
    end
    if count == 1
        conditions = {}; 
    end
    count = count - 1;
end
    
function deleteAll()
    global conditions;
    global count;
    answer = questdlg('Are you sure you want to delete all conditions?', 'Deletion', 'Yes', 'No', 'Yes');
    switch answer
        case 'Yes'
            conditions = {};
            count = 0;
    end
end
    
function initializeGlobal()
    global count;
    if isempty(count) 
        count = 0;
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
    end
    count = countval;
end

function saveConditions() 
global count;
global conditions;
answer = questdlg('Are you sure you want to save these conditions?', 'Save All Conditions', 'Yes', 'No', 'Yes');
   switch answer
       case 'Yes'
           [file, path] = uiputfile('.m', 'Save Conditions', 'UntitledConditions.m');
           filename = strcat(path, file);
           save(filename, 'conditions', 'count');
   end
end

function loadConditions()
    [file, path] = uigetfile('.m', 'Select Saved Condition(s)');
    filename = strcat(path, file);
    data = importdata(filename);
    global count
    global conditions;
    count = data.count;
    conditions = data.conditions;
end