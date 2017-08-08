function [prefix, num_stacks, image_struc, num_images, stack_text, func_name,...
    bend_struc] = eda_load_data(source_dir, date_str, camera)
    % if remote
    %     prefix=get_remoteprefix();
    % else
    %     prefix='';
    % end%check that the prefix is actually right! if it isn't, fix it! 
    % if ~strcmp(prefix,source_dir(1:end-1))
    %     setpref('FACET_data','prefix',source_dir(1:end-1));
    %     prefix=get_remoteprefix();
    % end
    setpref('FACET_data', 'prefix', source_dir(1:end - 1));
    prefix = get_remoteprefix();
    % data_path = [source_dir server_str expt_str '/' date_str(1:4) '/'  ...
    %     date_str '/' expt_str '_' dataset_str '/' expt_str '_' ...
    %     dataset_str '.mat'];
    
    % load data
    data = getappdata(0, 'data');

    % determine whether it is a sample or scan
    if strcmp(data.raw.metadata.settype, 'daq')
        num_stacks = 1;
        image_struc = data.raw.images.(genvarname(camera));
        num_images = length(image_struc.dat);
        stack_text{1} = '';
        func_name = '';
        bend_struc = '';
    elseif strcmp(data.raw.metadata.settype, 'scan')
        if strcmp(date_str(1:4), '2014')
            metadata_struc = data.raw.metadata.param.dat{1};
        elseif strcmp(date_str(1:4), '2015')
            metadata_struc = data.raw.metadata.param;
        end
        num_stacks = data.raw.metadata.n_steps;
        image_struc = data.raw.images.(genvarname(camera));
        num_images = metadata_struc.n_shot;
        % error('find out what the num_stack is in this case!')
        bend_struc.func_name = func2str(metadata_struc.fcnHandle);
        % separate_parts = find(func_name == '_');
        if length(find(bend_struc.func_name == '_')) > 1        
            undescore_loc = find(bend_struc.func_name == '_');
            func_name = ...
                bend_struc.func_name(undescore_loc(1) + 1:undescore_loc(2) - 1);
        else
            func_name = bend_struc.func_name;
        end
        for i = 1:num_stacks
            stack_text{i} = [func_name ': ' ...
                num2str(metadata_struc.PV_scan_list(i))];
        end    
        if strcmp(bend_struc.func_name, 'set_QSBEND_energy')
            bend_struc.variable_bend = true;
            bend_struc.bend_values = ...
                data.raw.metadata.param.dat{1}.PV_scan_list;
            warning(['This is a bend scan, dipole bend and zero GeV values ' ...
                'will vary and need to be checked']);
            for iii = 1:length(bend_values)
                bend_struc.dipole_multiplier_values(iii) = ...
                    (20.35 + bend_values(iii)) / 20.35;
                switch(bend_values(iii))
                    case -16
                        zero_Gev_px_vector(iii) = 149; %For Apr 6, QSBend -16                    
                    case -14
                        zero_Gev_px_vector(iii) = 241; %For Apr 6, QSBend -14
                    case -12
                        zero_Gev_px_vector(iii) = 365; %For Apr 6, QSBend -12
                    case -10
                        zero_Gev_px_vector(iii) = 434; %For Apr 6, QSBend -10
                    case -8
                        zero_Gev_px_vector(iii) = 530; %For Apr 6, QSBend -8
                    case -6
                        zero_Gev_px_vector(iii) = 611; %For Apr 6, QSBend -6
                    case -2
                        zero_Gev_px_vector(iii) = 799; %For Apr 6, QSBend -2
                    case -1
                        zero_Gev_px_vector(iii) = 849; %For Apr 6, QSBend -1
                    case 0
                        zero_Gev_px_vector(iii) = 890; %For Apr 6, QSBend 0
                    case 1
                        zero_Gev_px_vector(iii) = 928; %For Apr 6, QSBend 1
                    case 2
                        zero_Gev_px_vector(iii) = 934; %For Apr 6, QSBend 2
                    case 3
                        zero_Gev_px_vector(iii) = 1034; %For Apr 6, QSBend 3
                    otherwise
                        error('The bend value is unknown');
                end
                bend_struc.zero_Gev_px_vector = zero_Gev_px_vector;
            end
        end
    else
        error(['You are running a new type of DAQ. Please write the code ' ...
            'for it!']);
    end
end