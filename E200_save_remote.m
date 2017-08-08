function datasaved = E200_save_remote(data, override, data_path)
    if nargin < 2
        override = false;
    end

    data_path = getappdata(0, 'data_path');
    dataorig = getappdata(0, 'dataorig');
    % dataorig = E200_load_data(data_path);

    datanew = E200_merge(data, dataorig, override);
    % datasaved = save_data(datanew, ...
    %   fullfile(getpref('FACET_data', 'prefix'), ...
    %   datanew.VersionInfo.originalpath, ...
    %   datanew.VersionInfo.originalfilename), false);
    prefix = get_remoteprefix();
    savepath = fullfile(prefix, datanew.VersionInfo.originalpath, ...
        datanew.VersionInfo.originalfilename);
    [~, ~, ~, data_source_type] = get_valid_filename(data_path, ...
        data.VersionInfo.originalfilename(1:4));

    switch data_source_type
        case '2015'
            datasaved = save_data(datanew, savepath, false);        
        case '2014'	
            % REMOVED: datasaved = save_data_2014(datanew, savepath, false);
            % NOTE: lineouts are currently not saved
        case '2013'
            datasaved = save_data(datanew, savepath, false);
        otherwise
            error('Shouldn''t get here!!!');
    end
end