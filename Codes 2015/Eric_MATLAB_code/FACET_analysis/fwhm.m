function width = fwhm(x,y)
% uses Gaussian fit to estimate FWHM of y
% Eric Welch
%
%
N = length(y);
flag=1;
while flag
    [~,centerindex]=max(y);
    if centerindex > 0.9*N || centerindex < 0.1*N
        y(centerindex)=0;
    else
        flag = 0;
    end
end

fx=fit(x',y,'gauss1');
width=fx.c1*2*sqrt(log(2));

end

