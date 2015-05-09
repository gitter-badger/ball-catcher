function sarsa_start(h, dummy)
    load perf;
    sarsa = getappdata(0, 'sarsa');
    arm = getappdata(0, 'arm');
    'hi'
    t=zeros(3,8);
    weights_sarsa=zeros(size(arm,2),3,8);
    %% Create sarsa variables
    if ( ~exist('sarsa', 'var') ) || isempty(sarsa)
        sarsa = {};
        for i=1:size(arm,2)
        sarsa(i).score = 0;
        sarsa(i).currently_working = true;
        
        sarsa(i).exploration_factor = 0.1;
        sarsa(i).discounting_factor = 0.7;
        sarsa(i).step_size = 0.3;
        sarsa(i).lambda = 0;
        sarsa(i).eligibility_trace = zeros(3, 8);
        sarsa(i).action_error_scale = 0.4;
        sarsa(i).error_to_catch = 100;
        sarsa(i).delta_time = 100;
        
        sarsa(i).ball.pos_min = [-300 -300 10000];
        sarsa(i).ball.pos_max = [300 300 10000];
        sarsa(i).ball.radius = 100;
        sarsa(i).ball.vel_min = [-0.05, -0.05, -0.5];
        sarsa(i).ball.vel_max = [0.05, 0.05, -1.5];
        sarsa(i).ball.acc_min = [0, 0, -1e-3];
        sarsa(i).ball.acc_max = [0, 0, -1e-2];

        sarsa(i).arm.angle_vel_min = 0.1 * [-1, -1, -1, -1, -1, -1]; % rad / sec
        sarsa(i).arm.angle_vel_max = 0.1 * [1, 1, 1, 1, 1, 1];
        
        if exist('weights_sarsa.m', 'file')
            load weights_sarsa.mat;
            sarsa(i).weights = reshape(weights_sarsa(i,:,:),3,8);
            
        else
            sarsa(i).weights = zeros(3, 8);
            
        end
        
        setappdata(0, 'sarsa', sarsa);
        end
        
    else
        if sarsa(1).currently_working
            fprintf('Another instance of sarsa is already working\n');
            return
        end
    
    end
    
    %% Run experiments
    
    for i=1:10
        use_gui = true;
        sarsa_episode(use_gui);
    end
    
    sarsa = getappdata(0, 'sarsa');
    
     load perf;
    perf.no_epi=perf.no_epi+1;
    
        perf.sc(:,perf.no_epi)=[sarsa.score]';
    
    for i=1:size(arm,2)
    sarsa(i).currently_working = false;
    
    setappdata(0, 'sarsa', sarsa);
    
    %% Save weights
    
    sarsa = getappdata(0, 'sarsa');
    weights_sarsa(i,:,:) = sarsa(i).weights;
    end
    for i=1:size(arm,2)
            
        if sum([sarsa.score])==0
        
        t=t+(1/(size(arm,2)))*sarsa(i).weights;
        else
        
        t=t+(sarsa(i).score/sum([sarsa.score]))*sarsa(i).weights;
        end
    end
        
        for i=1:size(arm,2)
        sarsa(i).weights=t;
        
        weights_sarsa(i,:,:) = sarsa(i).weights;
        sarsa(i).score = 0;
        end
        setappdata(0, 'sarsa', sarsa);
    save('./perf.mat', 'perf');
    save('./weights_sarsa.mat', 'weights_sarsa');
end