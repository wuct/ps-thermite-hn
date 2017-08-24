module Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import React as R
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import ReactDOM as RDOM
import Thermite as T
import DOM (DOM)
import Data.Array ((..))

data Action

type Story = { title :: String
             }

type State = { topStories :: Array Story }

genFakeStory :: Int -> Story
genFakeStory idx = { title: "Fake Story Title " <> show idx }

initState :: State
initState = { topStories: map genFakeStory (1 .. 30)}

renderStoryItem :: Story -> ReactElement
renderStoryItem { title } = R.div' [ R.text title ]

renderStoryList :: Array Story -> Array ReactElement
renderStoryList = map renderStoryItem

render :: T.Render State _ Action
render dispatch _ state _ =
  [ R.p' [ R.text "Hello thermite!!" ]
  , R.div' $ renderStoryList state.topStories
  ]

performAction :: T.PerformAction _ State _ Action
performAction _ _ _ = void $ pure unit

spec :: T.Spec _ State _ Action
spec = T.simpleSpec performAction render

main :: forall e. Eff (console :: CONSOLE, dom :: DOM | e) Unit
main = do
  T.defaultMain spec initState unit
  log "Hello from main"
