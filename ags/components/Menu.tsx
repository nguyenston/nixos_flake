import { Gtk } from "ags/gtk3"
import { createState } from "ags"

type MenuProps = {
  child: JSX.Element
}
function Menu({ child }: MenuProps) {
  const [opened, setOpened] = createState(false)

  return <revealer transition_type={Gtk.RevealerTransitionType.SLIDE_DOWN} reveal_child={opened()}>
    {child}
  </revealer>
}

export default Menu
