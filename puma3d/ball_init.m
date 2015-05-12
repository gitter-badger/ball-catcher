% Creates a ball with the given parameters of 
function ball_init(pos, r, vel, acc, use_gui,i)
    
%     balls = {};
    if nargin == 0
        pos = rand(1,3);
        r = 40; 
        vel = rand(1,3); 
        acc = [0 0 0];
    elseif nargin == 1
        r = 40; 
        vel = rand(1,3); 
        acc = [0 0 0];
    elseif nargin == 2
        vel = rand(1,3); 
        acc = [0 0 0];
    elseif nargin == 3
        acc = [0 0 0];
    end
    
    if i~=1
        balls = getappdata(0, 'balls');
    end
    
    if nargin ~= 5
        use_gui = true;
    end
    
    new_ball = {};
    new_ball.radius = r;
    
    new_ball.pos = pos;
    new_ball.pos
    new_ball.vel = vel;
    new_ball.acc = acc;
    new_ball.last_updated = clock;
    
    if use_gui
        [sphere_x, sphere_y, sphere_z] = sphere;

        new_ball.handler = surf(sphere_x * new_ball.radius + new_ball.pos(1), ...
            sphere_y * new_ball.radius + new_ball.pos(2), ...
            sphere_z * new_ball.radius + new_ball.pos(3));

    set(new_ball.handler, 'FaceColor', [0 0 1], 'FaceAlpha', 1, ...
        'EdgeColor', 'none', 'LineStyle', 'none', 'FaceLighting', 'phong');
    end    
    balls(i)=new_ball;
   
    
    setappdata(0, 'balls', balls);
end