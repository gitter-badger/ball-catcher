function clr_trail_button_press(h,dummy)
    %disp('pushed clear trail bottom');
    arm = getappdata(0, 'arm');
    
    arm.trail = [0; 0; 0];
    set(arm.patch_h(9), 'xdata', 0, 'ydata', 0, 'zdata', 0);
    
    setappdata(0, 'arm', arm);
end