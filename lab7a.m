categories={'공유','트럼프','톰 크루즈','호날두', '원빈'};
imds=imageDatastore(fullfile('사람',categories), 'LabelSource', 'foldernames');
tbl=countEachLabel(imds)
imds.ReadFcn = @(filename)readAndPreprocessImage(filename);
[trainingSet, testSet] = splitEachLabel(imds, 0.1, 'randomize');

net=helperImportMatConvNet('alex.mat');
featureLayer = 'fc7';
trainingFeatures = activations(net, trainingSet, featureLayer, 'MiniBatchSize', 32, 'OutputAs', 'columns');

% Get training labels from the trainingSet
trainingLabels = trainingSet.Labels;

% Train multiclass SVM classifier using a fast linear solver, and set
% 'ObservationsIn' to 'columns' to match the arrangement used for training
% features.
classifier = fitcecoc(trainingFeatures, trainingLabels, ...
    'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');

% Extract test features using the CNN
testFeatures = activations(net, testSet, featureLayer, 'MiniBatchSize',32);

% Pass CNN image features to trained classifier
predictedLabels = predict(classifier, testFeatures);

% Get the known labels
testLabels = testSet.Labels;

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);

% Convert confusion matrix into percentage form
confMat = bsxfun(@rdivide,confMat,sum(confMat,2))
