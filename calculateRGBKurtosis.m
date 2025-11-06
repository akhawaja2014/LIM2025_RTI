function rgbKurtosis = calculateRGBKurtosis(LP, rgbMean, rgbStd)
   % Get image dimensions from first image
   firstImg = imread(fullfile(LP.Path, LP.FileNames{1}));
   [height, width, ~] = size(firstImg);
   totalImages = length(LP.FileNames);
   
   % Convert inputs to single precision
   rgbMean = single(rgbMean);
   rgbStd = single(rgbStd);
   
   % Initialize kurtosis calculation
   rgbKurtosis = zeros(height, width, 3, 'single');
   sumKurtR = zeros(height, width, 'single');
   sumKurtG = zeros(height, width, 'single');
   sumKurtB = zeros(height, width, 'single');
   
   % Show progress
   WaitBar = waitbar(0, 'Calculating Kurtosis...');
   
   % Calculate kurtosis using existing mean and std
   for i = 1:totalImages
       img = single(imread(fullfile(LP.Path, LP.FileNames{i})));
       
       % Calculate ((I - μ)/σ)⁴ for each channel
       devR = (img(:,:,1) - rgbMean(:,:,1)) ./ rgbStd(:,:,1);
       devG = (img(:,:,2) - rgbMean(:,:,2)) ./ rgbStd(:,:,2);
       devB = (img(:,:,3) - rgbMean(:,:,3)) ./ rgbStd(:,:,3);
       
       sumKurtR = sumKurtR + devR.^4;
       sumKurtG = sumKurtG + devG.^4;
       sumKurtB = sumKurtB + devB.^4;
       
       waitbar(i/totalImages, WaitBar);
   end
   
   % Final kurtosis calculation according to the formula
   % κm,n = (1/K)Σ((I - μ)/σ)⁴ - 3
%    rgbKurtosis(:,:,1) = sumKurtR / totalImages - 3;
%    rgbKurtosis(:,:,2) = sumKurtG / totalImages - 3;
%    rgbKurtosis(:,:,3) = sumKurtB / totalImages - 3;
     % Correct sample kurtosis formula
    rgbKurtosis(:,:,1) = (totalImages .* sumKurtR) ./ ((totalImages-1) .* (rgbStd(:,:,1).^4)) - 3;
    rgbKurtosis(:,:,2) = (totalImages .* sumKurtG) ./ ((totalImages-1) .* (rgbStd(:,:,2).^4)) - 3;
    rgbKurtosis(:,:,3) = (totalImages .* sumKurtB) ./ ((totalImages-1) .* (rgbStd(:,:,3).^4)) - 3;
    

   
   % Convert to visualization range [0, 255]
%    for c = 1:3
%        channel = rgbKurtosis(:,:,c);
%        minVal = min(channel(:));
%        maxVal = max(channel(:));
%        rgbKurtosis(:,:,c) = (channel - minVal) / (maxVal - minVal) * 255;
%    end
   
   %rgbKurtosis = uint8(rgbKurtosis);
   
   close(WaitBar);
end