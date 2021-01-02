function [] = binary_system_coalescence()
%
% Author & support : nicolas.douillet (at) free.fr, 2007-2021.


%--- logarithmicly spaced path ---%
nb_loop = 6; % integer; default value : 6
Theta = logspace(0,log10(nb_loop*2*pi),36*24+1);
Radius = 12*pi+1-logspace(0,log10(12*pi),36*24+1);
U = [log(Radius).*cos(Theta); log(Radius).*sin(Theta)];

% 2D rotation matrix
Mr2 = @(Phi)[cos(Phi),-sin(Phi);
             sin(Phi),cos(Phi)];

V = Mr2(pi)*U;

sample_step = 12; % default value : 12

%--- Display parameters ---%
time_lapse = 0.1;      % animation time lapse; default value : 0.1
zoom_coeff = 1.7;      % zoom coefficient; default value : 1.7
camroll_angle = 40;    % camroll angle; default value : 40
az = -37.5;            % azimutal angle; default value : -37.5
el = 30;               % elevation angle; default value : 30
bckgrd_clr = [0 0 0];  % background color; default : [0 0 0] (black)
text_color = [1 1 1];  % title color; default : [1 1 1] (white)
star_color1 = [1 0 1]; % first star color; default : [1 0 1] (magenta)
star_color2 = [0 1 1]; % second star color; default : [0 1 1] (cyan)

title_text = 'Binary system coalescence';
filename = 'binary_system_coalescence.gif';

%--- Display settings ---%
h = figure;
set(h,'Position',get(0,'ScreenSize'));
set(gcf,'Color',bckgrd_clr);
axis tight manual;


for s = 1:sample_step:length(Theta)
    
    plot(U(1,s),U(2,s),'o','Color',star_color1,'MarkerSize',13,'Linewidth',13), hold on;
    plot(V(1,s),V(2,s),'o','Color',star_color2,'MarkerSize',13,'Linewidth',13), hold on;
    line(U(1,1:s),U(2,1:s),'Color',star_color1,'Linewidth',1.5), hold on;
    line(V(1,1:s),V(2,1:s),'Color',star_color2,'Linewidth',1.5), hold on;
    
    ax = gca;
    ax.Clipping = 'off';
    set(ax,'Color',bckgrd_clr);
    
    axis off;
    
    title(title_text,'FontSize',20,'Color',text_color), hold on;
    view(az,el);
    
    camroll(camroll_angle);
    zoom(zoom_coeff);
    
    drawnow;
    
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    
    %--- Write to the .gif file ---%
    if s == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',Inf,'DelayTime',time_lapse);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',time_lapse);
    end
    
    clf;
    
end

%--- Red screen ---%
set(gcf,'Color',[1 0 0]);
frame = getframe(h);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',time_lapse);

%--- White screen ---%
set(gcf,'Color',text_color);
frame = getframe(h);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',time_lapse);

%--- 2nd Red screen ---%
set(gcf,'Color',[1 0 0]);
frame = getframe(h);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',time_lapse);

%--- Total paths + merged star ---%
ax = gca;
set(gcf,'Color',bckgrd_clr), set(ax,'Color',bckgrd_clr);
ax.Clipping = 'off';
line(U(1,1:length(Theta)),U(2,1:length(Theta)),'Color',star_color1,'Linewidth',1.5), hold on;
line(V(1,1:length(Theta)),V(2,1:length(Theta)),'Color',star_color2,'Linewidth',1.5), hold on;
plot(U(1,s),U(2,s),'o','Color',[1 0 0],'MarkerSize',22,'Linewidth',22), hold on;
axis off;
title(title_text,'FontSize',20,'Color',text_color), hold on;
view(3);
camroll(camroll_angle);
zoom(zoom_coeff);

frame = getframe(h);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',2*time_lapse);


end % binary_system_coalescence