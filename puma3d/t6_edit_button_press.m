function t6_edit_button_press(h,dummy)
        global t6_slider;
        user_entry = check_edit(h,-266,266,0,t6_edit);
        set(t6_slider,'Value',user_entry);  % slider = text box.
        T_Old = getappdata(0,'ThetaOld');   % Current pose    
        %
        t1old = T_Old(1); t2old = T_Old(2); t3old = T_Old(3);
        t4old = T_Old(4); t5old = T_Old(5);
        %
        pumaANI(t1old,t2old,t3old,t4old,t5old,user_entry,10,'n')
    end