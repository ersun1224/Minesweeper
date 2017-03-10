import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 22;
public final static int NUM_COLS = 22;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++) {
        for(int c = 0; c < NUM_COLS; c++) {
            buttons[r][c] = new MSButton(r,c);
        }
    }
    
    
    setBombs();
}
public void setBombs()
{
    bombs = new ArrayList <MSButton>();
    while(bombs.size() < 50) {
        int r = (int)(Math.random()*NUM_ROWS);
        int c = (int)(Math.random()*NUM_COLS);
        if(!bombs.contains(buttons[r][c])) {
            bombs.add(buttons[r][c]);
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int clickedCount = 0;
    for(int r = 0; r < NUM_ROWS; r++) {
        for(int c = 0; c < NUM_COLS; c++) {
            if(buttons[r][c].clicked == true) {
                clickedCount++;
            }
        }
    }


    if(bombs.size() == (NUM_ROWS*NUM_COLS - clickedCount)) {
        return true;
    }
    //your code here
    return false;
}
public void displayLosingMessage()
{
    //your code here
    for(int r = 0; r < NUM_ROWS; r++) {
        for(int c = 0; c < NUM_COLS; c++) {
            if(bombs.contains(buttons[r][c])) {
                buttons[r][c].clicked = true;
            }
            buttons[r][c].setLabel("");
        }
    }

    buttons[11][7].setLabel("Y");
    buttons[11][8].setLabel("O");
    buttons[11][9].setLabel("U");
    buttons[11][10].setLabel(" ");
    buttons[11][11].setLabel("L");
    buttons[11][12].setLabel("O");
    buttons[11][13].setLabel("S");
    buttons[11][14].setLabel("E");
}
public void displayWinningMessage()
{
    //your code here
    for(int r = 0; r < NUM_ROWS; r++) {
        for(int c = 0; c < NUM_COLS; c++) {
            if(bombs.contains(buttons[r][c])) {
                buttons[r][c].clicked = true;
            }
            buttons[r][c].setLabel("");
        }
    }
    buttons[11][7].setLabel("Y");
    buttons[11][8].setLabel("O");
    buttons[11][9].setLabel("U");
    buttons[11][10].setLabel(" ");
    buttons[11][11].setLabel("W");
    buttons[11][12].setLabel("I");
    buttons[11][13].setLabel("N");
    buttons[11][14].setLabel("ツ");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        if(mouseButton == LEFT && marked == true) { //do nothing if marked
        }
        if(mouseButton == RIGHT && clicked == true ) { //do nothing if trying to mark clicked box
        }
        if(mouseButton == RIGHT && clicked == false) { //mark uncleared box
           marked = !marked;
        }
        if(mouseButton == LEFT && marked == false) { // the standard click //at this point, the box must be unclicked and unmarked
            clicked = true;
            if(bombs.contains(this)) {
                displayLosingMessage();
            }
            if(countBombs(r,c) > 0) {// numnBombs > 0, display the number adjacent to it
                setLabel(""+countBombs(r,c));
            } 
            if(countBombs(r,c) == 0 && !bombs.contains(this)) { // recursively call the mousePressed function on all adjacent tiles
                if(isValid(r-1,c-1) && buttons[r-1][c-1].clicked == false) {
                    buttons[r-1][c-1].mousePressed();
                }
                if(isValid(r-1,c) && buttons[r-1][c].clicked == false) {
                    buttons[r-1][c].mousePressed();
                }
                if(isValid(r-1,c+1) && buttons[r-1][c+1].clicked == false) {
                    buttons[r-1][c+1].mousePressed();
                }
                if(isValid(r,c-1) && buttons[r][c-1].clicked == false) {
                    buttons[r][c-1].mousePressed(); 
                }
                if(isValid(r,c+1) && buttons[r][c+1].clicked == false) {
                    buttons[r][c+1].mousePressed();
                }
                if(isValid(r+1,c-1) && buttons[r+1][c-1].clicked == false) {
                    buttons[r+1][c-1].mousePressed();
                }
                if(isValid(r+1,c) && buttons[r+1][c].clicked == false) {
                    buttons[r+1][c].mousePressed();
                }
                if(isValid(r+1,c+1) && buttons[r+1][c+1].clicked == false) {
                    buttons[r+1][c+1].mousePressed();
                }
            }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 150 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        //your code here
        if((r < NUM_ROWS && r >= 0) && (c < NUM_COLS && c >= 0)) {
            return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;

        if(isValid(row-1,col-1) && bombs.contains(buttons[row-1][col-1]) == true) {
            numBombs++;
        }
        if(isValid(row-1,col) && bombs.contains(buttons[row-1][col]) == true) {
            numBombs++;
        }
        if(isValid(row-1,col+1) && bombs.contains(buttons[row-1][col+1]) == true) {
            numBombs++;
        }
        if(isValid(row,col-1) && bombs.contains(buttons[row][col-1]) == true) {
            numBombs++;
        }
        if(isValid(row,col+1) && bombs.contains(buttons[row][col+1]) == true) {
            numBombs++;
        }
        if(isValid(row+1,col-1) && bombs.contains(buttons[row+1][col-1]) == true) {
            numBombs++;
        }
        if(isValid(row+1,col) && bombs.contains(buttons[row+1][col]) == true) {
            numBombs++;
        }
        if(isValid(row+1,col+1) && bombs.contains(buttons[row+1][col+1]) == true) {
            numBombs++;
        }

        if(bombs.contains(this)) {
            numBombs = 0;
        }
        //your code here
        return numBombs;
    }
}



