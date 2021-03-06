% brf_save_correlated_images creates a new img structure according to the
% correlated data from "Correlate" under specific conditions.

function brf_save_correlated_images(~,~,~)
    % gets variables needed for function
    data_struc = getappdata(0, 'data');
    camera = getappdata(0, 'camera');
    image_struc = data_struc.raw.images;
    image_info = image_struc.(camera.name);
    
    % gets original image information
    dat = image_info.dat;
    format = image_info.format;
    IDtype = image_info.IDtype;
    isfile = image_info.isfile;
    PID = image_info.PID;
    UID = image_info.UID;
    N_EXPT = image_info.N_EXPT;
    ERRORS = image_info.ERRORS;
    N_IMGS = image_info.N_IMGS;
    N_UIDS = image_info.N_UIDS;
    N_NOUID = image_info.N_NOUID;
    background_dat = image_info.background_dat;
    background_format = image_info.background_format;
    ROI_X = image_info.ROI_X;
    ROI_Y = image_info.ROI_Y;
    ROI_XNP = image_info.ROI_XNP;
    ROI_YNP = image_info.ROI_YNP;
    RESOLUTION = image_info.RESOLUTION;
    X_ORIENT = image_info.X_ORIENT;
    Y_ORIENT = image_info.Y_ORIENT;
    
    % grabs the x_values and their corresponding UIDs
    x_val = getappdata(0, 'correlated_x');
    corr_UID = getappdata(0, 'correlated_UIDs');
    [~,length] = size(corr_UID);
    
    % sorts the x_values from minimum to maximum values
    sorted_val = sort(x_val);
    
    % sorts the UID's to their corresponding x_val
    k = 1;
    while (k <= length)
        index = find(x_val == sorted_val(1, k));
        [~, index_size] = size(index);
        if index_size > 1
            for m = 1:index_size
                sorted_val(2, k) = corr_UID(index(m));
                k = k+1;
            end
        else
            sorted_val(2, k) = corr_UID(index); 
            k = k+1;
        end
    end
    
    % initializes a new image structure
    newImages = struct('IDType', IDtype, 'N_EXPT', N_EXPT, 'ERRORS', ERRORS, ...
        'N_IMGS', N_IMGS, 'N_UIDS', N_UIDS, 'N_NOUID', N_NOUID);
    
    % adds data information from the previous data in order according to
    % x_val
    i = 1;
    j = 1;
    
    % weird error here that gets rid of one image and I don't know why?
    while (j <= length)
        [~, index_size] = size(find(UID == sorted_val(2, j)))
        if index_size <= 1
            index = find(UID == sorted_val(2, j));
            if UID(index) == 0
                error('ERROR: UID is equal to zero, incomplete dataset');
            else
                if ~isempty(index)
                    newDat{i} = dat{index}
                    newFormat(i) = format(index);
                    newIsfile(i) = isfile(index);
                    newPID(i) = PID(index);
                    newUID(i) = UID(index);
                    newBackground_dat{i} = background_dat{index};
                    newBackground_format(i) = background_format(index);
                    newROI_X(i) = ROI_X(index);
                    newROI_Y(i) = ROI_Y(index);
                    newROI_XNP(i) = ROI_XNP(index);
                    newROI_YNP(i) = ROI_YNP(index);
                    newRESOLUTION(i) = RESOLUTION(index);
                    newX_ORIENT(i) = X_ORIENT(index);
                    newY_ORIENT(i) = Y_ORIENT(index);
                    ORG_IDX(i) = index;
                    i = i+1;
                end
             end
        end
        j = j+1;
    end
    % sets the fields for x_vals
    correlated_struc.condition = getappdata(0, 'x_param');
    correlated_struc.ORG_TOT = N_IMGS;
    correlated_struc.ORG_IDX = ORG_IDX;
    correlated_struc.SORT_X_VALS = sorted_val(1, :);
    correlated_struc.SORT_UIDS = sorted_val(2, :);
    newImages.correlated_struc = correlated_struc;
    newImages.N_IMGS = i-1;
    newImages.N_UIDS = i-1;
    newImages.dat = newDat;
    newImages.format = newFormat;
    newImages.isfile = newIsfile;
    newImages.PID = newPID;
    newImages.UID = newUID;
    newImages.background_dat = newBackground_dat;
    newImages.background_format = newBackground_format;
    newImages.ROI_X = newROI_X;
    newImages.ROI_Y = newROI_Y;
    newImages.ROI_XNP = newROI_XNP;
    newImages.ROI_YNP = newROI_YNP;
    newImages.RESOLUTION = newRESOLUTION;
    newImages.X_ORIENT = newX_ORIENT;
    newImages.Y_ORIENT = newY_ORIENT;
    
    % sets images now to be correlated images.
    images = newImages;
    setappdata(0, 'i', 1);
    setappdata(0, 'j', 1);
    setappdata(0, 'correlated_images', images);
    ImgTestGui_ShowImage;
end