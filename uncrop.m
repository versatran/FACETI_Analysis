% Uncrop the displayed images back to their original display widths and
% heights.
%
% Author: Elliot Tuck
% Date: 20170817
function uncrop()
    % reset display width and height values
    default_display_width = getappdata(0, 'default_display_width');
    default_display_height = getappdata(0, 'default_display_height');
    setappdata(0, 'display_width', default_display_width);
    setappdata(0, 'display_height', default_display_height);
    % reset width and height start values
    setappdata(0, 'width_start', 1);
    setappdata(0, 'height_start', 1);
    % remove draw_ROI
    if isappdata(0, 'draw_ROI')
        rmappdata(0, 'draw_ROI');
    end
    % re-display the current image (which is uncropped)
    ImgTestGui_ShowImage();
    % bring the main GUI to the front
    figureImgTestGui = findobj('Tag', 'figureImgTestGui');
    figure(figureImgTestGui);
end