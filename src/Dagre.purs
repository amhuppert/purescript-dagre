module Dagre
       ( NodeId
       , NodeLabel
       , Edge
       , EdgeLabel
       , LabelPosition(..)
       , LayoutConfig
       , RankDirection(..)
       , Align(..)
       , Acyclicer(..)
       , Ranker(..)
       , Point
       , LayoutResult
       , layout
       ) where


import Data.Maybe (Maybe)
import Data.Tuple (Tuple)


type NodeId = String

type NodeLabel =
  { width  :: Number
  , height :: Number
  }

type Edge = { from :: NodeId
            , to :: NodeId
            }

type EdgeLabel =
  { minLength :: Int
  , weight :: Number
  , width :: Number
  , height :: Number
  , labelPosition :: LabelPosition
  , labelOffset :: Number
  }

data LabelPosition = Left | Center | Right

type LayoutConfig =
  { rankDirection :: RankDirection
  , align :: Align
  , nodeSep :: Number
  , edgeSep :: Number
  , marginX :: Number
  , marginY :: Number
  , acyclicer :: Maybe Acyclicer
  , ranker :: Ranker
  }

data RankDirection = TopToBottom
                   | BottomToTop
                   | LeftToRight
                   | RightToLeft

data Align = UpperLeft
           | UpperRight
           | LowerLeft
           | LowerRight

data Acyclicer = Greedy

data Ranker = NetworkSimplex
            | TightTree
            | LongestPath

type Point = { x :: Number
             , y :: Number
             }

type LayoutResult =
  { graphHeight :: Number
  , graphWidth :: Number
  , nodes :: Array { nodeId :: NodeId
                   , position :: Point
                   }
  , edges :: Array { edge :: Edge
                   , labelCenter :: Point
                   , controlPoints :: Array Point
                   }
  }

foreign import layout :: Array (Tuple NodeId NodeLabel) -> Array (Tuple Edge EdgeLabel) -> LayoutResult
