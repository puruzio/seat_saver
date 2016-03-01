module SeatSaver_Pair where

import Html exposing (..)
import Html.Attributes exposing (class)
import StartApp
import Effects exposing (Effects, Never)
import Html.Events exposing (onClick)
import SeatSaver
import TodoModule
import Task exposing (Task)


type alias Model =
  { left: SeatSaver.Model
  , right: TodoModule.Model
  }


init: (Model, Effects Action) --an Effect that will result in an Action
init  =
  let
    (left, leftFx) = SeatSaver.init
    (right, rightFx) = TodoModule.init
  in
    (Model left right
    , Effects.batch
      [ Effects.map Left leftFx
      , Effects.map Right rightFx
      ]
    )

---Update --------------------------------------------
type Action
  =
    Left SeatSaver.Action
  | Right TodoModule.Action

update : Action -> Model -> (Model, Effects Action) --Because our update function steps the Model from one state to the next, it too needs to return this tuple of Model and Effects Action
update action model =
  case action of
    Left act ->
      let
        (left, fx) = SeatSaver.update act model.left
      in
        ( Model left model.right
        , Effects.map Left fx
        )

    Right act ->
      let
        (right, fx) = TodoModule.update act model.right
      in
        ( Model model.left right
        , Effects.map Right fx
        )

-- view
-- "Signal.Address Action" is the first argument
view: Signal.Address Action -> Model -> Html
view address model =
  div [ ]
    [ SeatSaver.view (Signal.forwardTo address Left) model.left
    , TodoModule.view (Signal.forwardTo address Right) model.right
    ]

