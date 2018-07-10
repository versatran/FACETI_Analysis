%% Parameters

% Number of points and size of mask
n_pts   = 1024;  % number of pixels
mid = n_pts/2 + 1;
window = 100;
low = mid-window;
high = mid+window;

res     = 4.65; % resolution in image plane (microns)
R       = 20e3; % illuminated radius of mask (microns)
nz      = 1001; % number of points in z
zmin    = 600e3; % upstream z location
zmax    = 3.0e6; % downstream z location
zs      = linspace(zmin,zmax,nz);
zmid    = round(nz/2)+1;

% Ti:Saph parameters
lambda  = 0.800; % wavelength in microns
k_0     = 2*pi/lambda; % microns^-1
t0 = 300e-15; %s
e0 = 320e-3; % J
eta = 0.57; % transmission efficieny
r0 = R/1e4; % radius in cm
I0 = eta*e0/(t0*pi*r0^2); % on-optic intensity

% Axicon parameters
ax_ang = 0.7;
gma_ax = 0.46*ax_ang*pi/180;   % angle of focused rays with respect to axis in degrees
kp    = 2*pi*sin(gma_ax)/lambda; % microns^-1

% Kinoforms parameters
gma_300 = 0.312*pi/180;   % angle of focused rays with respect to axis in degrees
kp_300  = 2*pi*sin(gma_300)/lambda; % microns^-1
m = 5;

% Axi-lens parameters
f0 = 1350e3;
Dz = 1000e3;

% super-gaussian (top-hat like) illumination
sig = 1.0;
sig2 = sig*R;
ord = 30;

i_max = zeros(nz,1);
lo_cen = zeros(nz,n_pts);


%% Calculation

for i = 1:nz
    i
    z = zs(i); % propagation distance in microns
    r_mask = lambda*z/(2*res); % radius of mask in microns

    % Mask coordinates
    x  = linspace(-r_mask,r_mask,n_pts);
    dx = x(2)-x(1);
    xx = repmat(x,n_pts,1);
    yy = rot90(xx,1);
    r2 = xx.^2+yy.^2;
    r  = sqrt(r2);
    phi = atan2(yy,xx);
    phi(round((n_pts/2+1)):n_pts,:) = phi(round((n_pts/2+1)):n_pts,:)+2*pi;

    % Axis at image plane
    fx = linspace(-lambda*z/(2*dx),lambda*z/(2*dx),n_pts);
    dfx = fx(2)-fx(1);
    Dfx = fx(end)-fx(1);

    % axicon phase
    PSI = kp*r;

    % kinoform phase
    %PSI = kp_300*r+m*phi;

    % axilens phase
    % PSI = k_0*R^2/(2*Dz)*log(f0+Dz/R^2*r2);

    % kino-axilens phase
    %PSI = k_0*R^2/(2*Dz)*log(f0+Dz/R^2*r2)+m*phi;


    % illum
    gauss_env = exp(-(r.^ord)/(2*(sig2)^ord));

    % Field after mask
    u_ideal  = gauss_env.*exp(-1i*PSI);
    i_input  = u_ideal.*conj(u_ideal);

    % fresnel term
    fresnel = exp(1i*k_0*z)*exp(1i*k_0*r2/(2*z))/(1i*lambda*z);

    % fresnel diffraction
    img_ideal = fft2(u_ideal.*fresnel);
    img_ideal = dx^2*fftshift(img_ideal);
    i_ideal   = img_ideal.*conj(img_ideal);
    i_ideal   = I0*i_ideal;

    i_max(i)  = i_ideal(mid,mid);
    lo_cen(i,:) = i_ideal(mid,:);
end

%% Plots
% cmap = custom_cmap;

figure(1);
surf(fx(low:high),zs/1e4,lo_cen(:,low:high)); shading flat; axis tight;
colormap(sebasColorTable);
set(gca,'fontsize',13);
xlabel('R [\mum]','fontsize',14);
ylabel('Z [cm]','fontsize',14);
zlabel('I [W/cm^2]','fontsize',14);
figure(2);
plot(zs/1e4,i_max,'b','linewidth',2);
set(gca,'fontsize',13);
xlabel('Z [cm]','fontsize',14);
ylabel('I [W/cm^2]','fontsize',14);
figure(3);
plot(fx(low:high),lo_cen(zmid,low:high),'k','linewidth',2);
set(gca,'fontsize',13);
xlabel('R [\mum]','fontsize',14);
zlabel('I [W/cm^2]','fontsize',14);