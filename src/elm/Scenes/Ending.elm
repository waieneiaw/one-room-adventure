module Scenes.Ending exposing (Model, Msg, init, subscriptions, update, view)

import Browser.Events
import Html exposing (Html)
import Html.Attributes
import Json.Decode as D
import Process
import Task exposing (Task)
import Utils.Keyboard exposing (onKeyDown)



-- MODEL


type alias Model =
    { proceeded : Bool
    , waiting : Bool
    }


init : ( Model, Cmd Msg )
init =
    let
        proceeded =
            False

        waiting =
            True
    in
    ( Model proceeded waiting, Task.perform Waiting wait )



-- UPDATE


type Msg
    = KeyDown
    | Waiting Bool


wait : Task Never Bool
wait =
    Process.sleep 3000
        |> Task.map (always True)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyDown ->
            if model.waiting then
                ( model, Cmd.none )

            else
                ( { model | proceeded = True }, Cmd.none )

        Waiting finished ->
            if finished then
                ( { model | waiting = False }, Cmd.none )

            else
                ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Html.div
        [ Html.Attributes.class "ml_panel"
        ]
        [ Html.div
            [ Html.Attributes.class "ml_panel_view"
            ]
            [ Html.text "Congratulations!"
            ]
        , Html.div
            [ Html.Attributes.class "ml_panel_message"
            ]
            [ Html.span []
                [ if model.waiting then
                    Html.text ""

                  else
                    Html.text "Hit Any Key"
                ]
            ]
        ]



-- SUBSCRIPTION


subscriptions : Sub Msg
subscriptions =
    Browser.Events.onKeyDown (D.succeed KeyDown)
