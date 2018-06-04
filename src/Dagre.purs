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
       , defConfig
       , defEdgeLabel
       , layoutDefault
       ) where


import Prelude
import Data.Maybe (Maybe(..))
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

instance showLabelPosition :: Show LabelPosition where
  show Left = "l"
  show Center = "c"
  show Right = "r"

type LayoutConfig =
  { rankDirection :: RankDirection
  , align :: Align
  , nodeSep :: Number
  , edgeSep :: Number
  , rankSep :: Number
  , marginX :: Number
  , marginY :: Number
  , acyclicer :: Maybe Acyclicer
  , ranker :: Ranker
  }

defConfig :: LayoutConfig
defConfig =
  { rankDirection: TopToBottom
  , align: UpperLeft
  , nodeSep: 50.0
  , edgeSep: 10.0
  , rankSep: 50.0
  , marginX: 0.0
  , marginY: 0.0
  , acyclicer: Nothing
  , ranker: NetworkSimplex
  }

defEdgeLabel :: EdgeLabel
defEdgeLabel =
  { minLength: 1
  , width: 0.0
  , height: 0.0
  , labelPosition: Right
  , labelOffset: 10.0
  }

data RankDirection = TopToBottom
                   | BottomToTop
                   | LeftToRight
                   | RightToLeft

instance showRankDirection :: Show RankDirection where
  show TopToBottom = "TB"
  show BottomToTop = "BT"
  show LeftToRight = "LR"
  show RightToLeft = "RL"

data Align = UpperLeft
           | UpperRight
           | LowerLeft
           | LowerRight

instance showAlign :: Show Align where
  show UpperLeft = "UL"
  show UpperRight = "UR"
  show LowerRight = "DR"
  show LowerLeft = "DL"

data Acyclicer = Greedy

instance showAcyclicer :: Show Acyclicer where
  show Greedy = "greedy"

data Ranker = NetworkSimplex
            | TightTree
            | LongestPath

instance showRanker :: Show Ranker where
  show NetworkSimplex = "network-simplex"
  show TightTree = "tight-tree"
  show LongestPath = "longest-path"

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

foreign import layout :: LayoutConfig
                      -> Array (Tuple NodeId NodeLabel)
                      -> Array (Tuple Edge EdgeLabel)
                      -> LayoutResult

layoutDefault :: Array (Tuple NodeId NodeLabel)
              -> Array (Tuple Edge EdgeLabel)
              -> LayoutResult
layoutDefault = layout defConfig
