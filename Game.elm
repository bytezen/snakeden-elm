port module Game exposing (..)

import Platform exposing (program)
import Json.Decode 


type alias Model = String

type Msg = Listen String 


main : Program Never Model Msg
main = program 
        { init = ("FooDat", Cmd.none)
        , update = update
        , subscriptions = subscriptions
        }


update : Msg -> Model -> (Model, Cmd msg)
update msg model =
    case msg of
        Listen input -> (input, talkBack input)


-- port for sending string out to JS
port talkBack : String -> Cmd msg

-- port for listening for messages from JS
port talkToElm : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
    talkToElm Listen    
