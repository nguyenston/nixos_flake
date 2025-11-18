import app from "ags/gtk3/app"  // CHANGED: was { App } from "astal/gtk3"
import { Astal } from "ags/gtk3"  // CHANGED
import Gdk from "gi://Gdk?version=3.0"  // CHANGED: separate import
import { createState, createBinding } from "ags"  // CHANGED: was "astal"
import Niri, { OutputsWithWorkspacesWithWindows, Window, WorkspaceWithWindows } from "../service/niri"

const niri = Niri.get_default()

// CHANGED: App.connect → app.connect
app.connect('monitor-added', () => niri.reloadMonitors())
app.connect('monitor-removed', () => niri.reloadMonitors())

function guessAppIcon(window: Window) {
  if (window.title?.endsWith('NVIM')) {
    return 'neovim'
  }

  if (window.app_id === 'foot') {
    return 'foot'
  }

  if (window.app_id === '' && window.title?.includes('Spotify')) {
    return 'spotify'
  }

  if (window.app_id === 'chromium-browser') {
    return 'chromium'
  }

  if (window.app_id === '1Password') {
    return '1password'
  }

  if (window.app_id === 'Slack') {
    return 'slack'
  }

  if (window.app_id === 'firefox-beta') {
    return 'firefox'
  }

  if (!!Astal.Icon.lookup_icon(window.app_id)) {
    return window.app_id
  }

  if (!!Astal.Icon.lookup_icon(window.app_id.toLowerCase())) {
    return window.app_id.toLowerCase()
  }

  return 'circle-dashed'
}

function Workspace(workspace: WorkspaceWithWindows, showInactiveIcons: boolean) {
  const traits = ['workspace']
  if (workspace.is_active) {
    traits.push('active')
  }

  if (workspace.windows.length > 0) {
    traits.push('populated')
  }

  const className = traits.join(' ')
  const showIcons = (workspace.is_active || showInactiveIcons) && workspace.windows.length > 0

  return <button
    onClick={() => niri.focusWorkspaceId(workspace.id)}
    onScroll={(_self, scroll) => {
      if (!workspace.is_focused) { niri.focusWorkspaceId(workspace.id) }
      niri.focusColumn(scroll.delta_y < 0)
    }}
    class={className}>  {/* CHANGED: className → class */}
    <box spacing={showIcons ? 5 : 0}>
      <label class="ws-idx" label={workspace.idx.toString()} />  {/* CHANGED */}
      {showIcons && workspace.windows.map(win => <icon icon={guessAppIcon(win)} />)}
    </box>
  </button>
}

export type WorkspacesProps = {
  forMonitor: Gdk.Monitor
  showInactiveIcons?: boolean
}

function getMonitorName(gdkmonitor: Gdk.Monitor) {
  const display = Gdk.Display.get_default()!;
  const screen = display.get_default_screen();
  for (let i = 0; i < display.get_n_monitors(); ++i) {
    if (gdkmonitor === display.get_monitor(i))
      return screen.get_monitor_plug_name(i);
  }
}

export default function Workspaces({ forMonitor, showInactiveIcons = false }: WorkspacesProps) {
  const monitorName = getMonitorName(forMonitor)!

  const filterWorkspacesForMonitor = (outputs: OutputsWithWorkspacesWithWindows, name: string) => {
    return Object.values(outputs)
      .filter(o => o.monitor?.name === name)
      .flatMap(o => Object.values(o.workspaces))
      .sort((a, b) => a.idx - b.idx)
  }

  const outputs = createBinding(niri, 'outputs')  // CHANGED: bind → createBinding
  const workspacesForMe = outputs.as(os => filterWorkspacesForMonitor(os, monitorName))

  return <box class="Workspaces">  {/* CHANGED: className → class */}
    {workspacesForMe.as(ws => ws.map(w => Workspace(w, showInactiveIcons)))}
  </box>
}
