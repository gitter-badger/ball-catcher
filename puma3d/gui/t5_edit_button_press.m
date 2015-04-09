function t5_edit_button_press(h,dummy)
    global t5_slider;
    user_entry = check_edit(h,-100,100,0,t5_edit);
    set(t5_slider,'Value',user_entry);  % slider = text box.
    T_Old = getappdata(0,'ThetaOld');   % Current pose    
    %
    t1old = T_Old(1); t2old = T_Old(2); t3old = T_Old(3);
    t4old = T_Old(4); t6old = T_Old(6);
    %
    pumaANI(t1old,t2old,t3old,t4old,user_entry,t6old,10,'n')
end