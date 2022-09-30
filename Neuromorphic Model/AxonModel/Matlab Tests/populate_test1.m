%this code tests the populate feature of a given axon class
clear all;

x = [1 1 1; 1 0 1; 2 -1 1; 5 0 4];
axon = SENN_AxonP(x,0.1,50);
axon.populate(23, .1, .5, 1);
q = axon.position;
hold off;
plot3(x(:,1),x(:,2),x(:,3));
hold on;
grid on;
plot3(q(:,1),q(:,2),q(:,3),'o');
axis square;
