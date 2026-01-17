function [Kmean, Kgaussian, Kmehlum] = calculateInvariantCurvatures(normalMap, pixelSizeX, pixelSizeY, Kmin, Kmax)
    % If pixel sizes are not provided, default to 1
    if nargin < 2
        pixelSizeX = 1;
        pixelSizeY = 1;
    end
    
    % First get Kmin and Kmax
    % [Kmin, Kmax] = calculateCriticalCurvatures(normalMap, pixelSizeX, pixelSizeY);
    
    % Convert to double and back to original scale (from uint8)
    Kmin = double(Kmin)/127.5 - 1;
    Kmax = double(Kmax)/127.5 - 1;
    
    % Calculate Mean Curvature (Kµ)
    % Kµ[X] = (Kmin[X] + Kmax[X])/2
    Kmean = (Kmin + Kmax)/2;
    
    % Calculate Gaussian Curvature (KG)
    % KG[X] = Kmin[X] × Kmax[X]
    Kgaussian = Kmin .* Kmax;
    
    % Calculate Mehlum Curvature (KM)
    % KM[X] = sqrt(3*(Kµ[X]²/2) - KG[X])
    Kmehlum = sqrt(3 * (Kmean.^2)/2 - Kgaussian);
    
    % Normalize and convert to uint8 for visualization
    function result = normalizeToUint8(data)
        maxVal = max(abs(data(:)));
        if maxVal > 0
            data = data / maxVal;
        end
        result = uint8((data + 1) * 127.5);
    end
    
    Kmean = normalizeToUint8(Kmean);
    Kgaussian = normalizeToUint8(Kgaussian);
    Kmehlum = normalizeToUint8(Kmehlum);
end