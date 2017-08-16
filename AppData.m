% A class to be used in place of getting/setting app data with the
% getappdata()/setappdata() functions. Objects of this class will contain
% the same information that used to be set as application data.
%
% Author: Elliot Tuck
% Date: 20170815
classdef AppData < handle
    properties
        remote = 1
        skip_background_verification = 0
        linearize = 0
        show_image = 1
        DC_offset = 1
        save_video = 1
        save_data = 1
        save_override = 0
        show_noise_sample = 1
        remove_xrays = 1
        show_DC_sample = 0
        manual_energy = 1
        log_color = 0
        manual_set_figure_position = 1
        background_checked = 0
        scale_adjustment = 0.95
        curr_lim = [0 5000]
        curr_lim1 = 0
        curr_lim2 = 5000
        dataset_info = DatasetInfo()
        data
        dataorig
        check_linearize_ROI
        load_linearize_ROI
        camera
        prefix
        num_stacks
        image_struc
        num_images
        stack_text
        func_name
        bend_struc
        i
        j
        curr_image
        noise
        sample_vector
        X_ORIENT
        Y_ORIENT
        original_noise
        image_size
        vertsize
        horizsize
        resolution
        energy_calib_vector
        energy_pixel
        energy_ticks
        processed_data
        this_image
        linear_energy_scale
        height_start
        width_start
        display_width
        display_height
        contained_p
        r1
        r2
    end
    methods
        function obj = AppData()
            % default constructor
        end
    end
end