    function c = correlate_plot(x_val, xuid, y_val, yuid)
        sort_q = questdlg('Would you like your x_parameter sorted?');
        x_param = getappdata(0, 'x_param');
        y_param = getappdata(0, 'y_param');
        dataset_str = getappdata(0, 'dataset_str');
        switch sort_q
            case 'Yes'
                % make the sort vector from x parameter
                unique_sort_id = unique(xuid);
                if length(unique_sort_id) ~= length(xuid)
                    error(['repetative UIDs exist in the sort dataset. Program ' ...
                        'terminated']);
                end
                [Y1, I1] = sort(x_val);        
                sorted_UID = xuid(I1);

                % match the UIDs with the parameter values. This discards parameter
                % values that do not have an associated shot to create vectors of
                % same length
                 j = 1;
                 [~, index_y_UID_matched, index_sorted_UID] = ...
                     intersect(sorted_UID, yuid(j, :), 'stable');

                matched_y_values(j, :) = y_val(j, index_sorted_UID);    
                revised_UID(j, :) = sorted_UID(index_y_UID_matched);
                sorted_x_values(j, :) = Y1(index_y_UID_matched);

                % creates plot
                c = figure('Name', ['Correlation Plot of ' x_param ' with ' ...
                    y_param ' ' dataset_str]);
                % linecutOptions('reset');
            
                set(c, 'color', [1,1,1]);
                plot(sorted_x_values, matched_y_values);
                plot_title = title([x_param ' vs. ' y_param]);
                plot_xlabel = xlabel(x_param);
                plot_ylabel = ylabel(y_param);
                set(plot_xlabel, 'Interpreter', 'none');
                set(plot_title, 'Interpreter', 'none');
                set(plot_ylabel, 'Interpreter', 'none');
        otherwise
                % creates non-sorted plot. The lengths of these parameters are
                % longer than the number of shots taken for the dataset
                c = figure('Name', ['Correlation Plot of ' x_param ' with ' ...
                    y_param ' ' dataset_str]);
                set(c, 'color', [1,1,1]);
                scatter(x_val, y_val, 'bo', 'MarkerFaceColor','b');
                plot_title = title([x_param ' vs. ' y_param]);
                plot_xlabel = xlabel(x_param);
                plot_ylabel = ylabel(y_param);
                set(plot_xlabel, 'Interpreter', 'none');
                set(plot_title, 'Interpreter', 'none');
                set(plot_ylabel, 'Interpreter', 'none');
        end
        saveFigure_option = uimenu(c, 'Label', 'Save');
        setappdata(0, 'x_param', x_param);
        uimenu(saveFigure_option, 'Label', 'Save Conditions', 'Callback', @openViewConditions);
    end