function rgbStd = calculateRGBStd(LP)
    % Get image dimensions from first image
    firstImg = imread(fullfile(LP.Path, LP.FileNames{1}));
    [height, width, ~] = size(firstImg);
    totalImages = length(LP.FileNames);
    
    % Initialize sum and sum of squares arrays using single precision
    redSum = zeros(height, width, 'single');
    greenSum = zeros(height, width, 'single');
    blueSum = zeros(height, width, 'single');
    
    redSumSq = zeros(height, width, 'single');
    greenSumSq = zeros(height, width, 'single');
    blueSumSq = zeros(height, width, 'single');
    
    % Show progress
    WaitBar = waitbar(0, 'Processing RGB images for StD...');
    
    % First pass: calculate sums and sum of squares
    for i = 1:totalImages
        % Read current image and convert to single
        img = single(imread(fullfile(LP.Path, LP.FileNames{i})));
        
        % Accumulate sums and squared sums for each channel
        redSum = redSum + img(:,:,1);
        greenSum = greenSum + img(:,:,2);
        blueSum = blueSum + img(:,:,3);
        
        redSumSq = redSumSq + img(:,:,1).^2;
        greenSumSq = greenSumSq + img(:,:,2).^2;
        blueSumSq = blueSumSq + img(:,:,3).^2;
        
        % Update progress
        waitbar(i/totalImages, WaitBar);
    end
    
    % Calculate standard deviations
    rgbStd = zeros(height, width, 3, 'single');
    rgbStd(:,:,1) = sqrt((redSumSq - (redSum.^2)/totalImages) / (totalImages - 1));
    rgbStd(:,:,2) = sqrt((greenSumSq - (greenSum.^2)/totalImages) / (totalImages - 1));
    rgbStd(:,:,3) = sqrt((blueSumSq - (blueSum.^2)/totalImages) / (totalImages - 1));

    % Normalize each channel separately
    for channel = 1:3
        channelData = rgbStd(:,:,channel);
        minVal = min(channelData(:));
        maxVal = max(channelData(:));
        
        % Normalize to [0, 255] range
        if maxVal > minVal
            rgbStd(:,:,channel) = (channelData - minVal) / (maxVal - minVal) * 255;
        end
    end
    
    
    % Convert back to uint8
    rgbStd = uint8(rgbStd);
    
    close(WaitBar);
end