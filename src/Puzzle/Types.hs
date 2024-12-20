{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module Puzzle.Types
  ( Answer (..),
    Puzzle (..),
    Input (..),
  )
where

import Control.DeepSeq (NFData)
import Data.List.NonEmpty (NonEmpty)
import Data.Text (Text)
import Data.Text.Display (Display (..))
import GHC.Generics (Generic)

data Answer
  = Unanswered
  | NilAnswer
  | IntAnswer Int
  deriving stock (Generic)
  deriving anyclass (NFData)

instance Display Answer where
  displayBuilder (IntAnswer a) = displayBuilder a
  displayBuilder NilAnswer = "nil"
  displayBuilder Unanswered = "unanswered"

instance Show Answer where
  show (IntAnswer a) = show a
  show NilAnswer = "nil"
  show Unanswered = "unanswered"

instance Eq Answer where
  IntAnswer a == IntAnswer b = a == b
  NilAnswer == NilAnswer = True
  Unanswered == Unanswered = True
  _ == _ = False

newtype Puzzle = Puzzle {puzzles :: NonEmpty Input}
  deriving stock (Show, Eq)

data Input = Input
  { answer1 :: Answer,
    answer2 :: Answer,
    comment :: Maybe Text,
    name :: Maybe Text,
    input :: Text
  }
  deriving stock (Show, Eq)
