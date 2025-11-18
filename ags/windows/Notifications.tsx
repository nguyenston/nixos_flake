import { Astal } from "ags/gtk3"
import Gtk from "gi://Gtk?version=3.0"
import Gdk from "gi://Gdk?version=3.0"
import GLib from "gi://GLib?version=2.0"
import { createState, createBinding } from "ags"
import { timeout } from "ags/time"
import Notifd from "gi://AstalNotifd"
import Notification from "../widgets/Notification"

// see comment below in constructor
const TIMEOUT_DELAY = 5000

// The purpose of this class is to replace Variable<Array<Widget>>
// with a Map<number, Widget> type in order to track notification widgets
// by their id, while making it conviniently bindable as an array
class NotificationMap {
  // the underlying map to keep track of id widget pairs
  private map: Map<number, Gtk.Widget> = new Map()

  // it makes sense to use createState under the hood and use its
  // reactivity implementation instead of keeping track of subscribers ourselves
  private state: () => Array<Gtk.Widget>
  private setState: (value: Array<Gtk.Widget>) => void

  // notify subscribers to rerender when state changes
  private notifiy() {
    this.setState([...this.map.values()].reverse())
  }

  constructor() {
    const [state, setState] = createState<Array<Gtk.Widget>>([])
    this.state = state
    this.setState = setState
    
    const notifd = Notifd.get_default()

    /**
     * uncomment this if you want to
     * ignore timeout by senders and enforce our own timeout
     * note that if the notification has any actions
     * they might not work, since the sender already treats them as resolved
     */
    // notifd.ignoreTimeout = true

    notifd.connect("notified", (_, id) => {
      this.set(id, Notification({
        notification: notifd.get_notification(id)!,

        // once hovering over the notification is done
        // destroy the widget without calling notification.dismiss()
        // so that it acts as a "popup" and we can still display it
        // in a notification center like widget
        // but clicking on the close button will close it
        onHoverLost: () => this.delete(id),

        // notifd by default does not close notifications
        // until user input or the timeout specified by sender
        // which we set to ignore above
        setup: () => timeout(TIMEOUT_DELAY, () => {
          /**
           * uncomment this if you want to "hide" the notifications
           * after TIMEOUT_DELAY
           */
          this.delete(id)
        })
      }))
    })

    // notifications can be closed by the outside before
    // any user input, which have to be handled too
    notifd.connect("resolved", (_, id) => {
      this.delete(id)
    })
  }

  private set(key: number, value: Gtk.Widget) {
    // in case of replacement destroy previous widget
    this.map.get(key)?.destroy()
    this.map.set(key, value)
    this.notifiy()
  }

  private delete(key: number) {
    this.map.get(key)?.destroy()
    this.map.delete(key)
    this.notifiy()
  }

  // Return the state accessor
  get() {
    return this.state
  }
}

export default function NotificationPopups(gdkmonitor: Gdk.Monitor) {
  const { TOP, RIGHT } = Astal.WindowAnchor
  const notifs = new NotificationMap()

  return <window
    className="NotificationPopups"
    gdkmonitor={gdkmonitor}
    exclusivity={Astal.Exclusivity.EXCLUSIVE}
    anchor={TOP | RIGHT}>
    <box vertical>
      {notifs.get()}
    </box>
  </window>
}
