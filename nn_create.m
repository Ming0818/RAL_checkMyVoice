function [network] = nn_create(p_inputs,p_outputs)

    load('ral_settings.mat');
    % network.trainParam.goal   = 0.000000001;    
    % network.trainParam.show   = 100;      
    % network.trainParam.epochs = 1000;  
    % network.trainParam.mc     = 0.95;
    % network.trainParam.showWindow=true; 
    
    network = feedforwardnet(30,'trainlm');
    network.trainParam.goal   = settings.net_trainParam_goal;
    network.trainParam.show   = settings.net_trainParam_show;
    network.trainParam.epochs = settings.net_trainParam_epochs;
    network.trainParam.mc     = settings.net_trainParam_mc;
    network.trainParam.showWindow = settings.debug_mode;
    
    network = train(network, p_inputs, p_outputs);
end