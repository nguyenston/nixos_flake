import style from "./style.scss"
import app from "ags/gtk3/app"
import Gtk from "gi://Gtk?version=3.0"
import Gdk from "gi://Gdk?version=3.0"
import Bar from "./windows/Bar"
import BluetoothMenu from "./windows/BluetoothMenu"
import Applauncher from "./windows/Applauncher"
import NotificationPopups from "./windows/Notifications"
import Niri from "./service/niri"

app.start({
  icons: "./icons",
  css: style,
  main() {
    const niri = Niri.get_default()
    const bars = new Map<string, Gtk.Widget>()

    // Helper to find GDK monitor by Niri connector name
    const findGdkMonitor = (connectorName: string): Gdk.Monitor | null => {
      const display = Gdk.Display.get_default()!
      const screen = display.get_default_screen()
      
      for (let i = 0; i < display.get_n_monitors(); i++) {
        const monitor = display.get_monitor(i)
        const name = screen.get_monitor_plug_name(i)
        if (name === connectorName) {
          return monitor
        }
      }
      return null
    }

    // Reconcile bars with current monitor state
    const reconcileBars = () => {
      const currentOutputs = Object.keys(niri.outputs)
      const trackedOutputs = Array.from(bars.keys())

      // Remove bars for disconnected monitors
      for (const name of trackedOutputs) {
        if (!currentOutputs.includes(name)) {
          bars.get(name)?.destroy()
          bars.delete(name)
          console.log(`[Monitor] Removed bar for ${name}`)
        }
      }

      // Add bars for newly connected monitors
      for (const [name, output] of Object.entries(niri.outputs)) {
        if (!bars.has(name) && output.monitor) {
          const gdkMonitor = findGdkMonitor(output.monitor.name)
          if (gdkMonitor) {
            bars.set(name, Bar(gdkMonitor))
            console.log(`[Monitor] Added bar for ${name}`)
          } else {
            console.warn(`[Monitor] Could not find GDK monitor for ${output.monitor.name}`)
          }
        }
      }
    }

    // Initial setup
    reconcileBars()

    // Listen to Niri's output changes (primary solution)
    niri.connect('notify::outputs', reconcileBars)

    // Fallback: also listen to GDK events (debounced)
    let updateTimeout: number | null = null
    const scheduleUpdate = () => {
      if (updateTimeout) clearTimeout(updateTimeout)
      updateTimeout = setTimeout(() => {
        reconcileBars()
        updateTimeout = null
      }, 500) as any
    }

    app.connect("monitor-added", scheduleUpdate)
    app.connect("monitor-removed", scheduleUpdate)

    // Create other windows
    app.get_monitors().map(NotificationPopups)
    Applauncher()
    BluetoothMenu()
  },
})
