import Wireplumber from "gi://AstalWp"
import { bind } from "astal"
import { cn, percentage } from "../utils"
import { App, Astal } from "astal/gtk3"
import AstalBluetooth from "gi://AstalBluetooth?version=0.1"

export default function AudioBluetooth() {
  const audio = Wireplumber.get_default()?.audio
  const speaker = audio?.get_default_speaker()!
  const mic = audio?.get_default_microphone()!

  const audioVolText = bind(speaker, "volume").as(vol => `Speaker volume ${percentage(vol)}`)
  const audioIcon2Glyph = {
    "audio-volume-low-symbolic": "󰕿",
    "audio-volume-medium-symbolic": "󰖀",
    "audio-volume-high-symbolic": "󰕾",
    "audio-volume-muted-symbolic": "󰝟",
  }
  const micVolText = bind(mic, "volume").as(vol => `Mic volume ${percentage(vol)}`)
  const MicIcon2Glyph = {
    "microphone-sensitivity-low-symbolic": "󰍬",
    "microphone-sensitivity-medium-symbolic": "󰍬",
    "microphone-sensitivity-high-symbolic": "󰍬",
    "microphone-sensitivity-muted-symbolic": "󰍭",
  }

  const bt = AstalBluetooth.get_default()
  const bluetoothIcon = bind(bt, "is_powered").as(c => c ? "󰂯" : "󰂲")

  return <box className="AudioBluetooth">
    <button
      onClick={(_self, click) => {
        if (click.button === Astal.MouseButton.PRIMARY) {
          App.toggle_window('bluetooth')
        } else if (click.button === Astal.MouseButton.SECONDARY) {
          speaker.set_mute(!speaker.get_mute())
        }
      }}

      onScroll={(_self, scroll) => {
        speaker.volume = scroll.delta_y < 0 ? Math.min(1, speaker.volume + 0.02) : Math.max(0, speaker.volume - 0.02)
      }}
    >
      <box>
        <label
          label={bluetoothIcon}
          className={cn('Bluetooth', 'icon', { connected: bind(bt, 'is_connected') })()}
        />
        <label
          label={bind(speaker, "volume_icon").as(icon => audioIcon2Glyph[icon])}
          tooltip_text={audioVolText}
          className={cn('Audio', 'icon', { muted: bind(speaker, 'mute') })()}
        />
        <label
          label={bind(mic, "volume_icon").as(icon => MicIcon2Glyph[icon])}
          tooltip_text={micVolText}
          className={cn('Microphone', 'icon', { muted: bind(mic, 'mute') })()}
        />
      </box>
    </button>
  </box>
}
