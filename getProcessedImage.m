% Check if the image designated by the given path string has already been
% processed. If it has been processed, return the processed image.
% Otherwise, return an empty array.
%
% Author: Elliot Tuck
% Date: 20170803
function processed_image = getProcessedImage(path)
    processed_image = [];
    if (~isappdata(0, 'processed_data'))
        % processed_data has not been created yet, so there is definitely no
        % processed version of the current image
        return;
    else
        % processed_data has been created, so check if it contains a processed
        % version of the image in question
        processed_data = getappdata(0, 'processed_data');
        camera = getappdata(0, 'camera');
        cameraName = camera.name;
        if (~isfield(processed_data.images, cameraName))
            % processed_data does not contain a folder for the current camera,
            % so it definitely does not have a processed version of the
            % current image
            return;
        else
            % processed_data contains a folder for the current camera, so check
            % if it has a processed version of the current image
            [~, imageName, ~] = fileparts(path);
            if (isfield(processed_data.images.(cameraName), imageName))
                % processed_data contains a processed version of the current
                % image
                processed_image = ...
                    processed_data.images.(cameraName).(imageName);
            end
        end
    end
end