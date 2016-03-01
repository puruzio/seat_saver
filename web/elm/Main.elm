
import Html exposing (..)
import Html.Attributes exposing (class)
import StartApp
import Effects exposing (Effects, Never)
import Html.Events exposing (onClick)
import SeatSaver_Pair exposing (init, update, view)
import Task exposing (Task)

app =
  StartApp.start
    { init = init       -- was model = init
    , update = update
    , view = view
    , inputs = []  -- Unique to StartApp (not Simple) Inputs allow us to specify external Signals that provide Actions to our application.
    }

--main : Signal Html
main =
  app.html  --calls the html function on the function returned by the app function.
            --This gives us access to the HTML that results from the View function we passed to StartApp.
  --view init


--create a port so that we can use any tasks that pass through StartApp
port tasks : Signal (Task Never ())
port tasks =
  app.tasks

