module Types.Command.Noun exposing (Noun(..), fromString)


type Noun
    = None
    | Never
    | Door
    | Paper
    | Desk


fromString : Maybe String -> Noun
fromString noun =
    case noun of
        Just "door" ->
            Door

        Just "paper" ->
            Paper

        Just "desk" ->
            Desk

        Nothing ->
            None

        _ ->
            Never
