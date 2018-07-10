function [width1,width2,fx] = rms2(x,y,extra)
% uses 2 Gaussian fits to estimate RMS widths of y
% Eric Welch
%

if nargin==2
    extra=0;
end

if ~extra
    options = fitoptions('gauss2');
%     options.StartPoint = [5e4 300 15 1e4 300 75]; % [a1 b1 c1 a2 b2 c2]
%     options.Lower = [0 400 0 0 400 60];
    options.Lower = [0 50 0 0 50 60];
    options.Upper = [Inf 800 60 Inf 800 Inf];
    
%     fx=fit(x',y,'gauss2');
    fx=fit(x',y,'gauss2',options);
    width1=fx.c1/sqrt(2);
    width2=fx.c2/sqrt(2);
%     plot(fx,x,y)
else
    fx=fit(x',y,'gauss3')
    width1=fx.c1/sqrt(2);
    width2=fx.c3/sqrt(2);
    plot(fx,x,y)
    hold on
    plot(x,fx.a1*exp(-((x-fx.b1)/fx.c1).^2)+fx.a3*exp(-((x-fx.b3)/fx.c3).^2))
    hold off
end

end