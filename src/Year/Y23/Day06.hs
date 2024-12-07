{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Year.Y23.Day06 where

import Control.Applicative (Alternative (..))
import Data.Text (Text)
import Day (AoC, PartStatus (..), mkAoC)
import Parsers
import Text.Megaparsec hiding (some)
import Text.Megaparsec.Char
import Text.Megaparsec.Char.Lexer qualified as L
import Utils (readConcat)

partA :: [(Int, Int)] -> PartStatus Int
partA xs = Solved . product $ map numWins xs

partB :: [(Int, Int)] -> PartStatus Int
partB xs = Solved $ numWins (readConcat (map fst xs), readConcat (map snd xs))

numWins :: (Int, Int) -> Int
numWins (a, b) = abs (x1 - x2) + 1
  where
    t = fromIntegral a :: Double
    d = fromIntegral b
    delta = t * t - 4 * d
    x1 = ceiling $ (t + sqrt delta) / 2 - 1
    x2 = 1 + floor ((t - sqrt delta) / 2)

parser :: Parser [(Int, Int)]
parser = zip <$> lineParser "Time:" <*> lineParser "Distance:"
  where
    lineParser :: Parser Text -> Parser [Int]
    lineParser t = lexeme t >> some (lexeme L.decimal) <* optional eol

day06 :: AoC [(Int, Int)] Int
day06 = mkAoC parser partA partB 6 2023
