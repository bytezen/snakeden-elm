port module Game exposing (..)

import Platform exposing (program)
import Json.Decode 


-- port for sending something to JS
port foo : String -> Cmd msg

-- port for listening for messages from JS
port bar : (String -> msg) -> Sub msg


type alias Model = String

type Msg = Update Model


main : Program Never Model Msg
main = program 
        { init = ("FooDat", foo "FooDat")
        , update = update
        , subscriptions = subscriptions
        }


update : Msg -> Model -> (Model, Cmd msg)
update msg model =
    case msg of
        Update s -> ( s, foo <| "update: " ++ s)


subscriptions : Model -> Sub Msg
subscriptions model =
    bar Update  
