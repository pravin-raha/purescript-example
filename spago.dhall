{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "purescript-example"
, dependencies =
    [ "arrays"
    , "console"
    , "effect"
    , "halogen"
    , "lists"
    , "math"
    , "prelude"
    , "psci-support"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
