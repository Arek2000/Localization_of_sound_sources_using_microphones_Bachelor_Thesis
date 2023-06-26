function DOADisplay(angles)         %angle in degrees
    x = 0;                          % X coordinate of arrow start
    y = 0;                          % Y coordinate of arrow start
    L = 2;                          % Length of arrow
    xEnds = [];
    yEnds = [];
    for angle=1:length(angles)  
        theta = deg2rad(angles(angle));             % Angle of arrow, from x-axis
        xEnds = [xEnds, x+L*cos(theta)];            % X coordinate of arrow end
        yEnds = [yEnds, y+L*sin(theta)];            % Y coordinate of arrow end
    end
    Z = compass(xEnds, yEnds);
    colors = get(0,'DefaultAxesColorOrder');
    for i=1:length(Z)
        set(Z(i),'color',colors(mod(i-1,length(colors))+1,:),'linewidth',2)
    end
    view(90,90);
end