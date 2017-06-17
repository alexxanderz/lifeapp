defmodule Util.Patterns do
    def translate([], _dx, _dy), do: []
    def translate([{x, y} | cells], dx, dy) do
        [{x + dx, y + dy} | translate(cells, dx, dy)]
    end

    def blinker do
        [
            {1, 0},
            {1, 1},
            {1, 2},
        ]
    end

    def toad do
        [
            {2, 3},
            {0, 2}, {3, 2},
            {0, 1}, {3, 1},
            {1, 0},
        ]
    end

    def beacon do
        [
            {0, 3}, {1, 3},
            {0, 2},
            {3, 1},
            {2, 0}, {3, 0},
        ]
    end

    def pulsar do
        [
            {2, 12}, {3, 12}, {4, 12}, {8, 12}, {9, 12}, {10, 12},

            {0, 10}, {5, 10}, {7, 10}, {12, 10},
            {0, 9}, {5, 9}, {7, 9}, {12, 9},
            {0, 8}, {5, 8}, {7, 8}, {12, 8},

            {2, 7}, {3, 7}, {4, 7}, {8, 7}, {9, 7}, {10, 7},

            {2, 5}, {3, 5}, {4, 5}, {8, 5}, {9, 5}, {10, 5},

            {0, 4}, {5, 4}, {7, 4}, {12, 4},
            {0, 3}, {5, 3}, {7, 3}, {12, 3},
            {0, 2}, {5, 2}, {7, 2}, {12, 2},

            {2, 0}, {3, 0}, {4, 0}, {8, 0}, {9, 0}, {10, 0},
        ]
    end

    def pentadecathlon do
        [
            {1, 11}, {2, 11}, {3, 11},
            {0, 10}, {4, 10},
            {0, 9}, {4, 9},
            {1, 8}, {2, 8}, {3, 8},
            {0, 2}, {4, 2},
            {0, 1}, {4, 1},
            {1, 0}, {2, 0}, {3, 0},
        ]
    end

    def r_pentomino do
        [
            {1, 2}, {2, 2},
            {0, 1}, {1, 1},
            {1, 0},
        ]
    end

    def diehard do
        [
            {6, 2},
            {0, 1}, {1, 1},
            {1, 0}, {5, 0}, {6, 0}, {7, 0},
        ]
    end

    def acorn do
        [
            {1, 2},
            {3, 1},
            {0, 0}, {1, 0}, {4, 0}, {5, 0}, {6, 0},
        ]
    end

    def gosper_glider do
        [
            {24, 8},
            {22, 7}, {24, 7},
            {12, 6}, {13, 6}, {20, 6}, {21, 6}, {34, 6}, {35, 6},
            {11, 5}, {15, 5}, {20, 5}, {21, 5}, {34, 5}, {35, 5},
            {0, 4}, {1, 4}, {10, 4}, {16, 4}, {20, 4}, {21, 4},
            {0, 3}, {1, 3}, {10, 3}, {14, 3}, {16, 3}, {17, 3}, {22, 3}, {24, 3},
            {10, 2}, {16, 2}, {24, 2},
            {11, 1}, {15, 1},
            {12, 0}, {13, 0},
        ]
    end

    def p1 do
        blinker()
        |> translate(5, 5)
        |> Cell.new_cells()
    end

    def p2 do
        toad()
        |> translate(5, 5)
        |> Cell.new_cells()
    end

    def p3 do
        beacon()
        |> translate(5, 5)
        |> Cell.new_cells()
    end

    def p4 do
        pulsar()
        |> translate(5, 5)
        |> Cell.new_cells()
    end

    def p5 do
        pentadecathlon()
        |> translate(5, 5)
        |> Cell.new_cells()
    end

    def p6 do
        r_pentomino()
        |> translate(5, 5)
        |> Cell.new_cells()
    end

    def p7 do
        diehard()
        |> translate(5, 5)
        |> Cell.new_cells()
    end

    def p8 do
        acorn()
        |> translate(5, 5)
        |> Cell.new_cells()
    end

    def p9 do
        gosper_glider()
        |> translate(10, 25)
        |> Cell.new_cells()
    end

    def p10 do
        (
            (blinker() |> translate(0, 0)) ++
            (toad() |> translate(0, 20)) ++
            (beacon() |> translate(0, 40)) ++
            (pulsar() |> translate(0, 60)) ++

            (pentadecathlon() |> translate(20, 0)) ++
            (r_pentomino() |> translate(20, 20)) ++
            (diehard() |> translate(20, 40)) ++
            (acorn() |> translate(20, 60)) ++

            (gosper_glider() |> translate(40, 0)) ++
            (acorn() |> translate(40, 20)) ++
            (diehard() |> translate(40, 40)) ++
            (r_pentomino() |> translate(40, 60)) ++

            (pentadecathlon() |> translate(60, 0)) ++
            (pulsar() |> translate(60, 20)) ++
            (beacon() |> translate(60, 40)) ++
            (toad() |> translate(60, 60)) ++

            (blinker() |> translate(80, 0)) ++
            (pentadecathlon() |> translate(80, 20)) ++
            (pulsar() |> translate(80, 40)) ++
            (r_pentomino() |> translate(80, 60)) ++

            (gosper_glider() |> translate(100, 0)) ++
            (gosper_glider() |> translate(100, 20)) ++
            (gosper_glider() |> translate(100, 40)) ++
            (gosper_glider() |> translate(100, 60)) ++

            (blinker() |> translate(110, 0)) ++
            (pentadecathlon() |> translate(120, 20)) ++
            (pulsar() |> translate(130, 40)) ++
            (r_pentomino() |> translate(140, 60)) ++

            (blinker() |> translate(150, 0)) ++
            (pentadecathlon() |> translate(160, 20)) ++
            (pulsar() |> translate(170, 40)) ++
            (r_pentomino() |> translate(180, 60)) ++

            (blinker() |> translate(190, 0)) ++
            (pentadecathlon() |> translate(200, 20)) ++
            (pulsar() |> translate(210, 40)) ++
            (r_pentomino() |> translate(220, 60)) ++

            (blinker() |> translate(230, 0)) ++
            (pentadecathlon() |> translate(240, 20)) ++
            (pulsar() |> translate(250, 40)) ++
            (r_pentomino() |> translate(260, 60)) ++

            (gosper_glider() |> translate(270, 0)) ++
            (gosper_glider() |> translate(280, 20)) ++
            (gosper_glider() |> translate(290, 40)) ++
            (gosper_glider() |> translate(300, 60)) ++

            (gosper_glider() |> translate(310, 0)) ++
            (gosper_glider() |> translate(320, 20)) ++
            (gosper_glider() |> translate(330, 40)) ++
            (gosper_glider() |> translate(340, 60)) ++

            (gosper_glider() |> translate(350, 0)) ++
            (gosper_glider() |> translate(360, 20)) ++
            (gosper_glider() |> translate(370, 40)) ++
            (gosper_glider() |> translate(380, 60)) ++

            (gosper_glider() |> translate(390, 0)) ++
            (gosper_glider() |> translate(400, 20)) ++
            (gosper_glider() |> translate(410, 40)) ++
            (gosper_glider() |> translate(420, 60))
        )
        |> Cell.new_cells()
    end
end