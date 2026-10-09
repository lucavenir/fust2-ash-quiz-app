# itsquitz

a real-time trivia quiz app for events and walk-by booths.

built with **elixir**, **phoenix liveview**, the **ash framework**, and **postgresql 18**.

---

## how it works

1. **join**: players scan a qr code, enter a 5-digit room code, and pick a username.
2. **lobby**: a genserver holds players in memory and groups them into teams of 4.
3. **play**: an admin starts the round. 40 unique questions are picked from postgres (10 per player) with a 2-minute timer.
4. **score**: player choices stay in memory during play. when time ends, final results freeze to postgres for the leaderboard.

---

## domain structure

### content domain (`Itsquitz.Content`)

* **topic**: category name.
* **question**: question text, optional image url, topic link.
* **answer**: option text, points awarded, question link.

### game domain (`Itsquitz.Game`)

* **team**: team name, code.
* **player**: username, optional team link.
* **play**: game session state (`:lobby`, `:in_progress`, `:completed`), team link.
* **player_answer**: in-memory struct (`Ash.DataLayer.Simple`) for active choices during play.
* **results**: immutable postgres snapshot saved when a round finishes.

---

## setup

### 1. install dependencies

```bash
mix deps.get

```

### 2. setup database

```bash
mix ecto.setup

```

### 3. run server

```bash
mix phx.server
```

