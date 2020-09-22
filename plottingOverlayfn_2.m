
function plottingOverlayfn_2(handles, handles2)

close all

assert(length(handles.t_s) == length(handles2.t_s), 'inputs are not of same duration')

assert(handles.omega_head(15,1) == handles2.omega_head(15,1), 'not same input motion')

%% User Inputs
% 1 means it will be plotted. 0 means it will not.
handles.gif_plot_check = 1;
handles.naso_checkbox = 1;
handles.inter_checkbox = 1;
handles.dorso_checkbox = 1;
handles.scale_checkbox = 1;
handles.lin_plot_check = 1;
handles.ang_plot_check = 1;
handles.gravity_plot_check = 1;
handles.cue_plot_check = 1;
handles.position_plot_check = 1;
handles.vert_plot_check = 1;
handles.euler_plot_check = 1;
handles.lin_vel_plot_check = 1;

% ************************************* PLOTTING ***********************************
if handles.gif_plot_check==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
     
     num_col = 0;
     x_on = 0;
     y_on = 0;
     z_on = 0;
     to_plot_act = zeros(length(handles.t_s),1);
     to_plot_est = zeros(length(handles.t_s),1);
     to_plot_act2 = zeros(length(handles2.t_s),1);
     to_plot_est2 = zeros(length(handles2.t_s),1);
     
    if handles.naso_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.gif_head(:,1);
        to_plot_est(:,num_col) = handles.gif_est(:,1);
        to_plot_act2(:,num_col) = handles2.gif_head(:,1);
        to_plot_est2(:,num_col) = handles2.gif_est(:,1);
        x_on = 1;
    end
    
    if handles.inter_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.gif_head(:,2);
        to_plot_est(:,num_col) = handles.gif_est(:,2);
        to_plot_act2(:,num_col) = handles2.gif_head(:,2);
        to_plot_est2(:,num_col) = handles2.gif_est(:,2);
        y_on = 1;
    end
    
    if handles.dorso_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.gif_head(:,3);
        to_plot_est(:,num_col) = handles.gif_est(:,3);
        to_plot_act2(:,num_col) = handles2.gif_head(:,3);
        to_plot_est2(:,num_col) = handles2.gif_est(:,3);
        z_on = 1;
    end
    
to_plot_est_all = [to_plot_est to_plot_est2];    
       
figure1 = figure('Name','GIF','NumberTitle','on');

% Create subplot 1
subplot1 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if handles.scale_checkbox==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
    
    if max(max(abs(to_plot_act))) > max(max(abs(to_plot_est)))
        y_high = max(max(abs(to_plot_act))) + 0.1*max(max(abs(to_plot_act)));
        y_low = -1.0*y_high;
    else
        y_high = max(max(abs(to_plot_est_all))) + 0.1*max(max(abs(to_plot_est_all)));
        y_low = -1.0*y_high;
    end

    if y_low == y_high
        y_low = y_low - 1;
        y_high = y_high + 1;
    end
    
    ylim([y_low y_high]);
end



box('on');
hold('all');

title('GIF','FontSize',14);

plot1 = plot(handles.t_s,to_plot_act, 'LineWidth',2);

if x_on == 1
    set(plot1(1),'DisplayName','G_x');
    if y_on == 1
        set(plot1(2),'DisplayName','G_y');
        if z_on == 1
            set(plot1(3),'DisplayName','G_z');
        end
    else
        if z_on == 1
            set(plot1(2),'DisplayName','G_z');
        end
    end
else
    if y_on == 1
        set(plot1(1),'DisplayName','G_y');
        if z_on == 1
            set(plot1(2),'DisplayName','G_z');
        end
    else
        if z_on == 1
            set(plot1(1),'DisplayName','G_z');
        end
    end
end


xlabel('Time (sec)','FontSize',12);
ylabel('G''s','FontSize',12);

% Create subplot 2
subplot2 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if handles.scale_checkbox==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
       ylim([y_low y_high]);
end

box('on');
hold('all');


title('Estimated GIF','FontSize',14);
plot2 = plot(handles.t_s,to_plot_est_all,'LineWidth',2);

