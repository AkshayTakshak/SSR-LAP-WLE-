function e = WLE(matrix)
    % Weighted Local Energy
    w = (1/16)*[1,2,1;2,4,2;1,2,1]; % Gaussian-like kernel
    e = conv2(matrix.^2, w, 'same'); % local energy map
end

