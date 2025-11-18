import AstalNetwork from "gi://AstalNetwork?version=0.1"
import AstalBattery from "gi://AstalBattery?version=0.1"
import { createBinding, createComputed, createState } from "ags"
import { cn, percentage, linCom } from "../utils"
import MeteringLabel from "./MeteringLabel"
import AstalBrightness from "../service/brightness"
import Gtk from "gi://Gtk?version=3.0"

const network = AstalNetwork.get_default()
const battery = AstalBattery.get_default()
const brightness = AstalBrightness.get_default()

function WifiIcon(wifi: AstalNetwork.Wifi) {
  const notIsoProof = createBinding(wifi, 'ssid').as(ssid => ssid?.includes('BusinessCenter'))

  return <icon
    icon={createBinding(wifi, 'icon_name')}
    tooltip_text={createBinding(wifi, 'ssid').as(ssid => ssid ?? 'Not connected')}
    class={cn({ 'wifi-danger': notIsoProof })()}
  />
}

function WiredIcon() {
  return <icon 
    icon={createBinding(network.wired, 'icon_name')}
    tooltip_text={createBinding(network.wired, 'speed').as(s => s.toString())}
  />
}

function WifiSection({ reveal }: { reveal: () => boolean }) {
  const wifi = network.wifi

  return <box>
    {WifiIcon(wifi)}
    <revealer
      reveal_child={reveal()}
      transition_type={Gtk.RevealerTransitionType.SLIDE_LEFT}
      visible={createBinding(wifi, 'ssid').as(ssid => !!ssid)}
    >
      {createBinding(wifi, 'ssid')}
    </revealer>
  </box>
}

const batteryStatetoClass = [
  'unknown',
  'charging',
  'discharging',
  'empty',
  'full',
  'pendingCharge',
  'pendingDischarge'
]

function BatteryIcon() {
  return <MeteringLabel
    class="icon"
    width={29} height={25}
    firstLabel="󰂎" secondLabel="󰁹"
    firstClassName="grey"
    secondClassName={createBinding(battery, 'state').as(s => 'battery ' + batteryStatetoClass[s])}
    tooltip_text={createBinding(battery, 'state').as(s => batteryStatetoClass[s])}
    level={createBinding(battery, 'percentage').as(per => linCom(per, 0.17, 0.88))}
  />
}

function BatterySection({ reveal }: { reveal: () => boolean }) {
  return <box>
    <BatteryIcon />
    <revealer
      reveal_child={reveal()}
      transition_type={Gtk.RevealerTransitionType.SLIDE_LEFT}
    >
      {createBinding(battery, 'percentage').as(percentage)}
    </revealer>
  </box>
}

function BrightnessIcon() {
  return <MeteringLabel
    class="icon"
    width={29} height={25}
    firstLabel="󰃞" secondLabel="󰃠"
    firstClassName="grey" secondClassName="brightness"
    level={createBinding(brightness, 'screen').as(per => linCom(per, 0.17, 0.88))}
  />
}

function BrightnessSection(brightness: AstalBrightness, hovered: () => boolean) {
  return <box>
    <BrightnessIcon />
    <revealer
      reveal_child={hovered()}
      transition_type={Gtk.RevealerTransitionType.SLIDE_LEFT}
    >
      <label label={createBinding(brightness, 'screen').as(percentage)} css="margin-right: 0.8rem" />
    </revealer>
  </box>
}

const batteryLevels: [number, string][] = [
  [0.1, 'battery-critical'],
  [0.25, 'battery-low'],
  [0.5, 'battery-needs-juice'],
  [100, '']
]

export default function LaptopStuff() {
  const batteryLevelClass = createBinding(battery, 'percentage').as(perc => 
    batteryLevels.find(([level, _]) => level >= perc)![1]
  )
  const batteryCharging = createBinding(battery, 'charging')
  const batteryClass = createComputed([batteryLevelClass, batteryCharging], (level, charging) => 
    charging ? '' : level
  )

  const [hoverReveal, setHoverReveal] = createState(false)

  return <eventbox
    onScroll={(_self, scroll) => {
      brightness.screen = scroll.delta_y < 0 ? Math.min(1, brightness.screen + 0.02) : Math.max(0, brightness.screen - 0.02)
    }}
    onHover={() => setHoverReveal(true)}
    onHoverLost={() => setHoverReveal(false)}>
    <box class={batteryClass(cls => `LaptopStuff ${cls}`)}>
      <BatterySection reveal={hoverReveal} />
      {BrightnessSection(brightness, hoverReveal)}
    </box>
  </eventbox>
}
