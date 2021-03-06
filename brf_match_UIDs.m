function [x_vals, x_UID, y_vals, y_UID] = brf_match_UIDs(xVals, xUID, yVals, yUID)
    
    [~, xlength_v] = size(xVals);
    [~, xlength_u] = size(xUID);
    if xlength_u ~= xlength_v
        error('The amount of UIDs for X do not match the amount of corresponding values');
    end
    x_length = xlength_v;
    [~, ylength_v] = size(yVals);
    [~, ylength_u] = size(yUID);
    if ylength_v ~= ylength_u
        error('the amount of UIDs for Y do not match the amount of corresponding values');
    end
    
    % compares x and y UIDs to see if they match
    count = 1;
    for i = 1:x_length
       if ismember(xUID(i), yUID)
          index = find(yUID == xUID(i));
          x_vals(count) = xVals(i);
          x_UID(count) = xUID(i);
          y_vals(count) = yVals(index);
          y_UID(count) = yUID(index);
          count = count + 1;
       end
    end
        
end