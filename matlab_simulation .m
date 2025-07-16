% Ball and Beam PID Simulation

clc; clear;

% Time
dt = 0.05;
t = 0:dt:20;

% System Parameters
mass = 0.027;  % ball mass in kg
g = 9.81;      % gravity
beam_length = 0.5;  % meters

% Initial conditions
pos = 0.1;      % initial position (meters)
vel = 0;
angle = 0;

% Setpoint
setpoint = 0.25;  % center of beam (meters)

% PID Gains (tune these)
Kp = 50;
Ki = 5;
Kd = 10;

% PID terms
integral = 0;
prev_error = 0;

% Log
pos_log = zeros(size(t));
angle_log = zeros(size(t));

for i = 1:length(t)
    % Error
    error = setpoint - pos;
    integral = integral + error * dt;
    derivative = (error - prev_error) / dt;

    % PID Output (angle in radians)
    angle = Kp*error + Ki*integral + Kd*derivative;
    angle = max(min(angle, pi/12), -pi/12);  % limit to ±15 deg
    prev_error = error;

    % Ball acceleration on inclined beam
    acc = (g * sin(angle));  % ideal model
    vel = vel + acc * dt;
    pos = pos + vel * dt;

    % Log
    pos_log(i) = pos;
    angle_log(i) = angle;
end

% Plot
subplot(2,1,1);
plot(t, pos_log, 'b', 'LineWidth', 2); hold on;
yline(setpoint, 'r--', 'Setpoint');
xlabel('Time (s)');
ylabel('Ball Position (m)');
title('Ball Position vs Time');
grid on;

subplot(2,1,2);
plot(t, rad2deg(angle_log), 'k', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Servo Angle (deg)');
title('Control Output (Servo Angle)');
grid on;
