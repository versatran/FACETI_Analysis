% This function is used to select a region of interest (ROI) to be focused
% on. Once an ROI is selected for one image, other images will be displayed
% through the same ROI to aid comparison of images.
%
% Author: Elliot Tuck
% Date: 20170816
function crop()
    % have user crop the image
    [~, draw_ROI] = imcrop();
    % set the ROI
    setappdata(0, 'draw_ROI', draw_ROI);
    % re-display the current image (which is now cropped)
    ImgTestGui_ShowImage();
end