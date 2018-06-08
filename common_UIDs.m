
% This function evaluates two sets of data (values and their corresponding
% UIDs) and pulls the values according to identical UIDs within those sets

% There are 4 parameters needed. They are:
% (first set of values, first set of UID's, second set of values, second 
% set of UIDs)

% This function returns two things: the values that had matching UIDs, and 
% returns those matching UIDs

function [values, UIDs] = common_UIDs(varargin)
    % initializing the parameters
   val_a = varargin{1};
   if iscell(val_a)
      val_a = cell2mat(val_a); 
   end
   UID_a = varargin{2};
   if iscell(UID_a)
      UID_a = cell2mat(UID_a); 
   end
   val_b = varargin{3};
   if iscell(val_b)
      val_b = cell2mat(val_b); 
   end
   UID_b = varargin{4};
   if iscell(UID_b)
       UID_b = cell2mat(UID_b);
   end
   count = 1;
   
   % checks each UID in set 'a' to see if that UID exists in set 'b'
   for i = 1:length(val_a)
       % pulls the index if 'a' exists in 'b'. if not, it returns an empty
       % variable
       idx = find(UID_b==UID_a(i));
       % checks if it's empty (or if 'a' exists in 'b')
       if ~isempty(idx)
           % adds values and UIDs to output variables, and count is
           % incrimented
           values{count} = val_b(idx);
           UIDs{count} = UID_a(i);
           count = count + 1;
       end
   end
end