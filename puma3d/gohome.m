function gohome()
    global t1_edit t1_slider t2_edit t2_slider t3_edit t3_slider;
    global t4_edit t4_slider t5_edit t5_slider t6_edit t6_slider;
    
    pumaANI(90,-90,-90,0,0,0,20,'n') % show it animate home
    %pumaPOS(90,-90,-90,0,0,0)  %drive it home, no animate.
    
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