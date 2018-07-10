ionization = 13.6;  % ionization energy (eV)
Z = 1;    % atomic number
Imax = 2e14; % intensity (W/cm^2)
pulse_width = 100e-6;    % characteristic width (m)
time_width = 100e-15;  % time (s)
time_delay = 300e-15;    % time (s)
N_0 = 1; % plasma density
z_ramp=.18;
z_peak=1;

r = linspace(-350e-6,350e-6,1000);
% r=0;
t = linspace(0,6e-13,1000);
z = linspace(0,1.2,1000);
perm = 8.854e-12;
c = 3e8;
n = 3.69*Z/sqrt(ionization);  % principle quantum number
dt=t(2)-t(1);

F=zeros(length(r),length(t));
Ne=zeros(length(r),length(z));
% I=zeros(length(r),length(t));
% E=zeros(length(r),length(t));
% W=zeros(length(r),length(t));

Ir=(besselj(0,2.4*r/pulse_width)).^2;
It=exp(-0.5*((t-time_delay)/time_width).^2);
Iz=z/z_peak;
Iz(z>z_peak)=1;
for i=1:length(z)
    I = Imax*Iz(i)*Ir'*It;
    E = sqrt(I*1e4*2/c/perm)/1e9;   % electric field (GV/m)

    W = 1.5e15*(4^n)*ionization/n/gamma(2*n)*((20.5*(ionization^(3/2))./E).^(2*n-1)).*...
        exp(-6.83*(ionization^(3/2))./E);

%     for j=1:length(t)
%         F(:,j) = sum(W(:,1:j),2)*dt;
%     end

    F = sum(W,2)*dt;
    Ne(:,i) = N_0*(1-exp(-F));
end
% [AX,H1,H2]=plotyy(t,I,t,Ne);
% xlabel('Time')
% ylabel(AX(1),'Intensity (W/cm^2)')
% ylabel(AX(2),'N_e (normalized)')
% axis(AX(2),[0 t(end) 0 1])
% figure
% imagesc(t*1e15,r*1e6,I)
% xlabel('fs');ylabel('\mum')
figure
% plot(z,Iz,z,Ne)
imagesc(z,r*1e6,Ne)
% xlabel('m');ylabel('\mum')
title([num2str(Imax,'%.0e') ' W/cm^2'])