{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Day.Day12 where

import Data.MemoTrie (HasTrie (..), Reg, enumerateGeneric, memo2, trieGeneric, untrieGeneric)
import Day (AoC, mkAoC)
import Parsers
import Text.Megaparsec hiding (some)
import Text.Megaparsec.Char hiding (string)
import Universum

data Spring = Operational | Damaged | Unknown deriving stock (Show, Eq, Ord, Generic)

instance HasTrie Spring where
  newtype Spring :->: a = SpringTrie {unSpringTrie :: Reg Spring :->: a}
  trie = trieGeneric SpringTrie
  untrie = untrieGeneric unSpringTrie
  enumerate = enumerateGeneric unSpringTrie

partA :: [([Spring], [Int])] -> Int
partA xs = sum $ map (uncurry memo) xs

partB :: [([Spring], [Int])] -> Int
partB xs = sum $ map (uncurry memo . unfold) xs

unfold :: ([Spring], [Int]) -> ([Spring], [Int])
unfold (springs, nums) = (intercalate [Unknown] (replicate 5 springs), concat $ replicate 5 nums)

parser :: Parser [([Spring], [Int])]
parser = flip sepBy eol $ do
  springs <- some (choice [Operational <$ char '.', Damaged <$ char '#', Unknown <$ char '?']) <* hspace
  nums <- number `sepBy` char ','
  pure (springs, nums)

memo :: [Spring] -> [Int] -> Int
memo = memo2 go
  where
    go :: [Spring] -> [Int] -> Int
    go xs [] = if Damaged `notElem` xs then 1 else 0
    go [] _ = 0
    go (Operational : xs) ns = memo xs ns
    go (Damaged : xs) (n : ns) = damaged (splitAt (n - 1) xs) (n - 1) ns
    go (Unknown : xs) ns = memo (Operational : xs) ns + memo (Damaged : xs) ns
    damaged :: ([Spring], [Spring]) -> Int -> [Int] -> Int
    damaged (left, x : right) n ns | length left == n, Operational `notElem` left, x /= Damaged = memo right ns
    damaged (left, []) n ns | length left == n, Operational `notElem` left = memo [] ns
    damaged _ _ _ = 0

day12 :: AoC
day12 = mkAoC parser partA partB 12 2023
