import Gtk from "gi://Gtk?version=3.0"
import { Variable, bind } from "astal"
import Usage from "../service/usage"
import { cn, percentage, linCom } from "../utils"
import MeteringLabel from "./MeteringLabel"

const usage = Usage.get_default()

export default function ResourceUsage() {

  const cpu = bind(usage, 'cpuUsage')
  const mem = bind(usage, 'memory').as(mem => mem.percentage)
  const temp = bind(Variable(0).poll(2000, ["sensors", "-j"], out => {
    const obj = JSON.parse(out)

    return obj["acpitz-acpi-0"].temp1.temp1_input / 100
  }))

  const revealCPU = cpu.as(cpu => cpu > 0.8)
  const revealMemory = mem.as(mem => mem > 0.8)
  const revealTemperature = temp.as(tem => tem > 0.8)
  const hovered = Variable(false)

  const reveal = Variable.derive([revealCPU, revealMemory, revealTemperature, hovered], (rc, rm, rt, hovered) => hovered || rc || rm || rt)

  const ru = <box className="ResourceUsage">
    <eventbox onHover={() => hovered.set(true)} onHoverLost={() => hovered.set(false)}>
      <box>
        <box
        // className={cn('cpu', {
        //   'medium': cpu.as(c => c > 0.6 && c <= 0.9),
        //   'high': cpu.as(c => c > 0.9)
        // })()}
        >
          <MeteringLabel
            className="icon"
            width={29} height={25}
            firstLabel="" secondLabel=""
            firstClassName="grey" secondClassName="cpu"
            level={cpu.as(cpu => linCom(cpu, 0.17, 0.9))} />
          {/* level={cpu.as(cpu => linCom(1 - cpu, 0.28, 0.72))} /> */}
          <revealer reveal_child={reveal()} transition_type={Gtk.RevealerTransitionType.SLIDE_LEFT}>
            <label label={cpu.as(percentage)} />
          </revealer>
        </box>
        <box
        // className={cn('memory', {
        //   'medium': mem.as(c => c > 0.6 && c <= 0.9),
        //   'high': mem.as(c => c > 0.9)
        // })()}
        >
          <MeteringLabel
            className="icon"
            width={29} height={25}
            firstLabel="" secondLabel=""
            firstClassName="grey" secondClassName="memory"
            level={mem.as(mem => linCom(mem, 0.25, 0.71))} />
          <revealer reveal_child={reveal()} transition_type={Gtk.RevealerTransitionType.SLIDE_LEFT}>
            <label label={mem.as(percentage)} />
          </revealer>
        </box>
        <box
        // className={cn('temperature', {
        //   'medium': temp.as(c => c > 0.5 && c <= 0.7),
        //   'high': temp.as(c => c > 0.7)
        // })()}
        >
          <MeteringLabel
            className="icon"
            width={29} height={25}
            firstLabel="" secondLabel=""
            firstClassName="grey" secondClassName="temperature"
            level={temp.as(temp => linCom(temp, 0.17, 0.9))} />
          <revealer reveal_child={reveal()} transition_type={Gtk.RevealerTransitionType.SLIDE_LEFT}>
            <label label={temp.as(t => `${Math.round(t * 100)}°C`)} />
          </revealer>
        </box>
      </box>
    </eventbox>
  </box>
  // ru.queue_draw()
  return ru
}
