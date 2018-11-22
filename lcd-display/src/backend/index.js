import Koa from 'koa'
import Router from 'koa-router'
import koaBody from 'koa-body'
import five from 'johnny-five'
import _ from 'lodash'

const backend = new Koa()
backend.use(koaBody())
const router = new Router({prefix: '/api'})
backend.use(router.routes())

class LCD {
    constructor() {
        this._lcd.cursor(0,0).print(this._firstLine)
        this._lcd.cursor(1,0).print(this._secondLine)
        this._lcd.backlight()
    }

    get firstLine() {
        return this._firstLine
    }

    setFirstLine(line) {
        if (!_.isString(line)) {
            throw 'string expected'
        }
        this._firstLine = (line + " ".repeat(16)).slice(0, 16)
        this._lcd.cursor(0, 0).print(this._firstLine)
    }

    get secondLine() {
        return this._secondLine
    }

    setSecondLine(line) {
        if (!_.isString(line)) {
            throw 'string expected'
        }
        this._secondLine = (line + " ".repeat(16)).slice(0, 16)
        this._lcd.cursor(1, 0).print(this._secondLine)
    }

    get on() {
        return this._on
    }

    setOn(value) {
        if (!_.isBoolean(value)) {
            throw 'bool expected'
        }
        if (value) {
            this._lcd.backlight()
        } else {
            this._lcd.noBacklight()
        }
        this._on = value
    }

    toJson() {
        return {
            firstLine: this._firstLine,
            secondLine: this._secondLine,
            on: this._on
        }
    }

    _lcd = new five.LCD({controller: 'PCF8574T'})
    _firstLine = " ".repeat(16)
    _secondLine = " ".repeat(16)
    _on = true
}



const board = new five.Board({repl: false})
board.on('ready', () => {
    try {
        const lcd = new LCD()

        router.get('/lcd', ctx => {
            try {
                ctx.body = lcd.toJson()
            } catch {
                ctx.status = 400
            }
        })

        router.put('/backlight', ctx => {
            const {on} = ctx.request.body
            try {
                lcd.setOn(on)
                ctx.body = lcd.toJson()
            } catch {
                ctx.status = 400
            }
        })

        router.put('/firstline', ctx => {
            const {firstLine} = ctx.request.body
            try {
                lcd.setFirstLine(firstLine)
                ctx.body = lcd.toJson()
            } catch {
                ctx.status = 400
            }
        })

        router.put('/secondline', ctx => {
            const {secondLine} = ctx.request.body
            try {
                lcd.setSecondLine(secondLine)
                ctx.body = lcd.toJson()
            } catch {
                ctx.status = 400
            }
        })

        backend.use(router.routes())
        backend.listen(3000)
    } catch(e) {
        console.error(e)
    }
})


