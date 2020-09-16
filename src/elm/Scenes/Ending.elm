module Scenes.Ending exposing (Model(..), Msg, init, subscriptions, update, view)

import Browser.Events
import Html exposing (Html)
import Html.Attributes
import Json.Decode as D
import Process
import Task exposing (Task)
import Utils.Keyboard exposing (onKeyDown)



-- MODEL


type Model
    = Idling
    | Running
    | Finished


init : ( Model, Cmd Msg )
init =
    ( Idling, Task.perform Waiting wait )



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
    let
        noop =
            ( model, Cmd.none )
    in
    case msg of
        KeyDown ->
            case model of
                Idling ->
                    noop

                _ ->
                    ( Finished, Cmd.none )

        Waiting finished ->
            if finished then
                ( Running, Cmd.none )

            else
                noop



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
                [ if model == Idling then
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
