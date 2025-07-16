# Ball-and-Beam-balance-system
Control System..

# Ball and Beam Balance System

A self-stabilizing Ball and Beam control system built using Arduino, infrared (IR) sensors, MPU6050, and a servo motor. This project showcases real-time control and sensor fusion techniques to balance a ping pong ball at the center of a beam by dynamically adjusting its tilt.

# Features

- Balances a ping pong ball at the center of a 50 cm beam.
- Uses *two IR sensors* to detect the ball’s position from both ends of the beam.
- Uses *MPU6050 IMU* to measure beam orientation.
- Implements Kalman Filter for sensor fusion and noise reduction.
- Servo motor adjusts the tilt of the beam in real time to balance the ball.

# Control System Logic

- IR sensors detect the distance of the ball from both ends.
- MPU6050 gives the beam's tilt angle.
- Kalman filter fuses accelerometer and gyroscope data from MPU6050.
- A feedback control loop (Proportional control) calculates the required servo position.
- The system continuously adjusts the servo to maintain the ball at the beam’s midpoint (25 cm).

# Hardware Components

| Component                    | Quantity |
|------------------------------|----------|
| Arduino UNO / Nano           | 1        |
| IR Sensors (3-pin)           | 2        |
| MPU6050 IMU Sensor           | 1        |
| Servo Motor (MG996R or SG90) | 1        |
| Ping Pong Ball               | 1        |
| Custom Beam (50 cm x 4.5 cm) | 1        |
| Cardboard base and arms      | -        |
| Jumper wires                 | -        |
| Power supply (USB or 9V)     | 1        |

# Pin Configuration

| Module       | Arduino Pin |
|--------------|-------------|
| IR Sensor 1  | D2          |
| IR Sensor 2  | D3          |
| MPU6050 SDA  | A4          |
| MPU6050 SCL  | A5          |
| Servo PWM    | D9          |

>  Ensure MPU6050 is fixed at the beam's center and IR sensors are properly aligned at both ends for accurate readings.

# 🧾 Code Overview

- ball_and_beam.ino – Main sketch handling sensor readings and servo control.
- kalman_filter.h / .cpp – Implements Kalman Filter for MPU6050 data.
- servo_control.ino – Logic to determine appropriate PWM values.
- sensor_readings.ino – Handles IR and IMU sensor data.

# Output

- Real-time beam angle, servo position, and ball location printed to Serial Monitor.
- Optional: Interface OLED or Serial Plotter for live visualization.

📷 Demo image !  
![WhatsApp Image 2025-04-22 at 16 00 59_eca822fa](https://github.com/user-attachments/assets/8b19c112-9fc8-436d-85e5-369d41c7531d)

# Future Enhancements

- Replace Proportional control with full PID control for better stability.
- Add OLED or LCD for live display of sensor readings.
- Design a compact PCB to reduce wiring complexity.
- Introduce auto-calibration for IR sensors.

# Concepts Used

- Feedback Control System
- Sensor Fusion using Kalman Filter
- Embedded Programming with Arduino
- Servo Motor Control
- Real-Time System Response

# Project Structure
Ball-and-Beam-balance-system/
├── ball_and_beam.ino
├── kalman_filter.h
├── kalman_filter.cpp
├── servo_control.ino
├── sensor_readings.ino
├── README.md


# Author

Anjali Sharna 
📌 Maulana Azad National Institute of Technology (MANIT), Bhopal  
🔗 [GitHub](https://github.com/Anjali-Sharma-1703)  
🔗 [LinkedIn](https://www.linkedin.com/in/anjali-sharma-5790b7291/)

---

If you found this project interesting or helpful, feel free to ⭐ star the repo and share it with others!
