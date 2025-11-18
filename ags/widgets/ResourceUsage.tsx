import Gtk from "gi://Gtk?version=3.0"
import { createState, createBinding, createPoll } from "ags"  // CHANGED: was "astal"
import Usage from "../service/usage"
import { cn, percentage, linCom } from "../utils"
import MeteringLabel from "./MeteringLabel"

const usage = Usage.get_default()

export default function ResourceUsage() {
  const cpu = createBinding(usage, 'cpuUsage')  // CHANGED: bind → createBinding
  const mem = createBinding(usage, 'memory').as(mem => mem.percentage)  // CHANGED
  
  // CHANGED: Variable.poll → createPoll
  const temp = createPoll(0, 2000, ["sensors", "-j"], out => {
    const obj = JSON.parse(out)
    return obj["acpitz-acpi-0"].temp1.temp1_input / 100
  })

  const revealCPU = cpu.as(cpu => cpu > 0.8)
  const revealMemory = mem.as(mem => mem > 0.8)
  const revealTemperature = temp.as(tem => tem > 0.8)
  
  const [hovered, setHovered] = createState(false)  // CHANGED: Variable → createState

  // CHANGED: Variable.derive → createComputed
  const reveal = createComputed(
    [revealCPU, revealMemory, revealTemperature, hovered], 
    (rc, rm, rt, hovered) => hovered || rc || rm || rt
  )

  return <box class="ResourceUsage">  {/* CHANGED: className → class */}
    <eventbox 
      onHover={() => setHovered(true)}  {/* CHANGED: hovered.set(true) */}
      onHoverLost={() => setHovered(false)}>  {/* CHANGED */}
      <box>
        <box>
          <MeteringLabel
            class="icon"  {/* CHANGED */}
            width={29} height={25}
            firstLabel="" secondLabel=""
            firstClassName="grey" secondClassName="cpu"
            level={cpu.as(cpu => linCom(cpu, 0.17, 0.9))} 
          />
          <revealer reveal_child={reveal()} transition_type={Gtk.RevealerTransitionType.SLIDE_LEFT}>
            <label label={cpu.as(percentage)} />
          </revealer>
        </box>
        <box>
          <MeteringLabel
            class="icon"  {/* CHANGED */}
            width={29} height={25}
            firstLabel="" secondLabel=""
            firstClassName="grey" secondClassName="memory"
            level={mem.as(mem => linCom(mem, 0.25, 0.71))} 
          />
          <revealer reveal_child={reveal()} transition_type={Gtk.RevealerTransitionType.SLIDE_LEFT}>
            <label label={mem.as(percentage)} />
          </revealer>
        </box>
        <box>
          <MeteringLabel
            class="icon"  {/* CHANGED */}
            width={29} height={25}
            firstLabel="" secondLabel=""
            firstClassName="grey" secondClassName="temperature"
            level={temp.as(temp => linCom(temp, 0.17, 0.9))} 
          />
          <revealer reveal_child={reveal()} transition_type={Gtk.RevealerTransitionType.SLIDE_LEFT}>
            <label label={temp.as(t => `${Math.round(t * 100)}°C`)} />
          </revealer>
        </box>
      </box>
    </eventbox>
  </box>
}
