function [rrt] = build_rrt_arm
    arm = getappdata(0, 'arm');
    use_gui = true;
    stats = getappdata(0, 'stats');
    balls = getappdata(0, 'balls');

    threshold_to_catch = 200;
    cur_sc = get(stats(1).score.edit, 'string');
    cur_sc = str2double(cur_sc);
    start_pt = arm_tip;

    threshold_to_catch=200;
    cur_sc=get(stats.score.edit ,'string');
    cur_sc=str2double(cur_sc);
    start_pt= arm_tip;

    dim = 3;
    min_axis = [-600 -600 0];
    max_axis = [600  600 10000];
    delta_time = 100;
    
    %% Create ball(s)
    arr = rand(1,3);
    arr(3) = 1;
    new_balls = {};
    new_balls{1}.pos = [1000 -1000 4000 ];%min_axis + arr .* (max_axis - min_axis);
    new_balls{1}.vel = [ 0 0 -1 ];
    new_balls{1}.acc = [ 0 0 0 ];
    new_balls{1}.radius = 100;
    for i=1:length(new_balls)
        ball_init(new_balls{i}.pos, new_balls{1}.radius, ...
            new_balls{i}.vel, new_balls{i}.acc, true,size(arm,2));
    end
    simulated_arm_tip = arm_tip;
        start_pt = simulated_arm_tip;
    rrt = struct('state', start_pt', 'parent', [], 'vel', [0;0]);
    %% RRT
    max_plan_iter = 200; %or make it while loop till ball has hit the ground
    for plan_iter = 1:max_plan_iter
        fprintf('iteration %d\n', plan_iter);
        disp('move the goal');
        ball_loop(delta_time, use_gui);
        balls = getappdata(0, 'balls');
        goal = balls(1).pos;
        simulated_arm_tip = arm_tip;
        start_pt = simulated_arm_tip;
        rrt = struct('state', start_pt', 'parent', [], 'vel', [0;0]);
        %A new rrt from the start_pt every step
        %Vel can be used to set kino dynamic constraints on the arm
        
        %It is an online setting where we have to grow the tree from start and
        %after the goal has moved considerably, we execute the plan and regrow
        %the tree from the current configuration

        %maximum number of points before goal changes , play around with some values 
        maxpoints = 100;
        for iter = 1: maxpoints
            % Update arm


            % Do RRT stuff
            %using x to avoid typing long name always
            x = simulated_arm_tip; 
          %  disp(sprintf('current position of the arm: %0.3f %0.3f %0.3f',x(1),x(2),x(3) ));
            prob = rand(1);
            if prob < 0.8
                sample_pt = min_axis+(max_axis-min_axis).*rand(dim,1)';
            else
                sample_pt = goal;
            end

            x = [rrt.state]; %all points in the rrt!    
            [dist,nearest] = min(sum((x-repmat(sample_pt',1,numel(rrt))).^2));%calc distances to all points in the rrt
            %do some checking here
            if ( dist  < 1)    
                new_pt = sample_pt';
            else 
                 new_pt = rrt(nearest).state +  (sample_pt' - rrt(nearest).state )/(dist^0.5);     
            end   
            rrt(end+1) = struct('state',new_pt,'parent',nearest, 'vel', [0;0]);

            %set px py pz as arm_tip;
            x = new_pt;
            
%             new_arm_angles = arm_IK(x(1), x(2), x(3));
%             new_arm_angles(3) = new_arm_angles(3) - 180;
%             new_arm_angles(4) = 0;
%             new_arm_angles(5) = 0;
%             new_arm_angles(6) = 0;

            

            % Theta 4, 5 & 6 are zero due to plotting at wrist origin.
            %arm_animate(new_arm_angles, 2, use_gui);
            %balls = getappdata(0, 'balls');

            if pdist2(goal',new_pt) < threshold_to_catch
               %Caught it!!
               %end the run and implement the plan to reach the goal
               pathtofollow = getPathtoPoint(rrt, new_pt);
               [trash, count] = size(pathtofollow);
               for i = 1 :count
                    pointtogo = pathtofollow(:,i);
                    new_arm_angles = zeros(1,6);
                    new_arm_angles = arm_IK(pointtogo(1), pointtogo(2), pointtogo(3));
                    new_arm_angles(3) = new_arm_angles(3) - 180;
                     new_arm_angles(4) = 0.1;
                     new_arm_angles(5) = 0.1;
                     new_arm_angles(6) = 0.1;

            

            % Theta 4, 5 & 6 are zero due to plotting at wrist origin.
                arm_animate(new_arm_angles, 2, use_gui);  
               end
               
               
               
               
               %TODO: Exevcute the pathtofollow
               disp('caught the ball');
               %it will be like [(1,1,1) (2,2,2) (3,3,3)] to reach (3,3,3)
               return;
            end
        end
            
            printrrt(rrt,plan_iter);
        
        
            %findign out what path to take in the tree
            x = [rrt.state]; %all points in the rrt!
            [dist,nearest] = min(sum((x-repmat(goal',1,numel(rrt))).^2));
            nearest_pt_in_rrt_to_goal = rrt(nearest).state;
            
            pathtofollow = getPathtoPoint(rrt,nearest_pt_in_rrt_to_goal);
            [trash, count] = size(pathtofollow);
            
               for i = 1 : count
                    pointtogo = pathtofollow(:,i);
                    new_arm_angles = zeros(1,6);
                    new_arm_angles = arm_IK(pointtogo(1), pointtogo(2), pointtogo(3));
                    new_arm_angles(3) = new_arm_angles(3) - 180;
                     new_arm_angles(4) = 0;
                     new_arm_angles(5) = 0;
                     new_arm_angles(6) = 0;

            

            % Theta 4, 5 & 6 are zero due to plotting at wrist origin.
                arm_animate(new_arm_angles, 2, use_gui);  
               end
            x = arm_tip;
            %disp(sprintf('new position of the arm: %0.3f %0.3f %0.3f',x(1),x(2),x(3) ));
            
            %TODO: execute the pathtofollow
            
            if pdist2(goal, arm_tip) < threshold_to_catch
                %done with the algo
                cur_sc = cur_sc+1;
                
                %caught!!
             end
                
    end
    
    
   
end