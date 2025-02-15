function [featureMatch,matchedPoints1,matchedPoints2] = ...
    featuredetector(image,image2,featurespoints1,featurespoints2)
    

    [row, col] = find(featurespoints1);
    image_coords = [col, row];

    [row, col] = find(featurespoints2);
    image_coords2 = [col, row];
    
    [features, vpts1] = extractFeatures(image,image_coords);
    [features2, vpts2] = extractFeatures(image2,image_coords2);

    indexPairs = matchFeatures(features, features2);

    matchedPoints1 = vpts1(indexPairs(:,1),:);
    matchedPoints2 = vpts2(indexPairs(:,2),:);

    
    featureMatch = showMatchedFeatures(image,image2,matchedPoints1,matchedPoints2,"montage");
    
 