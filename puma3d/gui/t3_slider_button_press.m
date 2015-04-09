   function t3_slider_button_press(h,dummy)
        global t3_edit;
        global t3_home;
        slider_value = round(get(h,'Value'));
        set(t3_edit,'string',slider_value);
        T_Old = getappdata(0,'ThetaOld');
        t1old = T_Old(1); t2old = T_Old(2); t4old = T_Old(4);
        t5old = T_Old(5); t6old = T_Old(6);
        pumaANI(t1old,t2old,slider_value+t3_home,t4old,t5old,t6old,10,'n')
    end