/* Maze
 * Author: Thuwarakan
 * Creation date: 1/7/2023
 */
MACHINE Maze
    
CONSTANTS
    xAxisRange,
    yAxisRange,
    maze,
    internalWalls,
    startPoint,
    endPoint
    
PROPERTIES
    // The x axis ranges from 1 to 7. 
    xAxisRange <: NATURAL1 & xAxisRange = 1..7 &
    
    // The y axis ranges from 1 to 5. 
    yAxisRange <: NATURAL1 & yAxisRange = 1..5 &
    
    // maze is an element of the relation between x axis range and the y axis range (x |-> y)
    maze : xAxisRange <-> yAxisRange &
    
    // Defining the maze
    maze = xAxisRange * yAxisRange &
     
    // Internal walls are associated with the relationships between the x and y axes.
    internalWalls : xAxisRange <-> yAxisRange &
    
    // Defining the internal walls
    internalWalls = {
        (2 |-> 1), (6 |-> 1), (4 |-> 2), (6 |-> 2), (1 |-> 3), (2 |-> 3), (3 |-> 3), (4 |-> 3), (4 |-> 4), (6 |-> 4), (7 |-> 4), (2 |-> 5)
    } &
    
    // Defining the start point 
    startPoint : xAxisRange <-> yAxisRange &
    startPoint = {(1 |-> 1)} &
    
    // Defining the end point 
    endPoint : xAxisRange <-> yAxisRange &
    endPoint = {(1 |-> 5)}    

END