if x_on == 1
    set(plot2(1),'DisplayName','G_xest');
    set(plot2(4),'DisplayName','G_xest 2');
    if y_on == 1
        set(plot2(2),'DisplayName','G_yest');
        set(plot2(5),'DisplayName','G_yest 2');
        if z_on == 1
            set(plot2(3),'DisplayName','G_zest');
            set(plot2(6),'DisplayName','G_zest 2');
        end
    else
        if z_on == 1
            set(plot2(2),'DisplayName','G_zest');
            set(plot2(5),'DisplayName','G_zest 2');
        end
    end
else
    if y_on == 1
        set(plot2(1),'DisplayName','G_yest');
        set(plot2(4),'DisplayName','G_yest 2');
        if z_on == 1
            set(plot2(2),'DisplayName','G_zest');
            set(plot2(5),'DisplayName','G_zest 2');
        end
    else
        if z_on == 1
            set(plot2(1),'DisplayName','G_zest');
            set(plot2(4),'DisplayName','G_zest 2');
        end
    end
end

xlabel('Time (sec)','FontSize',12);
ylabel('G''s','FontSize',12);


legend1 = legend(subplot1,'show');
set(legend1,'Position',[0.8131 0.7879 0.05682 0.123]);
legend2 = legend(subplot2,'show');
set(legend2,'Position',[0.8078 0.3143 0.07273 0.123]);

end








if handles.lin_plot_check==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
     
     num_col = 0;
     x_on = 0;
     y_on = 0;
     z_on = 0;
     to_plot_act = zeros(length(handles.t_s),1);
     to_plot_est = zeros(length(handles.t_s),1);
     to_plot_est2 = zeros(length(handles2.t_s),1);
     
    if handles.naso_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.a_head(:,1);
        to_plot_est(:,num_col) = handles.a_est(:,1);
        to_plot_est2(:,num_col) = handles2.a_est(:,1);
        x_on = 1;
    end
    
    if handles.inter_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.a_head(:,2);
        to_plot_est(:,num_col) = handles.a_est(:,2);
        to_plot_est2(:,num_col) = handles2.a_est(:,2);
        y_on = 1;
    end
    
    if handles.dorso_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.a_head(:,3);
        to_plot_est(:,num_col) = handles.a_est(:,3);
        to_plot_est2(:,num_col) = handles2.a_est(:,3);
        z_on = 1;
    end
    
    
to_plot_est_all = [to_plot_est to_plot_est2];
        
figure1 = figure('Name','ACC','NumberTitle','on');

% Create subplot 1
subplot1 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if handles.scale_checkbox==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
    
    if max(max(abs(to_plot_act))) > max(max(abs(to_plot_est)))
        y_high = max(max(abs(to_plot_act))) + 0.1*max(max(abs(to_plot_act)));
        y_low = -1.0*y_high;
    else
        y_high = max(max(abs(to_plot_est_all))) + 0.1*max(max(abs(to_plot_est_all)));
        y_low = -1.0*y_high;
    end

    if y_low == y_high
        y_low = y_low - 1;
        y_high = y_high + 1;
    end
    
    ylim([y_low y_high]);
end



box('on');
hold('all');

title('Acceleration','FontSize',14);

plot1 = plot(handles.t_s,to_plot_act,'LineWidth',2);

if x_on == 1
    set(plot1(1),'DisplayName','A_x');
    if y_on == 1
        set(plot1(2),'DisplayName','A_y');
        if z_on == 1
            set(plot1(3),'DisplayName','A_z');
        end
    else
        if z_on == 1
            set(plot1(2),'DisplayName','A_z');
        end
    end
else
    if y_on == 1
        set(plot1(1),'DisplayName','A_y');
        if z_on == 1
            set(plot1(2),'DisplayName','A_z');
        end
    else
        if z_on == 1
            set(plot1(1),'DisplayName','A_z');
        end
    end
end


xlabel('Time (sec)','FontSize',12);
ylabel('G''s','FontSize',12);

% Create subplot 2
subplot2 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if handles.scale_checkbox==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
       ylim([y_low y_high]);
end

box('on');
hold('all');


title('Estimated Acceleration','FontSize',14);
plot2 = plot(handles.t_s,to_plot_est_all,'LineWidth',2);

if x_on == 1
    set(plot2(1),'DisplayName','A_xest');
    set(plot2(4),'DisplayName','A_xest 2');
    if y_on == 1
        set(plot2(2),'DisplayName','A_yest');
        set(plot2(5),'DisplayName','A_yest 2');
        if z_on == 1
            set(plot2(3),'DisplayName','A_zest');
            set(plot2(6),'DisplayName','A_zest 2');
        end
    else
        if z_on == 1
            set(plot2(2),'DisplayName','A_zest');
            set(plot2(5),'DisplayName','A_zest 2');
        end
    end
