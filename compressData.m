% Compress data within processed_data and return the result.
%
% Author: Elliot Tuck
% Date: 20170808
function processed_data_comp = compressData(processed_data)
    processed_data_comp = processed_data;
    cameraNames = fieldnames(processed_data_comp.images);
    for k = 1:length(cameraNames)
        cameraName = cameraNames{k};
        imageNames = fieldnames(processed_data_comp.images.(cameraName));
        for l = 1:length(imageNames)
            imageName = imageNames{l};
            image = processed_data_comp.images.(cameraName).(imageName);
            processed_data_comp.images.(cameraName).(imageName) = dzip(image);
        end
    end
end