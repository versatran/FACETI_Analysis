% Test parallel image loading using constructs such as parfor, parfeval,
% etc.
%
% Author: Elliot Tuck
% Date: 20170810
function parallelTest()
    app_data = getappdata(0);
    if ~isappdata(0, 'set_app_data')
        set_app_data = struct();
    else
        set_app_data = getappdata(0, 'set_app_data');
    end
    parfor k = 1:100
        load_noiseless_images_15_edited(k, app_data, set_app_data);
    end
end