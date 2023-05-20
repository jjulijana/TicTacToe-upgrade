--[[ 

    XYZ Assignment
    
    This code is the basic implementation of the XYZ game - a randomized version of Tic-Tac-Toe.

]]--


--== SIMULATION CONFIGURATIONS ==--

INTERACTIVE = false
PRINT_DEB = false

math.randomseed(os.time())
math.random()

--== GAME CONFIGURATIONS ==--

local C_samples = 100000
if PRINT_DEB then C_samples = 1 end -- on printing, sets samples to 1

local DIM = 3 -- 3x3, 4x4 etc..

local EMPTY = 1 
local X = 2
local O = 3
local SIGN={"-","X","O"} -- used for printing

local C_stats = {
    score = {0,0,0}
}


--== UTILITY FUNCTIONS ==--

local function printBoard(game)
-- debug - prints the board

    if not(PRINT_DEB) then return end
    
    dprint("____________________")
    
    for iRow = 1,DIM do
        local strRow = "  "
        for iCol = 1, DIM do
            strRow = strRow..SIGN[game.board[iRow][iCol]].."\t"
        end
        dprint("\n"..strRow)
    end
        
end

local function printWinner(game)
-- debug - prints the game's winner or announces a tie
    
    if not(PRINT_DEB) then return end
    
    dprint("____________________")
    if game.winner then
        dprint("\nWinner is "..SIGN[game.winner].."\n")
    else
        dprint("Tie :) \n")
    end
        
end

local function dprint(str)
-- debug - prints the given line

    if PRINT_DEB then print(str) end
end

local function trunc(x)
-- truncates a floating point number to 3 digits after the decimal point

    return string.format("%.3f",x)
end

local function percent(x)
-- formats a floating point number to a percentage, with 3 digits after the decimal point

    return string.format("%.3f",x*100).."%"
end

local function waitForEnter()
-- debug + interactive - waits for the user to press enter before continuing
    
    if PRINT_DEB == false then return end
    if INTERACTIVE == false then return end
    local a = io.read("*line")
end

local function printRate(winner)
-- debug - prints the X victory/O victory/tie rate of the game

    print(SIGN[winner].." rate is: "..percent(C_stats.score[winner]/C_samples))
end


--== GAME LOGIC ==--

local function createNewGame()
-- initializes a single game
-- returns game object
    
    local game = {}
    
    game.board = {} -- board is an array of rows (rows are an array of cols)
    game.moves = {} --  moves is an array of row,col i.e. {2,1},{3,3}
    
    -- initialize the pool of possible moves
    for iRow=1,DIM do
        game.board[iRow] = {}
        for iCol=1,DIM do
            game.board[iRow][iCol] = EMPTY
            table.insert(game.moves,{iRow=iRow,iCol=iCol})
        end
    end
    
    game.turn = math.random(X,O) -- initialized to the first player
    
    game.winner = nil
    
    game.iMove = 0
    
    return game
end

local function changeTurn(game)
-- changes game.turn to the next player's sign 

    if game.turn == X then 
        game.turn = O 
    else 
        game.turn = X 
    end
end

local function evaluate(game)
-- goes over all rows, columns and main diagonals
-- if one of them is covered by the current (game.turn) player's tiles - returns game.turn
-- otherwise, returns nil

    local winner = false
    
    for iRow =1,DIM do
        winner = true
        for iCol=1,DIM do
            if game.board[iRow][iCol] ~= game.turn then
                winner = false
                break
            end
        end
        if winner then return game.turn end
    end
    
    for iCol =1,DIM do
        winner = true
        for iRow =1,DIM do
            if game.board[iRow][iCol] ~= game.turn then
                winner = false
                break
            end
        end
        if winner then return game.turn end
    end
         
    winner = true
    for i=1,DIM do
        if game.board[i][i] ~= game.turn then
            winner = false
            break
        end
    end
    
    if winner then return game.turn end
    
    winner = true
    for i=1,DIM do
        if game.board[i][DIM-i+1] ~= game.turn then
            winner = false
            break
        end
    end
    
    if winner then return game.turn end
    
    return nil
end


local function playTurn(game)
-- plays a single turn, advancing game.iMove 
-- removes an available tile from the move pool and places the current player's sign on that space on the board
-- afterwards, evaluates the board and updates game.winner accordingly

    game.iMove = game.iMove + 1
    
    local nextMove = table.remove(game.moves,math.random(#game.moves))
    
    game.board[nextMove.iRow][nextMove.iCol] = game.turn
    
    game.winner = evaluate(game)
    
end

local function recordStats(game)
-- records stats for a single game

    local winner = game.winner or EMPTY
    C_stats.score[winner] = C_stats.score[winner] + 1 -- record the winner in C_score
end

local function runGame()
-- runs a single game
-- returns X, O in case of a winner, or nil in case of a tie

    local game = createNewGame()
    
    dprint("\n"..SIGN[game.turn].." is starting - Good luck!\n")
    
    while not(game.winner) and #game.moves>0 do
        waitForEnter()
        playTurn(game) -- select tile and evaluate the board
        printBoard(game) 
        changeTurn(game) -- change game.turn from X to O or vice versa
    end
    
    printWinner(game) 
    
    recordStats(game)
    
    return game.winner
    
end



--== MAIN CODE ==--

for iSample = 1,C_samples  do
    runGame()
end

for _,i in ipairs({X,O,EMPTY}) do
    printRate(i)
end


