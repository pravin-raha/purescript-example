module Html.DynamicHtml where

import Prelude
import Data.Const (Const)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)

type State
  = Int

type DynamicHtml
  = H.ComponentHTML Unit () Aff

type StateOnlyDynamicRenderer state
  = (state -> DynamicHtml)

dynamicHtml :: State -> DynamicHtml
dynamicHtml state = HH.div_ [ HH.text $ "This is text in a div!" <> show state ]

main :: Effect Unit
main =
  launchAff_ do
    body <- awaitBody
    runUI (dynamicComponent 1 dynamicHtml) unit body

dynamicComponent ::
  forall state.
  state ->
  StateOnlyDynamicRenderer state ->
  H.Component HH.HTML (Const Unit) Unit Void Aff
dynamicComponent state renderHtml =
  H.mkComponent
    { initialState: const state
    , render: \_ -> renderHtml state
    , eval: H.mkEval H.defaultEval
    }
