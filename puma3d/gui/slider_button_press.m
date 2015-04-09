function slider_button_press(h, dummy)
    kin_panel = getappdata(0, 'kin_panel');
    home_pos = getappdata(0, 'home_pos');
    
    theta_values = home_pos;
    for i=1:6
        theta_values(i) = theta_values(i) + ...
            round(get(kin_panel.theta(i).slider, 'Value'));
        set(kin_panel.theta(i).edit, 'string', theta_values(i) - home_pos(i));
    end
    
%     T_Old = getappdata(0,'ThetaOld');
%     t1old = T_Old(1); t2old = T_Old(2); t4old = T_Old(4);
%     t5old = T_Old(5); t6old = T_Old(6);
    
    pumaANI(theta_values(1), theta_values(2), theta_values(3), ...
        theta_values(4), theta_values(5), theta_values(6), 10,'n')
end