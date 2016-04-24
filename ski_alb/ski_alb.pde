import processing.serial.*;

int vidas=5;
int xP=0;
int posXban = 50;
int anchuraBan=500;
int vel=2;
int score=0;
boolean gameover=false;
PImage img;
PImage ski1;
PImage ski2;
int posXsquiador=0;
String message;
Serial myPort;
float yaw;
float roll;
float pitch;
String [] ypr = new String [3];
void setup() {
  size(640, 360);
  if (myPort == null) {
    myPort = new Serial (this, Serial.list() [0], 115200);
  }
  vidas=1;
  xP=0;
  posXban = 50;
  anchuraBan=150;
  vel=3;
  score=0;
  posXsquiador=300;
  gameover=false;
  img = loadImage("GAME OVER.png");
  ski1=loadImage("ski1.png");
  ski2=loadImage("ski2.png");
}


void draw() {
  serialEvent();
  background(204, 153, 0);
  rect(280, 40, 70, 20);
  posXsquiador += velSki();
  if (posXsquiador < 20) {
    posXsquiador=20;
  }
  if (posXsquiador > 620) {
    posXsquiador=620;
  }

  if (gameover==true) {
    image(img, 0, 0, width, height);
    textSize(32);
    text("You Died With: "+score+" Points", 40, 50);
  } else {
    xP+=vel;
    line(posXban, xP, posXban, xP+75);
    line(posXban+anchuraBan, xP, posXban+anchuraBan, xP+75);

    if (xP>360) {
      xP=0;
      posXban = (int)random(10, 640-anchuraBan-10);
    }
    textSize(20);
    text("Puntuacion: "+score+" puntos", 400, 20);

    println(posXban +" < "+ (posXsquiador-20) +" && " + (posXsquiador+20) +" < " + anchuraBan +" && "+ xP +" ==336 ");
    if (posXban < (posXsquiador-20) && (posXsquiador+20) < posXban+anchuraBan && xP==336) {
      score+=5;
    } else if (xP==336) { 
      score-=5;
      vidas--;
    }
    textSize(20);
    text("Quedan: "+vidas+" Vidas", 400, 50);
    if (vidas<1) {
      gameover=true;
    }
  }
  myPort.write("s");
  if (velSki()>0) {
    image (ski1, posXsquiador-20, 300);
  } else {
    image (ski2, posXsquiador-20, 300);
  }
}


void mouseClicked() {
  if (gameover==true) {
    gameover=false;
    setup();
  }
}

int velSki() {
  if (mouseX > width/2+30) {
    return 5;
  } else if (width/2 - 30 < mouseX && mouseX < width + 30) {
    return 0;
  } else {
    return -5;
  }
}
void serialEvent()
{
  message = myPort.readStringUntil(13);
  if (message != null) {
    ypr = split(message, ",");
    yaw = -float(ypr[0]);
    pitch = -float(ypr[1]);
    roll = float(ypr[2]);
  }

  boolean right = (Math.abs(pitch)>Math.abs(yaw) && pitch > 2000);
  boolean left = (Math.abs(pitch)>Math.abs(yaw) && pitch < -2000);
  boolean up = (Math.abs(pitch)<Math.abs(yaw) && pitch < -2000);
  boolean down = (Math.abs(pitch)<Math.abs(yaw) && pitch > 2000);



  if (right) {
    vel=1;
  } else if (left) {
    vel=-1;
  } else if (up) {
    vel=-1;
  } else if (down) {
    vel=1;
  } else { 
    vel=0;
  }
}