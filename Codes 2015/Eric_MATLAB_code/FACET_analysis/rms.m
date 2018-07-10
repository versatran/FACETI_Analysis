function width = rms(x,y)
% uses Gaussian fit to estimate RMS width of y
% Eric Welch
%

options = fitoptions('gauss1');
options.Lower = [0 400 0]; % [a1 b1 c1]
options.Upper = [Inf 800 Inf];

fx=fit(x',y,'gauss1');
% fx=fit(x',y,'gauss1',options);
width=fx.c1/sqrt(2);

end