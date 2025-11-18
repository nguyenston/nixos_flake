import { Gtk } from "ags/gtk3"
import Mpris from "gi://AstalMpris"
import { createBinding } from "ags"

function lengthStr(length: number) {
  const min = Math.floor(length / 60)
  const sec = Math.floor(length % 60)
  const sec0 = sec < 10 ? "0" : ""
  return `${min}:${sec0}${sec}`
}

export default function MediaPlayer({ player }: { player: Mpris.Player }) {
  const { START, END } = Gtk.Align

  const title = createBinding(player, "title").as(t =>
    t || "Unknown Track")

  const artist = createBinding(player, "artist").as(a =>
    a || "Unknown Artist")

  const coverArt = createBinding(player, "coverArt").as(c =>
    `background-image: url('${c}')`)

  const playerIcon = createBinding(player, "entry")

  const position = createBinding(player, "position").as(p => player.length > 0
    ? p / player.length : 0)

  const playIcon = createBinding(player, "playbackStatus").as(s =>
    s === Mpris.PlaybackStatus.PLAYING
      ? "media-playback-pause-symbolic"
      : "media-playback-start-symbolic"
  )

  return <box className="MediaPlayer">
    <box className="cover-art" css={coverArt} />
    <box className="playerinfo" vertical>
      <box>
        <label className="title" truncate hexpand halign={START} label={title} />
        <icon className="playericon" name={playerIcon} />
      </box>
      <label halign={START} valign={START} vexpand wrap className="artist" label={artist} />
      <slider
        cursor="pointer"
        visible={createBinding(player, "length").as(l => l > 0)}
        onDragged={({ value }) => player.position = value * player.length}
        value={position}
      />
      <centerbox className="actions">
        <label
          hexpand
          className="position"
          halign={START}
          visible={createBinding(player, "length").as(l => l > 0)}
          label={createBinding(player, "position").as(lengthStr)}
        />
        <box className="controls">
          <button
            cursor="pointer"
            onClicked={() => player.previous()}
            visible={createBinding(player, "canGoPrevious")}>
            <icon icon="media-skip-backward-symbolic" />
          </button>
          <button
            cursor="pointer"
            onClicked={() => player.play_pause()}
            visible={createBinding(player, "canControl")}>
            <icon icon={playIcon} />
          </button>
          <button
            cursor="pointer"
            onClicked={() => player.next()}
            visible={createBinding(player, "canGoNext")}>
            <icon icon="media-skip-forward-symbolic" />
          </button>
        </box>
        <label
          className="length"
          hexpand
          halign={END}
          visible={createBinding(player, "length").as(l => l > 0)}
          label={createBinding(player, "length").as(l => l > 0 ? lengthStr(l) : "0:00")}
        />
      </centerbox>
    </box>
  </box>
}
