# MI136 Examples

This repo contains the code examples for the MI136 class held in winter semseter
2018 at FH Kiel.

Each example can be found in a separate subfolder.

### Requirements

You will need to install the following tools:

* **Node.js** JavaScript runtime
* **npm** package manager
* **npx** package runner
* **elm** [development tool chain](https://guide.elm-lang.org/install.html)
* **elm-live** [auto refresh build runner](https://github.com/wking-io/elm-live)

### Running Examples:

From an example folder run

```bash
./start
```

to run an example.

**NOTE:** windows users have to run this command in a BASH shell. Use Git BASH for example.


### List of examples:

#### Counter

`/counter`

[view app](http://mi136-counter.appspot.com/)

a very basic elm app that demonstrates the use of state

![counter screenshot](resources/counter.png)


#### Notes with Dementia

`/notes-with-dementia`

[view app](http://mi136-notes-with-dementia.appspot.com/)

a note application that does not store the notes

![notes with dementia screen shot](resources/notes-with-dementia.png)


#### Address Book

`/address-book`

[view app](https://mi136-address-book.appspot.com/)

A more complex application handling interaction with the materialize framework and
storing data in the local IndexDB.

Create and remove entries:
![create an entry](resources/address-book/create.png)

Adding and removing tags:
![create an entry](resources/address-book/tags.png)

Searching for entries by name:
![create an entry](resources/address-book/search-name.png)

Searching for entries by tag:
![create an entry](resources/address-book/search-tags.png)

The database storage:
![create an entry](resources/address-book/database.png)
