function data = E200_convert_images(data, savepath)
	savepath = fullfile(savepath, 'raw', 'images');
	images = data.raw.images;
	names = fieldnames(images);
	
	% prefix = getpref('FACET_data', 'prefix');
	prefix = get_remoteprefix();
	% loop over cameras
	for i = 1:size(names, 1)
		cam = images.(names{i});
		% get boolean for all binaries
		bool_bin = strcmp('bin', cam.format);
		% get all unique file names for binaries
		unique_binaries = unique(cam.dat(bool_bin));
		toread = fullfile_cell(prefix, unique_binaries);
		% read each file in
		for j = 1:size(toread, 2)
			% read file
			[image_data, cam_name, pulse_id] = readImagesBin(toread{j});
			% get boolean for all shots matching file
			bool_shots = strcmp(toread{j}, fullfile_cell(prefix, cam.dat));
			for k = 1:size(bool_shots, 2)
				if bool_shots(k)
					img = image_data(:, :, cam.bin_index(k));
					[path, name, ext] = fileparts(cam.dat{k});
					% display(cam.dat{k})
					filename = [names{i} '_' num2str(cam.UID(k)) '.mat'];
					savethis = fullfile(savepath, names{i}, filename);
					ind = regexp(savethis, 'processed');
					cam.dat{k} = savethis(ind:end);
					cam.format{k} = 'mat';
					if exist(savethis) ~= 2
						[outpath, thisname, ext] = fileparts(savethis);
						[stat, msg, msgid] = mkdir(outpath);
						display(newline);
						disp('Saving...');
						display(['Filename: ' thisname ext]);
						display(['Path: ' outpath]);
						save(savethis, 'img');
					end
				end
			end
		end
		% push changes back to data
		data.raw.images.(names{i}) = cam;
	end
end
