    function t2_edit_button_press(h,dummy)
        global t2_slider;
        global t2_home;
        user_entry = check_edit(h,-110,110,0,t2_edit);
        set(t2_slider,'Value',user_entry);  % slider = text box.
        T_Old = getappdata(0,'ThetaOld');   % Current pose    
        %
        t1old = T_Old(1); t3old = T_Old(3); t4old = T_Old(4);
        t5old = T_Old(5); t6old = T_Old(6);
        %
        pumaANI(t1old,user_entry+t2_home,t3old,t4old,t5old,t6old,10,'n')
    end