module Places.Room.South exposing (Model, init, update, view)

import Images.Cushion
import Images.GoldKey
import Images.Machine
import Images.Sofa
import Images.Wall
import Svg exposing (Svg)
import Types.Argument
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Item
import Types.Object


type alias Model =
    { sofa : Types.Object.Plain
    , cushion : Types.Object.Plain
    , bronzeKey : Types.Object.Plain
    , machine : Types.Object.Openable
    , goldKey : Types.Object.Plain
    }


init : Model
init =
    { sofa =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.None
            , name = "ソファ（SOFA）"
            }
        }
    , cushion =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.None
            , name = "角張ったクッション（CUSHION）"
            }
        }
    , bronzeKey =
        { status = Types.Object.Lost
        , feature =
            { type_ = Types.Item.BronzeKey
            , name = "銅色の鍵（BRONZEKEY）"
            }
        }
    , machine =
        Types.Object.Locked
            { feature =
                { type_ = Types.Item.None
                , name = "謎の機械（MACHINE）"
                }
            }
    , goldKey =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.GoldKey
            , name = "金色の鍵（GOLDKEY）"
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
                        machine =
                            Types.Object.getOpenableState model.machine
                    in
                    message
                        (model.sofa.feature.name
                            ++ "と"
                            ++ machine.feature.name
                            ++ "があります。"
                        )

                _ ->
                    noop

        ------------
        -- Bronze Key
        ------------
        Types.Command.Noun.BronzeKey ->
            case command.verb of
                Types.Command.Verb.Look ->
                    if model.bronzeKey.status == Types.Object.Exist then
                        message
                            "銅の色をした、何の変哲もない鍵です。"

                    else
                        noop

                Types.Command.Verb.Take ->
                    if model.bronzeKey.status == Types.Object.Exist then
                        ( { model
                            | bronzeKey =
                                { status = Types.Object.Lost
                                , feature = model.bronzeKey.feature
                                }
                          }
                        , Types.Command.resultWithItem model.bronzeKey
                        )

                    else
                        noop

                _ ->
                    noop

        ------------
        -- Cushion
        ------------
        Types.Command.Noun.Cushion ->
            case command.verb of
                Types.Command.Verb.Look ->
                    if model.cushion.status == Types.Object.Exist then
                        message
                            "妙に角張っていますが、触ってみると柔らかいです。"

                    else if model.bronzeKey.status == Types.Object.Exist then
                        message
                            ("中身が出ています。"
                                ++ model.bronzeKey.feature.name
                                ++ "があります。"
                            )

                    else
                        message
                            "中身が出ています。"

                Types.Command.Verb.Take ->
                    if model.cushion.status == Types.Object.Exist then
                        message
                            "ソファにくっついていて取れません。"

                    else
                        noop

                _ ->
                    noop

        ------------
        -- Gold Key
        ------------
        Types.Command.Noun.GoldKey ->
            case command.verb of
                Types.Command.Verb.Look ->
                    case model.machine of
                        Types.Object.Opened _ ->
                            if model.goldKey.status == Types.Object.Exist then
                                message "金色に輝いている鍵です。高級感が漂います。"

                            else
                                noop

                        _ ->
                            noop

                Types.Command.Verb.Take ->
                    case model.machine of
                        Types.Object.Opened _ ->
                            if model.goldKey.status == Types.Object.Exist then
                                ( { model
                                    | goldKey =
                                        { status = Types.Object.Lost
                                        , feature = model.goldKey.feature
                                        }
                                  }
                                , Types.Command.resultWithItem model.goldKey
                                )

                            else
                                noop

                        _ ->
                            noop

                _ ->
                    noop

        ------------
        -- Machine
        ------------
        Types.Command.Noun.Machine ->
            case command.verb of
                Types.Command.Verb.Look ->
                    case model.machine of
                        Types.Object.Opened _ ->
                            if model.goldKey.status == Types.Object.Exist then
                                message
                                    ("中には"
                                        ++ model.goldKey.feature.name
                                        ++ "が置かれています。"
                                    )

                            else
                                message "何もありません。"

                        _ ->
                            message
                                ("4桁の数字を入力できそうです。"
                                    ++ "入力する場合は`input 数字4桁`で"
                                    ++ "コマンド入力してください。"
                                )

                Types.Command.Verb.Open ->
                    case model.machine of
                        Types.Object.Closed state ->
                            ( { model
                                | machine =
                                    Types.Object.Opened state
                              }
                            , Types.Command.resultOk
                            )

                        _ ->
                            noop

                _ ->
                    noop

        Types.Command.Noun.MachineUnlockNumber ->
            case command.verb of
                Types.Command.Verb.Input ->
                    case model.machine of
                        Types.Object.Locked state ->
                            ( { model
                                | machine =
                                    Types.Object.Opened state
                              }
                            , Types.Command.resultWithMessage "入力に成功しました。"
                            )

                        _ ->
                            noop

                _ ->
                    noop

        ------------
        -- Sofa
        ------------
        Types.Command.Noun.Sofa ->
            case command.verb of
                Types.Command.Verb.Look ->
                    message
                        ("革製の高級そうなソファです。"
                            ++ model.cushion.feature.name
                            ++ "が置かれています。"
                        )

                _ ->
                    noop

        ------------
        -- ITEM
        ------------
        Types.Command.Noun.Scissors ->
            case command.verb of
                Types.Command.Verb.Use ->
                    if model.cushion.status == Types.Object.Exist then
                        ( { model
                            | cushion =
                                { status = Types.Object.Broken
                                , feature = model.cushion.feature
                                }
                            , bronzeKey =
                                { status = Types.Object.Exist
                                , feature = model.bronzeKey.feature
                                }
                          }
                        , Types.Command.resultWithMessage
                            "クッションを切りました。"
                        )

                    else
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
    , Images.Sofa.view model.sofa { x = 0, y = 200 }
    , Images.Cushion.view model.cushion { x = 400, y = 270 }
    , Images.GoldKey.view model.goldKey { x = 305, y = 145 }
    , Images.Machine.view model.machine { x = 260, y = 140 }
    ]
