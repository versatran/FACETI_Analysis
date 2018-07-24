function [width,fx] = find_rms(x,y,lower3,upper3)
% uses Gaussian fit to estimate FWHM of y
% Eric Welch. modified by Navid on 150903
%

options = fitoptions('gauss1');

if nargin<4
    options.Lower = [100 200 0]; % [a1 b1 c1]
    options.Upper = [1e6 400 60];
else
    options.Lower = lower3; % [a1 b1 c1]
    options.Upper = upper3;
end    

%Gauss1 format fx(x) =  a1*exp(-((x-b1)/c1)^2)
fx=fit(x',y,'gauss1',options);
width=fx.c1/sqrt(2);

end