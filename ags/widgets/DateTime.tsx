import GLib from "gi://GLib?version=2.0"
import { createPoll } from "ags/time"

export default function DateTime({ timefmt = "%H:%M", datefmt = "%a %d %b" }) {
  const time = createPoll("", 1000, () => GLib.DateTime.new_now_local().format(timefmt)!)
  const date = createPoll("", 1000, () => GLib.DateTime.new_now_local().format(datefmt)!)

  return <box class="DateTime" spacing={3}>
    <label class="date" label={date()} />
    <label class="dot" label="•"></label>
    <label class="time" label={time()} />
  </box>
}