else
    if y_on == 1
        set(plot2(1),'DisplayName','A_yest');
        set(plot2(4),'DisplayName','A_yest 2');
        if z_on == 1
            set(plot2(2),'DisplayName','A_zest');
            set(plot2(5),'DisplayName','A_zest 2');
        end
    else
        if z_on == 1
            set(plot2(1),'DisplayName','A_zest');
            set(plot2(4),'DisplayName','A_zest 2');
        end
    end
end

xlabel('Time (sec)','FontSize',12);
ylabel('G''s','FontSize',12);


legend1 = legend(subplot1,'show');
set(legend1,'Position',[0.8131 0.7879 0.05682 0.123]);
legend2 = legend(subplot2,'show');
set(legend2,'Position',[0.8078 0.3143 0.07273 0.123]);

end






if handles.ang_plot_check==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
     
     num_col = 0;
     x_on = 0;
     y_on = 0;
     z_on = 0;
     to_plot_act = zeros(length(handles.t_s),1);
     to_plot_est = zeros(length(handles.t_s),1);
     to_plot_est2 = zeros(length(handles2.t_s),1);
     handles.omega_est_plot = handles.omega_est*180/pi;
     handles2.omega_est_plot = handles2.omega_est*180/pi;
     
     
    if handles.naso_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.omega_head(:,1);
        to_plot_est(:,num_col) = handles.omega_est_plot(:,1);
        to_plot_est2(:,num_col) = handles2.omega_est_plot(:,1);
        x_on = 1;
    end
    
    if handles.inter_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.omega_head(:,2);
        to_plot_est(:,num_col) = handles.omega_est_plot(:,2);
        to_plot_est2(:,num_col) = handles2.omega_est_plot(:,2);
        y_on = 1;
    end
    
    if handles.dorso_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.omega_head(:,3);
        to_plot_est(:,num_col) = handles.omega_est_plot(:,3);
        to_plot_est2(:,num_col) = handles2.omega_est_plot(:,3);
        z_on = 1;
    end
    
to_plot_est_all = [to_plot_est to_plot_est2];
        
figure1 = figure('Name','OMEGA','NumberTitle','on');

% Create subplot 1
subplot1 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if handles.scale_checkbox==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
    
    if max(max(abs(to_plot_act))) > max(max(abs(to_plot_est)))
        y_high = max(max(abs(to_plot_act))) + 0.1*max(max(abs(to_plot_act)));
        y_low = -1.0*y_high;
    else
        y_high = max(max(abs(to_plot_est_all))) + 0.1*max(max(abs(to_plot_est_all)));
        y_low = -1.0*y_high;
    end

    if y_low == y_high
        y_low = y_low - 1;
        y_high = y_high + 1;
    end
    
    ylim([y_low y_high]);
end



box('on');
hold('all');

title('Angular Velocity','FontSize',14);

plot1 = plot(handles.t_s,to_plot_act,'LineWidth',2);

if x_on == 1
    set(plot1(1),'DisplayName','Omega_x');
    if y_on == 1
        set(plot1(2),'DisplayName','Omega_y');
        if z_on == 1
            set(plot1(3),'DisplayName','Omega_z');
        end
    else
        if z_on == 1
            set(plot1(2),'DisplayName','Omega_z');
        end
    end
else
    if y_on == 1
        set(plot1(1),'DisplayName','Omega_y');
        if z_on == 1
            set(plot1(2),'DisplayName','Omega_z');
        end
    else
        if z_on == 1
            set(plot1(1),'DisplayName','Omega_z');
        end
    end
end


xlabel('Time (sec)','FontSize',12);
ylabel('deg/sec','FontSize',12);

% Create subplot 2
subplot2 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if handles.scale_checkbox==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
       ylim([y_low y_high]);
end

box('on');
hold('all');


title('Estimated Angular Velocity','FontSize',14);

plot2 = plot(handles.t_s,to_plot_est_all,'LineWidth',2);

