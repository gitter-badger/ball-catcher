function del_app(varargin)
    %This is the main figure window close function, to remove any
    % app data that may be left due to using it for geometry.
    %CloseRequestFcn
    % here is the data to remove:
    %     link_data: [1x7 struct]
    %        patch_h: [1x9 double]
    %       ThetaOld: [1x6 double]
    %         xtrail: [1x1 double]
    %         ytrail: [1x1 double]
    %         ztrail: [1x1 double]
    %      kin_panel: [1x1 struct]
    % Now remove them.
    fig_1 = getappdata(0, 'fig_1');
    delete(fig_1);
    
    rmappdata(0, 'ThetaOld');
    rmappdata(0, 'link_data');
    rmappdata(0, 'patch_h');
    rmappdata(0, 'xtrail');
    rmappdata(0, 'ytrail');
    rmappdata(0, 'ztrail');
    rmappdata(0, 'kin_panel');
    rmappdata(0, 'fig_1');
    rmappdata(0, 'home_pos');
    rmappdata(0, 'min_pos');
    rmappdata(0, 'max_pos');
    rmappdata(0, 'uicontrols');
end