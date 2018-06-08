function [values, UIDs] = common_UIDs(varargin) 
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
   
   for i = 1:length(val_a)
       idx = find(UID_b==UID_a(i));
       if ~isempty(idx)
           values{count} = val_b(idx);
           UIDs{count} = UID_a(i);
           count = count + 1;
       end
   end
end