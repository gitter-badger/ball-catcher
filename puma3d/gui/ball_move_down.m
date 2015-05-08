function ball_move_down(h, dummy)
    sarsa = getappdata(0, 'sarsa');
    stats = getappdata(0, 'stats');
    score=stats.score;
    balls = getappdata(0, 'balls');
    lrn_sa = sarsa.step_size;
    eps = sarsa.exploration_factor;

    eps1 = 200;


<<<<<<< Updated upstream
    cur_sc=get(score.edit,'string');
    cur_sc=str2double(cur_sc);

=======
threshold_to_catch=200;
>>>>>>> Stashed changes

    thet = sarsa.weights;


<<<<<<< Updated upstream
    feat=[balls{1}.pos'-arm_tip'];
    feat(feat<0)=0;
    feat(feat>0)=1;
=======
w = getappdata(0, 'thet_sarsa');


feat=[balls{1}.pos'-arm_tip'];
feat(feat<0)=0;
feat(feat>0)=1;
>>>>>>> Stashed changes

q=w'*feat;
sp=feat;
clear feat;


pos=find(q==max(q));
ap=pos(randi(length(pos)));
if rand(1)<eps
    tmp=[1:8]';
    tmp(tmp==ap)=[];
    ap=tmp(randi(length(tmp) ));
end





ball_caught=0;

    while balls{1}.pos(3)>=-1120
                
        if ball_caught==1
            pause(0.5);
            break;
        end        
        
%        ball_caught=0;


        if lrn_sa==1
            [feat,a]=exec_action_sarsa(sp,ap);
        else
            [feat,a]=exec_action_sarsa;
        end
        
        
        ball_loop(100);
        %pause(0.01);
        
        balls = getappdata(0, 'balls');
        
        at=arm_tip;
        ang1=atan(sqrt(balls{1}.pos(1).^2+balls{1}.pos(2).^2)/balls{1}.pos(3));
        ang2=atan(sqrt(at(1).^2+at(2).^2)/at(3));
        
<<<<<<< Updated upstream
        if pdist2(balls{1}.pos,arm_tip)<eps1
=======
        if pdist2(balls{1}.pos,arm_tip)<threshold_to_catch
            
>>>>>>> Stashed changes
            cur_sc=cur_sc+1;
            ball_caught=1;
            fprintf('Ball caught !\n');
        end
        if lrn_sa==1
            
            if (balls{1}.pos(3)>=-1120) || (ball_caught==1)
                term=1;
            else
                term=0;
            end
            r_1=-1*abs(ang1-ang2);
            [sp,ap]=sarsa_lam(feat,a,ball_caught*20+r_1*10,term);
        end
    end
    
    set(score.edit, 'string',cur_sc);
    setappdata(0, 'score', score);
  delete_balls;
    
end