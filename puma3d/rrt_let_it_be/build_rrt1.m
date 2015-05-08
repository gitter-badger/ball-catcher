%Pilami was here
function [rrt] = build_rrt1(start_pt,dim,llimits,ulimits,maxpoints,samplefn,puddle)
	
	[r,term] = sample_rew(start_pt,puddle);
	rrt = struct('state',start_pt,'parent',[],'rew',r, 'vel' , [0;0]);
	termset = [];
    
    k = zeros(dim,maxpoints);
    k(:,1) = [start_pt];
	
	param1 = 0;
    param2 = 0;
	term = false;
%	while numel(rrt) < maxpoints
	for (z = 1:maxpoints)    
        prob = rand(1);
        if(prob < 0.9) 
            sample_pt = feval(samplefn,dim,llimits,ulimits,param1,param2);
        else 
            sample_pt = [95;95];
        end
        
       
		x = [rrt.state]; %all points in the rrt!
        
        [dist,nearest] = min(sum((x-repmat(sample_pt,1,numel(rrt))).^2));%calc distances to all points in the rrt
        if(nearest > maxpoints)
            display(sprintf('warning warning!! %d', nearest));
        end
		if any(termset == nearest)
			continue;
        end
                
		%extend towards the point
        % If grid world obstacles , use this formulation!!
%         noissues = true;
%         for pud = 1:numel(puddle)
%            if( norm( sample_pt -[puddle(pud).x;puddle(pud).y] ) < puddle(pud).r)
%                noissues = false;
%                break;
%            end
%         end
        
       
        vmax = [1 ;1];
        vmin = [-1 ;-1];
        amax = [1 ;1];
        amin = [-1;-1];
        
        disp = sample_pt - rrt(nearest).state;
        u  = rrt(nearest).vel;
        vreq = disp;
        bad = false;
        if( vreq(1) < vmax(1) && vreq(2) < vmax(2)  && vreq(1) > vmin(1) && vreq(2) > vmin(2) )
            areq = vreq - u;
            if( areq(1) < amax(1) && areq(2) < amax(2) && areq(1) > amin(1) && areq(2) > amin(2))
%                 display('It satisfies!!');
                [r,term] = sample_rew(sample_pt,puddle);
                rrt(end+1) = struct('state',sample_pt,'parent',nearest,'rew',r, 'vel', vreq);
                if term
                    termset(end+1) = numel(rrt);
                end
                bad = false;
            else 
                bad = true;
            end
        else 
            bad = true;
        end
        if(bad)
            vreq = u;
            if(disp(1) > 0 ) 
                vreq(1) = u(1) + abs( rand(1) )* amax(1);
            else 
                vreq(1) = u(1) +abs( rand(1) )* amin(1);
            end
            if( disp(2) > 0)
                vreq(2) = u(2) +abs( rand(1) )* amax(2);
            else
                vreq(2) = u(2) +abs( rand(1) )* amin(2);
            end
            if(vreq(1) > vmax(1) ) 
                vreq(1) = vmax(1);
            end
            if(vreq(2) > vmax(2) ) 
                vreq(2) = vmax(2);
            end
            if(vreq(1) < vmin(1) ) 
                vreq(1) = vmin(1);
            end
            if(vreq(1) < vmin(1) ) 
                vreq(1) = vmin(1);
            end
            
            %vreq is max magnitude of velocity - guide it with delta
            
            
            new_pt = [0;0];
            boo = rrt(nearest).state;
%             new_pt(1) = boo(1) + vreq(1);
%             new_pt(2) = boo(2) + vreq(2);rr
            new_pt(1) = boo(1) + vreq(1)* (sample_pt(1)-boo(1) )/ (dist^0.5);
            new_pt(2) = boo(2) + vreq(2) * (sample_pt(2) - boo(2) )/(dist^0.5);
            
%             new_pt = rrt(nearest).state + vreq .* (sample_pt - rrt(nearest).state )/(dist^0.5);
            
%             display(sprintf('Oh btw new pt: %0.4f %0.4f for old point %0.4f %0.4f vels: %0.4f %0.4f', new_pt(1), new_pt(2), boo(1), boo(2), vreq(1), vreq(2)));
             new_pt = rrt(nearest).state +  (sample_pt - rrt(nearest).state )/(dist^0.5);
%             if(norm( new_pt - [puddle.x; puddle.y]) < puddle.r  )
%                 maxpoints = maxpoints +1;
%                continue;
%             end
			[r,term] = sample_rew(new_pt,puddle);
			rrt(end+1) = struct('state',new_pt,'parent',nearest,'rew',r, 'vel', [0;0]);
			if term
				termset(end+1) = numel(rrt);
			end
        end
	end
	
end