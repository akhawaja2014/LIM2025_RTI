function rgbMin = calculateRGBMin(LP)
    % Get image dimensions from first image
    firstImg = imread(fullfile(LP.Path, LP.FileNames{1}));
    [height, width, ~] = size(firstImg);
    totalImages = length(LP.FileNames);
    
    % Initialize min arrays with the first image
    rgbMin = single(firstImg);
    
    % Show progress
    WaitBar = waitbar(0, 'Processing RGB images for Minimum...');
    
    % Process remaining images
    for i = 2:totalImages
        % Read current image
        img = single(imread(fullfile(LP.Path, LP.FileNames{i})));
        
        % Update minimum values for each channel
        rgbMin(:,:,1) = min(rgbMin(:,:,1), img(:,:,1));
        rgbMin(:,:,2) = min(rgbMin(:,:,2), img(:,:,2));
        rgbMin(:,:,3) = min(rgbMin(:,:,3), img(:,:,3));
        
        % Update progress
        waitbar(i/totalImages, WaitBar);
    end
    
    % Normalize each channel separately
    for channel = 1:3
        channelData = rgbMin(:,:,channel);
        minVal = min(channelData(:));
        maxVal = max(channelData(:));
        
        % Normalize to [0, 255] range
        if maxVal > minVal
            rgbMin(:,:,channel) = (channelData - minVal) / (maxVal - minVal) * 255;
        end
    end
    
    % Convert to uint8
    rgbMin = uint8(rgbMin);
    
    close(WaitBar);
end