function rgbMean = calculateRGBMean(LP)
    % Get image dimensions from first image
    firstImg = imread(fullfile(LP.Path, LP.FileNames{1}));
    [height, width, ~] = size(firstImg);
    totalImages = length(LP.FileNames);
    
    % Initialize sum arrays
    redSum = zeros(height, width, 'double');
    greenSum = zeros(height, width, 'double');
    blueSum = zeros(height, width, 'double');
    
    % Show progress
    WaitBar = waitbar(0, 'Processing RGB images...');  % Changed from waitbar to WaitBar
    
    % Process one image at a time
    for i = 1:totalImages
        % Read current image
        img = imread(fullfile(LP.Path, LP.FileNames{i}));
        
        % Accumulate sums for each channel
        redSum = redSum + double(img(:,:,1));
        greenSum = greenSum + double(img(:,:,2));
        blueSum = blueSum + double(img(:,:,3));
        
        % Update progress
        waitbar(i/totalImages, WaitBar);  % Changed to use WaitBar
    end
    
    % Calculate means
    rgbMean = zeros(height, width, 3);
    rgbMean(:,:,1) = redSum / totalImages;
    rgbMean(:,:,2) = greenSum / totalImages;
    rgbMean(:,:,3) = blueSum / totalImages;

        % Normalize each channel separately
    for channel = 1:3
        channelData = rgbMean(:,:,channel);
        minVal = min(channelData(:));
        maxVal = max(channelData(:));
        
        % Normalize to [0, 255] range
        if maxVal > minVal
            rgbMean(:,:,channel) = (channelData - minVal) / (maxVal - minVal) * 255;
        end
    end
    
    % Convert back to uint8
    rgbMean = uint8(rgbMean);
    
    close(WaitBar);  % Changed to WaitBar
end