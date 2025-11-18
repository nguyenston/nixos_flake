import app from "ags/gtk3/app"
import { Astal } from "ags/gtk3"
import Gtk from "gi://Gtk?version=3.0"
import Gdk from "gi://Gdk?version=3.0"
import DateTime from "../widgets/DateTime"
import Workspaces from "../widgets/Workspaces"
import Tray from "../widgets/Tray"
import Media from "../widgets/Media"
import AudioBluetooth from "../widgets/AudioBluetooth"
import LaptopStuff from "../widgets/LaptopStuff"
import CurrentCluster from "../widgets/CurrentCluster"
import AstalBattery from "gi://AstalBattery?version=0.1"
import ResourceUsage from "../widgets/ResourceUsage"

const battery = AstalBattery.get_default()

export default function Bar(monitor: Gdk.Monitor) {
  return <window
    name="bar"
    className="Bar"
    gdkmonitor={monitor}
    exclusivity={Astal.Exclusivity.EXCLUSIVE}
    anchor={Astal.WindowAnchor.TOP
      | Astal.WindowAnchor.LEFT
      | Astal.WindowAnchor.RIGHT}
    application={app}>
    <centerbox>
      <box className="left" hexpand halign={Gtk.Align.START}>
        <Workspaces forMonitor={monitor} showInactiveIcons></Workspaces>
      </box>
      <box className="center" hexpand>
      </box>
      <box className="right" hexpand halign={Gtk.Align.END}>
        <ResourceUsage />
        {/* <CurrentCluster /> */}
        {battery.isPresent && <LaptopStuff />}
        <AudioBluetooth />
        <Tray />
        <DateTime />
      </box>
    </centerbox>
  </window>
}
