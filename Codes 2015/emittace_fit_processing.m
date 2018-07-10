selected_image=24;


sigma_raw=squeeze(collect_width(1,selected_image,:));
sigma_m=sigma_raw*resolution*1e-6;

y_loc_select=squeeze(y_loc(1,selected_image,:))
ene=linear_energy_scale(y_loc_select(isfinite(y_loc_select)));
QS=-14;

z_im=2016.04;

p0=[1e-4 0.1 0.3]

[p,s_fit]=emitFit(ene,sigma_m',QS,z_im,p0)

p*1e6

figure
plot(ene, sigma_m,'o')
hold on
plot(ene,s_fit,'rd')