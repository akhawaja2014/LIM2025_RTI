function rgbMax = calculateRGBMax(LP)
    % Get image dimensions from first image
    firstImg = imread(fullfile(LP.Path, LP.FileNames{1}));
    [height, width, ~] = size(firstImg);
    totalImages = length(LP.FileNames);
    
    % Initialize max arrays with the first image
    rgbMax = single(firstImg);
    
    % Show progress
    WaitBar = waitbar(0, 'Processing RGB images for Maximum...');
    
    % Process remaining images
    for i = 2:totalImages
        % Read current image
        img = single(imread(fullfile(LP.Path, LP.FileNames{i})));
        
        % Update maximum values for each channel
        rgbMax(:,:,1) = max(rgbMax(:,:,1), img(:,:,1));
        rgbMax(:,:,2) = max(rgbMax(:,:,2), img(:,:,2));
        rgbMax(:,:,3) = max(rgbMax(:,:,3), img(:,:,3));
        
        % Update progress
        waitbar(i/totalImages, WaitBar);
    end
    
    % Normalize each channel separately to 95%
    for channel = 1:3
        channelData = rgbMax(:,:,channel);
        
        % Get the values at 2.5% and 97.5% percentiles (95% range)
        sortedValues = sort(channelData(:));
        numPixels = numel(sortedValues);
        lowIdx = max(1, round(0.025 * numPixels));
        highIdx = min(numPixels, round(0.975 * numPixels));
        
        lowVal = sortedValues(lowIdx);
        highVal = sortedValues(highIdx);
        
        % Normalize to [0, 255] range using the 95% range
        if highVal > lowVal
            % Apply normalization
            normalizedData = (channelData - lowVal) / (highVal - lowVal) * 255;
            
            % Clip values to [0, 255]
            normalizedData(normalizedData < 0) = 0;
            normalizedData(normalizedData > 255) = 255;
            
            rgbMax(:,:,channel) = normalizedData;
        end
    end
    
    % Convert to uint8
    rgbMax = uint8(rgbMax);
    close(WaitBar);
end