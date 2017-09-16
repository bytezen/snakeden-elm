module SandboxPlayerInput exposing (..)

import String exposing (toLower)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Decode exposing (string, decodeString, Decoder, succeed, fail, andThen, Value)
import Json.Encode as Encode

type alias PlayerInput =
    {
    name: String
    , move: Move
    }

type Move =
    Up
    | Down
    | Right
    | Left
    | Jump

inputDecoder : Decoder PlayerInput
inputDecoder =
    decode PlayerInput
        |> required "name" string
        |> required "move" moveDecoder


test = 
  """
    { "move": "up", "name": "player1"}
  """

moveDecoder : Decoder Move
moveDecoder =
    let
        convert : String -> Decoder Move
        convert str =
            case (toLower str) of 
                "up" -> succeed Up
                "down" -> succeed Down
                "left" -> succeed Left
                "right" -> succeed Right
                "jump" -> succeed Jump
                _ -> fail "I don't know that move"
    in
        string |> andThen convert

decodePlayerInput : String -> Result String PlayerInput
decodePlayerInput = 
    decodeString inputDecoder


makePlayer : String -> String -> Encode.Value
makePlayer name move = 
     Encode.object [("name", Encode.string name), ("move",Encode.string move)]