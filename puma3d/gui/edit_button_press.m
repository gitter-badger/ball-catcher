function edit_button_press(h, dummy)
    kin_panel = getappdata(0, 'kin_panel');
    home_pos = getappdata(0, 'home_pos');
    min_pos = getappdata(0, 'min_pos');
    max_pos = getappdata(0, 'max_pos');
    
    theta_values = home_pos;
    for i=1:6
        theta_values(i) = theta_values(i) + ...
            check_edit(kin_panel.theta(i).edit, min_pos(i), max_pos(i), ...
            0, kin_panel.theta(i).edit);
        
        set(kin_panel.theta(i).slider, 'Value', ...
            theta_values(i) - home_pos(i));  % slider = text box.
    end
    
    pumaANI(theta_values(1), theta_values(2), theta_values(3), ...
        theta_values(4), theta_values(5), theta_values(6), 10,'n')
end
