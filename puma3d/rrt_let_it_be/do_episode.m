%Pilami was here
function [rrt,J, numsteps] = do_episode(start_pt,dim,llimits,ulimits,maxpoints,samplefn,J,k,alpha, gamma,  puddle, successpaths, successreturns)
	
    
	[r,term] = sample_rew(start_pt,puddle);
    rrt = [];
    start_vel = [0;0];
	rrt = struct('state',start_pt,'parent',[],'rew',r, 'vel',start_vel);
    
	termset = [];
	term = false;
    pc = 1;
    numsteps = 0;
	for z = 1:maxpoints
        numsteps = z;
        %% Printing to make sure everthing is going on fine!
        if(pc>0)
              display(sprintf('sampling %d-th point', z));
              pc = 1;
        end
        pc = pc + 1;

       %% Sample next point!
        prob = rand(1);
        param1 = 0;
        param2 = 0;
        if(prob < 0.7) 
            sample_pt = feval(samplefn,dim,llimits,ulimits,param1,param2);
        else 
            if prob < 0.85
                getlost = false;
                if numel(successpaths) > 0
                    successpath = successpaths{1};
                    optpath = cell2mat(successpath);
                    len = length(optpath);
                    optidx = floor(z/maxpoints*len);
                    if optidx < 1
                        optidx = 1;
                    else if optidx> len
                            optidx = len;
                        end
                    end
                       optidx = len - optidx + 1;
                       sample_pt = optpath(:, optidx);
                       bla = getNNvalue(sample_pt, 1 , J);
                   getlost = false;
                else 
                    getlost = true;
                end
                if( getlost)
                    sample_pt = [48;48];
                end
            
%             display(sprintf('picked 95 95 '));
            else 
                sample_pt  = [48;48];
            end
        end
        % Sampling Over!
        
        %disp(sprintf('sampled: %0.5f %0.5f', sample_pt(1), sample_pt(2)));
        %% Select action!!
		x = [rrt.state]; %all points in the rrt!
%nn-value of sample pt a function!
        samp_val = getNNvalue(sample_pt,1,J);
%find out the closest of those in the rrt
        knn = 1;
        values = zeros(1,numel(rrt));
        
        
        maxval = 0;
        for iter543=1:numel(rrt)
            vx = getNNvalue(rrt(iter543).state, 1, J);
            
            if abs(vx ) < 0.0001
                vx = 0;
            end
            
            
            if(vx > maxval)
                maxval = vx;
            end
            values(iter543) = vx;
            
        end
        
        
        [dist,nearest] = max((values-repmat(samp_val,1,numel(values))));
        
        % Method 1 to eliminate local minima
        valvect = ( values == values(nearest));
%         for blehi = 1: numel (valvect)
%             if( valvect(blehi) == 1 && rand(1) > 0.5) 
%                 nearest = blehi;
%                 break;
%             end
%         end
        

%Method 2 to eliminate local minima 
        for blehi = 1: numel (valvect)
            if( valvect(blehi) == 1 && norm( rrt(blehi).state - sample_pt   ) < norm(rrt(nearest).state - sample_pt)) 
                nearest = blehi;
            end
        end
        
        J_CURR = values(nearest);
        J_NEXT = 0;
%         display(sprintf('the sampled point : %0.5f %0.5f and near: %0.5f %0.5f with ownval: %f and dist: %0.3f', sample_pt(1), sample_pt(2), blax, blay,samp_val, dist) );
%        display(sprintf('nearest point %0.5f %0.5f with value %0.5f maxval: %0.5f',blax, blay,getNNvalue(rrt(nearest).state,2,J ), maxval));
        
		if any(termset == nearest)
			continue;
        end
       
        
