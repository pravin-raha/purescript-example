module Main where

import Prelude

import Effect (Effect)
import Effect.Console (logShow)
import Math (sqrt)

digonal :: Number -> Number -> Number
digonal w h = sqrt( w *w + h*h)

main :: Effect Unit
main =  logShow(digonal 4.0 3.0)