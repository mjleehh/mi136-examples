module State exposing (..)

type alias Tags = List String

type alias Entry =
    {
        name: String,
        surname: Maybe String,
        company: Maybe String,
        email: String,
        phone: Maybe String,
        tags: Tags
    }

type alias EntryWithId = (String, Entry)

type Tabs = LIST_VIEW | ADD_VIEW | MODIFY_VIEW

type alias UiState =
    {
        tab: Tabs,
        search: Maybe String,
        newEntry: Entry,
        modifyEntry: EntryWithId
    }

type alias Entries = List EntryWithId

type Status = DEFAULT | STORING | LOADING

type alias DataState =
    {
        status: Status,
        entries: Entries
    }

type alias State =
    {
        ui: UiState,
        data: DataState
    }