%%For grid world!!        
%         for pud = 1:numel(puddle)
%            if( norm( sample_pt -[puddle(pud).x;puddle(pud).y] ) < puddle(pud).r)
%                noissues = false;
%                break;
%            end
%         end
%         
 

        dist = norm( sample_pt - rrt(nearest).state );
        vmax = [1 ;1];
        vmin = [-1 ;-1];
        amax = [1 ;1];
        amin = [-1;-1];
        displacement = [0;0];
        displac = sample_pt - rrt(nearest).state;
        u  = rrt(nearest).vel;
        vreq = displac;
        bad = false;
        if( vreq(1) < vmax(1) && vreq(2) < vmax(2)  && vreq(1) > vmin(1) && vreq(2) > vmin(2) )
            
            areq = vreq - u;
            
            if( areq(1) < amax(1) && areq(2) < amax(2) && areq(1) > amin(1) && areq(2) > amin(2))
%                 display('It satisfies!!');
                [r,term] = sample_rew(sample_pt,puddle);
                rrt(end+1) = struct('state',sample_pt,'parent',nearest,'rew',r, 'vel', vreq);
                tempval = getNNvalue(sample_pt,1,J);
                J_NEXT = tempval;
                jkey = rrt(nearest).state;
                jval = jkey(2);
                jkey = jkey(1);
                J_CURR = (1 - alpha) * J_CURR + alpha* ( r + gamma * J_NEXT);
                J(jkey) = [jval;J_CURR];
                
                
                
                x = sample_pt(1);
                y = sample_pt(2);
                J(x) = [y;tempval];
                if term
                    numsteps = z;
                    return;
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
            if(displac(1) > 0 ) 
                vreq(1) = u(1) + abs(rand(1))* amax(1);
            else 
                vreq(1) = u(1) + abs(rand(1))*amin(1);
            end
            if( displac(2) > 0)
                vreq(2) = u(2) +abs(rand(1))* amax(2);
            else
                vreq(2) = u(2) +abs(rand(1))* amin(2);
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
            new_pt(1) = boo(1) + vreq(1)* (sample_pt(1)-boo(1) )/ (dist^0.5);
            new_pt(2) = boo(2) + vreq(2) * (sample_pt(2) - boo(2) )/(dist^0.5);
            
%             new_pt = rrt(nearest).state + vreq .* (sample_pt - rrt(nearest).state )/(dist^0.5);
            
%             display(sprintf('Oh btw new pt: %0.4f %0.4f for old point %0.4f %0.4f vels: %0.4f %0.4f', new_pt(1), new_pt(2), boo(1), boo(2), vreq(1), vreq(2)));
             new_pt = rrt(nearest).state +  (sample_pt - rrt(nearest).state )/(dist^0.5);
            
%              if(norm( new_pt - [puddle.x; puddle.y]) < puddle.r  )
%                 maxpoints = maxpoints +1;
%                continue;
%              end
            
			[r,term] = sample_rew(new_pt, puddle);
			rrt(end+1) = struct('state',new_pt,'parent',nearest,'rew',r, 'vel', vreq);
            tempval = getNNvalue(new_pt,1,J);
            x = new_pt(1);
            y = new_pt(2);
            J(x) = [y;tempval];
            J_NEXT = tempval;
            jkey = rrt(nearest).state;
            jval = jkey(2);
            jkey = jkey(1);
            J_CURR = (1 - alpha) * J_CURR + alpha* ( r + gamma * J_NEXT);
            J(jkey) = [jval;J_CURR];
            
			if term
                numsteps = z;
                return;
				termset(end+1) = numel(rrt);
			end
        end
        %Action selection over! Action seleted gives a new_pt that is
        %reached!
        
        %%  Do J Update for the selected actions and the New point!!
        % j curr - nearest
        % j next - newpt
        % Done above for ease of doing!
        
        %% Random Planning!
        
        % Build RRT
          
%           booidx = randi(numel(keys(J)));
%           bookeys = keys(J);
%           start_pt = [0;0];
%           start_pt(1) = bookeys{booidx};
%           start_pt_s = J(start_pt(1));
%           start_pt(2) = start_pt_s(1);
          
         plaidx = randi(numel(rrt));
         start_pt = rrt(plaidx).state;
          
          
          [rrt1,J,blehhh] = build_rrt(start_pt , dim, llimits, ulimits , 40, @uniform_sample, J , 1 , puddle, successpaths, successreturns );
        % Do TDO
          J = mytd0(rrt1, J, alpha ,gamma,knn);
        
     
	end
	
end



