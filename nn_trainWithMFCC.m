function nn_trainWithMFCC()
%NN_TRAINWITHMFCC Get mfcc and users. Then create the neural networks

    load('ral_settings.mat');
    fprintf('NN : begin train\n');
    % Load mfcc features datas
    load(settings.path_mfcc_database);
    featuresData = mfcc_features_data;
    featuresSize = size(featuresData, 1);
    % Load user database
    load(settings.path_user_database);
    nbUsers = size(users, 1);
    listIDsUsers = users(:,2);

    % Prepare the inputs and outputs data
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

    %Normalization
    nnInputsNormalized = nnInputs;
    for iFeatureData=1:size(nnInputsNormalized,1)
        v = nnInputsNormalized(iFeatureData,:);
        v = v(:);
        maxFeatureData = max([v;1]);
        minFeatureData = min([v;-1]);
        nnInputsNormalized(iFeatureData,:) = 2*(nnInputsNormalized(iFeatureData,:)-minFeatureData)/(maxFeatureData-minFeatureData)-1;
    end

    % Create and train the neural network
    net = nn_create(nnInputsNormalized,nnOutnputs);
    % Save the neural network for futur uses
    save('net.mat', 'net');
    fprintf('NN : end train\n');
end

