function [tick_return,energy_pixel]=cher_y_tick(camera_name,vertsize,energy_scale)
% function [tick_return,energy_pixel]=cher_y_tick(camera_name,vertsize,y_low,y_high,zero_GeV_px,resolution)

yrange_full=1:vertsize;
% ylr_full=vertsize-yrange_full+1;
% yrange=y_low:y_high;
% ylr=vertsize-yrange+1;
% z_cherfar=2016.0398;

switch camera_name
    case 'CMOS_FAR'
%         z_camera=z_cherfar;
%         energy_ticks=[80 40 30 28 26 24 22 20 18 16 14 12 10 8 6 4]+0.35; %for full dipole
        energy_ticks=[80 48 44 40 36 32 28 24 20 16 12 8]+0.35; 
    case 'CMOS_NEAR'
        energy_ticks=[24 22 20 18 16 12]+0.35;
    case 'CMOS_WLAN'
        energy_ticks=[36 32 28 24 20 16 12 8]+0.35;
    case 'CMOS_ELAN'
        energy_ticks=[32 30 28 26 24 22 20 18 17 16 15 14 13 12 11 10]+0.35;
    case 'ELANEX'
        energy_ticks=[34:-1:10]+0.35;
    otherwise
        error('This has not be written yet')
end


% E1=E200_Eaxis_ana(ylr,vertsize-zero_GeV_px+1,resolution*1e-6,z_camera);

counter=1;
for l=1:length(energy_ticks)
    tick_loc=find(abs(energy_scale-energy_ticks(l))/energy_ticks(l)<0.001);
    if ~isempty(tick_loc)
        tick_return(counter)=energy_ticks(l);
        energy_pixel(counter)=yrange_full(tick_loc(round(length(tick_loc)/2)));        
        counter=counter+1;        
    end
end

