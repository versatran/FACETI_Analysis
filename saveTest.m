% Test various save techniques for performance. For each technique, print
% the amount of time it took from start to finish to save processed_data
% (either in its original form or in some compressed/serialized form), as
% well as the resulting save file size.
%
% Author: Elliot Tuck
% Date: 20170808
function saveTest(processed_data)
    path1 = '/Users/Elliot/Desktop/save1.mat';
    path2 = '/Users/Elliot/Desktop/save2.mat';
    path3 = '/Users/Elliot/Desktop/save3.mat';
    path4 = '/Users/Elliot/Desktop/save4.mat';
    % print the size of the processed_data in its original form
    processed_data_struct = whos('processed_data');
    fprintf('processed_data: %d bytes\n\n', processed_data_struct.bytes);
    % technique 1: save processed_data directly as a v7.3 file
    disp('technique 1: save processed_data directly as a v7.3 file');
    tic;
    save(path1, 'processed_data', '-v7.3');
    time = toc;
    fprintf('save time: %0.1f\n', time);
    t1_struct = dir(path1);
    fprintf('t1 file size: %d bytes\n\n', t1_struct.bytes);
    % technique 2: compress processed_data and then save it as a v7.3 file
    disp(['technique 2: compress processed_data and then save it as a ' ...
        'v7.3 file']);
    tic;
    processed_data_comp = compressData(processed_data);
    compTime = toc;
    fprintf('compression time: %0.1f\n', compTime);
    tic;
    save(path2, 'processed_data_comp', '-v7.3');
    saveTime = toc;
    fprintf('save time: %0.1f\n', saveTime);
    t2_struct = dir(path2);
    fprintf('t2 file size: %d bytes\n\n', t2_struct.bytes);
    % technique 3: serialize processed_data and then save it using savefast
    disp(['technique 3: serialize processed_data and then save it ' ...
        'using savefast utility']);
    tic;
    processed_data_ser = hlp_serialize(processed_data);
    serTime = toc;
    fprintf('serialization time: %0.1f\n', serTime);
    tic;
    savefast(path3, 'processed_data_ser');
    saveTime = toc;
    fprintf('save time: %0.1f\n', saveTime);
    t3_struct = dir(path3);
    fprintf('t3 file size: %d bytes\n\n', t3_struct.bytes);
    % technique 4: compress processed_data, and then serialize, and then
    % save that using savefast
    disp(['technique 4: compress processed_data, then serialize that, ' ...
        'then save that using savefast utility']);
    tic;
    processed_data_comp_2 = compressData(processed_data);
    compTime = toc;
    fprintf('compression time: %0.1f\n', compTime);
    tic;
    processed_data_comp_ser = hlp_serialize(processed_data_comp_2);
    serTime = toc;
    fprintf('serialization time: %0.1f\n', serTime);
    tic;
    savefast(path4, 'processed_data_comp_ser');
    saveTime = toc;
    fprintf('save time: %0.1f\n', saveTime);
    t4_struct = dir(path4);
    fprintf('t4 file size: %d bytes\n', t4_struct.bytes);
end