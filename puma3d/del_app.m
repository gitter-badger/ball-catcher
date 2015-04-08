    function del_app(varargin)
    global fig_1
        %This is the main figure window close function, to remove any
        % app data that may be left due to using it for geometry.
        %CloseRequestFcn
        % here is the data to remove:
        %     Link1_data: [1x1 struct]
        %     Link2_data: [1x1 struct]
        %     Link3_data: [1x1 struct]
        %     Link4_data: [1x1 struct]
        %     Link5_data: [1x1 struct]
        %     Link6_data: [1x1 struct]
        %     Link7_data: [1x1 struct]
        %      Area_data: [1x1 struct]
        %        patch_h: [1x9 double]
        %       ThetaOld: [90 -182 -90 -106 80 106]
        %         xtrail: 0
        %         ytrail: 0
        %         ztrail: 0
        % Now remove them.
        rmappdata(0,'Link1_data');
        rmappdata(0,'Link2_data');
        rmappdata(0,'Link3_data');
        rmappdata(0,'Link4_data');
        rmappdata(0,'Link5_data');
        rmappdata(0,'Link6_data');
        rmappdata(0,'Link7_data');
        rmappdata(0,'ThetaOld');
        rmappdata(0,'Area_data');
        rmappdata(0,'patch_h');
        rmappdata(0,'xtrail');
        rmappdata(0,'ytrail');
        rmappdata(0,'ztrail');
        delete(fig_1);
    end