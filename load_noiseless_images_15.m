%load_noiseless_images
%This script loads the jth image of ith stack and it is such a common block
%in all programs that I am saving this as a script, 
%I have removed this from the moviemaker script.
% 


% image_stack=cell{num_stacks,num_images};


if ~background_checked

    %TODO: Check that this code works with a QS-scan like DAQ
    bkgrndstr = fullfile(prefix,image_struc.background_dat{curr_image});
    %note: in 2014, backgrounds were saved as mat
    assert(strcmp(image_struc.background_format(1),'mat'),'unexpected background format')
    background= load(bkgrndstr);
%     noise=double(background.img);
    noise=(background.img);
    if ~isa(noise,'uint16')
        noise=uint16(noise);
    end
    if ~skip_background_verification
        %Check noise is really just noise
        figure(1)
        imagesc(noise)
        set(gca,'CLim',[100,500]);
        acceptable_noise=input('is this noise acceptable? ','s');
        close(1)
        background_saved_path=[outputdir 'background src' filesep date_str '_' camera.name '.mat'];    
        if ~strcmpi(acceptable_noise,'y') && ~strcmpi(acceptable_noise,'yes')
    %         warning([camera ' has unacceptable background and will be skipped'])
    %         return;
            if exist(background_saved_path,'file')
                background_content=load(background_saved_path);
%                 noise=background_content.noise;
%                 noise=double(background_content.img);
                noise=(background_content.img);
            else
                error('noise is unacceptable. Program ends')
            end
        elseif ~exist(background_saved_path,'file')
            [status, msg, msgID] = copyfile(bkgrndstr,background_saved_path)
        end
    end

    %ROI_region has been depreciated since the full image is no longer
    %saved
%         ROI_region=[image_struc.ROI_X(1) image_struc.ROI_Y(1) ...
%             image_struc.ROI_XNP(1) image_struc.ROI_YNP(1)];
    X_ORIENT = image_struc.X_ORIENT(1);
    Y_ORIENT = image_struc.Y_ORIENT(1);
    
    %noise on CMOS_FAR is different than SYAG. So I made this flag explicit
    %here
    if strcmp(camera.name,'CMOS_FAR')
        if X_ORIENT
            noise = fliplr(noise);
        end
        if Y_ORIENT
            noise = flipud(noise);
        end   
    end
    if camera.rotate_noise
        noise=rot90(noise);
    end
    
    
    %The noise scaling happens with the original size of the noise, but the
    %cropped image is the one that is modified in the rest of the program
    original_size=size(noise);
    original_vertsize=original_size(1);
    original_horizsize=original_size(2);

    original_noise=noise; 
    if exist('draw_ROI','var')       
        noise=imcrop(noise,draw_ROI);
    end
    
    image_size=size(noise);
    vertsize=image_size(1);
    horizsize=image_size(2);
    resolution=image_struc.RESOLUTION(1);
   




    %create the energy scale for the entire image, even parts that will be
    %hidden
    %This parameter might be useful for non-standard bends
    %data.raw.scalars.LI20_LGPS_3330_BDES.dat{1}

%         [energy_ticks,energy_pixel,energy_calib_vector]=...
%             cher_y_tick(camera,vertsize,1,vertsize,zero_Gev_px,...
%             image_struc.RESOLUTION(1));
    if camera.energy_camera
        theta0 = 6e-3*camera.dipole_bend;
        % adjust pixel location of initial energy to ROI (if needed)
        if (data.raw.images.(camera.name).ROI_Y(1)~=camera.default_ROI_Y)
            camera.zero_Gev_px=camera.zero_Gev_px+camera.default_ROI_Y-...
               data.raw.images.(camera.name).ROI_Y(1);
        end
        if exist('draw_ROI','var')
            camera.zero_Gev_px=camera.zero_Gev_px-draw_ROI(2);
        end
        energy_calib_vector=get_energy_curve(camera.name,vertsize,camera.zero_Gev_px,...
            image_struc.RESOLUTION(1),theta0);
        if linearize
            %in linearizing the image, the pixel numbers of the image are
            %preserved.
            [linear_energy_scale,linear_noise]=linearize_image(noise,energy_calib_vector);
            [energy_ticks,energy_pixel]=cher_y_tick(camera.name,vertsize,linear_energy_scale);
        else
            [energy_ticks,energy_pixel]=cher_y_tick(camera.name,vertsize,energy_calib_vector);
        end    
    end
    
    %If this is not reset, the energy vector for the next bend will
    %not be produced
    if ~exist('variable_bend','var')
        background_checked=1;
    end

