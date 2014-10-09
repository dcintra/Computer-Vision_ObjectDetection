function hough_accumulator = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)


[rows, cols] = size(img);


rhoSpace = (-rho_num_bins:1:rho_num_bins);

thetasToTest = (-(theta_num_bins*pi/180):(pi/theta_num_bins):(theta_num_bins*pi/180));
rhoToTest = numel(rhoSpace);
HoughAccumulator = zeros(rhoToTest,numel(thetasToTest));

%Loop through image
for i=1:rows
    for j=1:cols
    %Loop through theta values
    if(img(i,j)>0)
                
        for t=1:numel(thetasToTest)
            
            theta = thetasToTest(1,t);
            
            r=i*cos(theta)+j*sin(theta);
            rho_index = round(r+numel(rhoSpace)/2);
            
            HoughAccumulator(rho_index,t) = HoughAccumulator(rho_index,t)+1;
                        
        end %end of theta loop
    end %of if
    end %end of col loop
end %end of row loop
 
 normHough = HoughAccumulator./max(HoughAccumulator(:))*255;
 

hough_accumulator = normHough;