function complete_E_curve=get_energy_curve(camera_name,vertsize,zero_GeV_px,resolution,theta0)

if nargin<5
    theta0=6e-3; 
end
z_cherfar=2016.0398;
z_chernear = 2015.9298; 
z_Wlanex= 2015.614;
z_Elanex=2015.220;

switch camera_name
    case 'CMOS_FAR'
        z_camera=z_cherfar;
    case 'CMOS_NEAR'
        z_camera=z_chernear;
    case 'CMOS_WLAN'
        z_camera=z_Wlanex;
    case 'CMOS_ELAN'
        z_camera=z_Elanex;
    otherwise
        error('This has not be written yet')
end

yrange_full=1:vertsize;
ylr_full=vertsize-yrange_full+1;
complete_E_curve=E200_Eaxis_ana(ylr_full,vertsize-zero_GeV_px+1,resolution*1e-6,z_camera,theta0);
