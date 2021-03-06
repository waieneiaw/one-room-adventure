module Places.Room.East exposing (Model, init, update, view)

import Images.Box
import Images.BoxDoor
import Images.Safe
import Images.SafeDoor
import Images.Screwdriver
import Images.SilverKey
import Images.Wall
import Svg exposing (Svg)
import Types.Argument
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Item
import Types.Object


type alias Model =
    { safe : Types.Object.Openable
    , box : Types.Object.Openable
    , silverKey : Types.Object.Plain
    , screwdriver : Types.Object.Plain
    }


init : Model
init =
    { safe =
        Types.Object.Locked
            { feature =
                { type_ = Types.Item.None
                , name = "金庫（SAFE）"
                }
            }
    , box =
        Types.Object.Locked
            { feature =
                { type_ = Types.Item.None
                , name = "鍵のついた箱（BOX）"
                }
            }
    , silverKey =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.None
            , name = "銀色の鍵（SILVERKEY）"
            }
        }
    , screwdriver =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.Screwdriver
            , name = "ドライバー（SCREWDRIVER）"
            }
        }
    }


update :
    Types.Argument.UpdateDirectionArgs Model
    -> ( Model, Types.Command.Result )
update { model, command } =
    let
        message : String -> ( Model, Types.Command.Result )
        message text =
            ( model
            , Types.Command.resultWithMessage text
            )

        noop =
            ( model, Types.Command.resultNg )
    in
    case command.noun of
        ------------
        -- ONLY VERB
        ------------
        Types.Command.Noun.None ->
            case command.verb of
                Types.Command.Verb.Look ->
                    let
                        box =
                            Types.Object.getOpenableState model.box

                        safe =
                            Types.Object.getOpenableState model.safe
                    in
                    message
                        (box.feature.name
                            ++ "と"
                            ++ safe.feature.name
                            ++ "があります。"
                        )

                _ ->
                    noop

        ------------
        -- Box
        ------------
        Types.Command.Noun.Box ->
            let
                target =
                    model.box

                item =
                    model.silverKey
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    case target of
                        Types.Object.Opened _ ->
                            if item.status == Types.Object.Exist then
                                message
                                    ("銅色の箱です。中に。"
                                        ++ item.feature.name
                                        ++ "があります。"
                                    )

                            else
                                message
                                    "箱の中には何もありません。"

                        _ ->
                            message
                                "銅色の箱です。鍵穴がついています。"

                Types.Command.Verb.Open ->
                    case target of
                        Types.Object.Closed state ->
                            ( { model
                                | box =
                                    Types.Object.Opened state
                              }
                            , Types.Command.resultOk
                            )

                        _ ->
                            noop

                Types.Command.Verb.Close ->
                    case target of
                        Types.Object.Opened state ->
                            ( { model
                                | box =
                                    Types.Object.Closed state
                              }
                            , Types.Command.resultOk
                            )

                        _ ->
                            noop

                _ ->
                    noop

        ------------
        -- Safe
        ------------
        Types.Command.Noun.Safe ->
            let
                target =
                    model.safe

                item =
                    model.screwdriver
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    case target of
                        Types.Object.Opened _ ->
                            if item.status == Types.Object.Exist then
                                message
                                    ("中には"
                                        ++ item.feature.name
                                        ++ "が置かれています。"
                                    )

                            else
                                message "何もありません。"

                        _ ->
                            message
                                ("4桁のダイヤルナンバー式の金庫です。"
                                    ++ "頑丈そうで、壊すのはムリでしょう。"
                                    ++ "解錠する場合は`unlock 数字4桁`で"
                                    ++ "コマンド入力してください。"
                                )

                Types.Command.Verb.Open ->
                    case target of
                        Types.Object.Closed state ->
                            ( { model
                                | safe =
                                    Types.Object.Opened state
                              }
                            , Types.Command.resultOk
                            )

                        _ ->
                            noop

                Types.Command.Verb.Close ->
                    case target of
                        Types.Object.Closed state ->
                            ( { model
                                | safe =
                                    Types.Object.Closed state
                              }
                            , Types.Command.resultOk
                            )

                        _ ->
                            noop

                _ ->
                    noop

        Types.Command.Noun.SafeUnlockNumber ->
            let
                target =
                    model.safe
            in
            case command.verb of
                Types.Command.Verb.Unlock ->
                    case target of
                        Types.Object.Locked state ->
                            ( { model
                                | safe =
                                    Types.Object.Closed state
                              }
                            , Types.Command.resultWithMessage "解錠に成功しました。"
                            )

                        _ ->
                            noop

                _ ->
                    noop

        ------------
        -- Screwdriver
        ------------
        Types.Command.Noun.Screwdriver ->
            let
                target =
                    model.screwdriver

                place =
                    model.safe
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    case place of
                        Types.Object.Opened _ ->
                            if target.status == Types.Object.Exist then
                                message "大きめのプラスドライバーです。"

                            else
                                noop

                        _ ->
                            noop

                Types.Command.Verb.Take ->
                    case place of
                        Types.Object.Opened _ ->
                            if target.status == Types.Object.Exist then
                                ( { model
                                    | screwdriver =
                                        { status = Types.Object.Lost
                                        , feature = target.feature
                                        }
                                  }
                                , Types.Command.resultWithItem target
                                )

                            else
                                noop

                        _ ->
                            noop

                _ ->
                    noop

        ------------
        -- SilverKey
        ------------
        Types.Command.Noun.SilverKey ->
            let
                target =
                    model.silverKey
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    if target.status == Types.Object.Exist then
                        message
                            "銀色の鍵です。箱の奥に貼り付けられています。"

                    else
                        noop

                Types.Command.Verb.Take ->
                    if target.status == Types.Object.Exist then
                        ( { model
                            | silverKey =
                                { status = Types.Object.Lost
                                , feature = target.feature
                                }
                          }
                        , Types.Command.resultWithItem target
                        )

                    else
                        noop

                _ ->
                    noop

        ------------
        -- ITEM
        ------------
        Types.Command.Noun.BronzeKey ->
            let
                target =
                    model.box
            in
            case command.verb of
                Types.Command.Verb.Use ->
                    case target of
                        Types.Object.Locked state ->
                            ( { model
                                | box =
                                    Types.Object.Closed state
                                , silverKey =
                                    { status = Types.Object.Exist
                                    , feature = model.silverKey.feature
                                    }
                              }
                            , Types.Command.resultWithMessage
                                "箱の鍵が開きました。"
                            )

                        _ ->
                            noop

                _ ->
                    noop

        ------------
        -- NoOp
        ------------
        _ ->
            noop


view : Model -> List (Svg msg)
view model =
    [ Images.Wall.view
    , Images.Box.view model.box { x = 70, y = 280 }
    , Images.SilverKey.view model.silverKey { x = 105, y = 360 }
    , Images.BoxDoor.view model.box { x = 70, y = 280 }
    , Images.Safe.view model.safe { x = 230, y = 280 }
    , Images.Screwdriver.view model.screwdriver { x = 280, y = 424 }
    , Images.SafeDoor.view model.safe { x = 230, y = 280 }
    ]