if x_on == 1
    set(plot2(1),'DisplayName','Omega_xest');
    set(plot2(4),'DisplayName','Omega_xest 2');
    if y_on == 1
        set(plot2(2),'DisplayName','Omega_yest');
        set(plot2(5),'DisplayName','Omega_yest 2');
        if z_on == 1
            set(plot2(3),'DisplayName','Omega_zest');
            set(plot2(6),'DisplayName','Omega_zest 2');
        end
    else
        if z_on == 1
            set(plot2(2),'DisplayName','Omega_zest');
            set(plot2(5),'DisplayName','Omega_zest 2');
        end
    end
else
    if y_on == 1
        set(plot2(1),'DisplayName','Omega_yest');
        set(plot2(4),'DisplayName','Omega_yest 2');
        if z_on == 1
            set(plot2(2),'DisplayName','Omega_zest');
            set(plot2(5),'DisplayName','Omega_zest 2');
        end
    else
        if z_on == 1
            set(plot2(1),'DisplayName','Omega_zest');
            set(plot2(4),'DisplayName','Omega_zest 2');
        end
    end
end

xlabel('Time (sec)','FontSize',12);
ylabel('deg/sec','FontSize',12);


legend1 = legend(subplot1,'show');
set(legend1,'Position',[0.8131 0.7879 0.05682 0.123]);
legend2 = legend(subplot2,'show');
set(legend2,'Position',[0.8078 0.3143 0.07273 0.123]);

end



if handles.gravity_plot_check==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
     
     num_col = 0;
     x_on = 0;
     y_on = 0;
     z_on = 0;
     to_plot_act = zeros(length(handles.t_s),1);
     to_plot_est = zeros(length(handles.t_s),1);
     to_plot_est2 = zeros(length(handles2.t_s),1);
     
    if handles.naso_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.g_head(:,1);
        to_plot_est(:,num_col) = handles.g_est(:,1);
        to_plot_est2(:,num_col) = handles2.g_est(:,1);
        x_on = 1;
    end
    
    if handles.inter_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.g_head(:,2);
        to_plot_est(:,num_col) = handles.g_est(:,2);
        to_plot_est2(:,num_col) = handles2.g_est(:,2);
        y_on = 1;
    end
    
    if handles.dorso_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.g_head(:,3);
        to_plot_est(:,num_col) = handles.g_est(:,3);
        to_plot_est2(:,num_col) = handles2.g_est(:,3);
        z_on = 1;
    end
    
to_plot_est_all = [to_plot_est to_plot_est2];
        
figure1 = figure('Name','G','NumberTitle','on');

% Create subplot 1
subplot1 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if handles.scale_checkbox==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
    
    if max(max(abs(to_plot_act))) > max(max(abs(to_plot_est)))
        y_high = max(max(abs(to_plot_act))) + 0.1*max(max(abs(to_plot_act)));
        y_low = -1.0*y_high;
    else
        y_high = max(max(abs(to_plot_est_all))) + 0.1*max(max(abs(to_plot_est_all)));
        y_low = -1.0*y_high;
    end

    if y_low == y_high
        y_low = y_low - 1;
        y_high = y_high + 1;
    end
    
    ylim([y_low y_high]);
end



box('on');
hold('all');

title('Gravity','FontSize',14);

plot1 = plot(handles.t_s,to_plot_act,'LineWidth',2);

if x_on == 1
    set(plot1(1),'DisplayName','g_x');
    if y_on == 1
        set(plot1(2),'DisplayName','g_y');
        if z_on == 1
            set(plot1(3),'DisplayName','g_z');
        end
    else
        if z_on == 1
            set(plot1(2),'DisplayName','g_z');
        end
    end
else
    if y_on == 1
        set(plot1(1),'DisplayName','g_y');
        if z_on == 1
            set(plot1(2),'DisplayName','g_z');
        end
    else
        if z_on == 1
            set(plot1(1),'DisplayName','g_z');
        end
    end
end


xlabel('Time (sec)','FontSize',12);
ylabel('G''s','FontSize',12);

% Create subplot 2
subplot2 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if handles.scale_checkbox==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
       ylim([y_low y_high]);
end

box('on');
hold('all');


title('Estimated Gravity','FontSize',14);

plot2 = plot(handles.t_s,to_plot_est_all,'LineWidth',2);

if x_on == 1
    set(plot2(1),'DisplayName','g_xest');
    set(plot2(4),'DisplayName','g_xest 2');
    if y_on == 1
        set(plot2(2),'DisplayName','g_yest');
        set(plot2(5),'DisplayName','g_yest 2');
        if z_on == 1
            set(plot2(3),'DisplayName','g_zest');
            set(plot2(6),'DisplayName','g_zest 2');
        end
    else
        if z_on == 1
            set(plot2(2),'DisplayName','g_zest');
            set(plot2(5),'DisplayName','g_zest 2');
        end
    end
