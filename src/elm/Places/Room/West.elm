module Places.Room.West exposing (Model, init, update, view)

import Images.Desk
import Images.LowerDrawer
import Images.Notebook
import Images.UpperDrawer
import Images.Wall
import Svg exposing (Svg)
import Types.Argument
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Item
import Types.Object


type alias Model =
    { desk : Types.Object.Plain
    , drawer1 : Types.Object.Openable
    , drawer2 : Types.Object.Openable
    , scissors : Types.Object.Plain
    , paper1 : Types.Object.Plain
    , notebook : Types.Object.Openable
    }


init : Model
init =
    { desk =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.None
            , name = "とても大きな机（DESK）"
            }
        }
    , drawer1 =
        Types.Object.Closed
            { feature =
                { type_ = Types.Item.None
                , name = "上段の抽斗（DRAWER1）"
                }
            }
    , drawer2 =
        Types.Object.Locked
            { feature =
                { type_ = Types.Item.None
                , name = "下段の抽斗（DRAWER2）"
                }
            }
    , scissors =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.Scissors
            , name = "はさみ（SCISSORS）"
            }
        }
    , paper1 =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.PaperOfSafeTips
            , name = "紙1（PAPER1）"
            }
        }
    , notebook =
        Types.Object.Closed
            { feature =
                { type_ = Types.Item.None
                , name = "ノート（NOTEBOOK）"
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
                    message
                        (model.desk.feature.name
                            ++ "があります。"
                        )

                _ ->
                    noop

        ------------
        -- Desk
        ------------
        Types.Command.Noun.Desk ->
            let
                notebook =
                    Types.Object.getOpenableState model.notebook

                drawer1 =
                    Types.Object.getOpenableState model.drawer1

                drawer2 =
                    Types.Object.getOpenableState model.drawer2
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    message
                        ("机の上には"
                            ++ notebook.feature.name
                            ++ "が置かれています。また、"
                            ++ drawer1.feature.name
                            ++ "と"
                            ++ drawer2.feature.name
                            ++ "があります。"
                        )

                _ ->
                    noop

        ------------
        -- Drawer1
        ------------
        Types.Command.Noun.Drawer1 ->
            let
                target =
                    model.drawer1
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    case target of
                        Types.Object.Opened _ ->
                            if model.scissors.status == Types.Object.Exist then
                                message
                                    ("中には"
                                        ++ model.scissors.feature.name
                                        ++ "があります。"
                                    )

                            else
                                message "何もありません。"

                        _ ->
                            message
                                "ただの抽斗です。閉まっています。"

                Types.Command.Verb.Open ->
                    case target of
                        Types.Object.Closed state ->
                            case model.drawer2 of
                                Types.Object.Opened _ ->
                                    message
                                        "何かがひっかかっていて開きません。"

                                _ ->
                                    ( { model
                                        | drawer1 =
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
                                | drawer1 =
                                    Types.Object.Closed state
                              }
                            , Types.Command.resultOk
                            )

                        _ ->
                            noop

                _ ->
                    noop

        ------------
        -- Drawer2
        ------------
        Types.Command.Noun.Drawer2 ->
            let
                target =
                    model.drawer2

                item =
                    model.paper1
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    case target of
                        Types.Object.Opened _ ->
                            if item.status == Types.Object.Exist then
                                message
                                    (model.paper1.feature.name ++ "が入っています。")

                            else
                                message
                                    "何もありません。"

                        _ ->
                            message
                                "鍵穴がついた抽斗です。"

                Types.Command.Verb.Open ->
                    case target of
                        Types.Object.Closed state ->
                            case model.drawer1 of
                                Types.Object.Opened _ ->
                                    message
                                        "何かがひっかかっていて開きません。"

                                _ ->
                                    ( { model
                                        | drawer2 =
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
                                | drawer2 =
                                    Types.Object.Closed state
                              }
                            , Types.Command.resultOk
                            )

                        _ ->
                            noop

                _ ->
                    noop

        ------------
        -- Notebook
        ------------
        Types.Command.Noun.Notebook ->
            let
                target =
                    model.notebook

                content =
                    message
                        ("「プレイしてくれてありがとうございます！」"
                            ++ "……と書かれています。"
                            ++ "それ以外のページは白紙です。"
                        )
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    case target of
                        Types.Object.Opened _ ->
                            content

                        _ ->
                            message
                                "ふつうのノートです。"

                Types.Command.Verb.Read ->
                    case target of
                        Types.Object.Opened _ ->
                            content

                        _ ->
                            noop

                Types.Command.Verb.Take ->
                    message "背表紙が机にくっついていて、取れません。"

                Types.Command.Verb.Open ->
                    case target of
                        Types.Object.Closed state ->
                            ( { model
                                | notebook =
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
                                | notebook =
                                    Types.Object.Closed
                                        { feature = state.feature
                                        }
                              }
                            , Types.Command.resultOk
                            )

                        _ ->
                            noop

                _ ->
                    noop

        ------------
        -- Paper1
        ------------
        Types.Command.Noun.PaperOfSafeTips ->
            let
                target =
                    model.paper1
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    case model.drawer2 of
                        Types.Object.Opened _ ->
                            if target.status == Types.Object.Exist then
                                message
                                    "何かが書かれた紙です。"

                            else
                                noop

                        _ ->
                            noop

                Types.Command.Verb.Read ->
                    case model.drawer2 of
                        Types.Object.Opened _ ->
                            if target.status == Types.Object.Exist then
                                message
                                    ("何か記号のようなものが書かれているみたいですが、"
                                        ++ "取らないとよく読めません。"
                                    )

                            else
                                noop

                        _ ->
                            noop

                Types.Command.Verb.Take ->
                    case model.drawer2 of
                        Types.Object.Opened _ ->
                            if target.status == Types.Object.Exist then
                                ( { model
                                    | paper1 =
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
        -- Scissors
        ------------
        Types.Command.Noun.Scissors ->
            let
                target =
                    model.scissors
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    case model.drawer1 of
                        Types.Object.Opened _ ->
                            if target.status == Types.Object.Exist then
                                message "大きなはさみです。裁断ばさみだと思います。"

                            else
                                noop

                        _ ->
                            noop

                Types.Command.Verb.Take ->
                    case model.drawer1 of
                        Types.Object.Opened _ ->
                            if target.status == Types.Object.Exist then
                                ( { model
                                    | scissors =
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
        -- ITEM
        ------------
        Types.Command.Noun.SilverKey ->
            case command.verb of
                Types.Command.Verb.Use ->
                    case model.drawer2 of
                        Types.Object.Locked state ->
                            ( { model
                                | drawer2 =
                                    Types.Object.Closed state
                              }
                            , Types.Command.resultWithMessage
                                "下段の抽斗の鍵が開きました。"
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
    , Images.Desk.view model.desk { x = 32, y = 220 }
    , Images.Notebook.view model.notebook { x = 200, y = 225 }
    , Images.LowerDrawer.view model.drawer2 { x = 382, y = 365 }
    , Images.UpperDrawer.view model.drawer1 { x = 382, y = 280 }
    ]
