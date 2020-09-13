module Places.Room.North exposing (Model, init, update, view)

import Images.Door
import Images.Paper
import Images.Wall
import Svg exposing (Svg)
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Door
import Types.Item
import Types.Object


type alias Model =
    { door : Types.Door.Door
    , paper : Types.Object.Object
    }


init : Model
init =
    let
        door =
            { opened = False, locked = False }

        paper =
            Types.Object.Exist
                { type_ = Types.Item.Paper
                , name = "紙（PAPER）"
                , weight = 1
                }
    in
    Model
        door
        paper


noResults : Model -> ( Model, Types.Command.Result )
noResults model =
    ( model, Types.Command.noResults )


update : Model -> Types.Command.Command -> ( Model, Types.Command.Result )
update model { verb, noun } =
    case verb of
        Types.Command.Verb.Open ->
            case noun of
                Types.Command.Noun.Door ->
                    ( { model
                        | door = { opened = True, locked = False }
                      }
                    , Types.Command.resultWithoutItem
                        "ドアを開けました。"
                    )

                _ ->
                    noResults model

        Types.Command.Verb.Close ->
            case noun of
                Types.Command.Noun.Door ->
                    ( { model
                        | door = { opened = False, locked = False }
                      }
                    , Types.Command.resultWithoutItem
                        "ドアを閉めました。"
                    )

                _ ->
                    noResults model

        Types.Command.Verb.Look ->
            case noun of
                Types.Command.Noun.Door ->
                    ( model
                    , Types.Command.resultWithoutItem
                        "何の変哲もないドアです。"
                    )

                Types.Command.Noun.Paper ->
                    case model.paper of
                        Types.Object.Exist _ ->
                            ( model
                            , Types.Command.resultWithoutItem
                                "壁に貼り付けられています。取れそうです。"
                            )

                        _ ->
                            noResults model

                Types.Command.Noun.None ->
                    let
                        paper =
                            case model.paper of
                                Types.Object.Exist _ ->
                                    "、紙切れ(PAPER)"

                                _ ->
                                    ""
                    in
                    ( model
                    , Types.Command.resultWithoutItem
                        ("目の前にドア(DOOR)"
                            ++ paper
                            ++ "があります。"
                        )
                    )

                _ ->
                    noResults model

        Types.Command.Verb.Take ->
            case noun of
                Types.Command.Noun.Door ->
                    ( model
                    , Types.Command.resultWithoutItem
                        "さすがに無理です。"
                    )

                Types.Command.Noun.Paper ->
                    case model.paper of
                        Types.Object.Exist item ->
                            ( { model
                                | paper = Types.Object.NotExist
                              }
                            , Types.Command.resultWithItem "紙を取りました。"
                                item
                            )

                        _ ->
                            noResults model

                _ ->
                    noResults model

        _ ->
            noResults model


view : Model -> List (Svg msg)
view model =
    [ Images.Wall.view
    , Images.Door.view model.door.opened { x = 360, y = 196 }
    , Images.Paper.view model.paper { x = 100, y = 200 }
    ]
