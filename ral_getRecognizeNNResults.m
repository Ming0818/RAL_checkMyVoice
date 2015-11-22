function [out,score] = ral_getRecognizeNNResults(p_features)

    % Load mfcc features data and users
    load('ral_settings.mat');
    load(settings.path_user_database);
    load(settings.path_mfcc_database);
    % Prepare the inputs and outputs data
    featuresData = mfcc_features_data;
    featuresSize = size(featuresData, 1);
    nbUsers = size(users, 1);
    listIDsUsers = users(:,2);
    
    nnInputs = [];
    nnOutnputs = [];
    
    for iFeatureData=1:featuresSize
        aFeature = featuresData{iFeatureData,2};
        [dimx,dimy] = size(aFeature);
        nnInputs = [nnInputs aFeature'];
        
        % Create an array of 0
        userFeaturesArray   = zeros(nbUsers, dimx);
        idUserFeature =  featuresData{iFeatureData,1};
        % Associate the feature with the right user :
        % IF the user ID on the feature is the same as the ID in the
        % database line
        % THEN 
        %   the value becomes 1.
        % ELSE 
        %   the value becomes -1.
        % FI
        for listIDsUsers=1:(nbUsers)
            if listIDsUsers==idUserFeature
                userFeaturesArray(listIDsUsers,:) = 1;
            else
                userFeaturesArray(listIDsUsers,:) = -1;
            end
        end
        nnOutnputs = [nnOutnputs userFeaturesArray];
    end
    
    input_vector = p_features';
    %Normalization
    for iFeatureData=1:size(nnInputs,1)
        v = nnInputs(iFeatureData,:);
        v = v(:);
        maxFeatureData = max([v;1]);
        minFeatureData = min([v;-1]);
        nnInputs(iFeatureData,:) = 2*(nnInputs(iFeatureData,:)-minFeatureData)/(maxFeatureData-minFeatureData)-1;
        input_vector(iFeatureData,:) = 2*(input_vector(iFeatureData,:)-minFeatureData)/(maxFeatureData-minFeatureData)-1;
    end
    % Create the neural network
    % Train the neural network
    [network] = nn_create(nnInputs,nnOutnputs);
    % Get the result for the input audio file
    result = sim(network,input_vector);
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
