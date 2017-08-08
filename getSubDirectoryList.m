% Given a directory string, return a cell array containing the names of the
% sub-directories contained in the base directory.
%
% Author: Elliot Tuck
% Date: 20170728
function subDirList = getSubDirectoryList(dirString)
    subDirList = {};
    dirContents = dir(dirString);
    for k = 1:size(dirContents, 1)
        listing = dirContents(k);
        if listing.isdir && isempty(regexp(listing.name, '^\.', 'once'))
            subDirList{size(subDirList, 2) + 1} = listing.name;
        end
    end
end