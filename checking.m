function panorama = ...
    checking(image,image2,featurespoints1,featurespoints2)
    
    buildingScene = imageDatastore({image, image2});
    
    I = im2double(im2gray(readimage(buildingScene,1)));
    % Initialize features for I(1)
    
    [row, col] = find(featurespoints1);
    image_coords = [col, row];
    [features, points] = extractFeatures(I,image_coords);

    numImages = numel(buildingScene.Files);
    tforms(numImages) = projtform2d;

    imageSize = zeros(numImages,2);

    for n = 2:numImages
        pointsPrevious = points;
        featuresPrevious = features;
        I = im2double(im2gray(readimage(buildingScene, n)));
        imageSize(n,:) = size(im2gray(I));

        [row, col] = find(featurespoints2);
        image_coords = [col, row];
        [features, points] = extractFeatures(I,image_coords);

        indexPairs = matchFeatures(features, featuresPrevious, 'Unique', true);

        matchedPoints = points(indexPairs(:,1), :);
        matchedPointsPrev = pointsPrevious(indexPairs(:,2), :);

        tforms(n) = estgeotform2d(matchedPoints, matchedPointsPrev,...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
    
        % Compute T(1) * T(2) * ... * T(n-1) * T(n).
        tforms(n).A = tforms(n-1).A * tforms(n).A; 
    end

    for i = 1:numel(tforms)           
        [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);    
    end

    avgXLim = mean(xlim, 2);
    [~,idx] = sort(avgXLim);
    centerIdx = floor((numel(tforms)+1)/2);
    centerImageIdx = idx(centerIdx);
    
    Tinv = invert(tforms(centerImageIdx));
    for i = 1:numel(tforms)    
        tforms(i).A = Tinv.A * tforms(i).A;
    end

    for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
    end

    maxImageSize = max(imageSize);

    % Find the minimum and maximum output limits. 
    xMin = min([1; xlim(:)]);
    xMax = max([maxImageSize(2); xlim(:)]);

    yMin = min([1; ylim(:)]);
    yMax = max([maxImageSize(1); ylim(:)]);

    % Width and height of panorama.
    width  = round(xMax - xMin);
    height = round(yMax - yMin);

    % Initialize the "empty" panorama.
    panorama = zeros([height width 3], 'like', I);
 
    blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  

    % Create a 2-D spatial reference object defining the size of the panorama.
    xLimits = [xMin xMax];
    yLimits = [yMin yMax];
    panoramaView = imref2d([height width], xLimits, yLimits);

    % Create the panorama.
    for i = 1:numImages
    
        I = im2double((readimage(buildingScene, i)));   
   
        % Transform I into the panorama.
        warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
        
                  
        % Generate a binary mask.    
        mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
    
        % Overlay the warpedImage onto the panorama.

        panorama = step(blender, panorama, warpedImage, mask);
    end

end

    

