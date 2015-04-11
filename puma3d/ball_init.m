% Creates a ball with the given parameters of 
function ball_init(x, y, z, vx, vy, vz, ax, ay, az)
    global balls
    
    new_ball = {};
    new_ball.x = x;
    new_ball.y = y;
    new_ball.z = z;
    new_ball.vx = vx;
    new_ball.vy = vy;
    new_ball.vz = vz;
    new_ball.ax = ax;
    new_ball.ay = ay;
    new_ball.az = az;
    
    [sphere_x, sphere_y, sphere_z] = sphere;
    %surf(sphere_x*
    
    balls = [balls new_ball];
end