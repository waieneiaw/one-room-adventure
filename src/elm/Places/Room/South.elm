module Places.Room.South exposing (Model, init, update, view)

import Images.BronzeKey
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
            let
                target =
                    model.bronzeKey
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    if target.status == Types.Object.Exist then
                        message
                            ("銅の色をした、何の変哲もない鍵です。"
                                ++ "ソファに張り付いていますが、取れそうです。"
                            )

                    else
                        noop

                Types.Command.Verb.Take ->
                    if target.status == Types.Object.Exist then
                        ( { model
                            | bronzeKey =
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
        -- Cushion
        ------------
        Types.Command.Noun.Cushion ->
            let
                target =
                    model.cushion
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    if target.status == Types.Object.Exist then
                        message
                            "妙に角張っていますが、触ってみると柔らかいです。"

                    else
                        noop

                Types.Command.Verb.Take ->
                    if target.status == Types.Object.Exist then
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
            let
                target =
                    model.goldKey

                place =
                    model.machine
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    case place of
                        Types.Object.Opened _ ->
                            if target.status == Types.Object.Exist then
                                message "金色に輝いている鍵です。高級感が漂います。"

                            else
                                noop

                        _ ->
                            noop

                Types.Command.Verb.Take ->
                    case place of
                        Types.Object.Opened _ ->
                            if target.status == Types.Object.Exist then
                                ( { model
                                    | goldKey =
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
        -- Machine
        ------------
        Types.Command.Noun.Machine ->
            let
                target =
                    model.machine

                item =
                    model.goldKey
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    case target of
                        Types.Object.Opened _ ->
                            if item.status == Types.Object.Exist then
                                message
                                    ("機械の代わりに"
                                        ++ item.feature.name
                                        ++ "が貼り付けられています。"
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
                    case target of
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
            let
                target =
                    model.machine
            in
            case command.verb of
                Types.Command.Verb.Input ->
                    case target of
                        Types.Object.Locked state ->
                            ( { model
                                | machine =
                                    Types.Object.Opened state
                              }
                            , Types.Command.resultWithMessage
                                ("入力に成功しました。"
                                    ++ "鍵が出てきました。"
                                )
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
                    if model.bronzeKey.status == Types.Object.Exist then
                        message
                            ("ソファの背もたれに"
                                ++ model.bronzeKey.feature.name
                                ++ "があります。"
                            )

                    else if model.cushion.status == Types.Object.Exist then
                        message
                            ("革製の高級そうなソファです。"
                                ++ model.cushion.feature.name
                                ++ "が置かれています。"
                            )

                    else
                        message
                            "革製の高級そうなソファです。"

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
                            ("クッションを切ってソファから剥がしてみました。"
                                ++ "ソファに何かがくっついています。"
                            )
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
    , Images.BronzeKey.view model.bronzeKey { x = 440, y = 310 }
    , Images.Cushion.view model.cushion { x = 400, y = 270 }
    , Images.GoldKey.view model.goldKey { x = 305, y = 145 }
    , Images.Machine.view model.machine { x = 260, y = 140 }
    ]
