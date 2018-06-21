function images = brf_save_correlated_images
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
    RESOLUTION = image_info.RESOLUTION;
    X_ORIENT = image_info.X_ORIENT;
    Y_ORIENT = image_info.Y_ORIENT;
    
    
    x_val = getappdata(0, 'correlated_x');
    corr_UID = getappdata(0, 'correlated_UIDs');
    [~,length] = size(corr_UID);
    
    tree = cell(1, 2*length+1);
    root = {{x_val(1), corr_UID(1)}, 0};
    tree{1} = root;
    
    function node = createNode(varargin)
       isRed = 1;
       node = {varargin, isRed};
    end

    function addNode(node, index, val, UID)
       nodecell = node{1};
       if val < nodecell{1}
          index = 2*index;
          if isempty(tree{index})
             tree{index} = createNode(val, UID);
             checkTree(index);
          else
              addNode(tree{index}, index, val, UID);
          end
       elseif val > nodecell{1}
           index = 2*index + 1;
           if isempty(tree{index})
               tree{index} = createNode(val, UID);
               checkTree(index);
           else
               addNode(tree{index}, index, val, UID);
           end
       end
    end

    function checkTree(index)
        if index == 1
           root = {root{1}, 0};
           tree{1} = root;
           return;
        end
        pIndex = floor(index/2);
        child = tree{index};
        parent = tree{pIndex};
        
        isRedChild = child{2};
        isRedParent = parent{2};
        
        % check to see if both child and parent are red
        if isRedChild && isRedParent
            % check to see if parent is on the right path (odd) or left
            % (even)
            gIndex = floor(pIndex/2);
            grandparent = tree{gIndex};
            isRedGrandparent = grandparent{2};
            if mod(pIndex, 2)
                uIndex = 2*gIndex;
            else
                uIndex = 2*gIndex + 1;
            end
            
            if isempty(tree{uIndex})
                % rotate
            else
                uncle = tree{uIndex}
                isRedUncle = uncle{2};
                if isRedUncle
                    % recolor
                    uncle{2} = ~isRedUncle;
                    parent{2} = ~isRedParent;
                    grandparent{2} = ~isRedGrandparent;
                    tree{uIndex} = uncle;
                    tree{pIndex} = parent;
                    tree{gIndex} = grandparent;
                    checkTree(gIndex);
                end
            end         
        end
    end
        

    for k = 2:length
       addNode(root, 1, x_val(k), corr_UID(k)); 
    end
    
    newImages = struct('IDType', IDtype, 'N_EXPT', N_EXPT, 'ERRORS', ERRORS, ...
        'N_IMGS', N_IMGS, 'N_UIDS', N_UIDS, 'N_NOUID', N_NOUID);
    
    i = 1;
    for j = 1:length
        index = find(UID == corr_UID(i));
        
        if ~isempty(index)
            newDat{i} = dat{index}
            newFormat(i) = format(index);
            newIsfile(i) = isfile{index};
            newPID(i) = PID(index);
            newUID(i) = UID(index);
            newBackground_dat{i} = background_dat{index};
            newBackground_format(i) = background_format(index);
            newROI_X(i) = ROI_X(index);
            newROI_Y(i) = ROI_Y(index);
            newROI_XNP(i) = ROI_XNP(index);
            newROI_YNP(i) = ROI_YNP(index);
            newRESOLUTION(i) = RESOLUTION(index)
            newX_ORIENT(i) = X_ORIENT(index);
            newY_ORIENT(i) = Y_ORIENT(index);
            i = i+1;
        end
    end
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
    
    images = newImages;
end