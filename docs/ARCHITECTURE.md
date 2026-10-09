# architecture

key design choices and data boundaries for itsquitz.

## 1. we do not persist *temporary* results 

* `PlayerAnswer` is the only resources that uses `Ash.DataLayer.Simple` (pure in-memory structs). in other words, expect zero postgres writes occur during the active 2-minute countdown. we handle this inside a dedicated genserver / liveview process.
* `Results`, instead, writes the "historical results" to postgres when a game finishes.

## 2. about "historical results" vs "live changes"

* `Results` copies `question_text`, `answer_text`, and `points` at game completion
    * in other words, `Results` drops foreign keys to `Question` and `Answer`
    * again, future admin edits or deletes in `Content` will never alter past leaderboard scores.
    * this struct still keeps foreign keys towards `Play`, `Player`, `Team`, so we can score aggregations.
* `PlayerAnswer`, instead, holds an in memory struct which links `Question` and `Answer`
    * this struct is the main sync point during a game

## 3. isolated execution (`Play` 1:1 `Team`)

* a `Play` session represents a 2-minute game run for a single 4-player `Team`.
* teams start, play, and finish on an independent genserver, thus with an independent timer, without interfering with other lobby groups.

TBD.
