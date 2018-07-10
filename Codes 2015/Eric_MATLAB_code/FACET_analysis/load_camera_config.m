%Load camera config
function camera_struc=load_camera_config(camera_name)

%NOTE: NOISE on every camera needs to be checked.
%Note: Verifying the zero GeV_pixel is up to the user
camera_struc.name=camera_name;
switch camera_name
    case 'CMOS_FAR'
%         camera_struc.zero_Gev_px=890; %For Apr 6
%         camera_struc.zero_Gev_px=902; %For Apr 6, 1232* series        
%         camera_struc.zero_Gev_px=149; %For Apr 6, QSBend -16
%         camera_struc.zero_Gev_px=241; %For Apr 6, QSBend -14
%         camera_struc.zero_Gev_px=365; %For Apr 6, QSBend -12
%         camera_struc.zero_Gev_px=434; %For Apr 6, QSBend -10
%         camera_struc.zero_Gev_px=530; %For Apr 6, QSBend -8
%         camera_struc.zero_Gev_px=414; %For Apr 6 half bend
%         camera_struc.zero_Gev_px=979; %for May 26+
%             camera_struc.zero_Gev_px=979; %for May 30 laser off
        camera_struc.zero_Gev_px=966; %for May 30
%         camera_struc.zero_Gev_px=983; %for June 1, 13123
%         camera_struc.zero_Gev_px=965; %for June 25, 13123
%         camera_struc.zero_Gev_px=935; %for Feb 2015
%         camera_struc.zero_Gev_px=966;
        camera_struc.default_ROI_Y=0;
        %dipole_bend is the bend of the dipole compared to normal. Normal 
        %bend is defined as 1. half bend is 0.5, etc
%         dipole_bend=0.5; %for data between 12414 and 12422
        camera_struc.dipole_bend=1;
%         dipole_bend=(20.35-14)/20.35;
%         camera_struc.energy_camera=1;
        camera_struc.energy_camera=1;
        camera_struc.y_label_text='Enegy (GeV)';
        camera_struc.rotate_image=1;
        camera_struc.rotate_noise=0;
        camera_struc.sample_vert_width=400;
        camera_struc.sample_horiz_width=100;
        camera_struc.noise_region='top';
    case 'CMOS_NEAR'
%         camera_struc.zero_Gev_px=965; %for June 25, 13123
        camera_struc.zero_Gev_px=1020;
        camera_struc.default_ROI_Y=0;
        camera_struc.dipole_bend=1;
        camera_struc.rotate_image=0;
        camera_struc.energy_camera=1;
        camera_struc.y_label_text='Enegy (GeV)';        
        camera_struc.rotate_noise=0;
        camera_struc.sample_vert_width=300;
        camera_struc.sample_horiz_width=300;
        camera_struc.noise_region='top';
    case 'WLANEX'
        camera_struc.zero_Gev_px=1020;
        camera_struc.default_ROI_Y=0;
        camera_struc.dipole_bend=1;
        camera_struc.rotate_image=1;
        camera_struc.energy_camera=0;
        camera_struc.y_label_text='Enegy (GeV)';        
        camera_struc.rotate_noise=0;
        camera_struc.sample_vert_width=300;
        camera_struc.sample_horiz_width=300;
        camera_struc.noise_region='top';
    case 'ELANEX'
        camera_struc.energy_camera=1;
%         camera_struc.zero_Gev_px=-3574; %Qs-8
%         camera_struc.zero_Gev_px=-1057; %Qs-4
%         camera_struc.zero_Gev_px=470; %Qs+0
        camera_struc.zero_Gev_px=1272; %Qs+3
%         camera_struc.zero_Gev_px=1496; %Qs+4
%         camera_struc.zero_Gev_px=1587; %Qs+4.5
%         camera_struc.zero_Gev_px=2151; %Qs+7.5
%         camera_struc.zero_Gev_px=2232; %Qs+8
        camera_struc.default_ROI_Y=0;
        camera_struc.dipole_bend=1;
        camera_struc.y_label_text='Enegy (GeV)';
        camera_struc.rotate_image=0;
        camera_struc.rotate_noise=0;
        camera_struc.sample_vert_width=150;
        camera_struc.sample_horiz_width=200;
        camera_struc.noise_region='top';
    case 'CMOS_WLAN'
        camera_struc.energy_camera=1;
        camera_struc.zero_Gev_px=282;
        camera_struc.default_ROI_Y=474;
        camera_struc.dipole_bend=1;
        camera_struc.y_label_text='Enegy (GeV)'; 
        camera_struc.rotate_noise=0;
        camera_struc.rotate_image=0;
%         camera_struc.sample_vert_width=300;
%         camera_struc.sample_horiz_width=200;
        camera_struc.sample_vert_width=200;
        camera_struc.sample_horiz_width=100;
        camera_struc.noise_region='bottom';
   case 'SYAG'
        camera_struc.energy_camera=0;
        camera_struc.y_label_text='';
        camera_struc.curr_lim=[0 1000]; %for SYAG  
        %Too lazy to write a program for horizontal lineout. Much easier to
        %rotate the image and noise together by 90 degrees!
        camera_struc.rotate_image=1;
        camera_struc.rotate_noise=1;
    case 'E224_Probe'
        camera_struc.energy_camera=0;
        camera_struc.y_label_text='';
        camera_struc.curr_lim=[0 1000]; %
        camera_struc.rotate_noise=0;
    case 'CMOS_ELAN'
        camera_struc.energy_camera=1;
%         camera_struc.zero_Gev_px=-19504; %Qs-16
%         camera_struc.zero_Gev_px=-7054; %Qs-12
%         camera_struc.zero_Gev_px=-2669; %Qs-8
        camera_struc.zero_Gev_px=-429; % Qs-4
%         camera_struc.zero_Gev_px=930; % Qs+0
%         camera_struc.zero_Gev_px=1843; % Qs+4
%         camera_struc.zero_Gev_px=2498; % Qs+8
        camera_struc.default_ROI_Y=0;
        camera_struc.dipole_bend=1;
        camera_struc.y_label_text='Energy (GeV)';
        camera_struc.curr_lim=[0 1000]; %        
        camera_struc.rotate_noise=0;
        camera_struc.rotate_image=0;
        camera_struc.sample_vert_width=300;
        camera_struc.sample_horiz_width=300;
        camera_struc.noise_region='bottom';
    case 'BETAL'
        camera_struc.energy_camera=0;
        camera_struc.y_label_text='';
        camera_struc.curr_lim=[0 1000]; %        
        camera_struc.rotate_noise=0;
        camera_struc.rotate_image=0;
        camera_struc.sample_vert_width=200;
        camera_struc.sample_horiz_width=200;
        camera_struc.noise_region='bottom';    
    case 'AX_IMG1'
        camera_struc.energy_camera=0;
        camera_struc.y_label_text='';
        camera_struc.curr_lim=[0 1000]; %        
        camera_struc.rotate_noise=0;
        camera_struc.rotate_image=0;
    otherwise
        error('this part has not be written yet!')
        energy_camera=0;
end

