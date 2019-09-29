module Html.DynamicHtmlWithAction where

import Prelude
import Control.Monad.State (put, get)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)

type State
  = Boolean

data Action
  = Toggle

type DynamicHtml action
  = H.ComponentHTML action () Aff

type StateAndActionRenderer state action
  = state -> DynamicHtml action

type HandleSimpleAction state action
  = (action -> H.HalogenM state action () Void Aff Unit)

toggleButton :: StateAndActionRenderer State Action
toggleButton isOn =
  let
    toggleLabel = if isOn then "On" else "Off"
  in
    HH.button
      [ HE.onClick \_ -> Just Toggle ]
      [ HH.text $ "The button is " <> toggleLabel ]

handleAction :: HandleSimpleAction State Action
handleAction = case _ of
  Toggle -> do
    oldState <- get
    let
      newState = not oldState
    put newState

type SimpleChildComponent state action
  = { initialState :: state
    , render :: StateAndActionRenderer state action
    , handleAction :: HandleSimpleAction state action
    }

stateAndActionCompontent ::
  forall state action.
  SimpleChildComponent state action ->
  H.Component HH.HTML (Const Unit) Unit Void Aff
stateAndActionCompontent spec =
  H.mkComponent
    { initialState: const spec.initialState
    , render: spec.render
    , eval: H.mkEval $ H.defaultEval { handleAction = spec.handleAction }
    }

runStateAndActionComponent ::
  forall state action.
  SimpleChildComponent state action ->
  Effect Unit
runStateAndActionComponent childSpec = do
  launchAff_ do
    body <- awaitBody
    runUI (stateAndActionCompontent childSpec) unit body

main :: Effect Unit
main =
  runStateAndActionComponent
    { initialState: false
    , render: toggleButton
    , handleAction: handleAction
    }
