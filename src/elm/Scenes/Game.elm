module Scenes.Game exposing
    ( Model(..)
    , Msg
    , init
    , update
    , view
    )

import Browser.Dom
import Constants.Basic
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Places.Room
import Svg
import Svg.Attributes
import Task
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Direction
import Types.Item
import Types.Object
import Utils.Keyboard



-- MODEL


type Place
    = Room Places.Room.Model


type alias State =
    { command : String
    , message : String
    , place : Place
    , items : Types.Item.Items
    , direction : Types.Direction.Direction
    }


type Model
    = Playing State
    | Finished


init : ( Model, Cmd Msg )
init =
    ( Playing
        { command = ""
        , message = ""
        , place = Room Places.Room.init
        , items = []
        , direction = Types.Direction.North
        }
    , focusCommandBox
    )



-- UPDATE


type Msg
    = NoOp
    | Input String
    | KeyDown Int


focusCommandBox : Cmd Msg
focusCommandBox =
    Task.attempt (\_ -> NoOp) (Browser.Dom.focus "input")


existsItem : Maybe Types.Item.Item -> ( Bool, Types.Item.Item )
existsItem maybeItem =
    maybeItem
        |> Maybe.map (\item_ -> ( True, item_ ))
        |> Maybe.withDefault
            ( False, Types.Item.noneValue )


onEnter : State -> State
onEnter state =
    let
        ( place, result ) =
            execCommand state state.command

        ( exists, item ) =
            existsItem result.item
    in
    { state
        | place = place
        , command = ""
        , message = result.message
        , items =
            if exists == False then
                state.items

            else
                item
                    :: []
                    |> List.append state.items
    }


onTurn : Moving -> State -> String -> State
onTurn moving state message =
    { state
        | direction = move state moving
        , command = ""
        , message = message
    }


canEscape : State -> Bool
canEscape state =
    case state.place of
        Room placeModel ->
            let
                door =
                    placeModel.north.door
            in
            case door of
                Types.Object.Opened _ ->
                    state.direction
                        == Types.Direction.North

                _ ->
                    False


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        noop =
            ( model, Cmd.none )
    in
    case msg of
        NoOp ->
            noop

        Input value ->
            case model of
                Playing state ->
                    ( Playing { state | command = value }, Cmd.none )

                _ ->
                    noop

        KeyDown code ->
            case model of
                Playing state ->
                    case code of
                        -- Enter
                        13 ->
                            ( Playing (onEnter state), Cmd.none )

                        -- <-
                        37 ->
                            ( Playing (onTurn TurnLeft state "左を向きました。")
                            , Cmd.none
                            )

                        -- ->
                        39 ->
                            ( Playing (onTurn TurnRight state "右を向きました。")
                            , Cmd.none
                            )

                        -- ↑
                        38 ->
                            if canEscape state then
                                ( Finished, Cmd.none )

                            else
                                noop

                        _ ->
                            noop

                _ ->
                    ( model, Cmd.none )


{-| Place別のコマンドの実行処理。
-}
execCommandWithPlace :
    State
    -> Types.Command.Command
    -> ( Place, Types.Command.Result )
execCommandWithPlace model command =
    case model.place of
        Room placeModel ->
            let
                ( newModel, result ) =
                    Places.Room.update
                        { direction = model.direction
                        , model = placeModel
                        , command = command
                        , items = model.items
                        }
            in
            ( Room newModel, result )


{-| Place問わずどこでも実行できるコマンドの実行処理。
-}
execCommandWithoutPlace :
    State
    -> Types.Command.Command
    -> Maybe ( Place, Types.Command.Result )