else
    if y_on == 1
        set(plot2(1),'DisplayName','g_yest');
        set(plot2(4),'DisplayName','g_yest 2');
        if z_on == 1
            set(plot2(2),'DisplayName','g_zest');
            set(plot2(5),'DisplayName','g_zest 2');
        end
    else
        if z_on == 1
            set(plot2(1),'DisplayName','g_zest');
            set(plot2(4),'DisplayName','g_zest 2');
        end
    end
end

xlabel('Time (sec)','FontSize',12);
ylabel('G''s','FontSize',12);


legend1 = legend(subplot1,'show');
set(legend1,'Position',[0.8131 0.7879 0.05682 0.123]);
legend2 = legend(subplot2,'show');
set(legend2,'Position',[0.8078 0.3143 0.07273 0.123]);

end

%% Visual cues plotting

if handles.cue_plot_check==1.0
    
figure1 = figure('Name','Cues','NumberTitle','on');
% Create axes
box('on');
hold('all');
axes1 = axes('YTickLabel',{'Off','On'},'YTick',[0 1],'FontSize',12);


subplot(4,2,1);
% Create plot
plot(handles.t,handles.switch_xv,'LineWidth',3,'LineStyle',':',...
    'DisplayName','switch_xv vs t',...
    'Color',[0 0 0]);
title('Visual Position Cue, Condition 1','FontWeight','bold','FontSize',12);
yticks([0 1])
yticklabels({'Off','On'})
xlim([0 max(handles.t_s)]);
ylim([-0.5 1.5]);

subplot(4,2,2);
% Create plot
plot(handles2.t,handles2.switch_xv,'LineWidth',3,'LineStyle',':',...
    'DisplayName','switch_xv vs t',...
    'Color',[0 0 0]);
title('Visual Position Cue, Condition 2','FontWeight','bold','FontSize',12);
yticks([0 1])
yticklabels({'Off','On'})
xlim([0 max(handles.t_s)]);
ylim([-0.5 1.5]);




subplot(4,2,3);
% Create plot
plot(handles.t,handles.switch_xvdot,'LineWidth',3,'LineStyle',':',...
    'Color',[0 0.498 0],...
    'DisplayName','switch_xvdot vs t');
title('Visual Linear Velocity Cue','FontWeight','bold','FontSize',12);
yticks([0 1])
yticklabels({'Off','On'})
xlim([0 max(handles.t_s)]);
ylim([-0.5 1.5]);

subplot(4,2,4);
% Create plot
plot(handles2.t,handles2.switch_xvdot,'LineWidth',3,'LineStyle',':',...
    'Color',[0 0.498 0],...
    'DisplayName','switch_xvdot vs t');
title('Visual Linear Velocity Cue','FontWeight','bold','FontSize',12);
yticks([0 1])
yticklabels({'Off','On'})
xlim([0 max(handles.t_s)]);
ylim([-0.5 1.5]);


subplot(4,2,5);
% Create plot
plot(handles.t,handles.switch_omegav,'LineWidth',3,'LineStyle',':',...
    'Color',[1 0 0],...
    'DisplayName','switch_omegav vs t');
title('Visual Angular Velocity','FontWeight','bold','FontSize',12);
yticks([0 1])
yticklabels({'Off','On'})
xlim([0 max(handles.t_s)]);
ylim([-0.5 1.5]);

subplot(4,2,6);
% Create plot
plot(handles2.t,handles2.switch_omegav,'LineWidth',3,'LineStyle',':',...
    'Color',[1 0 0],...
    'DisplayName','switch_omegav vs t');
title('Visual Angular Velocity','FontWeight','bold','FontSize',12);
yticks([0 1])
yticklabels({'Off','On'})
xlim([0 max(handles.t_s)]);
ylim([-0.5 1.5]);




subplot(4,2,7);
% Create plot
plot(handles.t,handles.switch_gv,'MarkerSize',8,'LineWidth',3,...
    'LineStyle',':',...
    'DisplayName','switch_gv vs t');
