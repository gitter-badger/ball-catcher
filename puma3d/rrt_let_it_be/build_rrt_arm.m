function [rrt] = build_rrt_arm
    use_gui = true;
    stats = getappdata(0, 'stats');
    balls = getappdata(0, 'balls');
    threshold_to_catch = 200;
    cur_sc = get(stats.score.edit, 'string');
    cur_sc = str2double(cur_sc);
    start_pt = arm_tip;
    dim = 3;
    min_axis = [-300 -300 10000];
    max_axis = [300  300 10000];
    delta_time = 100;
    
    %% Create ball(s)
    new_balls = {};
    new_balls{1}.pos = min_axis + rand(1,3) .* (max_axis - min_axis);
    new_balls{1}.vel = [ 0 0 -1 ];
    new_balls{1}.acc = [ 0 0 0 ];
    new_balls{1}.radius = 100;
    for i=1:length(new_balls)
        ball_init(new_balls{i}.pos, new_balls{1}.radius, ...
            new_balls{i}.vel, new_balls{i}.acc, true);
    end
    
    %% RRT
    balls = getappdata(0, 'balls');
    goal = balls{1}.pos;
    rrt = struct('state', start_pt, 'parent', [], 'vel', [0;0]);
    maxpoints = 1000;
    for iter = 1: maxpoints
        % Update arm
        ball_loop(delta_time, use_gui);
        
        % Do RRT stuff
        x = arm_tip;
        disp(sprintf('current position of the arm: %0.3f %0.3f %0.3f',x(1),x(2),x(3) ));
        prob = rand(1);
        if prob < 0.8
            sample_pt = min_axis+(max_axis-min_axis).*rand(dim,1)';
        else
            sample_pt = goal;
        end
        
        x = [rrt.state]; %all points in the rrt!    
        [dist,nearest] = min(sum((x-repmat(sample_pt,1,numel(rrt))).^2));%calc distances to all points in the rrt

        %do some checking here
        if ( dist  < 100)    
            rrt(end+1) = struct('state',new_pt,'parent',nearest, 'vel', [0;0]);
            %move the arm tip
            new_pt = sample_pt;
        else 
            %move by a distance
             new_pt = rrt(nearest).state + 100* (sample_pt - rrt(nearest).state )/(dist^0.5);
        end   
        
        
        %set px py pz as arm_tip;
        x = new_pt;
        disp(sprintf('new position of the arm: %0.3f %0.3f %0.3f',x(1),x(2),x(3) ));
        new_arm_angles = arm_IK(x(1), x(2), x(3));
        new_arm_angles(3) = new_arm_angles(3) - 180;
        new_arm_angles(4) = 0;
        new_arm_angles(5) = 0;
        new_arm_angles(6) = 0;
        
        % Theta 4, 5 & 6 are zero due to plotting at wrist origin.
        arm_animate(new_arm_angles, 2, use_gui);
        
        balls = getappdata(0, 'balls');

        if pdist2(balls{1}.pos,arm_tip) < threshold_to_catch
           cur_sc=cur_sc+1;
           return;
         end
        
        
    end
   
end