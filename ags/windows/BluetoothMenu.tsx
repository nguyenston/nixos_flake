import GObject from "gi://GObject"
import app from "ags/gtk3/app"
import { Astal, ConstructProps, Widget } from "ags/gtk3"
import Gtk from "gi://Gtk?version=3.0"
import Gdk from "gi://Gdk?version=3.0"
import { Binding, createState, createBinding, createComputed } from "ags"
import AstalBluetooth from "gi://AstalBluetooth?version=0.1"
import AstalWp from "gi://AstalWp?version=0.1"
import AstalBattery from "gi://AstalBattery?version=0.1"

import { cn, percentage } from "../utils"
import MediaPlayer from "../widgets/MediaPlayer"
import AstalMpris from "gi://AstalMpris?version=0.1"

// this stuff is massively annoying to implement, so I'll just use buttons for each audio option
class ComboBox extends Gtk.ComboBox {
  static { GObject.registerClass(this) }

  constructor(props: ConstructProps<
    ComboBox,
    Gtk.ComboBox.ConstructorProps,
    {}
  >) {
    super(props as any)
  }
}

// subclass, register, define constructor props
class Spinner extends Gtk.Spinner {
  static { GObject.registerClass(this) }

  constructor(props: ConstructProps<
    Spinner,
    Gtk.Spinner.ConstructorProps,
    {}
  >) {
    super(props as any)
  }
}

function BtStatus() {
  const bt = AstalBluetooth.get_default()
  const upower = new AstalBattery.UPower()
  const batteries = createBinding(upower, 'devices')

  const btinfo = createComputed([createBinding(bt, 'devices'), batteries], (devices, batteries) => {
    return devices.map(device => {
      return {
        device,
        battery: batteries.find(b => b.serial === device.address)
      }
    })
  })

  return <box vertical>
    {btinfo.as(devices => devices.map(device => <Device btinfo={device} />))}
  </box>
}

type BtInfo = {
  device: AstalBluetooth.Device
  battery?: AstalBattery.Device
}

type DeviceProps = {
  btinfo: BtInfo
}

function Device({ btinfo: { device, battery } }: DeviceProps) {
  const title = battery
    ? createComputed([createBinding(device, 'alias'), createBinding(battery, 'percentage')], (d, p) => `${d} [${Math.floor(p * 100)}%]`)
    : createBinding(device, 'alias')
    
  return <box class="btdevice">
    <button
      class={cn('connect', { 'connected': createBinding(device, 'connected') })()}
      cursor="pointer"
      hexpand
      onClick={() => device.connect_device((result) => console.log(result))}
    >
      <box hexpand>
        <icon icon={device.icon}></icon>
        <label hexpand xalign={0} label={title()}></label>
        <Spinner
          visible={createBinding(device, "connecting")}
          $={(self) => {
            createBinding(device, "connecting").subscribe(connecting => {
              connecting ? self.start() : self.stop()
            })
          }}
        ></Spinner>
      </box>
    </button>
    <button
      class="disconnect"
      cursor="pointer"
      visible={createBinding(device, "connected")}
      onClick={() => device.disconnect_device((result) => console.log(result))}
    >
      <icon icon="window-close-symbolic"></icon>
    </button>
  </box>
}

function Endpoint(endpoint: AstalWp.Endpoint) {
  const iconName = createComputed([createBinding(endpoint, 'mediaClass'), createBinding(endpoint, 'mute')], (mediaClass, mute) => {
    if (mediaClass === AstalWp.MediaClass.AUDIO_SPEAKER) {
      return mute ? 'audio-volume-muted-symbolic' : 'audio-volume-high-symbolic'
    }

    if (mediaClass === AstalWp.MediaClass.AUDIO_MICROPHONE) {
      return mute ? 'microphone-sensitivity-muted-symbolic' : 'microphone-sensitivity-high-symbolic'
    }

    return 'circle-dashed'
  })

  return <box>
    <button
      cursor="pointer"
      class={cn('endpoint', { 'default': createBinding(endpoint, 'is_default') })()}
      onClick={() => endpoint.is_default = true}
    >
      <box hexpand>
        <icon icon={iconName()} />
        <label label={createBinding(endpoint, 'description')} />
      </box>
    </button>
  </box>
}

type EndpointStatusProps = {
  default_endpoint: AstalWp.Endpoint,
  endpoints: Binding<AstalWp.Endpoint[]>
}

function EndpointStatus({ default_endpoint, endpoints }: EndpointStatusProps) {
  const [show, setShow] = createState(false)

  app.connect('window-toggled', (_app, win) => {
    if (win.name === 'bluetooth' && win.visible) {
      setShow(false)
    }
  })

  return <box vertical class="audiostatus">
    <eventbox
      onScroll={(_self, scroll) => {
        default_endpoint.volume = scroll.delta_y < 0 ? Math.min(1, default_endpoint.volume + 0.05) : Math.max(0, default_endpoint.volume - 0.05)
      }}>
      <box vertical>
        <box class="adjuster">
          <button
            cursor="pointer"
            class={cn('mute', { 'muted': createBinding(default_endpoint, 'mute') })()}
            onClick={() => default_endpoint.mute = !default_endpoint.mute}
          >
            <box class="volume">
              <icon icon={createBinding(default_endpoint, 'volumeIcon')} />
              <label label={createBinding(default_endpoint, 'volume').as(percentage)} />
            </box>
          </button>
          <slider
            hexpand
            cursor="pointer"
            onDragged={({ value }) => default_endpoint.volume = value}
            value={createBinding(default_endpoint, "volume")}
          />
          <button cursor="pointer" class="expander" onClick={() => setShow(!show())}>
            <icon icon={show(s => s ? 'pan-down-symbolic' : 'pan-end-symbolic')}></icon>
          </button>
        </box>
        <revealer reveal_child={show()} transition_type={Gtk.RevealerTransitionType.SLIDE_DOWN}>
          <box vertical>
            {endpoints.as(endpoints => endpoints.map(Endpoint))}
          </box>
        </revealer>
      </box>
    </eventbox>
  </box>
}

export default function BluetoothMenu() {
  const audio = AstalWp.get_default()!.audio

  const bt = AstalBluetooth.get_default()
  const speakers = createBinding(audio, 'speakers')
  const microphones = createBinding(audio, 'microphones')

  const player = createBinding(AstalMpris.get_default(), 'players').as(players => players.find(p => p.bus_name === 'org.mpris.MediaPlayer2.spotify'))

  return <window
    name="bluetooth"
    class="BluetoothMenu"
    $={(self) => app.add_window(self)}
    keymode={Astal.Keymode.ON_DEMAND}
    visible={false}
    onFocusOutEvent={(self) => app.toggle_window(self.name)}
    anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}>
    <box class="AudioBluetoothMenu" clickThrough={false} vertical valign={Gtk.Align.START} halign={Gtk.Align.END}>
      <box spacing={10}>
        <label label="Bluetooth" xalign={0} />
        <overlay passThrough={false}>
          <switch active={createBinding(bt, "is_powered")} />
          <eventbox onClick={() => bt.toggle()} cursor="pointer" />
        </overlay>
      </box>
      <BtStatus />
      <label label="Audio" xalign={0} />
      <EndpointStatus default_endpoint={audio.default_speaker} endpoints={speakers} />
      <EndpointStatus default_endpoint={audio.default_microphone} endpoints={microphones} />
      <label label="Music" xalign={0} visible={player.as(Boolean)} />
      <box visible={player.as(Boolean)}>
        {player.as(p => p && <MediaPlayer player={p} />)}
      </box>
    </box>
  </window>
}
