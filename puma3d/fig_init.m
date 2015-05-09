function fig_init
    arm = getappdata(0, 'arm');
    stats = {};
    
    set(0, 'Units', 'pixels')
    dim = get(0, 'ScreenSize');

    fig = figure('doublebuffer','on','Position',[0,35,dim(3)-200,dim(4)-110],...
        'MenuBar','none','Name',' 3D Puma Robot Graphical Demo',...
        'NumberTitle','off');
    
    hold on;
    for i=1:size(arm,2)
    %light('Position',[-1 0 0]);
    light;                       % add a default light
    daspect([1 1 1]);            % Setting the aspect ratio
    view(135, 25);               % Set viewpoint (azimuth, elevation)
    xlabel('X'); 
    ylabel('Y'); 
    zlabel('Z');
    title('PUMA 762');

    % Make sure it axes are scaled correctly
    axis([-1500 1500 -1500 1500 -1120 10000]);
    
    % Plot lines at the corners of the cube defines by above axes
    plot3([-1500,  1500], [-1500, -1500], [-1120, -1120], 'k')
    plot3([-1500, -1500], [-1500,  1500], [-1120, -1120], 'k')
    plot3([-1500, -1500], [-1500, -1500], [-1120,  10000], 'k')
    plot3([-1500, -1500], [ 1500,  1500], [-1120,  10000], 'k')
    plot3([-1500,  1500], [-1500, -1500], [ 10000,  10000], 'k')
    plot3([-1500, -1500], [-1500,  1500], [ 10000,  10000], 'k')
    
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
    
    uicontrols.move_ball = uicontrol(fig,'String','Move Ball Down','callback',@ball_move_down,...
        'Position', [470 5 120 20]);
    
    uicontrols.sarsa_start = uicontrol(fig,'String','Sarsa Start','callback',@sarsa_start,...
        'Position', [100 400 120 20]);
    uicontrols.sarsa_clear = uicontrol(fig,'String','Sarsa Clear','callback',@sarsa_clear,...
        'Position', [100 350 120 20]);
    
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
    for i1=1:6
        kin_panel.theta(i1).text = uicontrol(K_p,'style','text',...
            'String', ['T' int2str(i1)],...
            'Position',[LEFT BOTTOM 20 HEIGHT]); % L, B, W, H
        kin_panel.theta(i1).edit = uicontrol(K_p,'style','edit',...
            'String', 0,...
            'callback',@edit_button_press,...
            'Position',[LEFT+20 BOTTOM 40 HEIGHT]); % L, B, W, H
        kin_panel.theta(i1).min = uicontrol(K_p,'style','text',...
            'String', int2str(arm(i).min_pos(i1)),...
            'Position',[LEFT+60 BOTTOM+1 35 HEIGHT-4]); % L, from bottom, W, H
        kin_panel.theta(i1).slider = uicontrol(K_p, 'style', 'slider',...
            'Max', arm(i).max_pos(i1), 'Min', arm(i).min_pos(i1), 'Value', 0,...
            'SliderStep', [0.05 0.2],...
            'callback', @slider_button_press,...
            'Position', [LEFT+95 BOTTOM 120 HEIGHT]);
        kin_panel.theta(i1).max = uicontrol(K_p,'style','text',...
            'String', int2str(arm(i).max_pos(i1)),...
            'Position',[LEFT+215 BOTTOM+1 35 HEIGHT-4]); % L, B, W, H
        BOTTOM = BOTTOM - 30;
    end
    
    
    % points are no fun to watch, make it look 3d by making patches
    % Note : 1-7 are links, 8 is area ? 9 is trail
    arm(i).patch_h(1) = patch('faces', arm(i).link_data.s1.F1, 'vertices', arm(i).link1(:,1:3));
    arm(i).patch_h(2) = patch('faces', arm(i).link_data.s2.F2, 'vertices', arm(i).link2(:,1:3));
    arm(i).patch_h(3) = patch('faces', arm(i).link_data.s3.F3, 'vertices', arm(i).link3(:,1:3));
    arm(i).patch_h(4) = patch('faces', arm(i).link_data.s4.F4, 'vertices', arm(i).link4(:,1:3));
    arm(i).patch_h(5) = patch('faces', arm(i).link_data.s5.F5, 'vertices', arm(i).link5(:,1:3));
    arm(i).patch_h(6) = patch('faces', arm(i).link_data.s6.F6, 'vertices', arm(i).link6(:,1:3));
    arm(i).patch_h(7) = patch('faces', arm(i).link_data.s7.F7, 'vertices', arm(i).link7(:,1:3));
    arm(i).patch_h(8) = patch('faces', arm(i).link_data.A1.Fa, 'vertices', arm(i).link_data.A1.Va(:,1:3));
    arm(i).patch_h(9) = plot3(arm(i).trail(1, :), arm(i).trail(2, :), arm(i).trail(3, :), 'b.');
    
    
    set(arm(i).patch_h(1), 'facec', [0.717, 0.116, 0.123]);
    set(arm(i).patch_h(1), 'EdgeColor', 'none');
    set(arm(i).patch_h(2), 'facec', [0.216, 1, .583]);
    set(arm(i).patch_h(2), 'EdgeColor', 'none');
    set(arm(i).patch_h(3), 'facec', [0.306, 0.733, 1]);
    set(arm(i).patch_h(3), 'EdgeColor', 'none');
    set(arm(i).patch_h(4), 'facec', [1, 0.542, 0.493]);
    set(arm(i).patch_h(4), 'EdgeColor', 'none');
    set(arm(i).patch_h(5), 'facec', [0.216, 1, .583]);
    set(arm(i).patch_h(5), 'EdgeColor', 'none');
    set(arm(i).patch_h(6), 'facec', [1, 1, 0.255]);
    set(arm(i).patch_h(6), 'EdgeColor', 'none');
    set(arm(i).patch_h(7), 'facec', [0.306, 0.733, 1]);
    set(arm(i).patch_h(7), 'EdgeColor', 'none');
    set(arm(i).patch_h(8), 'facec', [.8, .8, .8], 'FaceAlpha', .25);
    set(arm(i).patch_h(8), 'EdgeColor', 'none');
    
    %% Stats panel
    
    stats_panel = uipanel(fig,...
        'units', 'pixels',...
        'Position', [10 500 200 100],...
        'Title', 'Score', 'FontSize', 11);
    stats(i).panel = stats_panel;
    
    stats(i).score.text = uicontrol(stats_panel,'style','text',...
            'String', 'Score',...
            'Position', [10 20 50 20]); % L, B, W, H
    stats(i).score.edit = uicontrol(stats_panel, 'style', 'edit', 'String', 0, ...
            'Position', [70 20 100 20]); % L B W H
        
    stats(i).reward.text = uicontrol(stats_panel,'style','text',...
            'String', 'Reward',...
            'Position', [10 50 50 20]); % L, B, W, H
    stats(i).reward.edit = uicontrol(stats_panel,'style','edit', 'String', 0, ...
            'Position', [70 50 100 20]);
    end
    %% Save to app
    setappdata(0, 'uicontrols', uicontrols);
    setappdata(0, 'kin_panel', kin_panel);
    setappdata(0, 'stats', stats);
    setappdata(0, 'arm', arm);
    setappdata(0, 'fig', fig);
    
%     setappdata(0, 'sarsa', {});
end