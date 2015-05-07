function sarsa_start(h, dummy)
    sarsa = getappdata(0, 'sarsa');
    
    %% Create sarsa variables
    if ( ~exist('sarsa', 'var') ) || isempty(sarsa)
        sarsa = {};
        sarsa.score = 0;
        sarsa.currently_working = true;
        
        sarsa.exploration_factor = 0.1;
        sarsa.discounting_factor = 0.7;
        sarsa.step_size = 0.3;
        sarsa.lambda = 0;
        sarsa.eligibility_trace = zeros(3, 8);
        sarsa.action_error_scale = 0.4;
        sarsa.error_to_catch = 100;
        sarsa.delta_time = 100;
        
        sarsa.ball.pos_min = [-300 -300 10000];
        sarsa.ball.pos_max = [300 300 10000];
        sarsa.ball.radius = 100;
        sarsa.ball.vel_min = [0, 0, -1];
        sarsa.ball.vel_max = [0, 0, -1];
        sarsa.ball.acc_min = [0, 0, 0];
        sarsa.ball.acc_max = [0, 0, 0];

        if exist('weights_sarsa.m', 'file')
            load weights_sarsa.mat;
            sarsa.weights = weights_sarsa;
        else
            sarsa.weights = zeros(3, 8);
        end
        setappdata(0, 'sarsa', sarsa);
    else
        if sarsa.currently_working
            fprintf('Another instance of sarsa is already working\n');
            return
        end
    end
    
    %% Run experiments
    for i=1:10
        use_gui = 0;
        sarsa_episode(use_gui);
    end
    sarsa = getappdata(0, 'sarsa');
    sarsa.currently_working = false;
    setappdata(0, 'sarsa', sarsa);
    
    %% Save weights
    sarsa = getappdata(0, 'sarsa');
    weights_sarsa = sarsa.weights;
    save('./weights_sarsa.mat', 'weights_sarsa');
end