clc; clear;

% Time parameters
dt = 0.05;
t = 0:dt:20;

% System parameters
mass = 0.027;
g = 9.81;
beam_length = 0.5;

% Initial conditions
pos = 0.1;
vel = 0;
angle = 0;

% Setpoint
setpoint = 0.25;

% Log for plotting
pos_log = zeros(size(t));
angle_log = zeros(size(t));

% Create fuzzy inference system
fis = mamfis('Name', 'BallBeamFIS');

% --- INPUT 1: Error (setpoint - position) ---
fis = addInput(fis, [-0.2 0.2], 'Name', 'Error');
fis = addMF(fis, 'Error', 'trapmf', [-0.2 -0.2 -0.1 -0.05], 'Name', 'NL');
fis = addMF(fis, 'Error', 'trimf', [-0.1 -0.05 0], 'Name', 'NS');
fis = addMF(fis, 'Error', 'trimf', [-0.02 0 0.02], 'Name', 'ZE');
fis = addMF(fis, 'Error', 'trimf', [0 0.05 0.1], 'Name', 'PS');
fis = addMF(fis, 'Error', 'trapmf', [0.05 0.1 0.2 0.2], 'Name', 'PL');

% --- INPUT 2: Change in error (velocity) ---
fis = addInput(fis, [-0.5 0.5], 'Name', 'dError');
fis = addMF(fis, 'dError', 'trapmf', [-0.5 -0.5 -0.2 -0.1], 'Name', 'NL');
fis = addMF(fis, 'dError', 'trimf', [-0.2 -0.1 0], 'Name', 'NS');
fis = addMF(fis, 'dError', 'trimf', [-0.05 0 0.05], 'Name', 'ZE');
fis = addMF(fis, 'dError', 'trimf', [0 0.1 0.2], 'Name', 'PS');
fis = addMF(fis, 'dError', 'trapmf', [0.1 0.2 0.5 0.5], 'Name', 'PL');

% --- OUTPUT: Angle (control action) ---
fis = addOutput(fis, [-0.2 0.2], 'Name', 'Angle');
fis = addMF(fis, 'Angle', 'trapmf', [-0.2 -0.2 -0.1 -0.05], 'Name', 'NL');
fis = addMF(fis, 'Angle', 'trimf', [-0.1 -0.05 0], 'Name', 'NS');
fis = addMF(fis, 'Angle', 'trimf', [-0.02 0 0.02], 'Name', 'ZE');
fis = addMF(fis, 'Angle', 'trimf', [0 0.05 0.1], 'Name', 'PS');
fis = addMF(fis, 'Angle', 'trapmf', [0.05 0.1 0.2 0.2], 'Name', 'PL');

% Define fuzzy rules
rules = [
    "Error==NL & dError==NL => Angle=PL"
    "Error==NL & dError==NS => Angle=PL"
    "Error==NL & dError==ZE => Angle=PL"
    "Error==NL & dError==PS => Angle=PL"
    "Error==NL & dError==PL => Angle=PS"

    "Error==NS & dError==NL => Angle=PL"
    "Error==NS & dError==NS => Angle=PL"
    "Error==NS & dError==ZE => Angle=PS"
    "Error==NS & dError==PS => Angle=PS"
    "Error==NS & dError==PL => Angle=ZE"

    "Error==ZE & dError==NL => Angle=PS"
    "Error==ZE & dError==NS => Angle=PS"
    "Error==ZE & dError==ZE => Angle=ZE"
    "Error==ZE & dError==PS => Angle=NS"
    "Error==ZE & dError==PL => Angle=NS"

    "Error==PS & dError==NL => Angle=ZE"
    "Error==PS & dError==NS => Angle=NS"
    "Error==PS & dError==ZE => Angle=NS"
    "Error==PS & dError==PS => Angle=NS"
    "Error==PS & dError==PL => Angle=NL"

    "Error==PL & dError==NL => Angle=NS"
    "Error==PL & dError==NS => Angle=NS"
    "Error==PL & dError==ZE => Angle=NL"
    "Error==PL & dError==PS => Angle=NL"
    "Error==PL & dError==PL => Angle=NL"
];
fis = addRule(fis, rules);

% --- SIMULATION LOOP ---
for i = 1:length(t)
    error = setpoint - pos;
    dError = -vel;  % change in position is negative velocity

    % Evaluate fuzzy controller
    angle = evalfis(fis, [error dError]);
    angle = max(min(angle, pi/12), -pi/12);  % limit to ±15 deg

    % Ball physics
    acc = g * sin(angle);
    vel = vel + acc * dt;
    pos = pos + vel * dt;

    % Log data
    pos_log(i) = pos;
    angle_log(i) = angle;
end

% --- PLOTS ---
subplot(2,1,1);
plot(t, pos_log, 'b', 'LineWidth', 2); hold on;
yline(setpoint, 'r--', 'Setpoint');
xlabel('Time (s)');
ylabel('Ball Position (m)');
title('Ball Position vs Time (Fuzzy Controller)');
grid on;

subplot(2,1,2);
plot(t, rad2deg(angle_log), 'm', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Servo Angle (deg)');
title('Beam Angle (Fuzzy Output)');
grid on;
