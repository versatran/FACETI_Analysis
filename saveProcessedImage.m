% Save this_image in processed_data. If processed_data does not exist, 
% create it, then save this_image in the newly-created processed_data.
%
% Author: Elliot Tuck
% Date: 20170803
function set_app_data = saveProcessedImage(curr_image, this_image, app_data, set_app_data)
    if ~isfield(app_data, 'processed_data')
        % processed_data does not exist, so create it
        set_app_data = createProcessedData(app_data.data);
        processed_data = set_app_data.processed_data;
    else
        % processed_data already exists
        processed_data = app_data.processed_data;
    end
    camera = app_data.camera;
    cameraName = camera.name;
    if (~isfield(processed_data.images, cameraName))
        % processed_data does not contain a folder for the current camera, so
        % create one
        processed_data.images.(cameraName) = struct();
    else
        % processed_data already contains a folder for the current camera, so
        % save the current (processed) image
        image_struc = app_data.image_struc;
        [~, imageName, ~] = fileparts(image_struc.dat{curr_image});
        processed_data.images.(cameraName).(imageName) = this_image;
    end
    set_app_data.processed_data = processed_data;
end