end

%Curr image is the index that is used to load image instead of j, because
%in a scan, all images are stacked into one single cell array (see
%multi_box_image_extract script)
loadstr = fullfile(prefix,image_struc.dat{curr_image});
% this_image = double(imread(loadstr));
%this set of commands needs to run if dealing with 2013 data
if strcmp(loadstr(end-3:end),'.mat')
    this_image_in_struc=load(loadstr);    
    this_image=this_image_in_struc.img;
    if strcmp(image_struc.X_ORIENT{1},'Negative')
        X_ORIENT = 0;
    else
        X_ORIENT=1;
    end
    if strcmp(image_struc.Y_ORIENT{1},'Negative')
        Y_ORIENT = 0;
    else
        Y_ORIENT = 1;
    end 
else       
    this_image = (imread(loadstr));
end

if ~exist('X_ORIENT')
    X_ORIENT = image_struc.X_ORIENT(1);
end
if ~exist('Y_ORIENT')
    Y_ORIENT = image_struc.Y_ORIENT(1);
end

image_UID=image_struc.UID(curr_image);
if X_ORIENT
    this_image = fliplr(this_image);
end
if Y_ORIENT
    this_image = flipud(this_image);
end

%CMOS_far needed to be rotated to look "normal". On an individual
%basis this should be determined and noise should be compensated
if camera.rotate_image
    this_image=rot90(this_image);
end


original_image=this_image;
if exist('draw_ROI','var')
    %TODO: only do analysis on the ROI. i.e. cut the noise, cut the image to
    %the ROI of the noise might not match the ROI of the image
    this_image=imcrop(this_image,draw_ROI);
end

% scale background and subtract. These variables are determined in the
% load_camera_config script
switch camera.noise_region
    case 'top'
        sample_vector=[1,camera.sample_vert_width,...
            1,camera.sample_horiz_width];
    case 'bottom'
        if ~exist('original_vertsize')
            original_vertsize = getappdata(0, 'original_vertsize');
        end
        if ~exist('original_horizsize')
            original_horizsize = getappdata(0, 'original_horizsize');
        end
        sample_vector=[original_vertsize-camera.sample_vert_width,...
            original_vertsize,original_horizsize-...
            camera.sample_horiz_width,original_horizsize];
    otherwise
        error('haven''t written this part yet')
end

if ~exist('original_noise')
    original_noise = getappdata(0, 'original_noise');
end
if ~exist('noise')
    noise = getappdata(0, 'noise');
end
if ~exist('scale_adjustment')
    scale_adjustment = getappdata(0, 'scale_adjustment');
end
if ~exist('sample_vector') || isempty(sample_vector)
    sample_vector = getappdata(0, 'sample_vector');
end
image_sample=sum(sum(original_image(sample_vector(1):sample_vector(2),...
    sample_vector(3):sample_vector(4))));
BG_sample=sum(sum(original_noise(sample_vector(1):sample_vector(2),...
    sample_vector(3):sample_vector(4))));

% image_sample=sum(sum(this_image(1:camera.sample_vert_width,1:camera.sample_horiz_width)));
% BG_sample=sum(sum(noise(1:camera.sample_vert_width,1:camera.sample_horiz_width)));
scale=image_sample/BG_sample;
% scale=1; % rest to see what happens without scale
this_image=this_image-noise*scale*scale_adjustment;
% this_image=this_image-2200;
    
if ~exist('remove_xrays')
    remove_xrays = getappdata(0, 'remove_xrays');
end
% this_image=this_image-noise;
if remove_xrays
    this_image=RemoveXRays(this_image);
end

% Removes DC offset in noise
if ~skip_DCOffset
%     this_image=this_image-mean2(this_image(sample_vector(1):sample_vector(2),...
%         sample_vector(3):sample_vector(4)));
    if ~exist('DC_box_size','var')
        DC_box_size=[100,200];
    end
    DC_level=mean(mean((this_image(end-DC_box_size(1)-10:end-10,...
        end-DC_box_size(2)-10:end-10))));
    this_image=this_image-DC_level;
end

if camera.energy_camera

     if linearize
        non_linear_image=this_image;
        [linear_energy_scale,this_image]=linearize_image(this_image,energy_calib_vector);
    end
end

%         
% for i=1:num_stacks
%     for j=1:num_images
% 
%         image_stack{i,j}=image;
%     end
% end