%%========================================================================
% THIS CODE WILL CREATE A PNG SKI-POLE INCLINOMETER WITH GNU OCTAVE V.5.2.0
% The inclinometer is ment to be wrapped around the ski-pole
% Author: Ph.D. Miguel LLORENTE ISIDRO
% Contact: m.llorente@igme.es
% Author affiliation: Spanish Geological Survey
% TOS: use at your own risk
% Date: 06/10/2020
% Version: 1.0

%%========================================================================
% REQUIREMENTS: GNU OCTAVE v. 5.2.0 
% You are supposed to know the diameter of your ski-pole, walking stick or 
% whatever cilinder-like object where you plan to wrap the inclinometer
%
% WARNING: there is a plog bug that wont rotate text, however, the png
% that will be created will have rotated text.

clc; clear; close;

%%========================================================================
%% INPUT DATA
% Diameter of the pole and line narrowest separation
d = input ('Input pole diameter (mm, usually 12, 14, 16 or 19): ');
e = input ('Input slope-line spacing (in mm, usually 5): ');
tf=25*d/19; % The fontsize for tags was calibrated for 19 mm diameter pole
lw=2; % The width of the lines marking the slopes, 2 or 3 is ok
%
%%========================================================================
% Preparing basic derivatives
c=d*pi(); % Circunference length of the pole
x=linspace(0,c,101); % equally spaced sampling for representing the sinusoidal
a=deg2rad(linspace(0,60,13)); % equally spaced 5 degree intervals slope planes

% The following describes the sinusoidal representing the intersection of 
% planes at different angles with a cilinder and then dewrapped
yy=[]; % this are the one line arrays describing one angle per line
y=[]; % all yy will be stored into a single matrix

for m = [1:length(a)];
    for n = [1:length(x)];
      yy=[yy, -((c*tan(a(m)))/(2*pi()))*(cos(2*pi()*(x(n)/(c))))-(-((c*tan(a(m)))/(2*pi()))*(cos(2*pi()*(-c/2)/(c))))-(e*rad2deg(a(m))/5)];
    end
  y=[y;yy];
  yy=[];
end


%%========================================================================
% GRAPHING RESULTS
fn = 1; fx = 100; fy = 10; % figure number and screen position
fw = round(c*10); fh = round(abs(min(y(:)))*10+100); % Figure width and height
% Adjusting size of data in plot to fit everything
figure(fn, 'OuterPosition', [fx fy fw fh], 'Position', [fx fy fw fh]);

hold on;
%%------------------------------------------------------------------------
% Background colors
% The green part from 0 to 25 degrees
X=[x,fliplr(x)];  
Y=[y(1, :),fliplr(y(6, :))];
fill(X,Y,'g');
% The yellow part from 25 to 30 degrees, which represents the most common
% friction angle for natural soils and also meaningful for snowavalanch hazard
Y=[y(6, :),fliplr(y(7, :))];
fill(X,Y,'y'); 
% The red part from 30  to 50 degrees, which represents a critical value
% for most natural slopes
Y=[y(7, :),fliplr(y(11, :))];
fill(X,Y,'r');
% The yellow part from 50 to 60 degrees, how the hell is that holding up?
Y=[y(11, :),fliplr(y(13, :))];
fill(X,Y,'y');

clear X Y;

%%------------------------------------------------------------------------ 
% Guiding lines
% Major black guiding lines
plot(x,y, '-', 'linewidth', lw, 'color', [0 0 0]);
% Grey dashed secondary guiding lines
plot( [c/4 c/4], [0 min(y(:))], '--', 'color', [100 100 100]/255);
plot( [3*c/4 3*c/4], [0 min(y(:))], '--', 'color', [100 100 100]/255);

%%------------------------------------------------------------------------
% The tags with all their properties
for i=[2:5];
  tt=num2str(round(rad2deg(a(i))));
  text (c*1/4, (y(i,26)), tt, 'HorizontalAlignment','center', 'FontSize', tf, 'backgroundcolor','green','margin',1,'rotation',rad2deg(a(i))); %left
  text (c*1/2+d/100, (y(i,51)), tt, 'HorizontalAlignment','center', 'FontSize',tf,'backgroundcolor','green','margin',1); %center
  text (c*3/4, (y(i,76)), tt, 'HorizontalAlignment','center', 'FontSize',tf,'backgroundcolor','green','margin',1,'rotation',-rad2deg(a(i))); %right
