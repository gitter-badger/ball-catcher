function sarsa_episode(use_gui)
    sarsa = getappdata(0, 'sarsa');
    arm = getappdata(0, 'arm');
    if nargin == 0
        use_gui = true;
    end
    
    %% Create ball(s)
    new_balls = {};
    
    for i=1:size(arm,2)
    new_balls(i).pos = sarsa(i).ball.pos_min + rand(1,3) .* (sarsa(i).ball.pos_max - sarsa(i).ball.pos_min);
    new_balls(i).vel = sarsa(i).ball.vel_min + rand(1,3) .* (sarsa(i).ball.vel_max - sarsa(i).ball.vel_min);
    new_balls(i).acc = sarsa(i).ball.acc_min + rand(1,3) .* (sarsa(i).ball.acc_max - sarsa(i).ball.acc_min);
    end
    for i=1:length(new_balls)
        ball_init(new_balls(i).pos, sarsa(i).ball.radius, ...
            new_balls(i).vel, new_balls(i).acc, use_gui,i);
    end
    
    %% Run
    
    balls = getappdata(0, 'balls');
    
    ball_caught = false(1,size(arm,2));
    first_loop = true;
    last_action = zeros(1,size(arm,2));
    last_state_features = zeros(1,size(arm,2));
    pos=reshape([balls.pos],3,size(arm,2));
    
     action_bools =[ [zeros(4,1); ones(4,1)], ...
            repmat([zeros(2,1); ones(2,1)], 2, 1), ...
            repmat([zeros(1,1); ones(1,1)], 4, 1)];
    while max(pos(3,:)) >= -1120
        % Find which action to do
        state_features = pos - arm_tip';
        state_features(state_features < 0) = 0;
        state_features(state_features > 0) = 1;
        
        state_action_function = [sarsa.weights]'*state_features;
       
    
        for i=1:size(arm,2)
        action = find(state_action_function((i-1)*8+1:i*8,i) == max(state_action_function((i-1)*8+1:i*8,i)));
        
        if length(action) > 1
            action1(i) = action(randi(length(action)));
        else
            action1(i)=action;
        end
        
        if rand(1) < max([sarsa.exploration_factor])
            action_list = [1:length(state_action_function((i-1)*8+1:i*8,i))]';
            
            action_list(action_list == action1(i)) = [];
            action1(i) = action_list(randi(length(action_list)));
        end
        action2(:,i)=action_bools(action1(i),:)';
        end
      
        action=action1;
        clear action1
      
        
        % Do the action, and let stuff move
        
        pos_error = pos - arm_tip';
        
        new_pos = arm_tip' + repmat([sarsa.action_error_scale],3,1).* ...
            (pos_error .* action2);
        new_arm_angles=zeros(6,size(arm,2));
        for i=1:size(arm,2)
        new_arm_angles(:,i) = arm_IK(new_pos(1,i),new_pos(2,i),new_pos(3,i))';
        end
        new_arm_angles(3,:) = new_arm_angles(3,:) - 180;
        new_arm_angles(4,:) = 0;
        new_arm_angles(5,:) = 0;
        new_arm_angles(6,:) = 0;
        
        old_arm_angles = reshape([arm.theta],6,size(arm,2));
        delta_arm_angles = new_arm_angles - old_arm_angles;
        
        delta_arm_max_angles = sarsa(1).arm.angle_vel_max * sarsa(1).delta_time;
        delta_arm_min_angles = sarsa(1).arm.angle_vel_min * sarsa(1).delta_time;
        
        t=repmat(delta_arm_max_angles',1,size(arm,2));
        t1=repmat(delta_arm_min_angles',1,size(arm,2));
        t=(delta_arm_angles<t).*delta_arm_angles+(delta_arm_angles>t).*t;
        delta_arm_angles = (t1<t).*t+(t1>t).*t1;
        
        new_constrainted_arm_angles = old_arm_angles + delta_arm_angles;
    %     p = sarsa.arm.angle_vel_max * sarsa.delta_time;
%        fprintf('vel = %d %d %d %d %d %d\n', delta_arm_angles(1), delta_arm_angles(2), delta_arm_angles(3), delta_arm_angles(4), delta_arm_angles(5),delta_arm_angles(6));
        target_arm_angles = new_constrainted_arm_angles;
        
        arm_animate(target_arm_angles, 2, use_gui)
        ball_loop(sarsa(1).delta_time, use_gui);
        
        % Get back the changed? global variables
        arm = getappdata(0, 'arm');
        balls = getappdata(0, 'balls');
        sarsa = getappdata(0, 'sarsa');

        
   %     fprintf('tip = %0.1f %0.1f %0.1f, ball = %0.1f %0.1f %0.1f\n', arm_tip_variable(1), arm_tip_variable(2), arm_tip_variable(3), balls{1}.pos(1), balls{1}.pos(2), balls{1}.pos(3));
        
        % Give rewards
        arm_tip_variable = arm_tip;
        
        pos_error_dist = sqrt(sum((reshape([balls.pos],3,size(arm,2))- arm_tip_variable').^2));
        tmp=reshape([balls.pos],3,size(arm,2));
        radial_pos_error_dist = sqrt(sum((tmp(1:2,:)- arm_tip_variable(:,1:2)').^2));
        
        sat=(pos_error_dist < [sarsa.error_to_catch]);
        if max(sat)==1
            
            [sarsa(sat).score] = [sarsa(sat).score] + 1;
            ball_caught(sat) = 1;
            setappdata(0, 'sarsa', sarsa)
        end
        
        if first_loop
            first_loop = false;
        else
            reward = radial_pos_error_dist * -0.10 + ball_caught * 20;
            stats = getappdata(0, 'stats');
            for i=1:size(arm,2)
            sarsa(i).action_error_scale=radial_pos_error_dist(i)/1000;
            
            e1 = sarsa(i).eligibility_trace(:, last_action(i));
            e1(last_state_features(:,i)==1) = 1;
            sarsa(i).eligibility_trace(:, action(i)) = e1;
            delta(i) = reward(i) - sum(sarsa(i).weights(:, last_action(i)) .* last_state_features(:,i));
            
            
            pos=reshape([balls.pos],3,size(arm,2));

            

            if ~(ball_caught(i) || pos(3,i) <= -1120)
                % Not Terminal, get next Q
                delta(i) = delta(i) + sarsa(i).discounting_factor * ...
                    sum(sarsa(i).weights(:, action(i)) .* state_features(:,i));
            end
            sarsa(i).weights = sarsa(i).weights + sarsa(i).step_size * delta(i) * sarsa(i).eligibility_trace;
            sarsa(i).eligibility_trace = sarsa(i).lambda * sarsa(i).discounting_factor * sarsa(i).eligibility_trace;
            set(stats(i).reward.edit, 'string', reward(i));
            end
            
            
            
        end
        
        if ball_caught
            
            disp(cat(2,'Ball Caught ! score= ', num2str(sarsa.score)));
    
            pause(0.5);
            break;
        end
        
%         fprintf('1 action : last=%d best=%d\n', last_action, action);
        last_action = action;
        last_state_features = state_features;
%         fprintf('2 action : last=%d best=%d\n', last_action, action);
    end
    
    %% Finish
    stats = getappdata(0, 'stats');
    for i=1:size(arm,2)
    set(stats(i).score.edit, 'string', sarsa(i).score);
    end
    setappdata(0, 'sarsa', sarsa);
    ball_del;
    
end