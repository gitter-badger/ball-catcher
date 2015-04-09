function t5_slider_button_press(h,dummy)
        global t5_edit
        slider_value = round(get(h,'Value'));
        set(t5_edit,'string',slider_value);
        T_Old = getappdata(0,'ThetaOld');
        t1old = T_Old(1); t2old = T_Old(2); t3old = T_Old(3);
        t4old = T_Old(4); t6old = T_Old(6);
        pumaANI(t1old,t2old,t3old,t4old,slider_value,t6old,10,'n')
    end