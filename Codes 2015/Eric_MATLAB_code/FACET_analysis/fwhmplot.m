widths=zeros(1,28);
pixels=zeros(1,28);
for i=1:7
    pixels(i*4-3:i*4)=[96 48 0 -48]+energy_pixel(10-i);
    sample=(-24:24)+energy_pixel(10-i);
    widths(i*4-3)=fwhm(1:horizsize,sum(this_image(sample+96,:),1)');
    widths(i*4-2)=fwhm(1:horizsize,sum(this_image(sample+48,:),1)');
    widths(i*4-1)=fwhm(1:horizsize,sum(this_image(sample,:),1)');
    widths(i*4)=fwhm(1:horizsize,sum(this_image(sample-48,:),1)');
end
figure
scatter(linear_energy_scale(pixels),widths);