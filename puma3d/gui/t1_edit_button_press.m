   function t1_edit_button_press(h,dummy)
        global t1_slider;
        global t1_home;
        user_entry = check_edit(h,-160,160,0,t1_edit);
        set(t1_slider,'Value',user_entry);  % slider = text box.
        T_Old = getappdata(0,'ThetaOld');   % Current pose    
        %
        t2old = T_Old(2); t3old = T_Old(3); t4old = T_Old(4);
        t5old = T_Old(5); t6old = T_Old(6);
        %
        pumaANI(user_entry+t1_home,t2old,t3old,t4old,t5old,t6old,10,'n')
    end