title('Visual Tilt (Gravity) Vector','FontWeight','bold','FontSize',12);
yticks([0 1])
yticklabels({'Off','On'})
xlim([0 max(handles.t_s)]);
ylim([-0.5 1.5]);

subplot(4,2,8);
% Create plot
plot(handles2.t,handles2.switch_gv,'MarkerSize',8,'LineWidth',3,...
    'LineStyle',':',...
    'DisplayName','switch_gv vs t');
title('Visual Tilt (Gravity) Vector','FontWeight','bold','FontSize',12);
yticks([0 1])
yticklabels({'Off','On'})
xlim([0 max(handles.t_s)]);
ylim([-0.5 1.5]);

end

%% back to plotting









if handles.position_plot_check==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
     
     num_col = 0;
     x_on = 0;
     y_on = 0;
     z_on = 0;
     to_plot_act = zeros(length(handles.t),1);
     to_plot_est = zeros(length(handles.t_s),1);
     to_plot_est2 = zeros(length(handles2.t_s),1);
     
    if handles.naso_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.x_in(:,1);
        to_plot_est(:,num_col) = handles.x_est(:,1);
        to_plot_est2(:,num_col) = handles2.x_est(:,1);
        x_on = 1;
    end
    
    if handles.inter_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.x_in(:,2);
        to_plot_est(:,num_col) = handles.x_est(:,2);
        to_plot_est2(:,num_col) = handles2.x_est(:,2);
        y_on = 1;
    end
    
    if handles.dorso_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.x_in(:,3);
        to_plot_est(:,num_col) = handles.x_est(:,3);
        to_plot_est2(:,num_col) = handles2.x_est(:,3);
        z_on = 1;
    end
    
to_plot_est_all = [to_plot_est to_plot_est2];
        
figure1 = figure('Name','DISP','NumberTitle','on');

% Create subplot 1
subplot1 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if handles.scale_checkbox==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
    
    if max(max(abs(to_plot_act))) > max(max(abs(to_plot_est)))
        y_high = max(max(abs(to_plot_act))) + 0.1*max(max(abs(to_plot_act)));
        y_low = -1.0*y_high;
    else
        y_high = max(max(abs(to_plot_est_all))) + 0.1*max(max(abs(to_plot_est_all)));
        y_low = -1.0*y_high;
    end

    if y_low == y_high
        y_low = y_low - 1;
        y_high = y_high + 1;
    end
    
    ylim([y_low y_high]);
end



box('on');
hold('all');

title('Displacement','FontSize',14);

plot1 = plot(handles.t,to_plot_act,'LineWidth',2);

if x_on == 1
    set(plot1(1),'DisplayName','D_x');
    if y_on == 1
        set(plot1(2),'DisplayName','D_y');
        if z_on == 1
            set(plot1(3),'DisplayName','D_z');
        end
    else
        if z_on == 1
            set(plot1(2),'DisplayName','D_z');
        end
    end
else
    if y_on == 1
        set(plot1(1),'DisplayName','D_y');
        if z_on == 1
            set(plot1(2),'DisplayName','D_z');
        end
    else
        if z_on == 1
            set(plot1(1),'DisplayName','D_z');
        end
    end
end


xlabel('Time (sec)','FontSize',12);
ylabel('Meter''s','FontSize',12);

% Create subplot 2
subplot2 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if handles.scale_checkbox==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
       ylim([y_low y_high]);
end

box('on');
hold('all');


title('Estimated Displacement','FontSize',14);

plot2 = plot(handles.t_s,to_plot_est_all,'LineWidth',2);

if x_on == 1
    set(plot2(1),'DisplayName','D_xest');
    set(plot2(4),'DisplayName','D_xest 2');
    if y_on == 1
        set(plot2(2),'DisplayName','D_yest');
        set(plot2(5),'DisplayName','D_yest 2');
        if z_on == 1
            set(plot2(3),'DisplayName','D_zest');
            set(plot2(6),'DisplayName','D_zest 2');
        end
    else
        if z_on == 1
            set(plot2(2),'DisplayName','D_zest');
            set(plot2(5),'DisplayName','D_zest 2');
        end
    end
else
    if y_on == 1
        set(plot2(1),'DisplayName','D_yest');
        set(plot2(4),'DisplayName','D_yest 2');
        if z_on == 1
            set(plot2(2),'DisplayName','D_zest');
            set(plot2(5),'DisplayName','D_zest 2');
        end
    else
        if z_on == 1
            set(plot2(1),'DisplayName','D_zest');
            set(plot2(4),'DisplayName','D_zest 2');
        end
    end
