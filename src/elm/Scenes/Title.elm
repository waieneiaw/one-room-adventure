module Scenes.Title exposing (Model, Msg, init, subscriptions, update, view)

import Browser.Events
import Html exposing (Html)
import Html.Attributes
import Json.Decode as D
import Utils.Keyboard exposing (onKeyDown)



-- MODEL


type alias Model =
    { proceeded : Bool }


init : Model
init =
    let
        proceeded =
            False
    in
    Model proceeded



-- UPDATE


type Msg
    = KeyDown


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyDown ->
            ( { model | proceeded = True }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view _ =
    Html.div
        [ Html.Attributes.class "ml_panel"
        ]
        [ Html.div
            [ Html.Attributes.class "ml_panel_view"
            ]
            [ Html.div []
                [ Html.text "ONE ROOM ADVENTURE"
                ]
            ]
        , Html.div
            [ Html.Attributes.class "ml_panel_message" ]
            [ Html.span [] [ Html.text "Hit Any Key" ]
            ]
        ]



-- SUBSCRIPTION


subscriptions : Sub Msg
subscriptions =
    Browser.Events.onKeyDown (D.succeed KeyDown)
