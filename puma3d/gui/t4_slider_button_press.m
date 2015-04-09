function t4_slider_button_press(h,dummy)
        global t4_edit
        slider_value = round(get(h,'Value'));
        set(t4_edit,'string',slider_value);
        T_Old = getappdata(0,'ThetaOld');
        t1old = T_Old(1); t2old = T_Old(2); t3old = T_Old(3);
        t5old = T_Old(5); t6old = T_Old(6);
        pumaANI(t1old,t2old,t3old,slider_value,t5old,t6old,10,'n')
    end