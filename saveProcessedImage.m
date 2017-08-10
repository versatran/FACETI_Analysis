% Save this_image in processed_data. If processed_data does not exist, 
% create it, then save this_image in the newly-created processed_data.
%
% Author: Elliot Tuck
% Date: 20170810
function saveProcessedImage()
    if ~isappdata(0, 'processed_data')
        % processed_data does not exist, so create it
        processed_data = createProcessedData();
    else
        % processed_data already exists
        processed_data = getappdata(0, 'processed_data');
    end
    % get the name of the camera so this_image can be saved in the
    % appropriate location
    camera = getappdata(0, 'camera');
    cameraName = camera.name;
    if ~isfield(processed_data.images, cameraName)
        % processed_data does not contain a folder for the current camera, so
        % create one
        processed_data.images.(cameraName) = struct();
    end
    % save the current (processed) image in its appropriate location
    % within processed_data
    image_struc = getappdata(0, 'image_struc');
    curr_image = getappdata(0, 'curr_image');
    [~, imageName, ~] = fileparts(image_struc.dat{curr_image});
    this_image = getappdata(0, 'this_image');
    processed_data.images.(cameraName).(imageName) = this_image;
    setappdata(0, 'processed_data', processed_data);
end