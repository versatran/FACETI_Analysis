% Load camera config
function camera_struc = load_camera_config(camera_name)

% NOTE: NOISE on every camera needs to be checked.
% Note: Verifying the zero GeV_pixel is up to the user
isEditCamera = 0;
data = getappdata(0, 'data');
if isfield(data.raw, 'camera')
    if isfield(data.raw.camera, (camera_name))
        isEditCamera = 1;
        cam = data.raw.camera.(camera_name);
    else
        cam = [];
    end
else
    cam = [];
end
camera_struc.name = camera_name;

function value = fielddata(parent, fieldname, default)
    if isEditCamera
        if isfield(parent, fieldname)
            value = cam.(fieldname);
        else
            value = default;
        end
    else
        value = default;
    end
end

% default camera settings
% NOTE: these may change as better default values are determined
camera_struc.energy_camera = 0;
camera_struc.y_label_text = ''; 
camera_struc.rotate_noise = 0;
camera_struc.noise_region = 'top';
camera_struc.sample_vert_width = 200;
camera_struc.sample_horiz_width = 200;
camera_struc.rotate_image = 0;

switch camera_name
    case 'CMOS_FAR'
        camera_struc.zero_Gev_px = fielddata(cam, 'zero_Gev_px', 902);
        % camera_struc.zero_Gev_px=890; % for Apr 6
        % camera_struc.zero_Gev_px = 902; % for Apr 6, 1232* series        
        % camera_struc.zero_Gev_px=149; % for Apr 6, QSBend -16
        % camera_struc.zero_Gev_px=241; % for Apr 6, QSBend -14
        % camera_struc.zero_Gev_px=365; % for Apr 6, QSBend -12
        % camera_struc.zero_Gev_px=434; % for Apr 6, QSBend -10
        % camera_struc.zero_Gev_px=530; % for Apr 6, QSBend -8
        % camera_struc.zero_Gev_px=414; % for Apr 6 half bend
        % camera_struc.zero_Gev_px=979; % for May 26+
        % camera_struc.zero_Gev_px=983; % for June 1, 13123
        % camera_struc.zero_Gev_px=965; % for June 25, 13123
        % camera_struc.zero_Gev_px=935; % for Feb 2015
        % camera_struc.zero_Gev_px=966;
        camera_struc.default_ROI_Y = fielddata(cam, 'default_ROI_Y', 0);
        % dipole_bend is the bend of the dipole compared to normal. Normal 
        % bend is defined as 1, half bend is 0.5, etc
        % dipole_bend = 0.5; % for data between 12414 and 12422
        camera_struc.dipole_bend = fielddata(cam, 'dipole_bend', 1);
        % dipole_bend = (20.35 - 14) / 20.35;
        % camera_struc.energy_camera = 1;
        camera_struc.energy_camera = 1
        camera_struc.y_label_text = fielddata(cam, 'y_label_text', 'Energy (GeV)');
        camera_struc.rotate_image = fielddata(cam, 'rotate_image', 1);
        camera_struc.rotate_noise = fielddata(cam, 'rotate_noise', 0);
        camera_struc.sample_vert_width = fielddata(cam, 'sample_vert_width', 400);
        camera_struc.sample_horiz_width = fielddata(cam, 'sample_horiz_width', 100);
        camera_struc.noise_region = fielddata(cam, 'noise_region', 'top');
    case 'CMOS_NEAR'
        % camera_struc.zero_Gev_px = 965; % for June 25, 13123
        camera_struc.zero_Gev_px = fielddata(cam, 'zero_Gev_px', 1020);
        camera_struc.default_ROI_Y = fielddata(cam, 'default_ROI_Y', 0);
        camera_struc.dipole_bend = fielddata(cam, 'dipole_bend', 1);
        camera_struc.rotate_image = fielddata(cam, 'rotate_image', 0);
        camera_struc.energy_camera = 1;
        camera_struc.y_label_text = fielddata(cam, 'y_label_text', 'Enegy (GeV)');        
        camera_struc.rotate_noise = fielddata(cam, 'rotate_noise', 0);
        camera_struc.sample_vert_width = fielddata(cam, 'sample_vert_width', 300);
        camera_struc.sample_horiz_width = fielddata(cam, 'sample_horiz_width', 300);
        camera_struc.noise_region = fielddata(cam, 'noise_region', 'bottom');
    case 'ELANEX'
        camera_struc.energy_camera = 0;
        camera_struc.y_label_text = fielddata(cam, 'y_label_text', 'Enegy (GeV)'); 
        camera_struc.rotate_noise = fielddata(cam, 'rotate_noise', 0);
    case 'CMOS_WLAN'
        camera_struc.energy_camera = 1
        camera_struc.zero_Gev_px = fielddata(cam, 'zero_Gev_px', 282);
        camera_struc.default_ROI_Y = fielddata(cam, 'default_ROI_Y', 474);
        camera_struc.dipole_bend = fielddata(cam, 'dipole_bend', 1);
        camera_struc.y_label_text = fielddata(cam, 'y_label_text', 'Enegy (GeV)'); 
        camera_struc.rotate_noise = fielddata(cam, 'rotate_noise', 0);
        camera_struc.rotate_image = fielddata(cam, 'rotate_image', 0);
        % camera_struc.sample_vert_width = 300;
        % camera_struc.sample_horiz_width = 200;
        camera_struc.sample_vert_width = fielddata(cam, 'sample_vert_width', 200);
        camera_struc.sample_horiz_width = fielddata(cam, 'sample_horiz_width', 100);
        camera_struc.noise_region = fielddata(cam, 'noise_region', 'bottom');
   case 'SYAG'
        camera_struc.energy_camera = 0;
        camera_struc.y_label_text = fielddata(cam, 'y_label_text', '');
        camera_struc.curr_lim = fielddata(cam, 'curr_lim', [0 1000]); % for SYAG  
        % Too lazy to write a program for horizontal lineout. Much easier to
        % rotate the image and noise together by 90 degrees!
        camera_struc.rotate_image = fielddata(cam, 'rotate_image', 1);
        camera_struc.rotate_noise = fielddata(cam, 'rotate_noise', 1);
    case 'E224_Probe'
        camera_struc.energy_camera = 0;
        camera_struc.y_label_text = fielddata(cam, 'y_label_text', '');
        camera_struc.curr_lim = fielddata(cam, 'curr_lim', [0 1000]);
        camera_struc.rotate_noise = fielddata(cam, 'rotate_noise', 0);
    case 'CMOS_ELAN'
        camera_struc.energy_camera = 0;
        camera_struc.y_label_text = fielddata(cam, 'y_label_text', '');
        camera_struc.curr_lim = fielddata(cam, 'curr_lim', [0 1000]);
        camera_struc.rotate_noise = fielddata(cam, 'rotate_noise', 0);
        camera_struc.rotate_image = fielddata(cam, 'rotate_image', 1);
        camera_struc.sample_vert_width = fielddata(cam, 'sample_vert_width', 300);
        camera_struc.sample_horiz_width = fielddata(cam, 'sample_horiz_width', 300);
        camera_struc.noise_region = fielddata(cam, 'noise_region', 'bottom');
    case 'BETAL'
        camera_struc.energy_camera = 0;
        camera_struc.y_label_text = fielddata(cam, 'y_label_text', '');
        camera_struc.curr_lim = fielddata(cam, 'curr_lim', [0 1000]);
        camera_struc.rotate_noise = fielddata(cam, 'rotate_noise', 0);
        camera_struc.rotate_image = fielddata(cam, 'rotate_image', 0);
        camera_struc.sample_vert_width = fielddata(cam, 'sample_vert_width', 200);
        camera_struc.sample_horiz_width = fielddata(cam, 'sample_hoirz_width', 200);
        camera_struc.noise_region = fielddata(cam, 'noise_region', 'bottom');    
    case 'AX_IMG1'
        camera_struc.energy_camera = 0;
        camera_struc.y_label_text = fielddata(cam, 'y_label_text', '');
        camera_struc.curr_lim = fielddata(cam, 'curr_lim', [0 1000]);
        camera_struc.rotate_noise = fielddata(cam, 'rotate_noise', 0);
        camera_struc.rotate_image = fielddata(cam, 'rotate_image', 0);
    otherwise
        % warn user that default settings are being used
        uiwait(msgbox(sprintf(['No explicit settings for camera %s. ' ...
            'Default values will be used instead.'], camera_name)));
%         warning('No explicit settings for camera %s; using default values', ...
%             camera_name);
end
end

