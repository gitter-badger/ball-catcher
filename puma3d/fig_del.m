function fig_del()
    fig = getappdata(0, 'fig');
    delete(fig);
    rmappdata(0, 'fig');
    
    uicontrols = getappdata(0, 'uicontrols');
    delete(uicontrols);
    rmappdata(0, 'uicontrols');
    
    kin_panel = getappdata(0, 'kin_panel');
    delete(kin_panel);
    rmappdata(0, 'kin_panel');
end