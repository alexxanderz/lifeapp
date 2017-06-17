import {Socket, LongPoller} from "phoenix"

class LifeCanvas {
    constructor() {
        this.originX = 0;
        this.originY = 0;
        this.context = null;
        this.cellWidth = 10;
        this.cellHeight = 10;
    }

    ensureContext() {
        if (this.context == null)
            this.loadContext();
    }
    loadContext() {
        var canvas = document.getElementById('canvas');
        if (canvas.getContext) {
            this.context = canvas.getContext('2d');
        }
    }

    start() {
        this.ensureContext();
    }

    getRandomIntInclusive(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    update(cells) {
        this.clear();
        this.drawCells(cells);
    }

    clear() {
        this.context.fillStyle = 'white';
        this.context.fillRect(0, 0, 500, 500);
    }

    drawCells(cells) {
        for (var i = 0; i < cells.length; i++)
            this.drawCell(cells[i]);
    }

    drawCell(cell) {
        this.drawCellAt(cell[0], cell[1]);
    }

    drawCellAt(x, y) {
        this.context.fillStyle = 'green';
        this.context.fillRect(
            x * this.cellWidth - this.originX * this.cellWidth,
            y * this.cellHeight - this.originY * this.cellHeight,
            this.cellWidth,
            this.cellHeight);
    }

    moveOrigin(dx, dy) {
        this.originX += dx;
        this.originY += dy;
    }
}

class App {
    static init(){
        App.lifeCanvas = new LifeCanvas();
        App.lifeCanvas.start();

        let socket = new Socket("/socket", {
            //logger: ((kind, msg, data) => { console.log(`${kind}: ${msg}`, data) })
        })

        socket.connect({user_id: "123"});

        var $messages = $("#messages");
        var $input = $("#message-input");

        var $gen_count = $("#gen-count");
        var $cell_count = $("#cell-count");
        var $origin_text = $("#origin-text");

        socket.onOpen(ev => console.log("OPEN", ev));
        socket.onError(ev => console.log("ERROR", ev));
        socket.onClose(e => console.log("CLOSE", e));

        var chan = socket.channel("rooms:lobby", {});
        chan.join().receive("ignore", () => console.log("auth error"))
                    .receive("ok", () => console.log("join ok"))
                    .after(10000, () => console.log("Connection interruption"));
        chan.onError(e => console.log("something went wrong", e));
        chan.onClose(e => console.log("channel closed", e));

        $input.off("keypress").on("keypress", e => {
            if (e.keyCode == 13) {
                chan.push("new:msg", {user: "name", body: $input.val()});
                $input.val("");
            }
        });

        $("#start-btn").on('click', function (e) {
            chan.push("new:msg", {body: "sim:start"});
            chan.push("new:msg", {body: "sim:t10"});
        });

        $("#p1-btn").on('click', function (e) {
            chan.push("new:msg", {body: "sim:p1"});
        });
        $("#p2-btn").on('click', function (e) {
            chan.push("new:msg", {body: "sim:p2"});
        });
        $("#p3-btn").on('click', function (e) {
            chan.push("new:msg", {body: "sim:p3"});
        });
        $("#p4-btn").on('click', function (e) {
            chan.push("new:msg", {body: "sim:p10"});
        });

        $("#left-btn").on('click', function (e) {
            App.lifeCanvas.moveOrigin(-10, 0);
        });
        $("#up-btn").on('click', function (e) {
            App.lifeCanvas.moveOrigin(0, -10);
        });
        $("#down-btn").on('click', function (e) {
            App.lifeCanvas.moveOrigin(0, 10);
        });
        $("#right-btn").on('click', function (e) {
            App.lifeCanvas.moveOrigin(10, 0);
        });

        chan.on("new:msg", msg => {
            $messages.append(`<br/>${msg.body}`);
        });

        chan.on("user:entered", msg => {
            $messages.append(`<br/>connected`);
        });

        chan.on("update:cells", msg => {
            $origin_text.text(`${App.lifeCanvas.originX}, ${App.lifeCanvas.originY}`);
            $gen_count.text(msg.gen);
            $cell_count.text(msg.cells.length);

            App.lifeCanvas.update(msg.cells);
        });
    }
}

$(() => App.init());

export default App;