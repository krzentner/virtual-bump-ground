#define MOTOR_ENA1(pins) (pins)[0]
#define MOTOR_IN1(pins) (pins)[1]
#define MOTOR_IN2(pins) (pins)[2]

typedef int motor_t[3];

const int MOTOR_1[3] = {2,3,4};

void motor_forward(motor_t motor, int amount /* 0..255 */) {
  digitalWrite(MOTOR_IN1(motor), HIGH);
  digitalWrite(MOTOR_IN2(motor), LOW);
  analogWrite(MOTOR_ENA1(motor), amount);
}

void motor_brake(motor_t motor) {
  digitalWrite(MOTOR_IN1(motor), LOW);
  digitalWrite(MOTOR_IN2(motor), LOW);
  analogWrite(MOTOR_ENA1(motor), 0);
}

void setup() {
  pinMode(MOTOR_ENA1(MOTOR_1), OUTPUT);
  pinMode(MOTOR_IN1(MOTOR_1), OUTPUT);
  pinMode(MOTOR_IN2(MOTOR_1), OUTPUT);
}

void loop() {
  motor_forward(MOTOR_1, 25);
  delay(3000);
  motor_forward(MOTOR_1, 0);
  delay(3000);
}
