function fig_init
    arm = getappdata(0, 'arm');
    
    set(0, 'Units', 'pixels')
    dim = get(0, 'ScreenSize');

    fig = figure('doublebuffer','on','Position',[0,35,dim(3)-200,dim(4)-110],...
        'MenuBar','none','Name',' 3D Puma Robot Graphical Demo',...
        'NumberTitle','off');
    
    hold on;
    %light('Position',[-1 0 0]);
    light;                       % add a default light
    daspect([1 1 1]);            % Setting the aspect ratio
    view(135, 25);               % Set viewpoint (azimuth, elevation)
    xlabel('X'); 
    ylabel('Y'); 
    zlabel('Z');
    title('PUMA 762');

    % Make sure it axes are scaled correctly
    axis([-1500 1500 -1500 1500 -1120 1500]);
    
    % Plot lines at the corners of the cube defines by above axes
    plot3([-1500,  1500], [-1500, -1500], [-1120, -1120], 'k')
    plot3([-1500, -1500], [-1500,  1500], [-1120, -1120], 'k')
    plot3([-1500, -1500], [-1500, -1500], [-1120,  1500], 'k')
    plot3([-1500, -1500], [ 1500,  1500], [-1120,  1500], 'k')
    plot3([-1500,  1500], [-1500, -1500], [ 1500,  1500], 'k')
    plot3([-1500, -1500], [-1500,  1500], [ 1500,  1500], 'k')
    
    arm.trail = [0; 0; 0];
    
    
    %
    % UI controls
    uicontrols = {};

    uicontrols.demo = uicontrol(fig,'String','Demo','callback',@demo_button_press,...
        'Position',[20 5 60 20]);

    uicontrols.rnd_demo= uicontrol(fig,'String','Random Move','callback',@rnd_demo_button_press,...
        'Position',[100 5 80 20]);

    uicontrols.clr_trail= uicontrol(fig,'String','Clr Trail','callback',@clr_trail_button_press,...
        'Position',[200 5 60 20]);

    uicontrols.home= uicontrol(fig,'String','Home','callback',@home_button_press,...
        'Position',[280 5 70 20]);

    uicontrols.create_ball = uicontrol(fig,'String','Create Ball','callback',@create_ball_button_press,...
        'Position', [370 5 80 20]);
    
    % 
    % Kinematics Panel
    %
    kin_panel = {};

    K_p = uipanel(fig,...
        'units','pixels',...
        'Position',[20 45 265 200],...
        'Title','Kinematics','FontSize',11);
    kin_panel.uipanel = K_p;
    kin_panel.theta = [{}, {}, {}, {}, {}, {}];

    LEFT = 2; % Left
    HEIGHT = 18;  % Height
    BOTTOM = 156; % Bottom

    %%  GUI buttons for Theta.  pos is: [left bottom width height]
    for i=1:6
        kin_panel.theta(i).text = uicontrol(K_p,'style','text',...
            'String', ['T' int2str(i)],...
            'Position',[LEFT BOTTOM 20 HEIGHT]); % L, B, W, H
        kin_panel.theta(i).edit = uicontrol(K_p,'style','edit',...
            'String', 0,...
            'callback',@edit_button_press,...
            'Position',[LEFT+20 BOTTOM 40 HEIGHT]); % L, B, W, H
        kin_panel.theta(i).min = uicontrol(K_p,'style','text',...
            'String', int2str(arm.min_pos(i)),...
            'Position',[LEFT+60 BOTTOM+1 35 HEIGHT-4]); % L, from bottom, W, H
        kin_panel.theta(i).slider = uicontrol(K_p, 'style', 'slider',...
            'Max', arm.max_pos(i), 'Min', arm.min_pos(i), 'Value', 0,...
            'SliderStep', [0.05 0.2],...
            'callback', @slider_button_press,...
            'Position', [LEFT+95 BOTTOM 120 HEIGHT]);
        kin_panel.theta(i).max = uicontrol(K_p,'style','text',...
            'String', int2str(arm.max_pos(i)),...
            'Position',[LEFT+215 BOTTOM+1 35 HEIGHT-4]); % L, B, W, H
        BOTTOM = BOTTOM - 30;
    end
    
    setappdata(0, 'uicontrols', uicontrols);
    setappdata(0, 'kin_panel', kin_panel);
    setappdata(0, 'arm', arm);
    setappdata(0, 'fig', fig);
end