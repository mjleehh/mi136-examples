module State exposing (..)

type alias Tags = List String

type alias Entry =
    {
        id: Maybe String,
        name: String,
        surname: Maybe String,
        company: Maybe String,
        email: String,
        phone: Maybe String,
        tags: Tags
    }

type Tabs = LIST_VIEW | ADD_VIEW | MODIFY_VIEW

type alias UiState =
    {
        tab: Tabs,
        search: Maybe String,
        newEntry: Entry,
        modifyEntry: Entry
    }

type alias Entries = List Entry

type Status = DEFAULT | STORING | LOADING

type alias DataState =
    {
        status: Status,
        entries: List Entry
    }

type alias State =
    {
        ui: UiState,
        data: DataState
    }

