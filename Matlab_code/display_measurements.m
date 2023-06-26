function display_measurements(ch1, ch2, ch3)
    clf;
    plot(ch1);
    hold on;
    plot(ch2);
    plot(ch3);
    legend('1','2','3');
    hold off;
end