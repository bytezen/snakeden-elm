port module Snakeden exposing (..)
{-  Shanghai.elm - Updated for 0.18
    Build with: $elm-make --warn --output Shanghai.js Shanghai.elm

 
    Elm JsonDecode code adapted from:
    "Elm: How to use Decoders for Ports + How not use Decoders for JSON"
    https://medium.com/@_rchaves_/elm-how-to-use-decoders-for-ports-how-to-not-use-decoders-for-json-a4f95b51473a
 -}

import Json.Decode as Decode
-- https://github.com/elm-lang/elm-make/issues/127
import Json.Decode.Pipeline as Pipeline 

-- import Dict exposing (Dict)

-- type alias Model =
--     Dict String Int

type alias Model = String

type alias PlayerInput =
    {
    player: String
    , move: Move
    }


type Move =  Up
           | Down
           | Left
           | Right
           | Jump


inputDecoder : Decode.Decoder PlayerInput
inputDecoder =
    Pipeline.decode PlayerInput
        |> Pipeline.required "player" Decode.string
        |> Pipeline.required "move" moveDecoder


moveDecoder : Decode.Decoder Move
moveDecoder =
    let
        convert : String -> Decode.Decoder Move
        convert str =
            case (String.toLower str) of 
                "up" -> Decode.succeed Up
                "down" -> Decode.succeed Down
                "left" -> Decode.succeed Left
                "right" -> Decode.succeed Right
                "jump" -> Decode.succeed Jump
                _ -> Decode.fail "I don't know that move"
    in
        Decode.string |> Decode.andThen convert


showMove : Move -> String
showMove m = 
    case m of 
        Up -> "up"
        Down -> "down"
        Left -> "left"
        Right -> "right"
        Jump -> "jump"

-- Browser-bound (-> Cmd msg)
port movePlayer : String -> Cmd msg


-- Elm-bound (-> Sub msg)
port playerInput : (Decode.Value -> msg) -> Sub msg
port testPlayerInput : (Decode.Value -> msg) -> Sub msg

{-
    Specify which Msg data constructors to use for
    the various Elm-bound port values
-}
type Msg            -- see also "subscriptions" below
    = PlayerMove (Result String PlayerInput)
    -- | PlayerMoveTest (Result String String)


decodePlayerInput : Decode.Value -> Result String PlayerInput
decodePlayerInput = 
    Decode.decodeValue inputDecoder

-- decodePlayerInputTest : Decode.Value -> Result String String
-- decodePlayerInputTest =
--     Decode.decodeValue 
--          (Decode.field "moveTest" Decode.string)

subscriptions : Model -> Sub Msg
subscriptions model =
    playerInput ( decodePlayerInput >> PlayerMove)
    -- Sub.batch [
    -- testPlayerInput ( decodePlayerInputTest >> PlayerMoveTest ) 
    -- ]



{-  Alternately Platform.programWithFlags
    accepts initialization data to be passed
    to "init" function
-}
init : ( Model, Cmd msg )
init =
    ("nothing in the model yet", Cmd.none)

-- Process the incoming values and dispatch the updated capacity
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlayerMove (Ok {player,move}) ->
            -- send out the move for this player as command
            (model,movePlayer (player ++ "," ++ (showMove move)) )
        PlayerMove (Err msg) ->
            (model, movePlayer msg)

{-
  Platform.program is "headless" - it does not
  generate an HTML view
-}
main : Program Never Model Msg
main =
    Platform.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        }

