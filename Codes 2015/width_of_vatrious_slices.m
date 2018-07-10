%Run this function while paused on your favorite picture!
vertical_points=[1830 1900 1970 2009 2052]
% vertical_points=[1836]

box_width=3;
horiz_lim=200:300;
lower3=[100 0 0];
upper3=[1e4 length(horiz_lim) 500];

for ii=1:length(vertical_points)
    curr_lineout=sum(this_image(vertical_points(ii)-floor(box_width/2):...
        vertical_points(ii)+floor(box_width/2),horiz_lim),1);
    [width(ii),fitted_gauss{ii}]=find_rms(1:length(curr_lineout),curr_lineout'...
        ,lower3,upper3);
    figure(50)
    hold on
    plot(horiz_lim,vertical_points(ii)*ones(length(horiz_lim)),'k','linewidth',2);
    hold off
    figure(100)
    plot(fitted_gauss{ii},1:length(curr_lineout),curr_lineout);
    waitforbuttonpress
end