end

xlabel('Time (sec)','FontSize',12);
ylabel('Meter''s','FontSize',12);


legend1 = legend(subplot1,'show');
set(legend1,'Position',[0.8131 0.7879 0.05682 0.123]);
legend2 = legend(subplot2,'show');
set(legend2,'Position',[0.8078 0.3143 0.07273 0.123]);

end

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
SVV = [handles.plot_SVV handles2.plot_SVV(:,2)];
plot1 = plot(handles.t_s,SVV,'LineWidth',2);
set(plot1(1),'DisplayName','Actual Vertical','Color','r');
set(plot1(2),'DisplayName','SVV','Color','b');
set(plot1(3),'DisplayName','SVV 2','Color','g');


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

tilt = [handles.plot_tilt handles2.plot_tilt(:,2)];
plot2 = plot(handles.t_s,tilt,'LineWidth',2);
set(plot2(1),'DisplayName','Tilt Angle','Color','r');
set(plot2(2),'DisplayName','Estimated Tilt Angle','Color','b');
set(plot2(3),'DisplayName','Estimated Tilt Angle 2','Color','g');


% Create xlabel
xlabel('Time (sec)','FontSize',12);

% Create ylabel
ylabel('Deg','FontSize',12);



% Create legend
legend1 = legend(subplot1,'show');


% Create legend
legend2 = legend(subplot2,'show');

end


if handles.euler_plot_check==1.0
% Create figure
figure6 = figure('Name','ANGLE','NumberTitle','on');

% Create subplot
subplot1 = subplot(3,1,1,'Parent',figure6,'YGrid','on','XGrid','on',...
    'FontSize',12);
box('on');
hold('all');


% Create title
title('Roll','FontSize',14);
roll = [handles.euler_head(:,1) handles.euler_est(:,1) handles2.euler_est(:,1) ];
plot1 = plot(handles.t_s,roll,'LineWidth',2);
set(plot1(1),'DisplayName','Roll Angle','Color','r');
set(plot1(2),'DisplayName','Estimated Roll Angle','Color','b');
set(plot1(3),'DisplayName','Estimated Roll Angle 2','Color','g');


% Create xlabel
xlabel('Time (sec)','FontSize',12);

% Create ylabel
ylabel('Deg','FontSize',12);

% Create subplot
subplot2 = subplot(3,1,2,'Parent',figure6,'YGrid','on','XGrid','on',...
    'FontSize',12);

box('on');
hold('all');

% Create title
title('Pitch','FontSize',14);

pitch = [handles.euler_head(:,2) handles.euler_est(:,2) handles2.euler_est(:,2)];
plot2 = plot(handles.t_s,pitch,'LineWidth',2);
set(plot2(1),'DisplayName','Pitch Angle','Color','r');
set(plot2(2),'DisplayName','Estimated Pitch Angle','Color','b');
set(plot2(3),'DisplayName','Estimated Pitch Angle 2','Color','g');

% Create xlabel
xlabel('Time (sec)','FontSize',12);

% Create ylabel
ylabel('Deg','FontSize',12);


% Create subplot
subplot3 = subplot(3,1,3,'Parent',figure6,'YGrid','on','XGrid','on',...
    'FontSize',12);

box('on');
hold('all');

% Create title
title('Yaw','FontSize',14);

yaw = [handles.euler_head(:,3) handles.euler_est(:,3) handles2.euler_est(:,3)];
plot3 = plot(handles.t_s,yaw,'LineWidth',2);
set(plot3(1),'DisplayName','Yaw Angle','Color','r');
set(plot3(2),'DisplayName','Estimated Yaw Angle','Color','b');
set(plot3(3),'DisplayName','Estimated Yaw Angle','Color','g');

% Create xlabel
xlabel('Time (sec)','FontSize',12);

% Create ylabel
ylabel('Deg','FontSize',12);

% Create legend
legend1 = legend(subplot1,'show');


% Create legend
legend2 = legend(subplot2,'show');

% Create legend
legend3 = legend(subplot3,'show');

end



