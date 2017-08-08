function B = RemoveXRays(varargin)
% function B = RemoveXRays(A)
%          B = RemoveXRays(A,'plot')
%          B = RemoveXRays(A,'noplot')
%          B = RemoveXRays(A,'plot',[offset threshold])
%          B = RemoveXRays(A,'noplot',[offset threshold])
%
% Attempts to remove X-rays that hit the CCD from the image A.
% If the optional argument 'plot' is given, a diagnostic plot is generated
% in the current figure.
%
% Algorithm: compare every pixel to the average of a surrounding ring. If
% it exceeds this by a certain threshold, it is considered to be an X-ray.
% In that case, the region is expanded by one pixel in every direction and
% the values are replaced by a smooth function that is determined by
% imposing Laplace f = 0.
%
% This version is optimized for the Princeton 16-bit camera that was used to
% measure the downstream energy spectrum in E-167.
% This camera often shows X-rays that extend over more than one pixel.
%
% 2005-08-31: initial version (Rasmus, with help from Ben, ChrisS & Neil)

switch nargin
   case 0, error('usage: B = RemoveXRays(A,''plot'')')
   case 1, A = double(varargin{1}); 
           doPlot = 0;
           offset = 30; threshold = 1.4;
   case 2, A = double(varargin{1}); 
           if strcmp(varargin(2),'plot'), doPlot=1; else doPlot=0; end
           offset = 30; threshold = 1.4;
   case 3, A = double(varargin{1}); 
           if strcmp(varargin(2),'plot'), doPlot=1; else doPlot=0; end
           offset = varargin{3}(1);
           threshold = varargin{3}(2);
end

% %% Remove first two columns
% % The two leftmost columns of our "timeint" camera appear to contain
% % garbage.
% 
% A = A(:,3:end);

% %% Common mode subtraction
% % the zero of the ADC fluctuates by a few counts for every image.
% % For the validity of the thresholds, this must be removed first.
% % find the maximum of the histogram (assuming our camera has at most 16 bits)
% %[y,x] = hist(A(:),-20:2^16);
% Background = A(1:50,:);
% [y,x] = hist(Background(:),-20:400);
% y = y(2:end-1); x = x(2:end-1); % remove overflow bins
% [m,i] = max(y); i = i(1);
% if i<3, error('The ADC offset appears to be too small'), end
% % we want to have a value with sub-LSB resolution, so we take the weighted
% % average of the top 5 points:
% zero = sum(y(i-2:i+2) .* x(i-2:i+2)) / sum(y(i-2:i+2));
% A = A - zero;

% %% pad the image
% % to avoid X-rays to be detected at the edge of the image, we pad the image
% % with equal values at the edges
% padsize = 3;
% A = padarray(A,[padsize padsize],'replicate');

%% make a smoothed image
% make an image where every pixel is replaced by the average of 
% surrounding pixels

ring = [0 0 1 1 1 0 0; ...
        0 1 0 0 0 1 0; ...
        1 0 0 0 0 0 1; ...
        1 0 0 0 0 0 1; ...
        1 0 0 0 0 0 1; ...
        0 1 0 0 0 1 0; ...
        0 0 1 1 1 0 0];
ring = ring / sum(ring(:));

Asmooth = conv2(A, ring, 'same');

% this was the first algorithm, but it was not very successful
%B = A;
%B(XR) = Asmooth(XR);

%% find X-rays
% now, the difficult part is to find the X-rays.

% the following criteria have to be met by this algorithm:
% - the density of X-rays is constant across the regions where ther is beam
%   and outside of the beam
% - no part of the beam is removed
% - no X-rays are detected from the noise in the background
% - the end result is somewhat independent of the exact values of arbitrarily
%   chosen numbers

% the noise in the background is about 2 ADC counts; for the noise in the
% number of photons, assume something proportional to the number of ADC
% counts
%sigma_bg = 2;
%threshold = 5*sigma_bg + 5*sqrt(abs(Asmooth));
%XR = A > Asmooth + threshold;

% Another way is to find points with a negative Laplacian (more precisely,
% where the relative value of the Laplacian is smaller than a certain threshold
%L = del2(A);
%XR = -L./A > 0.1;

% I have found that a combined relative-absolute criterion with arbitrarily 
% choosen offset and threshold works better than the previous idea
XR = (A+offset)./(Asmooth+offset) > threshold;

% I have observed that the X-rays are sometimes a bit larger than what was
% detected using this method. Therefore, I expand the X-Rays by 1 pixel in 
% all directions:

SE = strel('square',3);
XR2 = imdilate(XR,SE);

%% eliminate the X-rays
% replace every X-ray by a smooth function.
% This is achieved by finding a function that satisfies 
%     Laplace f = 0
% inside the eliminated region and is equal to the image outside those 
% regions.
% (Ben knows how to do this. Luckily, there is an Image Processing Toolbox
% function that does exactly what we want)

B = roifill(A,XR2);

% %% remove the padded border
% B = B(1+padsize:end-padsize, 1+padsize:end-padsize);

%% plot results
if doPlot
   subplot(1,3,1)
%    contour(A(1+padsize:end-padsize, 1+padsize:end-padsize),20:20:200)
   contour(A,20:20:200)
   set(gca,'YDir','reverse'), colorbar, axis image
   title('original image')
   subplot(1,3,2)
%    contour(A(1+padsize:end-padsize, 1+padsize:end-padsize)-B,20:20:200)
   contour(A-B,20:20:200)
   set(gca,'YDir','reverse'), colorbar, axis image
   title('X-Rays')
   subplot(1,3,3)
   contour(B,20:20:200)
   set(gca,'YDir','reverse'), colorbar, axis image
   title('cleaned image')
   drawnow
end