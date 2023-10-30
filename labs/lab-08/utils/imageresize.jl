function imresize(img::Array{Float64}, dims)
    # Get dimensions
    w, h = size(img)

    # New dimensions
    new_w, new_h = dims

    # Initialize output
    out = Array{Float64}(undef, new_w, new_h) 

    # Scaling ratios
    wx = (w-1) / (new_w-1)  
    hy = (h-1) / (new_h-1)

    # Loop through pixels
    for i in 1:new_w
        for j in 1:new_h
            # Map to input coordinates
            x = (i-1)*wx + 1
            y = (j-1)*hy + 1
        
            # Get surrounding pixels
            x1 = floor(Int, x); x2 = ceil(Int, x)
            y1 = floor(Int, y); y2 = ceil(Int, y)
        
            # Interpolation weights
            wx1 = (x2 - x) / (x2 - x1)
            wx2 = 1 - wx1
            wy1 = (y2 - y) / (y2 - y1) 
            wy2 = 1 - wy1
        
            # Bilinear interpolation 
            c00 = img[x1,y1]
            c01 = img[x1,y2]
            c10 = img[x2,y1] 
            c11 = img[x2,y2]
            out[i,j] = wx1*wy1*c00 + wx1*wy2*c01 + wx2*wy1*c10 + wx2*wy2*c11
        end
    end
    return out    
end