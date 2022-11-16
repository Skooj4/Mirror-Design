import processing.video.*;
import processing.net.*;

JSONObject json;

JSONObject news;

Capture cam;

Table calendar;

int startTime;
int totalTime = 10;

int i = 0;

void setup(){
  size(800, 500);
   
  cam = new Capture(this, 800, 500);
  
  // Start capturing the images from the camera
  cam.start();  

  background(0);
  
  //calendar = loadTable("Calendar.csv", "header");
  
  int startTime = second();
  int newTime = startTime;
  
  json = loadJSONObject("https://api.openweathermap.org/data/2.5/weather?lat=33.577&lon=-101.855&appid=392eb2b620fd02b1b79ce568ae594ec4");
  news = loadJSONObject("https://newsapi.org/v2/top-headlines?country=us&apiKey=8bb1b68765374520a1c7c58e90f5eede");
}

void draw(){
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
  background(150, 150, 150);
  
  //image(cam, 0, 0, width, height);
  
  int clockhour = hour();
  int clockminute = minute();
  
  fill(0, 0, 0, 0);
  rect(0, 1, 799, 498);
  
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
  text(str(passedTime), 735, 490);
}
