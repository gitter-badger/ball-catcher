% This function will animate the Puma 762 robot given joint angles.
% n is number of steps for the animation
% trail is 'y' or 'n' (n = anything else) for leaving a trail.

function arm_animate(a1, a2, a3, a4, a5, a6, a7, a8, a9)
    arm = getappdata(0, 'arm');
    new_theta = zeros(1, 6);
    n = 1;
    trail = 'n';
    use_gui = true;
    
    if nargin == 1 && isequal(size(a1), [1 6])
        new_theta = a1;
        n = 1;
        trail = 'n';
        use_gui = true;
    elseif nargin == 2 && isequal(size(a1), [1 6])
        if ischar(a2)
            new_theta = a1;
            n = 1;
            trail = a2;
            use_gui = true;
        else
            new_theta = a1;
            n = a2;
            trail = 'n';
            use_gui = true;
        end
    elseif nargin == 3 && isequal(size(a1), [1 6]) 
        if ischar(a2)
            new_theta = a1;
            n = a2;
            trail = a3;
            use_gui = true;
        else
            new_theta = a1;
            n = a2;
            trail = 'n';
            use_gui = a3;
        end
    elseif nargin == 8
        new_theta = [a1, a2, a3, a4, a5, a6];
        n = a7;
        trail = a8;
        use_gui = true;
    elseif nargin == 9
        new_theta = [a1, a2, a3, a4, a5, a6];
        n = a7;
        trail = a8;
        use_gui = a9;
    else
        fprintf('Error : Invalid number of arguments in arm_animate\n');
        return;
    end
    
    theta_chain = [linspace(arm.theta(1), new_theta(1), n); ...
        linspace(arm.theta(2), new_theta(2), n); ...
        linspace(arm.theta(3), new_theta(3), n); ...
        linspace(arm.theta(4), new_theta(4), n); ...
    	linspace(arm.theta(5), new_theta(5), n); ...
    	linspace(arm.theta(6), new_theta(6), n); ];

    n = size(theta_chain, 2); % change n ... just in case.
    
    for i = 2:n
        % Forward Kinematics
        %
        arm_calc_links(theta_chain(:, i)', trail);
        
        if use_gui
            arm_draw;
        end
        arm = getappdata(0, 'arm');
        
        drawnow
        arm.theta = theta_chain(:, i)';
        setappdata(0, 'arm', arm); % Update arm so everyone can use it
    end
    
    % setappdata(0, 'arm', arm);
end