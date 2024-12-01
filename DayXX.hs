{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Year.Y24.Day01 where

import Data.Text (Text)
import Day (AoC, mkAoC)
import Parsers (Parser)
import Text.Megaparsec
import Text.Megaparsec qualified as M
import Text.Megaparsec.Char

type Input = ([Any], [Any])

partA :: Input -> Int
partA xs = undefined

partB :: Input -> Int
partB xs = undefined

parser :: Parser Input
parser = undefined

day01 :: AoC
day01 = mkAoC parser partA partB 1 2024
