module Main exposing (Model, main)

import Browser
import Components.Template
import Scenes.Ending
import Scenes.Game
import Scenes.Title


type Model
    = Title Scenes.Title.Model
    | Game Scenes.Game.Model
    | Ending Scenes.Ending.Model


init : () -> ( Model, Cmd Msg )
init _ =
    ( Title Scenes.Title.init
    , Cmd.none
    )



-- UPDATE


type Msg
    = TitleMsg Scenes.Title.Msg
    | GameMsg Scenes.Game.Msg
    | EndingMsg Scenes.Ending.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( TitleMsg sceneMsg, Title sceneModel ) ->
            let
                ( newModel, cmd ) =
                    Scenes.Title.update sceneMsg sceneModel
            in
            if newModel.proceeded then
                let
                    ( initModel, initCmd ) =
                        Scenes.Game.init
                in
                ( Game initModel, Cmd.map GameMsg initCmd )

            else
                ( Title newModel, Cmd.map TitleMsg cmd )

        ( GameMsg sceneMsg, Game sceneModel ) ->
            let
                ( newModel, cmd ) =
                    Scenes.Game.update sceneMsg sceneModel
            in
            if newModel.isCleared then
                let
                    ( initModel, initCmd ) =
                        Scenes.Ending.init
                in
                ( Ending initModel, Cmd.map EndingMsg initCmd )

            else
                ( Game newModel, Cmd.map GameMsg cmd )

        ( EndingMsg sceneMsg, Ending sceneModel ) ->
            let
                ( newModel, cmd ) =
                    Scenes.Ending.update sceneMsg sceneModel
            in
            if newModel.proceeded then
                ( Title Scenes.Title.init, Cmd.map TitleMsg Cmd.none )

            else
                ( Ending newModel, Cmd.map EndingMsg cmd )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Title _ ->
            Sub.batch
                [ Scenes.Title.subscriptions |> Sub.map TitleMsg
                ]

        Ending _ ->
            Sub.batch
                [ Scenes.Ending.subscriptions |> Sub.map EndingMsg
                ]

        _ ->
            Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model of
        Title sceneModel ->
            Components.Template.view TitleMsg (Scenes.Title.view sceneModel)

        Game sceneModel ->
            Components.Template.view GameMsg (Scenes.Game.view sceneModel)

        Ending sceneModel ->
            Components.Template.view EndingMsg (Scenes.Ending.view sceneModel)



-- MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
