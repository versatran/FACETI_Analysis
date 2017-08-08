% Prompt the user to select the proper source directory. The user gets
% ATTEMPTS_LEFT chances to choose an appropriate source directory. If the user
% exhausts all attempts without selecting a valid source directory, of if the
% user closes the file selection dialogue without selecting a directory, a
% default source directory is chosen.
% 
% Author: Elliot Tuck
% Date: 20170727
function sourceDirectory = getSourceDirectory()
    % default source directory - TODO: make this a function that returns a
    % system-specific default
    DEFAULT_DIRECTORY = '/Users/Elliot/Documents/MATLAB/FACET_data/2014/';
    
    % number of attempts the user has to choose a source directory
    ATTEMPTS_LEFT = 3;
    
    % boolean flag for whether the user has selected an appropriate source
    % directory
    hasNAS = 0;
    
    % continue to allow the user to manually find a source directory while
    % they have not found one and they have more tries left
    while ~hasNAS && ATTEMPTS_LEFT > 0
        ATTEMPTS_LEFT = ATTEMPTS_LEFT - 1;
        sourceDirectory = uigetdir('', 'Select Source Directory');
        if sourceDirectory == 0
            % user closed out of the prompt before selecting a file
            ATTEMPTS_LEFT = 0;
            break;
        elseif regexpi(sourceDirectory, 'nas$')
            % user selected NAS directory itself - remove it from the filepath
            sourceDirectory = sourceDirectory(1:length(sourceDirectory) -  ...
                length('nas'));
            return;
        else
            % check if the selected directory contains a NAS folder
            sourceDirectoryContents = dir(sourceDirectory);
            for k = 1:size(sourceDirectoryContents, 1)
                if strcmpi(sourceDirectoryContents(k).name, 'nas')
                    hasNAS = 1;
                    break;
                end
            end
            if ~hasNAS
                if ATTEMPTS_LEFT > 0
                    % the user has more attempts left
                    decision = questdlg(sprintf(['The directory you have ' ...
                        'selected does not contain a NAS folder. Would you ' ...
                        'like to select a new directory? (Attempts Left: ' ...
                        '%d)'], ATTEMPTS_LEFT));
                    switch decision
                        case 'Yes'
                            % the user wants to continue selection
                            continue;
                        otherwise
                            % the user does not want to continue selection
                            ATTEMPTS_LEFT = 0;
                            continue;
                    end
                else
                    % the user has no more attempts left
                    break;
                end
            else
                % valid directory chosen - append system-dependent 
                % file separator to ensure proper behaviour
                sourceDirectory = [sourceDirectory filesep];
                return;
            end
        end
    end
    if ATTEMPTS_LEFT == 0 && ~hasNAS
        % the user has run out of attempts an a valid source directory has
        % still not been found
        uiwait(msgbox(['A valid source directory has not yet been found. ' ...
            'You will have to locate a valid source directory in order to ' ...
            'continue with your analysis. For now, a default source ' ...
            'directory has been chosen for you.']));
        sourceDirectory = DEFAULT_DIRECTORY;
    end
end