
if handles.vert_plot_check==1.0
% Create figure
figure6 = figure('Name','TILT','NumberTitle','on');

% Create subplot
subplot1 = subplot(2,1,1,'Parent',figure6,'YGrid','on','XGrid','on',...
    'FontSize',12);
box('on');
hold('all');


% Create title
title('Verticality Perception','FontSize',14);

plot1 = plot(handles.t_s,handles.plot_SVV,'LineWidth',2);
set(plot1(2),'DisplayName','SVV','Color','r');
set(plot1(1),'DisplayName','Actual Vertical','Color','b');


% Create xlabel
xlabel('Time (sec)','FontSize',12);

% Create ylabel
ylabel('Deg','FontSize',12);

% Create subplot
subplot2 = subplot(2,1,2,'Parent',figure6,'YGrid','on','XGrid','on',...
    'FontSize',12);

box('on');
hold('all');

% Create title
title('Tilt Angle Based on Gravity','FontSize',14);


plot2 = plot(handles.t_s,handles.plot_tilt,'LineWidth',2);
set(plot2(1),'DisplayName','Tilt Angle','Color','r');
set(plot2(2),'DisplayName','Estimated Tilt Angle','Color','b');


% Create xlabel
xlabel('Time (sec)','FontSize',12);

% Create ylabel
ylabel('Deg','FontSize',12);



% Create legend
legend1 = legend(subplot1,'show');


% Create legend
legend2 = legend(subplot2,'show');

end