function [Normal] = normalRTI(RTI,LP)

%   Positions = [LP.X LP.Y LP.Z];
%   Positions_inv = (Positions' * Positions)\Positions';
%   Normal = reshape((Positions_inv * reshape(RTI.Data, RTI.DataSize(1) * RTI.DataSize(2), [])')', RTI.DataSize(1), RTI.DataSize(2), []);
%   
%   Norm = sqrt(Normal(:,:,1) .* Normal(:,:,1) + Normal(:,:,2) .* Normal(:,:,2) + Normal(:,:,3) .* Normal(:,:,3));
%   Normal = Normal ./ Norm;
%         



    % Get data dimensions directly from RTI.Data
    [rows, cols, ~] = size(RTI.Data);
    
    % Create positions matrix from light positions
    Positions = [LP.X LP.Y LP.Z];
    
    % Calculate pseudo-inverse of positions
    Positions_inv = (Positions' * Positions)\Positions';
    
    % Reshape data and calculate normals
    Normal = reshape((Positions_inv * reshape(RTI.Data, rows * cols, [])')', rows, cols, []);
    
    % Calculate normalization factor
    Norm = sqrt(Normal(:,:,1).^2 + Normal(:,:,2).^2 + Normal(:,:,3).^2);
    
    % Normalize the vectors
    Normal = Normal ./ Norm;

end