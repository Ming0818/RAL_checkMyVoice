function [out,score] = ral_getRecognizeNNResults(p_features)

    load('ral_settings.mat');
    % Load mfcc features datas
    load(settings.path_mfcc_database);
    featuresData = mfcc_features_data;
    featuresSize = size(featuresData, 1);
    % Load user database
    load(settings.path_user_database);
    listIDsUsers = users(:,2);
    
    nnInputs = [];
    for iFeatureData=1:featuresSize
        aFeature = featuresData{iFeatureData,2};
        [dimx,dimy] = size(aFeature);
        nnInputs = [nnInputs aFeature'];
    end
    
    input_vector = p_features';
    %Normalization
    for iFeatureData=1:size(nnInputs,1)
        v = nnInputs(iFeatureData,:);
        v = v(:);
        maxFeatureData = max([v;1]);
        minFeatureData = min([v;-1]);
        input_vector(iFeatureData,:) = 2*(input_vector(iFeatureData,:)-minFeatureData)/(maxFeatureData-minFeatureData)-1;
    end
    
    % Get the result for the input audio file
    load net;
    % result = sim(network,input_vector);
    result = sim(net,input_vector);
    [dimx,dimy] = size(result);
    vector = zeros(dimx,1);
    % For each user ID, we keep his best score
    for listIDsUsers=1:dimy
        listUserResults = result(:,listIDsUsers);
        [value,position] = max(listUserResults);
        vector(position) = vector(position)+1;
    end
    % Return the user ID with the best score
    [value,position] = max(vector);
    out = position;
    score = value/dimy;
end
