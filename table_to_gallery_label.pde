
// https://www.processing.org/tutorials/data/


import processing.pdf.*;
import java.util.*;
import java.text.*;

// set debug = 1 to show boxes where label edges are
int debug = 0;

// you can left and top justify - if not the text will be centered
int leftJustify = 1;
int topJustify = 1;

// how many labels per page? (assumes 2 wide)
int cellsPerPage = 10;

// set the location of the labels 
// - xMargin, labelW, xInnerMargin, labelW, xMargin
// - yMargin, labelH, yInnerMargin, labelH, yMargin
float xMargin = 0.1875; //(3 / 16); // .1875
float yMargin = 0.5;
float xInnerMargin = .125; //(2 / 16); // .125
float yInnerMargin = 0;

// size of the labels
float labelW = 4;
float labelH = 2;

// default margin on labels
// - topJustify and leftJustify default to this
// - also used to calculate text width and height
float defaultPad = 0.4;
float labelPadW = defaultPad;
float labelPadH = defaultPad;

// set your font size and line height
int fontSize = 14;
float lineHeight = 1.4 * fontSize;
float leading = lineHeight - 1;

// used below to count how many lines the formatted text takes up
int wrapLines = 0;

// initialize the normal and italic fonts - fonts determined in setup()
PFont normal, italic;

// generate a date string to time stamp our files
DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss");
Date d = new Date();
String filename = "labels " + formatter.format(d) + ".pdf";

// where are we getting our form results? set to export as TSV from google form results
String formResults = "https://docs.google.com/spreadsheets/d/e/2PACX-1vQRq2C8Yfve5KFET2jNRjsVjHS0Iwv8uzFZsgWgDboIJ4ECKAavsEaPPKatqTywPpOHKqiTP1CQyIaN/pub?gid=1933511128&single=true&output=tsv";



void setup() {  
  
  size(612, 792, PDF, filename);

  normal = createFont("Arial", fontSize);
  italic = createFont("Arial-ItalicMT", fontSize);
  
  noLoop();
  
}
    
