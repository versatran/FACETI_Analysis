total_gain=0;
total_loss=0;

if ~linearize
    for i=1:615
        total_gain=total_gain+sum(this_image(i,:))*(energy_calib_vector(i)-20.35);
    end
    for i=617:2201
        total_loss=total_loss+sum(this_image(i,:))*(20.35-energy_calib_vector(i));
    end
else
    for i=1:1595
        total_gain=total_gain+sum(this_image(i,75:275))*(linear_energy_scale(i)-20.35);
    end
    for i=1596:2201
        total_loss=total_loss+sum(this_image(i,75:275))*(20.35-linear_energy_scale(i));
    end
end

total_gain
total_loss