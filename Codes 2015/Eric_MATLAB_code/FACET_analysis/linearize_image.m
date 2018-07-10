function [energy_linear,linearized_image]=linearize_image(image1,energy_scale)

linearized_image=zeros(size(image1));
linearized_count=zeros(size(image1));
image_size=size(image1);
horizsize=image_size(2);
vertsize=image_size(1);

energy_linear=linspace(energy_scale(1),energy_scale(end),length(energy_scale));

%constructing derivative vector
%use first approximation derivetive, becasue dE is not the same from point
%to point in dy/dE
y=1:vertsize;
dy=diff(y);
dE=diff(energy_scale);

%Have to pad the differentials with one more member to make them equal size
%to other vectors
dy=[dy dy(end)];
dE=[dE dE(end)];

energy_derivative=-1.0*dy./dE;


for i=1:horizsize
    linearized_count(:,i)=double(image1(:,i)).*energy_derivative';
    linearized_image(:,i)=interp1(energy_scale,linearized_count(:,i),energy_linear,'pchip');
%     linearized_image(:,i)=linearized_image(:,i)*sum(image1(:,i))...
%         /sum(linearized_image(:,i));
end
    linearized_image=linearized_image*sum(sum(image1))...
        /sum(sum(linearized_image));

