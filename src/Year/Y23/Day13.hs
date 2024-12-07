{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Year.Y23.Day13 where

import Control.Applicative (Alternative (..))
import Data.IntMap qualified as IntMap
import Data.List (find, inits, tails, transpose)
import Data.Maybe (fromMaybe, mapMaybe)
import Day (AoC, PartStatus (..), mkAoC)
import GHC.Generics (Generic)
import Parsers
import Text.Megaparsec hiding (some)
import Text.Megaparsec.Char hiding (string)

data Pattern = Ash | Rock deriving stock (Show, Eq, Ord, Generic)

partA :: [[[Pattern]]] -> PartStatus Int
partA xs = Solved . sum $ map (calculate 0) xs

partB :: [[[Pattern]]] -> PartStatus Int
partB xs = Solved . sum $ map (calculate 1) xs

calculate :: (Eq a) => Int -> [[a]] -> Int
calculate _ grid = fromMaybe 0 $ ((* 100) <$> pivot grid) <|> pivot (transpose grid)

numPivots :: [[[Pattern]]] -> [Int]
numPivots = concatMap (mapMaybe pivot)

countPivots :: [Int] -> [(Int, Int)]
countPivots xs = IntMap.toList $ IntMap.fromListWith (+) (map (,1) xs)

pivot :: (Eq a) => [a] -> Maybe Int
pivot grid = length . fst <$> find (\(xs, ys) -> and $ mirrored xs ys) (filter (\(xs, ys) -> not (null xs) && not (null ys)) $ zip (inits grid) (tails grid))
  where
    mirrored :: (Eq b) => [b] -> [b] -> [Bool]
    mirrored xs = zipWith (==) (reverse xs)

parser :: Parser [[[Pattern]]]
parser = ((some . choice) [Ash <$ char '.', Rock <$ char '#'] `sepEndBy` eol) `sepEndBy` some eol

day13 :: AoC [[[Pattern]]] Int
day13 = mkAoC parser partA partB 13 2023
