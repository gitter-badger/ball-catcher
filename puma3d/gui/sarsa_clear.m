function sarsa_clear(h, dummy)
  arm = getappdata(0, 'arm');  
    weights_sarsa = zeros(3, 8);
    save('./weights_sarsa.mat', 'weights_sarsa');
    
    sarsa = getappdata(0, 'sarsa');
    sarsa = {};
    setappdata(0, 'sarsa', sarsa);
    load perf;
    perf.no_epi=0;
    perf.sc=zeros(size(arm,2),0);
    save('./perf.mat', 'perf');
end