function [rew,term] = sample_rew(state,puddle)
	rew = 0;
	term = false;
	if state(1) > 45 && state(2) > 45
		rew = 100;
%         disp(sprintf('yayy got a final state!! xD'));
		term = true;
    end
    for pud= 1:numel(puddle)
        if( norm( state -[puddle(pud).x;puddle(pud).y] ) < puddle(pud).r)
            rew = - norm( state - [puddle(pud).x ; puddle(pud).y] );
%             display(sprintf('you re in deep shit!'));
            return;
        end
    end
    

end