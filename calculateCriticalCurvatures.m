function [Kmin, Kmax] = calculateCriticalCurvatures(normalMap, pixelSizeX, pixelSizeY, Kxx, Kyy, Kxy)
    % If pixel sizes are not provided, default to 1
    if nargin < 2
        pixelSizeX = 1;
        pixelSizeY = 1;
    end
    
    % First get the second derivatives
    %[Kxx, Kyy, Kxy] = calculateDoubleDerivatives(normalMap, pixelSizeX, pixelSizeY);
    
    % Convert to double for calculations
    Kxx = double(Kxx);
    Kyy = double(Kyy);
    Kxy = double(Kxy);
    
    % Calculate eigenvalues at each point (principal curvatures)
    Kmin = zeros(size(Kxx), 'single');
    Kmax = zeros(size(Kxx), 'single');
    
    for i = 1:size(Kxx,1)
        for j = 1:size(Kxx,2)
            % Create curvature matrix for this point
            H = [Kxx(i,j) Kxy(i,j);
                 Kxy(i,j) Kyy(i,j)];
            
            % Get eigenvalues
            eigenvals = eig(H);
            
            % Assign min and max curvatures
            Kmin(i,j) = min(eigenvals);
            Kmax(i,j) = max(eigenvals);
        end
    end
    
    % Convert to visualization range [0, 255]
    function result = visualizeCurvature(data)
        maxVal = max(abs(data(:)));
        if maxVal > 0
            data = data / maxVal;
        end
        %result = uint16((data + 1) * 32767.5);
        %initialVis = uint8((data + 1) * 127.5);
    
        result = uint8((data + 1) * 127.5);
    end

    Kmin = visualizeCurvature(Kmin);
    Kmax = visualizeCurvature(Kmax);


end