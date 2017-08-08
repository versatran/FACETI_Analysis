% Save processed_data as a .mat file so it can be loaded in for future
% sessions.
%
% Author: Elliot Tuck
% Date: 20170804
function saveProcessedData()
    % check if the current system is 'facet-srv20' - if it is, then do not
    % save anything
    if (~isfs20())
        % check if processed_data exists - if it does not, then there is
        % nothing to save, so we are done
        if (isappdata(0, 'processed_data'))
            processed_data = getappdata(0, 'processed_data');

            % see if there is already a path to save processed_data to
            if (isappdata(0, 'processed_data_path'))
                processed_data_path = getappdata(0, 'processed_data_path');
            else
                % a path does not already exist, so get one
                processed_data_path = getProcessedDataPath();
            end

            % save processed_data
            % NOTE: forcing version 7.3 MAT file to be used because this is the
            % only one (at the time of writing this) that can save >2GB of data
            save(processed_data_path, 'processed_data', '-v7.3');
        end
    end
end