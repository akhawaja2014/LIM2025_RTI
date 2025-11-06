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
   
       % Normalize each channel separately
    for channel = 1:3
        channelData = rgbMax(:,:,channel);
        minVal = min(channelData(:));
        maxVal = max(channelData(:));
        
        % Normalize to [0, 255] range
        if maxVal > minVal
            rgbMax(:,:,channel) = (channelData - minVal) / (maxVal - minVal) * 255;
        end
    end


   % Convert back to uint8
   rgbMax = uint8(rgbMax);
   
   close(WaitBar);
end