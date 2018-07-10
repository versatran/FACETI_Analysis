%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

expt_str='E200';
date_str='20150327';
dataset_str='15188';

top_cutoff=0.05;
bottom_cutoff=0.05;

sample_pixel_width=200;
sample_energy_width=500;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data=simple_data_load(expt_str,date_str,dataset_str);

num_imgs=data.raw.images.CMOS_FAR.N_IMGS;
% num_imgs=5;

[IMGS,IMGS_BG]=E200_load_images(data.raw.images.CMOS_FAR,...
    data.raw.images.CMOS_FAR.UID(1:num_imgs));

length=size(IMGS{1},2);

bottom_frac=zeros(1,num_imgs);
top_frac=zeros(1,num_imgs);
lineout=zeros(num_imgs,length);

for i=1:num_imgs
    % scale background and subtract
    image_sample=sum(sum(IMGS{i}(1:sample_pixel_width,1:sample_energy_width)));
    BG_sample=sum(sum(IMGS_BG{i}(1:sample_pixel_width,1:sample_energy_width)));
    scale=.95*image_sample/BG_sample;
%     IMGS{i}=IMGS{i}-IMGS_BG{i}*scale*.95;
    
    % average hotspots
%     IMGS{i}=RemoveXRays(IMGS{i});
     
    % sum image vertically
    lineout(i,:)=sum(IMGS{i}(250:600,:),1);
    
    total=sum(lineout(i,:));
    for j=1:length
        bottom_integral=sum(lineout(i,1:j));
        top_integral=sum(lineout(i,length:-1:length-j));
        if (bottom_integral>(total*bottom_cutoff) && ~bottom_frac(i))
            bottom_frac(i)=j;
        end
        if (top_integral>(total*top_cutoff) && ~top_frac(i))
            top_frac(i)=length-j;
        end
        if (top_frac(i) && bottom_frac(i))
            break;
        end
    end
end
