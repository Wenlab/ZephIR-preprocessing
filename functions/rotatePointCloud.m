function rotatedPoints = rotatePointCloud(points, pivot, angle)
    % points: Nx2 matrix of [x, y] coordinates
    % angle: rotation angle in degrees

    % Convert angle to radians
    angleRad = deg2rad(angle);


    % Create the rotation matrix
    R = [cos(angleRad) -sin(angleRad); sin(angleRad) cos(angleRad)];

    % Translate points to origin (based on pivot)
    translatedPoints = points - pivot;

    % Apply the rotation
    rotatedTranslatedPoints = (R * translatedPoints')';

    % Translate points back to original location
    rotatedPoints = rotatedTranslatedPoints + pivot;
end
