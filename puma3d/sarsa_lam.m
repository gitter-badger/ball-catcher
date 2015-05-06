function [sp,ap]=sarsa_lam(feat,a,r)
%     e = getappdata(0, 'elig_trace');
    w = getappdata(0, 'thet_sarsa');
    balls = getappdata(0, 'balls');
    e = zeros(3,8);
%     setappdata(0, 'elig_trace', e);
    gamma = 0.8;
    alp = 0.5;
    lam = 5;

    %{
    global nogo;
    if nogo==1
        r=r-0.1;
    end
    %}
    e1 = e(:,a);
    e1(feat==1) = e1(feat==1) + 1;
    e(:, a) = e1;


    del = r - sum(w(:,a) .* feat);
    feat = balls{1}.pos' - arm_tip';
    feat(feat<0) = 0;
    feat(feat>0) = 1;

    q = w' * feat;
    sp = feat;
    clear feat;

    pos = find(q==max(q));

    ap = pos(randi(length(pos)));

    eps = 0.01;
    if rand(1) < eps
        tmp = [1:8]';
        tmp(tmp==ap) = [];
        ap = tmp(randi(length(tmp) ));
    end

    qa = sum(w(:, ap) .* sp);


    del = del + gamma * qa;

    w = w + alp * del * e;
    e = e * gamma * lam;

    setappdata(0, 'elig_trace', e);
    setappdata(0, 'thet_sarsa',w);
end