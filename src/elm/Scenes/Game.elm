module Scenes.Game exposing (Model, Msg, init, update, view)

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
import Utils.Keyboard



-- MODEL


type Place
    = Room Places.Room.Model


type alias Items =
    List Types.Item.Item


type alias Model =
    { command : String
    , message : String
    , place : Place
    , items : Items
    , direction : Types.Direction.Direction
    , isCleared : Bool
    }


init : ( Model, Cmd Msg )
init =
    let
        command =
            ""

        message =
            ""

        place =
            Room Places.Room.init

        items =
            []

        direction =
            Types.Direction.North

        isCleared =
            False
    in
    ( Model command message place items direction isCleared, focusCommandBox )



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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Input value ->
            ( { model | command = value }, Cmd.none )

        KeyDown code ->
            case code of
                -- Enter
                13 ->
                    let
                        ( place, result ) =
                            execCommand model model.command
                    in
                    let
                        ( exists, item ) =
                            existsItem result.item
                    in
                    ( { model
                        | place = place
                        , command = ""
                        , message = result.message
                        , items =
                            if exists == False then
                                model.items

                            else
                                item
                                    :: []
                                    |> List.append model.items
                      }
                    , Cmd.none
                    )

                -- <-
                37 ->
                    ( { model
                        | direction = move model TurnLeft
                        , command = ""
                      }
                    , Cmd.none
                    )

                -- ->
                39 ->
                    ( { model
                        | direction = move model TurnRight
                        , command = ""
                      }
                    , Cmd.none
                    )

                -- ↑
                38 ->
                    case model.place of
                        Room placeModel ->
                            let
                                condition =
                                    placeModel.north.door.opened
                                        && model.direction
                                        == Types.Direction.North
                            in
                            if condition then
                                ( { model
                                    | isCleared = True
                                  }
                                , Cmd.none
                                )

                            else
                                ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )


{-| Place別のコマンドの実行処理。
-}
execCommandWithPlace :
    Model
    -> Types.Command.Command
    -> ( Place, Types.Command.Result )
execCommandWithPlace model command =
    case model.place of
        Room placeModel ->
            let
                ( newModel, result ) =
                    Places.Room.update model.direction placeModel command
            in
            ( Room newModel, result )


{-| 指定したtype\_のアイテムを持っている場合、そのアイテムを返す。
-}
getItem : List Types.Item.Item -> Types.Item.ItemType -> Maybe Types.Item.Item
getItem list type_ =
    case list of
        [] ->
            Nothing

        item :: items ->
            if item.type_ == type_ then
                Just item

            else
                getItem items type_


{-| Place問わずどこでも実行できるコマンドの実行処理。
-}
execCommandWithoutPlace :
    Model
    -> Types.Command.Command
    -> Maybe ( Place, Types.Command.Result )
execCommandWithoutPlace model { verb, noun } =
    let
        paper =
            getItem model.items Types.Item.Paper
    in
    case ( verb, noun ) of
        ( Types.Command.Verb.Use, Types.Command.Noun.Paper ) ->
            case paper of
                Just _ ->
                    Just
                        ( model.place
                        , Types.Command.resultWithoutItem
                            "紙には何も書かれていません。"
                        )

                _ ->
                    Nothing

        _ ->
            Nothing


{-| 入力されたコマンドを実行する。
-}
execCommand :
    Model
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


move : Model -> Moving -> Types.Direction.Direction
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
    Html.div [ Html.Attributes.class "ml_game" ]
        [ Html.div [ Html.Attributes.class "ml_game_center" ]
            [ viewWindow model
            , viewMessage model.message
            , viewInput "input" model.command Input KeyDown
            , viewNews model
            ]
        , viewItemList model.items
        ]


viewNews : Model -> Html Msg
viewNews model =
    Html.div [ Html.Attributes.class "ml_game_news" ]
        [ Html.text (Types.Direction.toString model.direction)
        ]


viewWindow : Model -> Html Msg
viewWindow model =
    case model.place of
        Room placeModel ->
            Html.div
                [ Html.Attributes.class "ml_game_view" ]
                [ Svg.svg
                    [ Svg.Attributes.width
                        (String.fromInt Constants.Basic.gameViewWidth)
                    , Svg.Attributes.height
                        (String.fromInt Constants.Basic.gameViewHeight)
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
