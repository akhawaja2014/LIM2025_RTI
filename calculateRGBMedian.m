function rgbMedian = calculateRGBMedian(LP)
    % Get image dimensions from first image
    firstImg = imread(fullfile(LP.Path, LP.FileNames{1}));
    [height, width, ~] = size(firstImg);
    totalImages = length(LP.FileNames);
    
    % Initialize output array
    rgbMedian = zeros(height, width, 3, 'single');
    
    % Define chunk size
    chunkSize = 100;  % Process 100 rows at a time
    numChunks = ceil(height/chunkSize);
    
    % Show progress
    WaitBar = waitbar(0, 'Processing RGB images for Median...');
    
    % Process in chunks
    for chunk = 1:numChunks
        % Calculate chunk boundaries
        startRow = (chunk-1)*chunkSize + 1;
        endRow = min(chunk*chunkSize, height);
        chunkRows = endRow - startRow + 1;
        
        % Initialize chunk arrays
        redChunk = zeros(chunkRows, width, totalImages, 'single');
        greenChunk = zeros(chunkRows, width, totalImages, 'single');
        blueChunk = zeros(chunkRows, width, totalImages, 'single');
        
        % Read data for current chunk
        for i = 1:totalImages
            img = single(imread(fullfile(LP.Path, LP.FileNames{i})));
            redChunk(:,:,i) = img(startRow:endRow,:,1);
            greenChunk(:,:,i) = img(startRow:endRow,:,2);
            blueChunk(:,:,i) = img(startRow:endRow,:,3);
            
            % Update progress
            waitbar(((chunk-1)*totalImages + i)/(numChunks*totalImages), WaitBar);
        end
        
        % Calculate median for current chunk
        rgbMedian(startRow:endRow,:,1) = median(redChunk, 3);
        rgbMedian(startRow:endRow,:,2) = median(greenChunk, 3);
        rgbMedian(startRow:endRow,:,3) = median(blueChunk, 3);
        
        % Clear chunk data
        clear redChunk greenChunk blueChunk;
    end
    
    % Convert to uint8
    rgbMedian = uint8(rgbMedian);
    
    close(WaitBar);
end