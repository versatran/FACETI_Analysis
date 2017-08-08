% READ
% This script takes in sorted energies and makes correlation plot
% according to the sorted parameter. eda_energy_limits and 
% sort_selected_snapshot_by_var_edited must run before this. This script cannot 
% run on its own.

% get data structure and saved variables from eda_energy_limits
data = getappdata(0, 'data');
index_sorted_UID = getappdata(0, 'index_sorted_UID');
sort_parameter = getappdata(0, 'sort_parameter');
sorting_values = getappdata(0, 'sorting_values');
% energy_gain = data.processed.vectors.(getappdata(0, 'save_struc_str')).energy_gain;
energy_gain = getappdata(0, 'energy_gain');
energy_loss = getappdata(0, 'energy_loss');
start_energy_top = getappdata(0, 'start_energy_top');
start_energy_bottom = getappdata(0, 'start_energy_bottom');
start_pixel_top = getappdata(0, 'start_pixel_top');
start_pixel_bottom = getappdata(0, 'start_pixel_bottom');
str = getappdata(0, 'save_struc_str');
energy_UID = data.processed.vectors.(getappdata(0, 'save_struc_str')).UID;

%attempt to perform cut specifically for 20140528 12981 to remove laser on
%shots 
% sorted_vector = getappdata(0, 'sorted_vector');
% index_sorted_UID_cut = index_sorted_UID;
% for i = 1:340
%     if ( index_sorted_UID(i)<60)
%         index_sorted_UID_cut(i) = [];
%         sorting_values_cut(i) = [];
%        
%     end
% end

q = questdlg('Would you like to plot energy gain or energy loss?', ...
    'Plot Energy Vs. Parameter', 'Energy Gain', 'Energy Loss', 'Energy Gain');
switch q
    case 'Energy Gain'
        y_label_name = 'Energy Gain (GeV)';
        y_title = 'Energy Gain';
        sorted_UID_energy = energy_UID(index_sorted_UID);
        sorted_values_energy = energy_gain(index_sorted_UID);
    case 'Energy Loss'
        y_label_name = 'Energy Loss (GeV)';
        y_title = 'Energy Loss';
        sorted_UID_energy = energy_UID(index_sorted_UID);
        sorted_values_energy = energy_loss(index_sorted_UID);
end       

% for plotting a peak energy line on a waterfall plot
sorted_start_energy_top = start_energy_top(index_sorted_UID);
sorted_start_energy_bottom = start_energy_bottom(index_sorted_UID);
sorted_start_pixel_top = start_pixel_top(index_sorted_UID);
sorted_start_pixel_bottom = start_pixel_bottom(index_sorted_UID);

% plot sorted parmaeter by energy gain/loss
shot = 1:400;
figure('Name', str);
set(gcf, 'color', [1,1,1]);
plot(sorting_values, sorted_values_energy, 'o');
y_label = ylabel(y_label_name);
x_label = xlabel(sort_parameter);
plot_title = title([y_title ' Vs. ' sort_parameter]);
set(y_label, 'Interpreter', 'none');
set(x_label, 'Interpreter', 'none');
set(plot_title, 'Interpreter', 'none');
% plot(sorted_start_energy_top);
% plot(sorted_start_pixel_top);

% ylim([0,1]);