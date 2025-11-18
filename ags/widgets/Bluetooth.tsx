import GObject from "gi://GObject"
import app from "ags/gtk3/app"
import { ConstructProps, Gtk, astalify } from "ags/gtk3"
import { createBinding } from "ags"
import AstalBluetooth from "gi://AstalBluetooth?version=0.1"

// subclass, register, define constructor props
class Popover extends astalify(Gtk.Popover) {
  static { GObject.registerClass(this) }

  constructor(props: ConstructProps<
    Popover,
    Gtk.Popover.ConstructorProps,
    {} // signals of Gtk.Popover have to be manually typed
  >) {
    super(props as any)
  }
}

export default function Bluetooth() {

  const bt = AstalBluetooth.get_default()

  const connected = createBinding(bt, "is_connected")
  const className = connected.as(c => c ? "Bluetooth connected" : "Bluetooth")

  const icon = createBinding(bt, "is_powered").as(c => c ? "bluetooth-active-symbolic" : "bluetooth-disabled-symbolic")

  return <box vertical>
    <button
      className={className}
      onClick={() => {
        app.toggle_window('bluetooth')
      }}
    >
      <icon icon={icon}></icon>
    </button>
  </box>
}
