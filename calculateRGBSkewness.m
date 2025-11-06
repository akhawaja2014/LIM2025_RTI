function [rawSkewness, norm_Skewness] = calculateRGBSkewness(LP, rgbMean, rgbStd)
    % Get image dimensions from first image
    firstImg = imread(fullfile(LP.Path, LP.FileNames{1}));
    [height, width, ~] = size(firstImg);
    totalImages = length(LP.FileNames);
    
    % Convert inputs to single if they aren't already
    rgbMean = single(rgbMean);
    rgbStd = single(rgbStd);
    
    % Initialize skewness calculation
    rawSkewness = zeros(height, width, 3, 'single');
    sumSkewR = zeros(height, width, 'double');
    sumSkewG = zeros(height, width, 'double');
    sumSkewB = zeros(height, width, 'double');
    
    % Show progress
    WaitBar = waitbar(0, 'Calculating Skewness...');
    
    % Calculate skewness using existing mean and std
    for i = 1:totalImages
        img = single(imread(fullfile(LP.Path, LP.FileNames{i})));
        
        % Calculate ((I - μ)/σ)³ for each channel
        devR = (img(:,:,1) - rgbMean(:,:,1)) ./ rgbStd(:,:,1);
        devG = (img(:,:,2) - rgbMean(:,:,2)) ./ rgbStd(:,:,2);
        devB = (img(:,:,3) - rgbMean(:,:,3)) ./ rgbStd(:,:,3);
        
        sumSkewR = sumSkewR + devR.^3;
        sumSkewG = sumSkewG + devG.^3;
        sumSkewB = sumSkewB + devB.^3;
        
        waitbar(i/totalImages, WaitBar);
    end
    
    % Final skewness calculation
    rawSkewness(:,:,1) = sumSkewR / totalImages;
    rawSkewness(:,:,2) = sumSkewG / totalImages;
    rawSkewness(:,:,3) = sumSkewB / totalImages;


    
    % Convert to visualization range [0, 255]
    for c = 1:3
        channel = rawSkewness(:,:,c);
        minVal = min(channel(:));
        maxVal = max(channel(:));
        norm_Skewness(:,:,c) = (channel - minVal) / (maxVal - minVal) * 255;
    end
    
    norm_Skewness = uint8(norm_Skewness);
    
    close(WaitBar);
end