
function answer = russCirclePlot(linewidth, vector1, color1, vector2, color2, vector3, color3, vector4, color4,...
                                 vector5, color5)
hold on
[xx,yy,zz]=sphere(40);
surf(xx/2,yy/2,zz/2);
colormap(white);
hold on
hand= plot3([0 vector1(1)],[0 vector1(2)],[0 vector1(3)],color1,...
            [0 vector2(1)],[0 vector2(2)],[0 vector2(3)],color2,...
            [0 vector3(1)],[0 vector3(2)],[0 vector3(3)],color3,...
            [0 vector4(1)],[0 vector4(2)],[0 vector4(3)],color4,...
            [0 vector5(1)],[0 vector5(2)],[0 vector5(3)],color5);
set (hand, 'Linewidth', linewidth);
grid on;
hold on; %we'll keep adding to this plot
view(0,90);
axis ([-1 1 -1 1 -1 1]);
title('SCC Selectivity Details');
axis square;

answer = hand;