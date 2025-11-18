import AstalTray from "gi://AstalTray?version=0.1";
import { createBinding } from "ags";  // CHANGED: was "astal"

export default function Tray() {
  const tray = AstalTray.get_default()

  return <box class="Tray">  {/* CHANGED: className → class */}
    {createBinding(tray, "items").as(items => items.map((item, idx, items) => {  // CHANGED: bind → createBinding
      return <menubutton
        class={idx == 0 ? "first" : idx == items.length - 1 ? "last" : ""}  {/* CHANGED: className → class */}
        tooltipMarkup={createBinding(item, "tooltipMarkup")}  {/* CHANGED */}
        usePopover={false}
        actionGroup={createBinding(item, "actionGroup").as(ag => ["dbusmenu", ag])}  {/* CHANGED */}
        menuModel={createBinding(item, "menuModel")}>  {/* CHANGED */}
        <icon gicon={createBinding(item, "gicon")} />  {/* CHANGED */}
      </menubutton>
    }))}
  </box>
}
