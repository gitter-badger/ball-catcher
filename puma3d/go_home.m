function go_home()
    kin_panel = getappdata(0, 'kin_panel');
    home_pos = getappdata(0, 'home_pos');
    
    pumaANI(home_pos(1), home_pos(2), home_pos(3), ...
        home_pos(4), home_pos(5), home_pos(6), 20,'n') % show it animate home
%     pumaPOS(home_pos(1), home_pos(2), home_pos(3), ...
%         home_pos(4), home_pos(5), home_pos(6))  %drive it home, no animate.
    
    for i=1:6
        set(kin_panel.theta(i).edit, 'string',0);
        set(kin_panel.theta(i).edit, 'Value', 0);
    end
    
    setappdata(0, 'ThetaOld', home_pos);
end