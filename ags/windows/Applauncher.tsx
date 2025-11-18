import Apps from "gi://AstalApps"
import app from "ags/gtk3/app"
import { Astal, Gdk, Gtk } from "ags/gtk3"
import { createState } from "ags"

const MAX_ITEMS = 8

function AppButton({ app }: { app: Apps.Application }) {
  return <button className="AppButton" onClicked={() => app.launch()}>
    <box>
      <icon icon={app.iconName} />
      <box valign={Gtk.Align.CENTER} vertical>
        <label
          className="name"
          truncate
          xalign={0}
          label={app.name}
        />
        {app.description && <label
          className="description"
          wrap
          xalign={0}
          label={app.description}
        />}
      </box>
    </box>
  </button>
}

export default function Applauncher() {
  const apps = new Apps.Apps({
    nameMultiplier: 3,
    executableMultiplier: 2,
    entryMultiplier: 2
  })

  const [query, setQuery] = createState("")
  const list = query(q => apps.fuzzy_query(q).slice(0, MAX_ITEMS))
  const hide = () => {
    if (app.get_window('launcher')?.visible) {
      app.toggle_window("launcher")
    }
  }

  function openfirst() {
    const first = list.get()[0]
    if (first && first.launch()) {
      hide()
    }
  }

  return <window
    name="launcher"
    exclusivity={Astal.Exclusivity.IGNORE}
    keymode={Astal.Keymode.ON_DEMAND}
    application={app}
    visible={false}
    onShow={() => setQuery("")}
    onFocusOutEvent={() => hide()}
    onKeyPressEvent={function(_self, event: Gdk.Event) {
      if (event.get_keyval()[1] === Gdk.KEY_Escape) {
        hide()
      }
    }}>
    <box>
      <box hexpand={false} vertical>
        <box widthRequest={500} className="Applauncher" vertical>
          <entry
            placeholderText="Search"
            onChanged={({ text }) => setQuery(text)}
            onActivate={() => { if (query() !== "") openfirst() }}
            text={query()}
          />
          <box spacing={6} vertical>
            {list.as(list => list.map(app => (
              <AppButton app={app} />
            )))}
          </box>
          <box visible={list.as(l => l.length === 0)}>
            <icon icon="system-search-symbolic" />
            No match found
          </box>
        </box>
      </box>
    </box>
  </window>
}
