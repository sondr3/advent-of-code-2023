module Coordinates
  ( Dir (..),
    Position,
    Turn (..),
    turnOffset,
    turnOffsetCardinal,
    turn,
    turnCardinal,
    allDirs,
    diagonals,
    cardinals,
    move,
    line,
    allPos,
  )
where

data Turn
  = TLeft
  | TRight
  deriving stock (Show, Eq, Ord, Enum, Bounded)

turnOffset :: Turn -> Int
turnOffset TLeft = -1
turnOffset TRight = 1

turnOffsetCardinal :: Turn -> Int
turnOffsetCardinal TLeft = -2
turnOffsetCardinal TRight = 2

data Dir
  = North
  | NorthEast
  | East
  | SouthEast
  | South
  | SouthWest
  | West
  | NorthWest
  deriving stock (Show, Eq, Ord, Enum, Bounded)

turn :: Dir -> Turn -> Dir
turn dir t = toEnum $ (fromEnum dir + turnOffset t) `mod` length allDirs

turnCardinal :: Dir -> Turn -> Dir
turnCardinal dir t = toEnum $ (fromEnum dir + turnOffsetCardinal t) `mod` length allDirs

allDirs :: [Dir]
allDirs = [minBound .. maxBound]

diagonals :: [Dir]
diagonals = [NorthEast, SouthEast, SouthWest, NorthWest]

cardinals :: [Dir]
cardinals = [North, East, South, West]

type Position = (Int, Int)

move :: Position -> Dir -> Position
move (x, y) North = (x, y - 1)
move (x, y) NorthEast = (x + 1, y - 1)
move (x, y) East = (x + 1, y)
move (x, y) SouthEast = (x + 1, y + 1)
move (x, y) South = (x, y + 1)
move (x, y) SouthWest = (x - 1, y + 1)
move (x, y) West = (x - 1, y)
move (x, y) NorthWest = (x - 1, y - 1)

-- get all positions that form a line in a direction of length `n`
line :: Position -> Dir -> Int -> [Position]
line pos dir n = take n $ iterate (`move` dir) pos

-- generate all (x, y) coordinates across a grid
allPos :: Position -> Position -> [Position]
allPos (minX, minY) (maxX, maxY) = [(x, y) | x <- [minX .. maxX], y <- [minY .. maxY]]
