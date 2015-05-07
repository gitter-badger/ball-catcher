function sarsa_episode(use_gui)
    sarsa = getappdata(0, 'sarsa');
    
    %% Create ball(s)
    new_balls = {};
    new_balls{1}.pos = sarsa.ball.pos_min + rand(1,3) .* (sarsa.ball.pos_max - sarsa.ball.pos_min);
    new_balls{1}.vel = sarsa.ball.vel_min + rand(1,3) .* (sarsa.ball.vel_max - sarsa.ball.vel_min);
    new_balls{1}.acc = sarsa.ball.acc_min + rand(1,3) .* (sarsa.ball.acc_max - sarsa.ball.acc_min);
    
    for i=1:length(new_balls)
        ball_init(new_balls{i}.pos, sarsa.ball.radius, ...
            new_balls{i}.vel, new_balls{i}.acc);
    end
    
    %% Run
    arm = getappdata(0, 'arm');
    balls = getappdata(0, 'balls');
    sarsa = getappdata(0, 'sarsa');
    ball_caught = false;
    first_loop = true;
    last_action = 0;
    last_state_features = 0;
    
    
    
    while balls{1}.pos(3) >= -1120
        % Find which action to do
        state_features = balls{1}.pos' - arm_tip';
        state_features(state_features < 0) = 0;
        state_features(state_features > 0) = 1;

        state_action_function = sarsa.weights' * state_features;
        action = find(state_action_function == max(state_action_function));
        if length(action) > 1
            action = action(randi(length(action)));
        end
        
        if rand(1) < sarsa.exploration_factor
            action_list = [1:length(state_action_function)]';
            action_list(action_list == action) = [];
            action = action_list(randi(length(action_list)));
        end
        
        % Do the action, and let stuff move
        action_bools =[ [zeros(4,1); ones(4,1)], ...
            repmat([zeros(2,1); ones(2,1)], 2, 1), ...
            repmat([zeros(1,1); ones(1,1)], 4, 1)];
        pos_error = balls{1}.pos' - arm_tip';
        new_pos = arm_tip' + sarsa.action_error_scale * ...
            (pos_error .* action_bools(action, :)');
        
        new_arm_angles = arm_IK(new_pos(1),new_pos(2),new_pos(3));
        new_arm_angles(3) = new_arm_angles(3) - 180;
        new_arm_angles(4) = 0;
        new_arm_angles(5) = 0;
        new_arm_angles(6) = 0;
        
        old_arm_angles = arm.theta;
        delta_arm_angles = new_arm_angles - old_arm_angles;
        delta_arm_max_angles = sarsa.arm.angle_vel_max * sarsa.delta_time;
        delta_arm_min_angles = sarsa.arm.angle_vel_min * sarsa.delta_time;
        delta_arm_angles = max(min(delta_arm_angles, delta_arm_max_angles), delta_arm_min_angles);
        new_constrainted_arm_angles = old_arm_angles + delta_arm_angles;
%         p = sarsa.arm.angle_vel_max * sarsa.delta_time;
        %fprintf('vel = %d %d %d %d %d %d\n', delta_arm_angles(1), delta_arm_angles(2), delta_arm_angles(3), delta_arm_angles(4), delta_arm_angles(5),delta_arm_angles(6));

        target_arm_angles = new_constrainted_arm_angles;
        
        arm_animate(target_arm_angles, 2)
        ball_loop(sarsa.delta_time);
        
        % Get back the changed? global variables
        arm = getappdata(0, 'arm');
        balls = getappdata(0, 'balls');
        sarsa = getappdata(0, 'sarsa');
        
        % Give rewards
        arm_tip_variable = arm_tip();
        pos_error_dist = pdist2(balls{1}.pos, arm_tip_variable);
        radial_pos_error_dist = pdist2(balls{1}.pos(1:2), arm_tip_variable(1:2));
        
        
        if pos_error_dist < sarsa.error_to_catch
            sarsa.score = sarsa.score + 1;
            ball_caught = 1;
            setappdata(0, 'sarsa', sarsa)
        end
        
        if first_loop
            first_loop = false;
        else
            %{
            radial_pos_error_dist * -1
            ball_caught * 100
            overall_rew*-1e-3*ball_caught
            pause
            %}
            reward = radial_pos_error_dist * -0.1 + ball_caught * 10;
            
            sarsa.action_error_scale=radial_pos_error_dist/1000;
            
            e1 = sarsa.eligibility_trace(:, last_action);
            e1(last_state_features==1) = 1;
            sarsa.eligibility_trace(:, action) = e1;

            delta = reward - sum(sarsa.weights(:, last_action) .* last_state_features);

            if ~(ball_caught || balls{1}.pos(3) <= -1120)
                % Not Terminal, get next Q
                delta = delta + sarsa.discounting_factor * ...
                    sum(sarsa.weights(:, action) .* state_features);
            end
            sarsa.weights = sarsa.weights + sarsa.step_size * delta * sarsa.eligibility_trace;
            sarsa.eligibility_trace = sarsa.lambda * sarsa.discounting_factor * sarsa.eligibility_trace;
            
            stats = getappdata(0, 'stats');
            set(stats.reward.edit, 'string', reward);
        end
        
        if ball_caught
          %  sarsa.exploration_factor=0.1/sarsa.score;
   %         setappdata(0, 'sarsa', sarsa);
         %   fprintf('Ball Caught ! score=%d', sarsa.score);
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
    
    set(stats.score.edit, 'string', sarsa.score);
    setappdata(0, 'sarsa', sarsa);
    ball_del;
    
end