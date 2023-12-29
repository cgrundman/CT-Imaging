function p = line_integral_xy(data, pixel_size_mm, ...
                                source_x, source_y, ...
                                dexel_x, dexel_y)
% INPUTS
% data - data matrix to simulate ct imaging through
% pixel_size_mm - size of the pixels in mm
% source_x - x coordinate for the x-ray beam source
% source_y - y coordinate for the x-ray beam source
% dexel_x - x coordinate for the x-ray beam detector
% dexel_y - y coordinate for the x-ray beam detector
% 
% OUTPUTS
% p - attenuation signal for the x-ray beam at the detector


% convert the source coordinates from x,y to r,c
source_c = x_to_c(source_x, data, pixel_size_mm);
source_r = y_to_r(source_y, data, pixel_size_mm);

% convert the detector coordinates from x,y to r,c
dexel_c = x_to_c(dexel_x, data, pixel_size_mm);
dexel_r = y_to_r(dexel_y, data, pixel_size_mm);

% perform line integration
p = line_integral_rc(data,source_r, source_c, dexel_r, dexel_c);

% convert to cm
% p = p*pixel_size_mm/10;

end