void draw() {  
  background(255);  
  

  
  //Table table = loadTable("https://docs.google.com/spreadsheets/d/e/2PACX-1vQRq2C8Yfve5KFET2jNRjsVjHS0Iwv8uzFZsgWgDboIJ4ECKAavsEaPPKatqTywPpOHKqiTP1CQyIaN/pub?gid=1933511128&single=true&output=tsv", "header,tsv");
  Table table = loadTable(formResults, "header,tsv");

  int cell = 0;
  int firstPage = 1;

  for (int i = 0; i<table.getRowCount(); i++) {
  
    // Access each row of the table one at a time, in a loop.
    TableRow Row = table.getRow(i);
    String artist = Row.getString(2);
    String title = Row.getString(3);
    String extra = Row.getString(7);
    String medium = Row.getString(4);
    String date = Row.getString(5);
    int printed = Row.getInt(8);
    
    if(printed == 1) { continue; }
    
    // start new page if we're at the first cell on a page and it isn't the first page
    if(cell == 0 && firstPage != 1) {
      PGraphicsPDF pdf = (PGraphicsPDF) g;
      pdf.nextPage();
    }
    // it's not the first page next time - add page breaks from now on as necessary
    firstPage = 0;
    
   
    
    int col = cell % 2;
    int row = floor(float(cell) / 2);
    
    // Do something with the data of each row
    println(artist); // + "\n");
    println(title);
    println(extra);
    println(medium);
    println(date);
    //println(printed);
    //println("cell " + cell + ": " + col + "," + row);
    println("");
    
    textSize(fontSize);
    textLeading(2);
    fill(0, 0, 0);    
    
    
    int thisLine = 0;
    int artistLine = 0;
    int titleLine = 0;
    int extraLine = 0;
    int mediumLine = 0;
    int dateLine = 0;
    
    // figure out how many lines we have and where they land
    textFont(normal);
    artist = wrapText(artist);
    artistLine = thisLine;
    //placeText(artist, col, row, thisLine);
    thisLine += wrapLines;
    
    
    textFont(italic); 
    title = wrapText(title);
    titleLine = thisLine;
    //placeText(title, col, row, thisLine);
    thisLine += wrapLines;
    
    textFont(normal);
    extra = wrapText(extra);
    extraLine = thisLine;
    //placeText(title, col, row, thisLine);
    thisLine += wrapLines;
    
    textFont(normal);
    medium = wrapText(medium);
    mediumLine = thisLine;
    //placeText(medium, col, row, thisLine);
    thisLine += wrapLines;
    
    textFont(normal);
    date = wrapText(date);
    dateLine = thisLine;
    //placeText(date, col, row, thisLine);
    thisLine += wrapLines;
    
    // how many lines total?
    println(thisLine + " lines");
    
    
    // figure out the labelPadW to center the text, up to 1 inch margin max
    // assumes the text has already been wrapped to defaultPad padding
    String wholeText = artist + "\n" + title + "\n" + extra + "\n" + medium + "\n" + date;
    float textWidth = textWidth(wholeText);
    println("textWidth: " + textWidth);
    //labelPadW = min(1, (labelW - pointsToInches(textWidth)) / 2);
    labelPadW = min(1, (labelW - pointsToInches(textWidth)) / 2);
    
    if(leftJustify == 1) {
      labelPadW = defaultPad;
    }  
    println("labelPadW: " + labelPadW);
    
    int textHeight = round(thisLine * lineHeight);
    println("textHeight: " + textHeight);
    labelPadH = (labelH - pointsToInches(textHeight)) / 2;
    
    if(topJustify == 1) {
      labelPadH = defaultPad;
    }  
    println("labelPadH: " + labelPadH);

    
    
    // place all the lines
    textFont(normal); textLeading(leading);
    placeText(artist, col, row, artistLine);
    
    textFont(italic); textLeading(leading);
    placeText(title, col, row, titleLine);
    
    textFont(normal); textLeading(leading);
    placeText(extra, col, row, extraLine);
    
    textFont(normal); textLeading(leading);
    placeText(medium, col, row, mediumLine);
    
    textFont(normal); textLeading(leading);
    placeText(date, col, row, dateLine);
    
    
    
    // set padding back to calculate next label at full size
    labelPadW = defaultPad;
    labelPadH = defaultPad;
    
    
    
    cell = (cell + 1) % cellsPerPage;
    
    /*
    if(cell == 0) {
      PGraphicsPDF pdf = (PGraphicsPDF) g;
      pdf.nextPage();
    }
    */
    
    println("");
    
  
  }  
  
  //println(PFont.list());
  
  // Exit the program 
  println("Finished.");
  exit();
  
}

int inchesToPoints(float inches) {
  return round(inches * 72);
  
}

float pointsToInches(float points) {
  return points / 72;
}


void placeText(String text, int col, int row, int line) {
    
    if(debug == 1) {
      noFill();
      stroke(200);
      rect(inchesToPoints(xMargin + (col * (labelW + xInnerMargin))),
          inchesToPoints(yMargin + (row * (labelH + yInnerMargin))),
          inchesToPoints(labelW),
          inchesToPoints(labelH)
        );
      fill(0);
      stroke(0);
      
    }
      
          
    text(text, 
      inchesToPoints(xMargin + labelPadW + (col * (labelW + xInnerMargin))), 
      inchesToPoints(yMargin + labelPadH + (row * (labelH + yInnerMargin))) + (line * lineHeight) + fontSize
      ); 

      
      

      
}

String wrapText(String text) {
  
  wrapLines = 1;
  
  int wrapW = inchesToPoints(labelW - (labelPadW * 1.8));  
  
  if(text.length() == 0) {
    //println("empty field");
    wrapLines = 0;
    return text;
  }
  
  String wrapped = "";
  
  //String lastLine = text.substring(0, indexOf(" ");
  //String line = "";
  
  String[] list = split(text, " ");
  
  for (int i = 0; i < list.length; i++) {
    if(textWidth(wrapped + " " + list[i]) > wrapW) {
      wrapped += "\n   " + list[i];
      wrapLines++;
    } else {
      wrapped += (i == 0 ? "" : " ") + list[i];
    }
  }
  
  return wrapped;
  
}
