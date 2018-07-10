function [vals,times] = E200_crawl(PVs,start_str,end_str,expt,header)

E200_PVs = strrep(PVs,':','_');
E200_PVs = strrep(E200_PVs,'.','_');

start_vec = datevec(start_str);
end_vec = datevec(end_str);
start_num = datenum(start_vec);
end_num = datenum(end_vec);

nas  ='/nas/nas-li20-pm00/';

years = start_vec(1):end_vec(1);
months = start_vec(2):end_vec(2);
days = start_vec(3):end_vec(3);


files = cell(0,1);
f = 0;
vals = zeros(numel(E200_PVs),0);
for y = years
    year_str = ['/' num2str(y) '/'];
    for m = months
        for d = days
            day_str = [num2str(y) num2str(m,'%02d') num2str(d,'%02d') '/'];
            folder = [header nas expt year_str day_str];
            disp(['Searching folder ' folder]);
            x = dir([folder expt '_*']);
            for i = 1:numel(x)
                if x(i).datenum > start_num && x(i).datenum < end_num
                    data_file = [folder x(i).name '/' x(i).name '.mat'];
                    if exist(data_file,'file')                        
                        f = f+1;
                        files{f} = data_file;
                        times(f) = x(i).datenum;
                        disp(['Working on data set ' x(i).name '.']);
                        load(data_file);
                        for p = 1:numel(E200_PVs)
                            vals(p,f) = data.raw.metadata.E200_state.(E200_PVs{p}).dat;
                        end
                    end
                end
            end
            
        end
    end
end
disp(['Found ' num2str(numel(files)) ' datasets.']);
            
