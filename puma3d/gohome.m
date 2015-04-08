function gohome()
 global t1_edit;
        global t1_slider;
        global t2_edit;
        global t2_slider;
        global t3_edit;
        global t3_slider;
        global t4_edit;
        global t4_slider;
        global t5_edit;
        global t5_slider;
        global t6_edit;
        global t6_slider;
        pumaANI(90,-90,-90,0,0,0,20,'n') % show it animate home
        %PumaPOS(90,-90,-90,0,0,0)  %drive it home, no animate.
        set(t1_edit,'string',0);
        set(t1_slider,'Value',0);  %At the home position, so all
        set(t2_edit,'string',0);   %sliders and input boxes = 0. 
        set(t2_slider,'Value',0);
        set(t3_edit,'string',0);
        set(t3_slider,'Value',0);
        set(t4_edit,'string',0);
        set(t4_slider,'Value',0);
        set(t5_edit,'string',0);
        set(t5_slider,'Value',0);
        set(t6_edit,'string',0);
        set(t6_slider,'Value',0);
        setappdata(0,'ThetaOld',[90,-90,-90,0,0,0]);
    end