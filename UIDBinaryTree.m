classdef UIDBinaryTree

    properties
        root
    end
    
    methods
        
       function child = create(varargin)
           current = varargin{2};
           val = varargin{3};
           UID = varargin{4};
           if isempty(current(1))
               child = {val, UID, {}, {}};
               return;
           end
           if val < current{1}
               left = current(3);
               current(3) = create(left, val, UID);
           elseif val > current{1}
               right = current(4);
               current(4) = create(right, val, UID);
           elseif val == current{1}
               current = {[current{1}, val], [current{2}, UID], current{3}, current{4}};
           end
           child = current;
        end
        
        function initialize(val, UID)
            a = UIDBinaryTree;
            a.root = [val, UID, [], []];
        end
    end
end