function [] = plot2D(x1_l,x1_u,x2_l,x2_u)

    % design variables at mesh points
    [x1,x2] = meshgrid(x1_l:(x1_u-x1_l)/500:x1_u,x2_l:(x2_u-x2_l)/500:x2_u);
    
    f = 100*((x2-(x1.^2))).^2 + (1-x1).^2;
    
    figure(1)
    a = [0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512];
    [C,h] = contour(x1,x2,f,a, 'k');
    xlabel('x1');
    ylabel('x2');
    hold on;
       
end