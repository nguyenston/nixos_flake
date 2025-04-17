import AstalTray from "gi://AstalTray?version=0.1";
import { bind } from "astal";

export default function Tray() {
  const tray = AstalTray.get_default()

  return <box className="Tray">
    {bind(tray, "items").as(items => items.map((item, idx, items) => {
      return <menubutton
        className={idx == 0 ? "first" : idx == items.length - 1 ? "last" : ""}
        tooltipMarkup={bind(item, "tooltipMarkup")}
        usePopover={false}
        actionGroup={bind(item, "actionGroup").as(ag => ["dbusmenu", ag])}
        menuModel={bind(item, "menuModel")}>
        <icon gicon={bind(item, "gicon")} />
        {/* <label label={idx.toString()} /> */}
      </menubutton>
    }))}
  </box>
}

