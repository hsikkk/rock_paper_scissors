while 1
    im=snapshot(cam);

    % Pre-process the images as required for the CNN
    img = imresize(im, [227 227]);

    % Extract image features using the CNN
    imageFeatures = activations(net, img, featureLayer);
    % Make a prediction using the classifier
    [label,scores] = predict(classifier, imageFeatures);

    imshow(im)
    text(30,30,sprintf('%s', label))
    text(30,60,sprintf('%f ',scores))
    drawnow
end
