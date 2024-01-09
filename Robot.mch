/* Robot
 * Author: Thuwarakan
 * Creation date: 1/6/2023
 */
MACHINE Robot

// use Maze machine in this machine 
SEES
    Maze
    
SETS
    //Set, which contains all the success and error messages. 
    REPORT = {
        Successfully_Moved_North, 
        Successfully_Moved_East, 
        Successfully_Moved_South, 
        Successfully_Moved_West,
        Cannot_Exceed_The_Maze_Boundary,
        Cannot_Move_On_The_Internal_Maze_Wall, 
        Cannot_Move_You_Reached_Exit_Square,
        Cannot_Teleport_Immediately, 
        Cannot_Teleport_To_The_Same_Square, 
        Successfully_Teleported, 
        yes, 
        no,
        Game_Over_You_Won_The_Game
    }               

VARIABLES
    // indicate the x axis position of robot.
    xPosition,
    
    // indicate the y axis position of robot.
    yPosition,
    
    //keep records of the square currently robot placed 
    currentSquare,
    
    //array that contains all the squares that the robot visited.
    visitedSquares
    
INVARIANT
    // Always keep the robot's x-axis between 1 and 7(xAxisRange).
    xPosition : xAxisRange &
    
    // Always keep the robot's y-axis between 1 and 5(yAxisRange).
    yPosition : yAxisRange &
    
    // current position of the Robot (maplet (x |-> y)) is an element of the maze
    currentSquare : maze &
    
    // squares which have been visited by the Robot is stored as a sequence of Maze maplets 
    visitedSquares : seq(maze)
    
INITIALISATION
    // The robot will begin at the start point (1, 1).
    xPosition := 1 ||
    yPosition := 1 ||
    currentSquare := ( 1 |-> 1 ) ||
    visitedSquares := [( 1 |-> 1 )] 

