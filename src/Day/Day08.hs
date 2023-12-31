{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Day.Day08 where

import Data.Map qualified as M
import Data.Text qualified as T
import Day (AoC, mkAoC)
import Parsers
import Text.Megaparsec hiding (some)
import Text.Megaparsec.Char hiding (string)
import Universum
import Universum.Unsafe qualified as U

data Dir = R | L deriving stock (Show, Eq, Ord)

step :: [Dir] -> Map Text (Text, Text) -> Text -> [Text]
step [] _ _ = error "impossible"
step (L : ds) m xs = xs : step ds m (fst $ m M.! xs)
step (R : ds) m xs = xs : step ds m (snd $ m M.! xs)

partA :: ([Dir], Map Text (Text, Text)) -> Int
partA (dirs, nodes) = length $ takeWhile (/= "ZZZ") $ step (cycle dirs) nodes "AAA"

partB :: ([Dir], Map Text (Text, Text)) -> Int
partB (dirs, nodes) = foldr (lcm . (length . takeWhile (not . isEndNode) . step (cycle dirs) nodes)) 1 startNodes
  where
    startNodes = filter isStartNode $ M.keys nodes
    isStartNode n = "A" `T.isSuffixOf` n
    isEndNode n = "Z" `T.isSuffixOf` n

parser :: Parser ([Dir], Map Text (Text, Text))
parser = do
  d <- dirParser <* some eol
  nodes <- M.fromList . sortWith fst <$> (nodeParser `sepBy` eol)
  pure (d, nodes)

nodeParser :: Parser (Text, (Text, Text))
nodeParser = do
  root <- string <* symbol "="
  edges <- parens (string `sepBy` symbol ",")
  pure (root, (U.head edges, U.last edges))

dirParser :: Parser [Dir]
dirParser = some $ choice [R <$ char 'R', L <$ char 'L']

day08 :: AoC
day08 = mkAoC parser partA partB 8 2023