end

for i=[6:7];
  tt=num2str(round(rad2deg(a(i))));
  text (c*1/4, (y(i,26)), tt, 'HorizontalAlignment','center', 'FontSize',tf,'backgroundcolor','yellow','margin',1,'rotation',rad2deg(a(i)));
  text (c*1/2+d/100, (y(i,51)), tt, 'HorizontalAlignment','center', 'FontSize',tf,'backgroundcolor','yellow','margin',1);
  text (c*3/4, (y(i,76)), tt, 'HorizontalAlignment','center', 'FontSize',tf,'backgroundcolor','yellow','margin',1,'rotation',-rad2deg(a(i))); 
end

for i=[8:10];
  tt=num2str(round(rad2deg(a(i))));
  text (c*1/4, (y(i,26)), tt, 'HorizontalAlignment','center', 'FontSize',tf,'backgroundcolor','red','margin',1,'rotation',rad2deg(a(i)));
  text (c*1/2+d/100, (y(i,51)), tt, 'HorizontalAlignment','center', 'FontSize',tf,'backgroundcolor','red','margin',1);
  text (c*3/4, (y(i,76)), tt, 'HorizontalAlignment','center', 'FontSize',tf,'backgroundcolor','red','margin',1,'rotation',-rad2deg(a(i))); 
end

for i=[11:13];
  tt=num2str(round(rad2deg(a(i))));
  text (c*1/4, (y(i,26)), tt, 'HorizontalAlignment','center','fontsize',tf,'backgroundcolor','yellow','margin',1,'rotation',rad2deg(a(i)));
  text (c*1/2+d/100, (y(i,51)), tt, 'HorizontalAlignment','center', 'fontsize',tf,'backgroundcolor','yellow','margin',1);
  text (c*3/4, (y(i,76)), tt, 'HorizontalAlignment','center', 'fontsize',tf,'backgroundcolor','yellow','margin',1,'rotation',-rad2deg(a(i))); 
end

%%------------------------------------------------------------------------
% More graph properties to keep things smooth and clean
axis equal;
xlim ([0 c]); ylim ([min(y(:))-10 0]);
axis nolabel; axis tick;

%%------------------------------------------------------------------------
%Decorations
% A cute vertical line at the bottom
refx=[c/2 c/2];
refy=[-((c*tan(a(13)))/(2*pi()))*(cos(2*pi()*(x(50)/(c))))-(-((c*tan(a(13)))/(2*pi()))*(cos(2*pi()*(-c/2)/(c))))-(e*rad2deg(a(13))/5)-e  min(y(:))+e/2];
plot(refx, refy, '-', 'color', [0 0 0]);

% A cute bounding box
refx=[0 0 c c];
refy=[0 min(y(:))-9.9 min(y(:))-9.9 0]; % minus 9.9 and not -10 to fit the line inside
plot(refx, refy, '-', 'color', [0 0 0], 'linewidth', lw);

% A cute text annotation at the bottom
text (c/2, min(y(:))+e, 'Slope indicator', 'HorizontalAlignment','left', 'FontWeight','normal', 'rotation',90,'fontsize',tf*1.1, 'backgroundcolor','white', 'margin',1); 
text (c/2+c/50, min(y(:))-3, 'Print keeping aspect ratio. Use at your own risk', 'HorizontalAlignment','center', 'FontWeight','normal','fontsize',tf*0.8); 
text (c/2+c/50, min(y(:))-5, 'For 19 mm pole diameter, print width: 59.7 mm', 'HorizontalAlignment','center', 'FontWeight','normal','fontsize',tf*0.8); 
text (c/2+c/50, min(y(:))-7, 'For 13 mm pole diameter, print width: 40.8 mm', 'HorizontalAlignment','center', 'FontWeight','normal','fontsize',tf*0.8); 
% Setting the size of the chart
t=char(strcat('-S',num2str(fw),{','},num2str(fh)));
%%------------------------------------------------------------------------

% Getting rid of the annoying white margins
set(gca, 'Position', get(gca, 'OuterPosition') - get(gca, 'TightInset') * [0 0 0 0; -10 0 -10 0; 0 0 0 0; 0 0 0 0]);

% Your clinometer in png format, ready to be printed using the circumference
% as width with a scale factor of 1 or keeping aspect ratio as is.
print (fn, 'poleclino.png', '-dpng', t);
hold off;
clear;
