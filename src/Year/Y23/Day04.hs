{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Year.Y23.Day04 where

import AoC (Answer (..), AoC, Year (..), mkAoC)
import Control.Monad (void)
import Data.Set qualified as S
import Day (Day (..))
import Parsers (Parser)
import Text.Megaparsec hiding (some)
import Text.Megaparsec qualified as T
import Text.Megaparsec.Char
import Text.Megaparsec.Char.Lexer qualified as L

partA :: [([Int], [Int])] -> Answer
partA xs = IntAnswer . sum . map (\x -> 2 ^ (x - 1) :: Int) . filter (> 0) $ map (uncurry numMatching) xs

numMatching :: [Int] -> [Int] -> Int
numMatching xs ys = S.size $ S.fromList xs `S.intersection` S.fromList ys

partB :: [([Int], [Int])] -> Answer
partB i = IntAnswer . sum $ go i
  where
    go :: [([Int], [Int])] -> [Int]
    go [] = []
    go ((xs, ys) : cs) =
      let cnt = go cs
          num = 1 + sum (take (numMatching xs ys) cnt)
       in num : cnt

parser :: Parser [([Int], [Int])]
parser = gameParser `sepEndBy` eol

gameParser :: Parser ([Int], [Int])
gameParser = do
  void $ "Card" >> hspace >> (L.decimal :: Parser Int) >> ": "
  winning <- hspace >> T.many (L.lexeme hspace L.decimal)
  void $ L.symbol hspace "|"
  yours <- T.many (L.lexeme hspace L.decimal)
  pure (winning, yours)

day04 :: AoC [([Int], [Int])]
day04 = mkAoC parser partA partB D4 Y23
