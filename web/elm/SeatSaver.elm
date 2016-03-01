module SeatSaver where

import Html exposing (..)
import Html.Attributes exposing (class)
import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json exposing ((:=))


type alias Seat =
  { seatNo : Int
  , occupied: Bool
}

type alias Model =
  List Seat

init: (Model, Effects Action) --an Effect that will result in an Action
init  =
  ([], fetchSeats)

  -- let
  --   seats =
  --     [ { seatNo = 1, occupied = False}
  --     , { seatNo = 2, occupied = False}
  --     , { seatNo = 3, occupied = False}
  --     , { seatNo = 4, occupied = False }
  --     , { seatNo = 5, occupied = False }
  --     , { seatNo = 6, occupied = False }
  --     , { seatNo = 7, occupied = False }
  --     , { seatNo = 8, occupied = False }
  --     , { seatNo = 9, occupied = False }
  --     , { seatNo = 10, occupied = False }
  --     , { seatNo = 11, occupied = False }
  --     , { seatNo = 12, occupied = False }
  --     , { seatNo = 12, occupied = False }
  --     ]
  -- in
  --   (seats, Effects.none) --no Action to send at this point so we use a null Effect

---Update --------------------------------------------
type Action
  = Toggle Seat
  | SetSeats (Maybe Model) --argument to SeatSeats may be a Model, or it may not.

update : Action -> Model -> (Model, Effects Action) --Because our update function steps the Model from one state to the next, it too needs to return this tuple of Model and Effects Action
update action model =
  case action of
    Toggle seatToToggle ->
      let
        updateSeat seatFromModel =
          if seatFromModel.seatNo == seatToToggle.seatNo then
            { seatFromModel | occupied = not seatFromModel.occupied }
          else seatFromModel
      in
        (List.map updateSeat model, Effects.none) --Now we have the option of either changing the state of the Model, or performing an Effect like an HTTP request, or both (or neither in the case of a NoOp).

    SetSeats seats ->
      let
        newModel = Maybe.withDefault model seats -- if the argument I’m given is anything other than a value of type Model return the current model, otherwise return the given argument
      in
        (newModel, Effects.none)

-- view
-- "Signal.Address Action" is the first argument
view: Signal.Address Action -> Model -> Html
view address model =
  --Html.text "Woo hoo, 오제석의 첫번째 페이지"
  -- "(seatItem address) is a partial function which has some arguments prefilled"
  ul [ class "seats"] (List.map (seatItem address) model)

seatItem: Signal.Address Action -> Seat -> Html
seatItem address seat =
  let
    occupiedClass =
      if seat.occupied then "occupied" else "available"
  in
    li
      [ class ("seat " ++ occupiedClass)
      , onClick address (Toggle seat)
      ]
      [ text (jasonFunc(toString seat.seatNo)) ]

jasonFunc: String -> String
jasonFunc text =
  text ++ "."


------Effects ----------------------------------------
fetchSeats: Effects Action
fetchSeats =
  Http.get decodeSeats "http://localhost:4000/api/seats"
    |> Task.toMaybe  --  Task is an asynchronous operation that might fail --The Task.toMaybe function lets us handle this uncertainty by wrapping the result in a Maybe. A Maybe is an option type that enables us to say “This might be a List of Seat records, or it might not.”
    |> Task.map SetSeats
    |> Effects.task


decodeSeats: Json.Decoder Model
decodeSeats =
  let
    seat =
      Json.object2 (\seatNo occupied -> (Seat seatNo occupied))
        ("seatNo" := Json.int)
        ("occupied" := Json.bool)
  in
    Json.at ["data"] (Json.list seat)
    


