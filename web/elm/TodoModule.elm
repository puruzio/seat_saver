module TodoModule where

import Html exposing (..)
import Html.Attributes exposing (class)
import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json exposing ((:=))


type alias Model =
    List Todo


type alias Todo =
  { task : String
  , task_id: String
  , project: String
  , duedates : String
  , closed: String
  }


init: (Model, Effects Action) --an Effect that will result in an Action
init =
 ([], fetchTodos)

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
  =
   SetTodos (Maybe Model) --argument to SeatSeats may be a Model, or it may not.

update : Action -> Model -> (Model, Effects Action) --Because our update function steps the Model from one state to the next, it too needs to return this tuple of Model and Effects Action
update action model =
  case action of
    SetTodos todos ->
      let
        newModel = Maybe.withDefault model todos -- if the argument I’m given is anything other than a value of type Model return the current model, otherwise return the given argument
      in
        (newModel, Effects.none)

-- view
-- "Signal.Address Action" is the first argument
view: Signal.Address Action -> Model -> Html
view address model =
  --Html.text "Woo hoo, 오제석의 첫번째 페이지"
  -- "(seatItem address) is a partial function which has some arguments prefilled"
  ul [ ] (List.map (todoItem address) model)


todoItem: Signal.Address Action -> Todo -> Html
todoItem address todo =
  li
    [
     -- onClick address (FillForm todo)
    ]
    [ text (todo.task) ]

------Effects ----------------------------------------
fetchTodos: Effects Action
fetchTodos =
  Http.get decodeTodos "http://stickyreminder.appspot.com/griddata"
    |> Task.toMaybe
    |> Task.map SetTodos
    |> Effects.task

decodeTodos: Json.Decoder Model
decodeTodos =
  let
    todo =
      Json.object5 (\task taskId project duedates closed -> (Todo task taskId project duedates closed))
        ("task" := Json.string)
        ("taskId" := Json.string)
        ("project" := Json.string)
        ("duedates" := Json.string)
        ("closed" := Json.string)
  in
    Json.at ["data"] (Json.list todo)

