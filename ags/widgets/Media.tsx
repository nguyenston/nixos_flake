import AstalMpris from "gi://AstalMpris?version=0.1"
import { createBinding } from "ags"
import { Gtk } from "ags/gtk3"

export default function Media() {
  const mpris = AstalMpris.get_default()

  return <box className="Media">
    {createBinding(mpris, "players").as(ps => ps[0] ? (
      <box>
        <box
          className="Cover"
          valign={Gtk.Align.CENTER}
          css={createBinding(ps[0], "coverArt").as(cover =>
            `background-image: url('${cover}');`
          )}
        />
        <label
          label={createBinding(ps[0], "title").as(() =>
            `${ps[0].title} - ${ps[0].artist}`
          )}
        />
      </box>
    ) : (
      "Nothing Playing"
    ))}
  </box>
}
