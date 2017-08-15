% Make and return a MATLAB movie out of all the images (.tif) in the given
% directory. Process the images in parallel using the MATLAB Parallel
% Computing Toolbox to speed things up.
%
% Input:
%   dirPath - the full path to the directory containing the images to make
%             a movie out of
%   colormap - the colormap to be used to display the images
%
% Output:
%   the movie containing the processed images
%
% Author: Elliot Tuck
% Date: 20170815
function movie = makeMovie(dirPath, colormap)
    % get the files of the directory
    contents = dir(dirPath);
    files = contents(~[contents.isdir]);
    
    % filter out any non-image files
    allNames = {files.name};
    [~, ~, extensions] = cellfun(@fileparts, allNames, 'UniformOutput', false);
    validNames = allNames(strcmp(extensions, '.tif'));
    
    % get full paths for all valid image files
    filePaths = strcat(dirPath, validNames);
    
    % load the images in parallel
    parfor i = 1:length(filePaths)
        path = filePaths{i};
        image = scaleImage(RemoveXRays(imread(path)), colormap);
        imageArr(:, :, 1, i) = image;
    end
    
    % make a movie out of the images
    movie = immovie(imageArr, colormap);
end

% Scale the pixel values in the given image to use the full range of the
% given colormap, and return the scaled image.
%
% Input:
%   image - the image to scale
%   colormap - the colormap to scale image's pixel values to
%
% Output:
%   the scaled image
%
% Author: Elliot Tuck
% Date: 20170815
function scaledImage = scaleImage(image, colormap)
    numIndices = length(colormap);
    scaledImage = double(image) - double(min(image(:)));
    scaledImage = scaledImage ./ max(scaledImage(:));
    scaledImage = scaledImage * (numIndices - 1) + 1;
end