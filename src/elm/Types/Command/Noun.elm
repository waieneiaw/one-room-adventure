module Types.Command.Noun exposing (Noun(..), fromString)

import Types.Item exposing (ItemType(..))


type Noun
    = None
    | Never
    | Board
    | Box
    | BronzeKey
    | Cushion
    | Desk
    | Door
    | Drawer1
    | Drawer2
    | GoldKey
    | Machine
    | MachineUnlockNumber
    | Notebook
    | PaperOfSafeTips
    | PaperOfMachineTips
    | Rack
    | Safe
    | SafeUnlockNumber
    | Scissors
    | Screwdriver
    | SilverKey
    | Sofa


fromString : Maybe String -> Noun
fromString value =
    let
        noun =
            value
                |> Maybe.map (\value_ -> String.toLower value_)
    in
    case noun of
        Just "board" ->
            Board

        Just "box" ->
            Box

        Just "bronzekey" ->
            BronzeKey

        Just "cushion" ->
            Cushion

        Just "desk" ->
            Desk

        Just "door" ->
            Door

        Just "drawer1" ->
            Drawer1

        Just "drawer2" ->
            Drawer2

        Just "goldkey" ->
            GoldKey

        Just "machine" ->
            Machine

        Just "0693" ->
            MachineUnlockNumber

        Just "notebook" ->
            Notebook

        Just "paper1" ->
            PaperOfSafeTips

        Just "paper2" ->
            PaperOfMachineTips

        Just "rack" ->
            Rack

        Just "safe" ->
            Safe

        Just "2018" ->
            SafeUnlockNumber

        Just "scissors" ->
            Scissors

        Just "screwdriver" ->
            Screwdriver

        Just "silverkey" ->
            SilverKey

        Just "sofa" ->
            Sofa

        Nothing ->
            None

        _ ->
            Never
