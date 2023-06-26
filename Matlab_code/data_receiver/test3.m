%DOADisplay(-45);

%u = [5 3 -4 -3 5];
%v = [1 5 3 -2 -6];
%compass(u,v)
%disp(acosd(-0.45));

display_measurements([[1 2 3 4 5 6 7 8] [8 7 6 5 4 3 2 1]]);

function display_measurements(measurements)
    clf;
    if length(measurements) == 1
        plot(measurements);
    else
    plot(measurements(1));
    hold on;
    for i=2:length(measurements)
        plot(measurements(i));
    end
    %legend('1','2','3');
    hold off;
    end
end

function DOADisplay(angle) %angle in degrees
    x = 0;                          % X coordinate of arrow start
    y = 0;                          % Y coordinate of arrow start
    theta = deg2rad(-90 - angle);   % Angle of arrow, from x-axis
    L = 2;                          % Length of arrow
    xEnd = x+L*cos(theta);          % X coordinate of arrow end
    yEnd = y+L*sin(theta);          % Y coordinate of arrow end
    points = linspace(0, theta);    % 100 points from 0 to theta
    xCurve = x+(L/2).*cos(points);  % X coordinates of curve
    yCurve = y+(L/2).*sin(points);  % Y coordinates of curve
    clf;
    %plot(x+[-L L], [y y], '--k');   % Plot dashed line
    %hold on;                        % Add subsequent plots to the current axes
    %axis([x+[-L L] y+[-L L]]);      % Set axis limits
    %axis equal;                     % Make tick increments of each axis equal
    compass(xEnd, yEnd);
    view(90,90);
    %quiver(x, y, xEnd - x, yEnd - y, 0);    % Plot arrow
    %plot(xCurve, yCurve, '-k');     % Plot curve
    %plot(x, y, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'w');  % Plot point
end