OPERATIONS
    
    // This function directs the robot to one square west.
    report <-- MoveEast = 
        PRE report : REPORT
        THEN
            IF (currentSquare : endPoint)
            THEN 
                report := Cannot_Move_You_Reached_Exit_Square
            ELSIF (xPosition + 1 > max(xAxisRange))
            THEN 
                report := Cannot_Exceed_The_Maze_Boundary
            ELSIF ((xPosition + 1 |-> yPosition) : internalWalls) 
            THEN 
                report := Cannot_Move_On_The_Internal_Maze_Wall
            ELSE
                visitedSquares := (visitedSquares <- (xPosition + 1 |-> yPosition)) ||
                currentSquare := (xPosition + 1 |-> yPosition) ||
                xPosition := xPosition + 1 ||
                report := Successfully_Moved_East
            END
        END;
     
    // This function directs the robot to one square south.
    report <-- MoveSouth = 
        PRE report : REPORT
        THEN
            IF (currentSquare : endPoint)
            THEN 
                report := Cannot_Move_You_Reached_Exit_Square
            ELSIF (yPosition - 1 < min(yAxisRange))
            THEN 
                report := Cannot_Exceed_The_Maze_Boundary
            ELSIF ((xPosition |-> yPosition - 1) : internalWalls) 
            THEN 
                report := Cannot_Move_On_The_Internal_Maze_Wall
            ELSE 
                visitedSquares := (visitedSquares <- (xPosition |-> yPosition - 1)) ||
                currentSquare := (xPosition |-> yPosition - 1) ||
                yPosition := yPosition - 1 ||
                report := Successfully_Moved_South
            END        
        END;
    
    // This function directs the robot to one square north.
    report <-- MoveNorth = 
        PRE report : REPORT
        THEN
            IF (currentSquare : endPoint)
            THEN 
                report := Cannot_Move_You_Reached_Exit_Square
            ELSIF (yPosition + 1 > max(yAxisRange))
            THEN 
                report := Cannot_Exceed_The_Maze_Boundary
            ELSIF ((xPosition |-> yPosition + 1) : internalWalls) 
            THEN 
                report := Cannot_Move_On_The_Internal_Maze_Wall
            ELSIF ((xPosition |-> yPosition + 1) : endPoint) 
            THEN
                visitedSquares := (visitedSquares <- (xPosition |-> yPosition + 1)) ||
                currentSquare := (xPosition |-> yPosition + 1) ||
                yPosition := yPosition + 1 ||
                report := Game_Over_You_Won_The_Game
            ELSE 
                visitedSquares := (visitedSquares <- (xPosition |-> yPosition + 1)) ||
                currentSquare := (xPosition |-> yPosition + 1) ||
                yPosition := yPosition + 1 ||
                report := Successfully_Moved_North
            END
        END;

     // This function directs the robot to one square west.
     report <-- MoveWest = 
            PRE report : REPORT
            THEN
                IF (currentSquare : endPoint)
                THEN 
                    report := Cannot_Move_You_Reached_Exit_Square
                ELSIF (xPosition - 1 < min(xAxisRange))
                THEN 
                    report := Cannot_Exceed_The_Maze_Boundary
                ELSIF ((xPosition - 1 |-> yPosition) : internalWalls) 
                THEN 
                    report := Cannot_Move_On_The_Internal_Maze_Wall
                ELSE 
                    visitedSquares := (visitedSquares <- (xPosition - 1 |-> yPosition)) ||
                    currentSquare := (xPosition - 1 |-> yPosition) ||
                    xPosition := xPosition - 1 ||
                    report := Successfully_Moved_West
                END
            END;


     // this function use to teleport robot  
     report <-- Teleport(teleportXPosition, teleportYPosition) =
            PRE report : REPORT & teleportXPosition : NATURAL1 & teleportYPosition : NATURAL1
            THEN
                IF (size(visitedSquares) = 1) 
                THEN 
                    report := Cannot_Teleport_Immediately
                ELSIF (currentSquare : endPoint)
                THEN 
                    report := Cannot_Move_You_Reached_Exit_Square
                ELSIF ((teleportXPosition |-> teleportYPosition) : internalWalls)
                THEN 
                    report := Cannot_Move_On_The_Internal_Maze_Wall
                ELSIF (teleportXPosition = xPosition & teleportYPosition = yPosition)
                THEN
                    report := Cannot_Teleport_To_The_Same_Square
                ELSIF ((teleportXPosition |-> teleportYPosition) /: maze)
                THEN
                    report := Cannot_Exceed_The_Maze_Boundary
                ELSE
                    visitedSquares := (visitedSquares <- (teleportXPosition |-> teleportYPosition)) ||
                    currentSquare := (teleportXPosition |-> teleportYPosition) ||
                    xPosition := teleportXPosition ||
                    yPosition := teleportYPosition ||
                    report := Successfully_Teleported
                END
            END;


     position <-- getPosition =
            BEGIN 
            position := currentSquare
            END;


     enquiry <-- foundExit = 
            PRE enquiry : REPORT
            THEN
                // Checks if the robot's current position is the exit square
                IF (currentSquare : endPoint)
                THEN 
                    enquiry := yes
                ELSE 
                    enquiry := no
                END
            END;


     visited <-- visitedSquare(visitedXPosition, visitedYPosition) =
            PRE visited : REPORT & visitedXPosition : NATURAL1 & visitedYPosition : NATURAL1
            THEN
                IF ((visitedXPosition |-> visitedYPosition) : maze)
                THEN 
                    IF ((visitedXPosition |-> visitedYPosition) : ran(front(visitedSquares)))
                    THEN 
                        visited := yes
                    ELSE
                        visited := no
                    END
                ELSE
                    visited := Cannot_Exceed_The_Maze_Boundary
                END
            END;


     route <-- robotsRoute =
            BEGIN
                route := visitedSquares
            END;
            
     //function which use to reset the game
     resetGame =
            BEGIN
                xPosition := 1 ||
                yPosition := 1 ||
                currentSquare := ( 1 |-> 1 ) ||
                visitedSquares := [( 1 |-> 1 )] 
            END
                
END
