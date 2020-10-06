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

%%========================================================================

clc; clear; close;

%% User input data is required
d = input ('Input pole diameter (mm, usually 19-12 is ok): ');
% hence the circunference length is c
c=d*pi(); 
% just for printing lines equally spaced
e = input ('Input slope-line spacing (in mm, usually 5 fits best): ');
x=linspace(0,c,101); % equally spaced sampling for representing the sinusoidal
a=deg2rad(linspace(0,60,13)); % equally spaced 5 degree intervals slope planes

% The fontsize for tags was calibrated for 19 mm diameter pole
tf=25*d/19; 

% The following describes a sinusoidal series representing the intersection of 
% planes at different angles with a cilinder and then dewrapped
yy=[]; %this are the one line arrays describing one angle per line
y=[]; %all angles will be stored into a single matrix

for m = [1:length(a)];
    for n = [1:length(x)];
      yy=[yy, -((c*tan(a(m)))/(2*pi()))*(cos(2*pi()*(x(n)/(c))))-(-((c*tan(a(m)))/(2*pi()))*(cos(2*pi()*(-c/2)/(c))))-(e*rad2deg(a(m))/5)];
    end
  y=[y;yy];
  yy=[];
end
clear m n yy;

% Graphing the results
fn = 1;         % figure number
fx = 100; fy = 50; % Screen position
fw = round(c*10); fh = round(abs(min(y(:)))*10+100); % Figure width and height
figure(fn, 'OuterPosition', [fx fy fw fh], 'Position', [fx fy fw fh]);
clear fx fy; 
hold on;

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
 
% Black guiding lines
plot(x,y, '-', 'linewidth', 3, 'color', [0 0 0]);

% The tags with all their properties, beware the plot won't rotate tags
for i=[2:5];
  tt=num2str(round(rad2deg(a(i))));
  text (c*1/4, (y(i,26)), tt, 'HorizontalAlignment','center', 'FontSize', tf, 'backgroundcolor','green','margin',1,'rotation',rad2deg(a(i)));
  text (c*1/2+d/100, (y(i,51)), tt, 'HorizontalAlignment','center', 'FontSize',tf,'backgroundcolor','green','margin',1); %right
  text (c*3/4, (y(i,76)), tt, 'HorizontalAlignment','center', 'FontSize',tf,'backgroundcolor','green','margin',1,'rotation',-rad2deg(a(i))); %center
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

% More graph properties to keep things smooth, clean and scaled
axis equal;
xlim ([0 c]); ylim ([min(y(:))-10 0]);
axis nolabel; axis tick;
box on;

% A cute vertical line at the bottom
refx=[c/2 c/2];
refy=[-((c*tan(a(13)))/(2*pi()))*(cos(2*pi()*(x(50)/(c))))-(-((c*tan(a(13)))/(2*pi()))*(cos(2*pi()*(-c/2)/(c))))-(e*rad2deg(a(13))/5)-e  min(y(:))+e/2];
plot(refx, refy, '-', 'color', [0 0 0]);
clear refx refy;

% A cute text annotation at the bottom
text (c/2, min(y(:))+e, 'Slope indicator', 'HorizontalAlignment','left', 'FontWeight','normal', 'rotation',90,'fontsize',tf*1.1, 'backgroundcolor','white', 'margin',1); 
text (c/2+c/50, min(y(:))-3, 'Print keeping aspect ratio, for width = diameter * pi', 'HorizontalAlignment','center', 'FontWeight','normal','fontsize',tf*0.8); 
text (c/2+c/50, min(y(:))-5, 'E.g. for 19 mm diameter, print width = 59.7 mm', 'HorizontalAlignment','center', 'FontWeight','normal','fontsize',tf*0.8); 
text (c/2+c/50, min(y(:))-7, 'E.g. for 13 mm diameter, print width = 40.8 mm', 'HorizontalAlignment','center', 'FontWeight','normal','fontsize',tf*0.8); 
% Setting the size of the chart
t=char(strcat('-S',num2str(fw),{','},num2str(fh)));

% Getting rid of the annoying white margins
set(gca, 'Position', get(gca, 'OuterPosition') - get(gca, 'TightInset') * [0 0 0 0; -10 0 -10 0; 0 0 0 0; 0 0 0 0]);

% Your clinometer in png format, ready to be printed using the circumference
% as width keeping aspect ratio untocuhed.
print (fn, 'poleclino.png', '-dpng', t);
hold off;
clear;
