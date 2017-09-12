import Html exposing (Html, text)

type alias Model = String

model: Model 
model = "Testing"

view: Model -> Html msg
view model =
    text model


update : msg -> Model -> Model
update _ model =
    model            

--uncomment if needed -- import Html.App as App

main = 
    Html.beginnerProgram {model = model
                          , view = view
                          , update = update
                          }

