module Places.Room.North exposing (Model, init, update, view)

import Images.Door
import Images.Wall
import Svg exposing (Svg)
import Types.Argument
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Item
import Types.Object


type alias Model =
    { door : Types.Object.Openable
    , board : Types.Object.Openable
    , screw : Types.Object.Plain
    , paper2 : Types.Object.Plain
    }


init : Model
init =
    { door =
        Types.Object.Locked
            { feature =
                { type_ = Types.Item.None
                , name = "ドア（DOOR）"
                }
            }
    , board =
        Types.Object.Locked
            { feature =
                { type_ = Types.Item.None
                , name = "板（BOARD）"
                }
            }
    , screw =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.None
            , name = "ねじ（SCREW）"
            }
        }
    , paper2 =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.PaperOfMachineTips
            , name = "紙2（PAPER2）"
            }
        }
    }


update :
    Types.Argument.UpdateDirectionArgs Model
    -> ( Model, Types.Command.Result )
update { items, model, command } =
    let
        message : String -> ( Model, Types.Command.Result )
        message text =
            ( model, Types.Command.resultWithMessage text )

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
                        board =
                            Types.Object.getOpenableState model.board

                        door =
                            Types.Object.getOpenableState model.door
                    in
                    case model.board of
                        Types.Object.Opened _ ->
                            message
                                (door.feature.name
                                    ++ "があります。"
                                )

                        _ ->
                            message
                                (door.feature.name
                                    ++ "と"
                                    ++ board.feature.name
                                    ++ "があります。"
                                )

                _ ->
                    noop

        ------------
        -- Door
        ------------
        Types.Command.Noun.Door ->
            case command.verb of
                Types.Command.Verb.Look ->
                    case model.door of
                        Types.Object.Locked _ ->
                            message
                                ("何の変哲もないドアです。"
                                    ++ "鍵がかかっているようです。"
                                )

                        Types.Object.Closed state ->
                            ( { model
                                | door =
                                    Types.Object.Opened state
                              }
                            , Types.Command.resultOk
                            )

                        _ ->
                            message
                                "何の変哲もないドアです。"

                Types.Command.Verb.Close ->
                    case model.door of
                        Types.Object.Opened state ->
                            ( { model
                                | door = Types.Object.Closed state
                              }
                            , Types.Command.resultOk
                            )

                        _ ->
                            noop

                Types.Command.Verb.Take ->
                    message "さすがに無理です。"

                _ ->
                    noop

        ------------
        -- Paper2
        ------------
        Types.Command.Noun.PaperOfMachineTips ->
            case command.verb of
                Types.Command.Verb.Look ->
                    case model.board of
                        Types.Object.Opened _ ->
                            if model.paper2.status == Types.Object.Exist then
                                message
                                    "何か書かれています。"

                            else
                                noop

                        _ ->
                            noop

                Types.Command.Verb.Read ->
                    case model.board of
                        Types.Object.Opened _ ->
                            if model.paper2.status == Types.Object.Exist then
                                message
                                    ("何かの暗号のようなものが書かれていますが、"
                                        ++ "取らないと読めません。"
                                    )

                            else
                                noop

                        _ ->
                            noop

                Types.Command.Verb.Take ->
                    case model.board of
                        Types.Object.Opened _ ->
                            if model.paper2.status == Types.Object.Exist then
                                ( { model
                                    | paper2 =
                                        { status = Types.Object.Lost
                                        , feature = model.paper2.feature
                                        }
                                  }
                                , Types.Command.resultWithItem model.paper2
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
        Types.Command.Noun.GoldKey ->
            case command.verb of
                Types.Command.Verb.Use ->
                    let
                        goldKey =
                            Types.Item.getItem items Types.Item.GoldKey
                    in
                    case model.door of
                        Types.Object.Locked state ->
                            case goldKey of
                                Just _ ->
                                    ( { model
                                        | door = Types.Object.Closed state
                                      }
                                    , Types.Command.resultWithMessage "ドアの鍵が開きました。"
                                    )

                                _ ->
                                    noop

                        _ ->
                            noop

                _ ->
                    noop

        Types.Command.Noun.Screwdriver ->
            case command.verb of
                Types.Command.Verb.Use ->
                    let
                        screwdriver =
                            Types.Item.getItem items Types.Item.Screwdriver
                    in
                    case model.board of
                        Types.Object.Locked state ->
                            case screwdriver of
                                Just _ ->
                                    ( { model
                                        | board = Types.Object.Opened state
                                      }
                                    , Types.Command.resultWithMessage "板が外れました。"
                                    )

                                _ ->
                                    noop

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
    , Images.Door.view model.door { x = 360, y = 196 }

    -- , Images.Paper.view model.paper { x = 100, y = 200 }
    ]
