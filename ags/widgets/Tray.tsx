import AstalTray from "gi://AstalTray?version=0.1";
import { createBinding } from "ags";

export default function Tray() {
  const tray = AstalTray.get_default()

  return <box class="Tray">
    {createBinding(tray, "items").as(items => items.map((item, idx, items) => {
      return <menubutton
        class={idx == 0 ? "first" : idx == items.length - 1 ? "last" : ""}
        tooltipMarkup={createBinding(item, "tooltipMarkup")}
        usePopover={false}
        actionGroup={createBinding(item, "actionGroup").as(ag => ["dbusmenu", ag])}
        menuModel={createBinding(item, "menuModel")}>
        <icon gicon={createBinding(item, "gicon")} />
      </menubutton>
    }))}
  </box>
}
