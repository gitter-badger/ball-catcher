%Pilami was here
function [rrt,J,numsteps] = build_rrt(start_pt,dim,llimits,ulimits,maxpoints,samplefn,J,k,puddle, successpaths, successreturns)
	
    
	[r,term] = sample_rew(start_pt,puddle);
    rrt = [];
    start_vel = [0;0];
	rrt = struct('state',start_pt,'parent',[],'rew',r, 'vel',start_vel);
    
	termset = [];
    %sample and add maxpoints	]
	term = false;
    pc = 1;
    numsteps = 0;
%	while numel(rrt) < maxpoints
    display(sprintf('Planning!'));
	for z = 1:maxpoints
        numsteps = z;
        if(pc>50)
%               display(sprintf('sampling %d-th point', z));
              pc = 1;
        end
        pc = pc + 1;
        
%       
		%Uniform distribution
		%sample_pt = llimits+(ulimits-llimits).*rand(dim,1);
		param1 = 0;
        param2 = 0;
       %this samples a point in the space!
         prob = rand(1);
        if(prob < 0.7) 
            sample_pt = feval(samplefn,dim,llimits,ulimits,param1,param2);
        else 
            if prob < 0.8
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
        
		x = [rrt.state]; %all points in the rrt!
        %nn-value of sample pt a function!
        samp_val = getNNvalue(sample_pt,1,J);
        %find out the closest of those in the rrt
        knn = 1;
        values = zeros(1,numel(rrt));
        pleaseprint = false;
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
%             display(sprintf('gen printing everything got a non-zero value: %0.5f ',vx));
%             if(vx > 0.1)
%                 display(sprintf('yayy got a non-zero value:%0.5f %0.5f %0.5f', samp_val,values(iter543),vx));
%              pleaseprint = true;
%             end
            
            
        end
        
%         //[values] = arrayfun(getNNvalue, x, repmat(knn,1, numel(x)), repmat(J,size(x)) );
        
        
        
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
        
        
        blax = rrt(nearest).state;
        blay = blax(2);
        blax = blax(1);
%         display(sprintf('the sampled point : %0.5f %0.5f and near: %0.5f %0.5f with ownval: %f and dist: %0.3f', sample_pt(1), sample_pt(2), blax, blay,samp_val, dist) );
%        display(sprintf('nearest point %0.5f %0.5f with value %0.5f maxval: %0.5f',blax, blay,getNNvalue(rrt(nearest).state,2,J ), maxval));
        
		if any(termset == nearest)
			continue;
        end
       
        noissues = true;
%         
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
        disp = [0;0];
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
                tempval = getNNvalue(sample_pt,1,J);
                x = sample_pt(1);
                y = sample_pt(2);
                J(x) = [y;tempval];
                if term
                    
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
            if(disp(1) > 0 ) 
                vreq(1) = u(1) + abs(rand(1))* amax(1);
            else 
                vreq(1) = u(1) + abs(rand(1))*amin(1);
            end
            if( disp(2) > 0)
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
			if term
                return;
				termset(end+1) = numel(rrt);
			end
        end
     
	end
	display(sprintf('Done '));
end



