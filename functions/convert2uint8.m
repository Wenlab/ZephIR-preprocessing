function img_out = convert2uint8(img_in)
    img_in = double(img_in);
    max_val = max(img_in(:)); % find the maximum intensity in the image
    img_in = img_in / max_val; % normalize to [0, 1]
    img_out = im2uint8(img_in); % convert to uint8
end

