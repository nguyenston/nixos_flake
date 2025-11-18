import Wireplumber from "gi://AstalWp"
import { createBinding } from "ags"
import { cn, percentage, linCom } from "../utils"
import { Gtk } from "astal/gtk3"
import { App, Astal } from "astal/gtk3"
import AstalBluetooth from "gi://AstalBluetooth?version=0.1"
import MeteringLabel from "./MeteringLabel"

export default function AudioBluetooth() {
  const audio = Wireplumber.get_default()?.audio
  const speaker = audio?.get_default_speaker()!
  const mic = audio?.get_default_microphone()!

  const audioVolText = createBinding(speaker, "volume").as(vol => `Speaker volume ${percentage(vol)}`)
  const audioIcon2Glyph = {
    "audio-volume-low-symbolic": "󰕿",
    "audio-volume-medium-symbolic": "󰖀",
    "audio-volume-high-symbolic": "󰕾",
    "audio-volume-muted-symbolic": "󰝟",
  }
  const micVolText = bind(mic, "volume").as(vol => `Mic volume ${percentage(vol)}`)
  const micIcon2Glyph = {
    "microphone-sensitivity-low-symbolic": "󰍬",
    "microphone-sensitivity-medium-symbolic": "󰍬",
    "microphone-sensitivity-high-symbolic": "󰍬",
    "microphone-sensitivity-muted-symbolic": "󰍭",
  }

  const bt = AstalBluetooth.get_default()
  const bluetoothIcon = createBinding(bt, "is_powered").as(c => c ? "󰂯" : "󰂲")

  return <eventbox
    class="AudioBluetooth"
    valign={Gtk.Align.CENTER}
    onClick={(_self, click) => {
      if (click.button === Astal.MouseButton.PRIMARY) {
        App.toggle_window('bluetooth')
      } else if (click.button === Astal.MouseButton.SECONDARY) {
        speaker.set_mute(!speaker.get_mute())
      }
    }}

    onScroll={(_self, scroll) => {
      speaker.volume = scroll.delta_y < 0 ? Math.min(1, speaker.volume + 0.05) : Math.max(0, speaker.volume - 0.05)
    }}
  >
    <box>
      {/* <label */}
      {/*   label={bluetoothIcon} */}
      {/*   class={cn('bluetooth', 'icon', { connected: bind(bt, 'is_connected') })()} */}
      {/* /> */}
      <MeteringLabel
        class='icon'
        width={29} height={25}
        firstLabel={bind(speaker, 'volume_icon').as(icon => audioIcon2Glyph[icon])}
        secondLabel={bind(speaker, 'volume_icon').as(icon => audioIcon2Glyph[icon])}
        tooltip_text={audioVolText}
        firstClassName='grey'
        secondClassName={cn('speaker', { muted: bind(speaker, 'mute') })()}
        level={bind(speaker, 'volume').as(per => linCom(per, 0.29, 0.82))}
      />
      <MeteringLabel
        class='icon'
        width={29} height={25}
        firstLabel={bind(mic, 'volume_icon').as(icon => micIcon2Glyph[icon])}
        secondLabel={bind(mic, 'volume_icon').as(icon => micIcon2Glyph[icon])}
        tooltip_text={micVolText}
        firstClassName='grey'
        secondClassName={cn('microphone', { muted: bind(mic, 'mute') })()}
        level={bind(mic, 'volume').as(per => linCom(per, 0.22, 0.83))}
      />
    </box>
  </eventbox>
}
