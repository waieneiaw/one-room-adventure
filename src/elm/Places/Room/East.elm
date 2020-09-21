module Places.Room.East exposing (Model, init, update, view)

import Images.Wall
import Svg exposing (Svg)
import Types.Argument
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Item
import Types.Object


type alias Model =
    { rack : Types.Object.Plain
    , safe : Types.Object.Openable
    , box : Types.Object.Openable
    , silverKey : Types.Object.Plain
    , screwdriver : Types.Object.Plain
    }


init : Model
init =
    { rack =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.None
            , name = "棚（RACK）"
            }
        }
    , safe =
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
    case ( command.noun, command.verb ) of
        ------------
        -- ONLY VERB
        ------------
        ( Types.Command.Noun.None, Types.Command.Verb.Look ) ->
            message
                (model.rack.feature.name ++ "があります。")

        ------------
        -- Box
        ------------
        ( Types.Command.Noun.Box, Types.Command.Verb.Look ) ->
            case model.box of
                Types.Object.Opened _ ->
                    message
                        ("銅色の箱です。中に。"
                            ++ model.silverKey.feature.name
                            ++ "があります。"
                        )

                _ ->
                    message
                        "銅色の箱です。鍵穴がついています。"

        ( Types.Command.Noun.Box, Types.Command.Verb.Open ) ->
            case model.box of
                Types.Object.Closed state ->
                    ( { model
                        | box =
                            Types.Object.Opened
                                { feature = state.feature
                                }
                      }
                    , Types.Command.resultOk
                    )

                _ ->
                    noop

        ( Types.Command.Noun.Box, Types.Command.Verb.Close ) ->
            case model.box of
                Types.Object.Opened state ->
                    ( { model
                        | box =
                            Types.Object.Closed
                                { feature = state.feature
                                }
                      }
                    , Types.Command.resultOk
                    )

                _ ->
                    noop

        ------------
        -- Rack
        ------------
        ( Types.Command.Noun.Rack, Types.Command.Verb.Look ) ->
            let
                box =
                    Types.Object.getOpenableState model.box

                safe =
                    Types.Object.getOpenableState model.safe
            in
            message
                ("中に"
                    ++ box.feature.name
                    ++ "と"
                    ++ safe.feature.name
                    ++ "があります。"
                )

        ------------
        -- Safe
        ------------
        ( Types.Command.Noun.Safe, Types.Command.Verb.Look ) ->
            case model.safe of
                Types.Object.Opened _ ->
                    if model.screwdriver.status == Types.Object.Exist then
                        message
                            ("中には"
                                ++ model.screwdriver.feature.name
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

        ( Types.Command.Noun.Safe, Types.Command.Verb.Open ) ->
            case model.safe of
                Types.Object.Closed state ->
                    ( { model
                        | safe =
                            Types.Object.Opened
                                { feature = state.feature
                                }
                      }
                    , Types.Command.resultOk
                    )

                _ ->
                    noop

        ( Types.Command.Noun.Safe, Types.Command.Verb.Close ) ->
            case model.safe of
                Types.Object.Closed state ->
                    ( { model
                        | safe =
                            Types.Object.Closed
                                { feature = state.feature
                                }
                      }
                    , Types.Command.resultOk
                    )

                _ ->
                    noop

        ( Types.Command.Noun.SafeUnlockNumber, Types.Command.Verb.Unlock ) ->
            case model.safe of
                Types.Object.Locked state ->
                    ( { model
                        | safe =
                            Types.Object.Closed
                                { feature = state.feature
                                }
                      }
                    , Types.Command.resultWithMessage "解錠に成功しました。"
                    )

                _ ->
                    noop

        ------------
        -- Screwdriver
        ------------
        ( Types.Command.Noun.Screwdriver, Types.Command.Verb.Look ) ->
            case model.safe of
                Types.Object.Opened _ ->
                    if model.screwdriver.status == Types.Object.Exist then
                        message "大きめのプラスドライバーです。"

                    else
                        noop

                _ ->
                    noop

        ( Types.Command.Noun.Screwdriver, Types.Command.Verb.Take ) ->
            case model.safe of
                Types.Object.Opened _ ->
                    if model.screwdriver.status == Types.Object.Exist then
                        ( { model
                            | screwdriver =
                                { status = Types.Object.Lost
                                , feature = model.screwdriver.feature
                                }
                          }
                        , Types.Command.resultWithItem model.screwdriver
                        )

                    else
                        noop

                _ ->
                    noop

        ------------
        -- SilverKey
        ------------
        ( Types.Command.Noun.SilverKey, Types.Command.Verb.Look ) ->
            if model.silverKey.status == Types.Object.Exist then
                message
                    "銀色の鍵です。少し小さいです。"

            else
                noop

        ( Types.Command.Noun.SilverKey, Types.Command.Verb.Take ) ->
            if model.silverKey.status == Types.Object.Exist then
                ( { model
                    | silverKey =
                        { status = Types.Object.Lost
                        , feature = model.silverKey.feature
                        }
                  }
                , Types.Command.resultWithItem model.silverKey
                )

            else
                noop

        ------------
        -- ITEM
        ------------
        ( Types.Command.Noun.BronzeKey, Types.Command.Verb.Use ) ->
            case model.box of
                Types.Object.Locked state ->
                    ( { model
                        | box =
                            Types.Object.Closed
                                { feature = state.feature
                                }
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

        ------------
        -- NoOp
        ------------
        _ ->
            noop


view : Model -> List (Svg msg)
view _ =
    [ Images.Wall.view
    ]
