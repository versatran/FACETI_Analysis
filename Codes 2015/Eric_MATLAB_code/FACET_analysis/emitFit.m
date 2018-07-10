function [p, sigma_fit, res] = emitFit(energy,sigma,QS,z_im,p0)
%energy is a energy vector of sigma vs energy in GeV
%sigma is a y vector of sigma vs energy 
%QS is QS setting e.g. -4
%z_im is the z location of the imaging condition (linac location of the
%detector)
%p0 is the initial guess for normalized emittance (m-rad)


gamma = energy*1e3/0.511;

% Quadrupoles
%Can Chack QS_BDES wrt to the values recorded in the DAQ
% Conversion using f = gamma*m*c / (e * Leff*B/a ), or f [m] = E [GeV] / (Leff*B/a [kG] * 0.0299792)
QS_BDES = [261.72, -167.95] * (1 + QS/20.35); % Imaging condition for E200 IP to long plasma exit PEXT, Apr. 22 2014. Value of Leff*B/a in kG
% QS_BDES = [301, -200.96] * (1 + QS/20.35); % imaging on ELANEX
f1 = abs ( energy ./ (QS_BDES(1) * 0.0299792) ); % QS1 focal length in m
f2 = abs ( energy ./ (QS_BDES(2) * 0.0299792) ); % QS2 focal length in m
Leff = 1; % QS 1 & 2 effective length in meter

% Distances
z_PEXT = 1994.97;    % linac z location of plasma exit in meter
z_PEXT = 1994.85;
z_QS1 = 1999.206665; % linac z location of QS1 (middle of quad) in meter
z_QS2 = 2004.206665; % linac z location of QS2 (middle of quad) in meter
% z_ELANEX = 2015.22;    % linac z location of ELANEX phosphor screen in meter
% z_CFAR = 2016.04;    % linac z location of Cherenkov Far gap in meter
D1 = z_QS1 - z_PEXT;
D2 = z_QS2 - z_QS1;
D3 = z_im - z_QS2;
% Drift Transport Matrixes
M2_D1 = [1 D1-Leff/2; 0 1];
M2_D2 = [1 D2-Leff; 0 1];
M2_D3 = [1 D3-Leff/2; 0 1];

% Initialisation of R11 and R12 (energy-dependent transport matrix components)
R11 = zeros(size(energy));
R12 = zeros(size(energy));

% Calculation of R11 and R12 as a function of energy
for i=1:numel(energy)
    % QS1 & 2 Transport Matrix
    k = abs(1/(Leff*f1(i)));
    phi = Leff*sqrt(k);
    M2_QS1 = [cos(phi)             (1/sqrt(k))*sin(phi)
        -sqrt(k)*sin(phi)    cos(phi)];
    k = abs(1/(Leff*f2(i)));
    phi = Leff*sqrt(k);
    M2_QS2 = [cosh(phi)             (1/sqrt(k))*sinh(phi)
        sqrt(k)*sinh(phi)    cosh(phi)];
    % Transport Matrix from PEXT to Image Plane
    M2 = M2_D3 * M2_QS2 * M2_D2 * M2_QS1 * M2_D1;
    % R11 and R12 components of the Transport Matrix
    R11(i) = M2(1,1);
    R12(i) = M2(1,2);
end

options = optimset('MaxFunEval', 1e4);
[p,res] = fminsearch(@emitError, p0, options);

%p(1) is normalized emittance, p(2) is beta*. p(3) is s*
    function residue = emitError(p)
        eps = p(1)./gamma;
        beta_star = p(2);
%         beta_star = p(2)*sqrt(energy/(20.35+QS));
        alpha = p(3)./beta_star;
        xx = beta_star .* (1+alpha.^2) .* eps;
        xxp = - alpha .* eps;
        xpxp = eps ./ beta_star;
        sigma_fit =  sqrt( R11.^2 .* xx + 2*R11.*R12 .* xxp + R12.^2 .* xpxp );
        residue = sum( 1./sigma .* (sigma_fit - sigma).^2 );
    end

end




