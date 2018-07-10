eps_i=200e-6; % m-rad (normalized)
gamma_b=40000;
sigma_r=30e-6; % m
beta_i=(sigma_r^2)/(eps_i/gamma_b);
gamma_i=1/beta_i;

z=linspace(.001,1.539,5000); % m
n=ones(1,5000);
n(z<.12)=z(z<.12)/.12;
n(z>1.42)=(z(z>1.42)-1.54)/-.12;
n=n*8e16; % 1/cm^3

B=3.01*n/1e11; % T/m

beta_f=sqrt(gamma_b*9.11e-31*3e8/1.6e-19./B); % m
eps_sat=(gamma_i*beta_f+beta_i./beta_f)/2; % saturated / inital
phi=z./beta_f; % phase w/out acceleration

eps=eps_i*eps_sat.*sqrt(1-(((2*eps_sat).^2-4)./(2*eps_sat).^2).*((sin(phi)./phi).^2));