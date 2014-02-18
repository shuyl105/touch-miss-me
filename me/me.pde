import spacebrew.*;

String server= "sandbox.spacebrew.cc";
String name="MEEEE";
String description ="";

PFont fontType; 
PImage heart;
boolean love = false;

Spacebrew sb;

void setup(){
  size(500,400);
  rectMode(CENTER);
  //text
  fontType = loadFont("ChalkboardSE-Bold-48.vlw");  
  textFont(fontType);
  textAlign(CENTER, CENTER); 
  //image
  imageMode(CENTER);
  heart = loadImage("Heart.png");
  
  sb = new Spacebrew( this );
  sb.addPublish ("p5Point", "point2d", "\"x\":0, \"y\":0");
  sb.addSubscribe ("p5Point", "point2d");
  sb.connect(server, name, description);
}

PVector localPoint = new PVector(0,0);
PVector remotePoint = new PVector(0,0);
JSONObject outgoing = new JSONObject();

void draw(){
  localPoint.set(mouseX, mouseY);
  
  background(250, 250, 240);
  fill(200);
  text("Touch Me!", width/2, height/2);
  
  //me: pink
  noStroke();
  fill(255, 95, 155);
  ellipse(localPoint.x, localPoint.y, 30,30);
  //you: blue
  fill(95, 155, 255);
  ellipse(remotePoint.x, remotePoint.y, 30,30);
  //drawing love heart
  if(love == true){
    fill(250, 250, 240);
    rect(width/2, height/2, 500, 400);
    fill(0);
    text("I Miss You<3", width/2, height/2);
    image(heart, random(125, 375),random(100, 300));
  }
  outgoing.setInt("x", mouseX);
  outgoing.setInt("y", mouseY);
  
  sb.send("p5Point", "point2d", outgoing.toString());
//println("localX: " + localPoint.x + "localY: " + localPoint.y);
//println("remoteX: " + remotePoint.x + "remoteY: " + remotePoint.y);
//println(localPoint);
  if(dist(localPoint.x, localPoint.y, remotePoint.x, remotePoint.y)<10){
    love = true;
  }else{
    love = false;
  }
}


void onCustomMessage( String name, String type, String value ){
  if ( type.equals("point2d") ){
    // parse JSON!
    JSONObject m = JSONObject.parse( value );
    remotePoint.set( m.getInt("x"), m.getInt("y"));
  }
}
