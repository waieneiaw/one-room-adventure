module Places.Room.West exposing (Model, init, update, view)

import Images.Wall
import Svg exposing (Svg)
import Types.Argument
import Types.Command
import Types.Command.Noun
import Types.Command.Verb


type alias Model =
    {}


init : Model
init =
    Model


update :
    Types.Argument.UpdateDirectionArgs Model
    -> ( Model, Types.Command.Result )
update { model, command } =
    let
        message : String -> ( Model, Types.Command.Result )
        message text =
            ( model
            , Types.Command.resultWithoutItem text
            )

        noop =
            ( model, Types.Command.noResults )
    in
    case ( command.noun, command.verb ) of
        ------------
        -- ONLY VERB
        ------------
        ( Types.Command.Noun.None, Types.Command.Verb.Look ) ->
            message "西を向いています。何もありません。"

        _ ->
            noop


view : Model -> List (Svg msg)
view _ =
    [ Images.Wall.view
    ]
