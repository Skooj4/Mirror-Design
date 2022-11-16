import processing.video.*;
import processing.net.*;

JSONObject json;

JSONObject news;

Capture cam;

Table calendar;

int startTime;
int totalTime = 10;

int i = 0;

int r, g, b, a = 0;
color c = color(r, g, b, a);

int rectW, rectH = 25;
boolean overBrighten = false;
boolean overDimmer = false;
boolean overRed = false;
boolean overBlue = false;
boolean overGreen = false;

void setup(){
  size(800, 500);
   
  cam = new Capture(this, 800, 500);
  
  // Start capturing the images from the camera
  cam.start();  

  background(150, 150, 150);
  
  calendar = loadTable("Calendar.csv", "csv");
  
  int startTime = second();
  int newTime = startTime;
  
  json = loadJSONObject("https://api.openweathermap.org/data/2.5/weather?lat=33.577&lon=-101.855&appid=392eb2b620fd02b1b79ce568ae594ec4");
  news = loadJSONObject("https://newsapi.org/v2/top-headlines?country=us&apiKey=8bb1b68765374520a1c7c58e90f5eede");
}

void draw(){
  update(mouseX, mouseY);
  background(150, 150, 150);
  
  if (cam.available()) {
    cam.read();
  }
  
  JSONObject weatherdata = json.getJSONObject("main"); //this section handels all the weather API calls
  
  int temp = weatherdata.getInt("temp");
  int realfeel = weatherdata.getInt("feels_like");
  int max = weatherdata.getInt("temp_max");
  int min = weatherdata.getInt("temp_min");
  
  realfeel = int((realfeel - 273.15) * 9/5 + 32);
  max = int((max - 273.15) * 9/5 + 32);
  min = int((min - 273.15) * 9/5 + 32);
  temp = int((temp - 273.15) * 9/5 + 32);
  
  
  int passedTime = second() - startTime;
  if (passedTime > totalTime){
   i = i + 1;
   if (i == 11){
     i = 0;
   }
   startTime = second();
  }
    
  JSONArray newsfeed = news.getJSONArray("articles"); // this handles the news feed
  JSONObject headlines = newsfeed.getJSONObject(i);
  String titles = headlines.getString("title");
  
  image(cam, 0, 0, width, height);
  
  int clockhour = hour();
  int clockminute = minute();
  
  textSize(30);
  fill(100, 185, 255);
  text(clockhour, 353, 45);
  
  textSize(30);
  fill(100, 185, 255);
  text(':', 385, 43);
  
  textSize(30);
  fill(100, 185, 255);
  text(clockminute, 392, 45);
  
  textSize(15);
  fill(100, 185, 255);
  text("Temperature:", 35, 50);
  
  textSize(30);
  fill(100, 185, 255);
  text(temp, 55, 35);
  
  textSize(15);
  fill(100, 185, 255);
  text("Real feel of:", 15, 75);
  
  textSize(15);
  fill(100, 185, 255);
  text(realfeel, 96, 75);
  
  textSize(15);
  fill(100, 185, 255);
  text("High of:", 15, 90);
  
  textSize(15);
  fill(100, 185, 255);
  text(max, 96, 90);
  
  textSize(15);
  fill(100, 185, 255);
  text("Low of:", 15, 105);
  
  textSize(15);
  fill(100, 185, 255);
  text(min, 96, 105);
  
  textSize(15);
  fill(100, 200, 255);
  text(titles, 15, 200, 210, 130);

  textSize(30);
  fill(100, 200, 255);
  text("ellapsed time: ", 550, 490);
  
  textSize(30);
  fill(100, 200, 255);
  text(str(int(millis()/1000)), 735, 490);
  
  textSize(15);
  fill(100, 200, 255);
  text("No Calendar Events.", 640, 35);
    
  stroke(r, g, b, a);
  fill(0, 0, 0, 0);
  strokeWeight(10);
  rect(0, 1, 799, 498);
  
  strokeWeight(0);        //rect draw for rgb buttons
  fill(200, 200, 200);
  rect(20, 455, 25, 25);
  
  fill(100, 100, 100);
  rect(50, 455, 25, 25);
  
  fill(0, 0, 255);
  rect(80, 455, 25, 25);
  
  fill(0, 255, 0);
  rect(110, 455, 25, 25);
  
  fill(255, 0, 0);
  rect(140, 455, 25, 25);
}

void update(int x, int y) {
  if ( mouseOverBrighten(20, 455, rectW, rectH) ) {
    overBrighten = true;
    overDimmer = overRed = overGreen = overBlue = false;
    
  } else if ( mouseOverDimmer(50, 455, rectW, rectH) ) {
    overDimmer = true;
    overBrighten = overGreen = overBlue = overRed = false;
    
  } else if ( mouseOverRed(80, 455, rectW, rectH) ) {
    overGreen = true;
    overBrighten = overDimmer = overBlue = overRed = false;
    
  } else if ( mouseOverBlue(110, 455, rectW, rectH) ) {
    overBlue = true;
    overBrighten = overDimmer = overGreen = overRed = false;
    
  } else if ( mouseOverGreen(140, 455, rectW, rectH) ) {
    overGreen = true;
    overBrighten = overDimmer = overBlue = overRed = false;
    
  } else {
    overBrighten = overDimmer = overGreen = overBlue = overRed = false;
  }
}

void mousePressed() {
  if (overBrighten) {
    a = a + 10;
    if(a > 255){
     a = 255;
    }
  }
  if (overDimmer) {
    a = a - 10;
    if(a < 0){
      a = 0;
    }
  }
    if (overRed) {
    r = r + 10;
    if(r > 255){
     r = 0; 
    }
  }
    if (overBlue) {
    b = b + 10;
    if(b > 255){
     b = 0; 
    }
  }
    if (overGreen) {
    g = g + 10;
    if(g > 255){
     g = 0;
    }
  }
}

boolean mouseOverBrighten(int x, int y, int width, int height)  {
  if (mouseX >= 20 && mouseX <= 45 && mouseY >= 455 && mouseY <= 455 + 25) {
    return true;
  } else {
    return false;
  }
}

boolean mouseOverDimmer(int x, int y, int width, int height)  {
  if (mouseX >= 50 && mouseX <= 75 && mouseY >= 455 && mouseY <= 455 + 25) {
    return true;
  } else {
    return false;
  }
}

boolean mouseOverGreen(int x, int y, int width, int height)  {
  if (mouseX >= 80 && mouseX <= 105 && mouseY >= 455 && mouseY <= 455 + 25) {
    return true;
  } else {
    return false;
  }
}

boolean mouseOverBlue(int x, int y, int width, int height)  {
  if (mouseX >= 110 && mouseX <= 135 && mouseY >= 455 && mouseY <= 455 + 25) {
    return true;
  } else {
    return false;
  }
}

boolean mouseOverRed(int x, int y, int width, int height)  {
  if (mouseX >= 140 && mouseX <= 165 && mouseY >= 455 && mouseY <= 455 + 25) {
    return true;
  } else {
    return false;
  }
}
