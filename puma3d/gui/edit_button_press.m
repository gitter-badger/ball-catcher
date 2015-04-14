function edit_button_press(h, dummy)
    kin_panel = getappdata(0, 'kin_panel');
    arm = getappdata(0, 'arm');
    
    theta_values = zeros(size(arm.home_pos));
    for i=1:size(arm.home_pos, 2)
        
        edit_value = check_edit(kin_panel.theta(i).edit, arm.min_pos(i), ...
            arm.max_pos(i), 0, kin_panel.theta(i).edit);
        
        theta_values(i) = arm.home_pos(i) + edit_value;
        
        set(kin_panel.theta(i).slider, 'Value', edit_value);
    end
    
    arm_animate(theta_values, 10,'n')
end