if handles.lin_vel_plot_check==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
     
     num_col = 0;
     x_on = 0;
     y_on = 0;
     z_on = 0;
     to_plot_act = zeros(length(handles.t_s),1);
     to_plot_est = zeros(length(handles.t_s),1);
     to_plot_est2 = zeros(length(handles2.t_s),1);
     
    if handles.naso_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.lin_vel(:,1);
        to_plot_est(:,num_col) = handles.lin_vel_est(:,1);
        to_plot_est2(:,num_col) = handles2.lin_vel_est(:,1);
        x_on = 1;
    end
    
    if handles.inter_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.lin_vel(:,2);
        to_plot_est(:,num_col) = handles.lin_vel_est(:,2);
        to_plot_est2(:,num_col) = handles2.lin_vel_est(:,2);
        y_on = 1;
    end
    
    if handles.dorso_checkbox==1.0
        num_col = num_col + 1;
        to_plot_act(:,num_col) = handles.lin_vel(:,3);
        to_plot_est(:,num_col) = handles.lin_vel_est(:,3);
        to_plot_est2(:,num_col) = handles2.lin_vel_est(:,3);
        z_on = 1;
    end
    
to_plot_est_all = [to_plot_est to_plot_est2];
        
figure1 = figure('Name','LINVEL','NumberTitle','on');

% Create subplot 1
subplot1 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if handles.scale_checkbox==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
    
    if max(max(abs(to_plot_act))) > max(max(abs(to_plot_est)))
        y_high = max(max(abs(to_plot_act))) + 0.1*max(max(abs(to_plot_act)));
        y_low = -1.0*y_high;
    else
        y_high = max(max(abs(to_plot_est_all))) + 0.1*max(max(abs(to_plot_est_all)));
        y_low = -1.0*y_high;
    end

    if y_low == y_high
        y_low = y_low - 1;
        y_high = y_high + 1;
    end
    
    ylim([y_low y_high]);
end



box('on');
hold('all');

title('Linear Velocity','FontSize',14);

plot1 = plot(handles.t_s,to_plot_act,'LineWidth',2);

if x_on == 1
    set(plot1(1),'DisplayName','V_x');
    if y_on == 1
        set(plot1(2),'DisplayName','V_y');
        if z_on == 1
            set(plot1(3),'DisplayName','V_z');
        end
    else
        if z_on == 1
            set(plot1(2),'DisplayName','V_z');
        end
    end
else
    if y_on == 1
        set(plot1(1),'DisplayName','V_y');
        if z_on == 1
            set(plot1(2),'DisplayName','V_z');
        end
    else
        if z_on == 1
            set(plot1(1),'DisplayName','V_z');
        end
    end
end


xlabel('Time (sec)','FontSize',12);
ylabel('m/s','FontSize',12);

% Create subplot 2
subplot2 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',12);

if handles.scale_checkbox==1.0 && (handles.naso_checkbox==1.0 || handles.inter_checkbox==1.0 ||handles.dorso_checkbox==1.0)
       ylim([y_low y_high]);
end

box('on');
hold('all');


title('Estimated Linear Velocity','FontSize',14);

plot2 = plot(handles.t_s,to_plot_est_all,'LineWidth',2);

if x_on == 1
    set(plot2(1),'DisplayName','V_xest');
    set(plot2(4),'DisplayName','V_xest 2');
    if y_on == 1
        set(plot2(2),'DisplayName','V_yest');
        set(plot2(5),'DisplayName','V_yest 2');
        if z_on == 1
            set(plot2(3),'DisplayName','V_zest');
            set(plot2(6),'DisplayName','V_zest 2');
        end
    else
        if z_on == 1
            set(plot2(2),'DisplayName','V_zest');
            set(plot2(5),'DisplayName','V_zest 2');
        end
    end
else
    if y_on == 1
        set(plot2(1),'DisplayName','V_yest');
        set(plot2(4),'DisplayName','V_yest 2');
        if z_on == 1
            set(plot2(2),'DisplayName','V_zest');
            set(plot2(5),'DisplayName','V_zest 2');
        end
    else
        if z_on == 1
            set(plot2(1),'DisplayName','V_zest');
            set(plot2(4),'DisplayName','V_zest 2');
        end
    end
end

xlabel('Time (sec)','FontSize',12);
ylabel('m/s','FontSize',12);


legend1 = legend(subplot1,'show');
set(legend1,'Position',[0.8131 0.7879 0.05682 0.123]);
legend2 = legend(subplot2,'show');
set(legend2,'Position',[0.8078 0.3143 0.07273 0.123]);

end

end