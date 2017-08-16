% Check if the given image indices (i and j, the stack and shot numbers,
% respectively) are valid for the current dataset.
%
% Author: Elliot Tuck
% Date: 20170804
function valid = validImageIndices(app_data, i, j)
%     num_images = getappdata(0, 'num_images');
%     num_stacks = getappdata(0, 'num_stacks');
    num_images = app_data.num_images;
    num_stacks = app_data.num_stacks;
    if (i >= 1 && i <= num_stacks && j >= 1 && j <= num_images)
        valid = 1;
    else
        valid = 0;
    end
end