execCommandWithoutPlace model command =
    let
        reaction :
            Maybe Types.Item.Item
            -> String
            -> Maybe ( Place, Types.Command.Result )
        reaction item text =
            case item of
                Just _ ->
                    Just
                        ( model.place, Types.Command.resultWithMessage text )

                _ ->
                    Nothing

        paperOfSafeTips =
            Types.Item.getItem model.items Types.Item.PaperOfSafeTips

        paperOfMachineTips =
            Types.Item.getItem model.items Types.Item.PaperOfMachineTips
    in
    case command.noun of
        Types.Command.Noun.PaperOfSafeTips ->
            let
                content =
                    -- 記号は辺の数。それを踏まえて当てはめて算出できた数が答え。
                    -- (3 * 1043) - 1111 = 2018
                    "「"
                        ++ "○ = 1、△ = 3"
                        ++ "」"
                        ++ "「"
                        ++ "3 × ◯✕□△ - ○○○○ = ????"
                        ++ "」"
                        ++ "と書かれています。"
            in
            case command.verb of
                Types.Command.Verb.Use ->
                    reaction paperOfSafeTips content

                Types.Command.Verb.Read ->
                    reaction paperOfSafeTips content

                _ ->
                    Nothing

        Types.Command.Noun.PaperOfMachineTips ->
            let
                content =
                    -- 「close」コマンドが作動するオブジェクトの数
                    -- N = 0 : door - DOOR -> 0
                    -- E = 1 : box -> 1 x 3 -> 3
                    -- W = 3 : notebook、drawer x 2 -> 3 x 3 -> 9
                    -- S = 0 : なし -> 3 x 0 -> 0
                    -- -> 0390 + 7105 = 7495
                    "「"
                        ++ "closable -> NEWS = 0??0"
                        ++ "」"
                        ++ "「"
                        ++ "NEWS × 3 + 7105"
                        ++ "」"
                        ++ "と書かれています。"
            in
            case command.verb of
                Types.Command.Verb.Use ->
                    reaction paperOfMachineTips content

                Types.Command.Verb.Read ->
                    reaction paperOfMachineTips content

                _ ->
                    Nothing

        _ ->
            Nothing


{-| 入力されたコマンドを実行する。
-}
execCommand :
    State
    -> String
    -> ( Place, Types.Command.Result )
execCommand model rawCommand =
    let
        command =
            Types.Command.parse rawCommand
    in
    -- 先にexecCommandWithoutPlaceを実行し、
    -- その結果がNothingの場合はexecCommandWithPlaceを実行する
    Maybe.withDefault (execCommandWithPlace model command) <|
        execCommandWithoutPlace model command


type Moving
    = TurnLeft
    | TurnRight


move : State -> Moving -> Types.Direction.Direction
move model moving =
    case moving of
        TurnLeft ->
            case model.direction of
                Types.Direction.North ->
                    Types.Direction.West

                Types.Direction.West ->
                    Types.Direction.South

                Types.Direction.South ->
                    Types.Direction.East

                Types.Direction.East ->
                    Types.Direction.North

        TurnRight ->
            case model.direction of
                Types.Direction.North ->
                    Types.Direction.East

                Types.Direction.East ->
                    Types.Direction.South

                Types.Direction.South ->
                    Types.Direction.West

                Types.Direction.West ->
                    Types.Direction.North



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Playing state ->
            Html.div [ Html.Attributes.class "ml_game" ]
                [ Html.div [ Html.Attributes.class "ml_game_center" ]
                    [ viewWindow state
                    , viewMessage state.message
                    , viewInput "input" state.command Input KeyDown
                    , viewNews state
                    ]
                , viewItemList state.items
                ]

        _ ->
            Html.div []
                []


viewNews : State -> Html Msg
viewNews model =
    Html.div [ Html.Attributes.class "ml_game_news" ]
        [ Html.text (Types.Direction.toString model.direction)
        ]


viewWindow : State -> Html Msg
viewWindow model =
    case model.place of
        Room placeModel ->
            Html.div
                [ Html.Attributes.class "ml_game_view" ]
                [ Svg.svg
                    [ Svg.Attributes.width
                        (String.fromInt Constants.Basic.gameView.width)
                    , Svg.Attributes.height
                        (String.fromInt Constants.Basic.gameView.height)
                    ]
                    (Places.Room.view model.direction placeModel)
                ]


viewMessage : String -> Html Msg
viewMessage message =
    Html.div [ Html.Attributes.class "ml_game_message" ]
        [ Html.text message
        ]


viewInput : String -> String -> (String -> msg) -> (Int -> msg) -> Html msg
viewInput t v msg keyDownMsg =
    Html.div [ Html.Attributes.class "ml_game_input" ]
        [ Html.text "Command ?"
        , Html.input
            [ Html.Attributes.id "input"
            , Html.Attributes.type_ t
            , Html.Attributes.value v
            , Html.Events.onInput msg
            , Utils.Keyboard.onKeyDown keyDownMsg
            ]
            []
        ]


viewItemListItem : Types.Item.Item -> Html msg
viewItemListItem item =
    Html.li []
        [ Html.text item.name
        ]


viewItemList : List Types.Item.Item -> Html msg
viewItemList items =
    Html.div []
        [ Html.section [ Html.Attributes.class "ml_game_itemList" ]
            [ Html.span [] [ Html.text "item list" ]
            , Html.div [ Html.Attributes.class "ml_game_itemList_inner" ]
                [ Html.ul []
                    (List.map viewItemListItem items)
                ]
            ]
        ]
