function [normalMap] = calculateRGBNormal(LP)
    % Get image dimensions from first image
    firstImg = imread(fullfile(LP.Path, LP.FileNames{1}));
    [height, width, ~] = size(firstImg);
    totalImages = length(LP.FileNames);
    pixelsPerImage = height * width;
    
    % Create light direction matrix L
    L = [LP.X LP.Y LP.Z]; % Each row is a light direction vector
    
    % Calculate pseudo-inverse of light directions
    % (L^T * L)^-1 * L^T
    L_pinv = (L' * L) \ L';
    
    % Display dimensions for debugging
    fprintf('Original L dimensions: %d x %d\n', size(L, 1), size(L, 2));
    fprintf('L_pinv dimensions: %d x %d\n', size(L_pinv, 1), size(L_pinv, 2));
    
    % Initialize the normal map accumulator with zeros
    % Each normal has 3 components (x,y,z)
    N_accum = zeros(3, pixelsPerImage, 'single');
    
    % Create waitbar
    WaitBar = waitbar(0, 'Processing images in batches...');
    
    % Process in pixel batches instead of image batches
    % This processes slices of all images for a subset of pixels
    pixelBatchSize = 500000; % Process this many pixels at a time
    numPixelBatches = ceil(pixelsPerImage / pixelBatchSize);
    
    % Process each batch of pixels
    for pixelBatchIdx = 1:numPixelBatches
        % Calculate pixel range for this batch
        pixelStartIdx = (pixelBatchIdx-1) * pixelBatchSize + 1;
        pixelEndIdx = min(pixelBatchIdx * pixelBatchSize, pixelsPerImage);
        currentPixelCount = pixelEndIdx - pixelStartIdx + 1;
        
        waitbar((pixelBatchIdx-1)/numPixelBatches, WaitBar, ...
                sprintf('Processing pixel batch %d/%d (%d pixels)', ...
                        pixelBatchIdx, numPixelBatches, currentPixelCount));
        
        % Create a smaller intensity matrix just for this batch of pixels
        I_batch = zeros(totalImages, currentPixelCount, 'single');
        
        % Load intensity values for all images, but only for this batch of pixels
        for imgIdx = 1:totalImages
            % Update progress
            if mod(imgIdx, 10) == 0
                waitbar((pixelBatchIdx-1)/numPixelBatches + (imgIdx/totalImages)/numPixelBatches, WaitBar, ...
                    sprintf('Batch %d/%d: Loading image %d/%d', pixelBatchIdx, numPixelBatches, imgIdx, totalImages));
            end
            
            % Read image and convert to grayscale if needed
            img = imread(fullfile(LP.Path, LP.FileNames{imgIdx}));
            if size(img, 3) == 3
                img = rgb2gray(img);
            end
            
            % Convert to single
            img = single(img);
            
            % Reshape image to a row vector
            img_vector = reshape(img, 1, []);
            
            % Store only the pixels for this batch
            I_batch(imgIdx, :) = img_vector(pixelStartIdx:pixelEndIdx);
        end
        
        % Compute normals for this batch of pixels
        waitbar((pixelBatchIdx-0.5)/numPixelBatches, WaitBar, ...
                sprintf('Computing normals for pixel batch %d/%d', pixelBatchIdx, numPixelBatches));
        
        % N_batch = L_pinv * I_batch for this subset of pixels
        N_batch = L_pinv * I_batch;
        
        % Store in the accumulator
        N_accum(:, pixelStartIdx:pixelEndIdx) = N_batch;
        
        % Clear batch data to free memory
        clear I_batch N_batch;
    end
    
    % Reshape normal vectors into the image
    waitbar(0.9, WaitBar, 'Reshaping normal vectors...');
    normalMap = zeros(height, width, 3, 'single');
    normalMap(:,:,1) = reshape(N_accum(1,:), height, width); % X component
    normalMap(:,:,2) = reshape(N_accum(2,:), height, width); % Y component
    normalMap(:,:,3) = reshape(N_accum(3,:), height, width); % Z component
    
    % Clear N_accum to free memory
    clear N_accum;
    
    % Normalize the vectors
    waitbar(0.95, WaitBar, 'Normalizing vectors...');
    norm = sqrt(sum(normalMap.^2, 3));
    normalMap = normalMap ./ repmat(norm, [1 1 3]);
    
    % Convert to visualization range [0, 255]
    waitbar(0.98, WaitBar, 'Converting to display format...');
    normalMap = uint8((normalMap + 1) * 127.5);
    
    close(WaitBar);

%     % Get image dimensions from first image
%     firstImg = imread(fullfile(LP.Path, LP.FileNames{1}));
%     [height, width, ~] = size(firstImg);
%     totalImages = length(LP.FileNames);
%     
%     % Create light direction matrix L
%     L = [LP.X LP.Y LP.Z];  % Each row is a light direction vector
%     
%     % Calculate pseudo-inverse of light directions
%     % (L^T * L)^-1 * L^T
%     L_pinv = (L' * L) \ L';
%     
%     % Initialize arrays for storing intensity values
%     I = zeros(totalImages, height * width, 'uint8');
%     
%     % Show progress for loading images
%     WaitBar = waitbar(0, 'Loading images...');
%     
%     % Load all images and reshape into intensity matrix
%     for k = 1:totalImages
%         % Read image and convert to grayscale if needed
%         img = imread(fullfile(LP.Path, LP.FileNames{k}));
%         if size(img, 3) == 3
%             img = rgb2gray(img);
%         end
%         img = single(img);
%         
%         % Reshape image to column vector and store
%         I(k, :) = reshape(img, 1, []);
%         
%         waitbar(k/totalImages, WaitBar);
%     end
%     
%     waitbar(0, WaitBar, 'Calculating surface normals...');
%     
%     % Calculate normal vectors
%     % N = L_pinv * I for all pixels
%     N = L_pinv * single(I);  % Result is 3 x (height*width)
%     
%     % Reshape result to image dimensions
%     normalMap = zeros(height, width, 3, 'single');
%     normalMap(:,:,1) = reshape(N(1,:), height, width);  % X component
%     normalMap(:,:,2) = reshape(N(2,:), height, width);  % Y component
%     normalMap(:,:,3) = reshape(N(3,:), height, width);  % Z component
%     
%     % Normalize vectors
%     norm = sqrt(sum(normalMap.^2, 3));
%     normalMap = normalMap ./ repmat(norm, [1 1 3]);
%     
%     % Convert to visualization range [0, 255]
%     % Map from [-1,1] to [0,255]
%     normalMap = uint8((normalMap + 1) * 127.5);
%     
%     close(WaitBar);
end