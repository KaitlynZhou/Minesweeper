import de.bezier.guido.*;
//constants (all capital)
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
//-------------------------------------------------------------------------------------------------------------------------------------------------
void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r<NUM_ROWS; r++) {
    for (int c = 0; c<NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  int mineC=0;
  while (mineC<40) {
    setMines();
    mineC++;
  }
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
public void setMines()
{
  //your code
  int rMine = (int)(Math.random()*NUM_ROWS);
  int cMine = (int)(Math.random()*NUM_COLS);
  if (!mines.contains(buttons[rMine][cMine]))
    mines.add(buttons[rMine][cMine]);
  System.out.println(rMine+", "+cMine);
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
public boolean isWon()
{
  //your code here
  for (int r =0; r<NUM_ROWS; r++) {
    for (int c =0; c<NUM_COLS; c++) {
      if (!mines.contains(buttons[r][c])&&buttons[r][c].clicked==false) {
        return false;
      }
    }
  }
  return true;
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
public void displayLosingMessage()
{
  //your code here
  for(int i = 0; i<NUM_ROWS; i++){
    for(int j = 0; j<NUM_COLS; j++){
      if(mines.contains(buttons[i][j])&&buttons[i][j].clicked==false) 
        fill(255, 0, 0);
    }
  }
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("0");
  buttons[9][8].setLabel("U");
  buttons[9][10].setLabel("L");
  buttons[9][11].setLabel("0");
  buttons[9][12].setLabel("S");
  buttons[9][13].setLabel("E");
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
public void displayWinningMessage()
{
  //your code here
  buttons[9][7].setLabel("Y");
  buttons[9][8].setLabel("0");
  buttons[9][9].setLabel("U");
  buttons[9][11].setLabel("W");
  buttons[9][12].setLabel("I");
  buttons[9][13].setLabel("N");
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
public boolean isValid(int r, int c)
{
  //your code here
  if (r<0 || c<0)
    return false;
  if (r<NUM_ROWS && c<NUM_COLS)
    return true;
  return false;
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  for (int r = row-1; r<=row+1; r++) {
    for (int c = col-1; c<=col+1; c++) {
      if (isValid(r, c)) {
        if (mines.contains(buttons[r][c])&&!(r==row&&c==col))
          numMines++;
      }
    }
  }
  //System.out.println(numMines);
  return numMines;
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;
  //~~~~~~~~~~~~~~~
  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  //~~~~~~~~~~~~~~~
  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if (mouseButton==RIGHT) {
      flagged = !flagged;
      if (flagged==false)
        clicked=false;
    } else if (mines.contains(this))
      displayLosingMessage();
    else if (countMines(myRow, myCol)>0) {
      clicked=true;
      setLabel(""+countMines(myRow, myCol));
    } else {
      //call mousePressed for the blob on left
      clicked = true;
      for (int i = myRow-1; i<=myRow+1; i++) {
        for (int j = myCol-1; j<=myCol+1; j++) {
          if (isValid(i, j) && !buttons[i][j].clicked) {
            buttons[i][j].mousePressed();
          }
        }
      }
    }
  }
  //~~~~~~~~~~~~~~~
  public void draw () 
  {    
    if (flagged)
      fill(0,255,0);
    else if (clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  //~~~~~~~~~~~~~~~
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  //~~~~~~~~~~~~~~~
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  //~~~~~~~~~~~~~~~
  public boolean isFlagged()
  {
    return flagged;
  }
}
