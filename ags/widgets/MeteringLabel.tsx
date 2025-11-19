import GObject, { register, property } from "ags/gobject"
import { Gtk, Gdk, Widget, type ConstructProps } from "ags/gtk3"
import { createBinding } from "ags"

@register()
export default class MeteringLabel extends Gtk.Overlay {
  declare _width: number
  declare _height: number
  declare _level: number

  @property(Number)
  get level() {
    return this._level || 0
  }
  set level(num) {
    const num_checked = num > 1 ? 1 : num < 0 ? 0 : num
    this._level = num_checked
    this.notify('level')
  }

  @property(String)
  firstLabel: string
  @property(String)
  secondLabel: string

  @property(String)
  firstClassName: string
  @property(String)
  secondClassName: string

  @getter(Number)
  get width() { return this._width }
  @getter(Number)
  get height() { return this._height }


  constructor({ width = 0, height = 0, ...props }: any) {
    super({ valign: Gtk.Align.CENTER, halign: Gtk.Align.CENTER, ...props })
    this._width = width
    this._height = height

    const first_half = <label
      class={createBinding(this, "firstClassName")}
      widthRequest={this.width}
      heightRequest={this.height}
      valign={Gtk.Align.CENTER}
      halign={Gtk.Align.CENTER}
      label={createBinding(this, "firstLabel")}
    />
    const second_half = <overlay
      valign={Gtk.Align.END}
      halign={Gtk.Align.CENTER}
    >
      <box widthRequest={this.width}></box>
      <label
        class={createBinding(this, "secondClassName")}
        widthRequest={this.width}
        heightRequest={this.height}
        valign={Gtk.Align.END}
        halign={Gtk.Align.CENTER}
        label={createBinding(this, "secondLabel")}
      />
    </overlay> as Widget.Overlay

    this.connect('notify::secondClassName', obj => {
      console.log(obj.secondClassName)
    })
    this.connect('notify::level', obj => {
      // var level_pixel, level_pixel_complement
      const level_pixel = Math.round(obj.height * obj.level)
      second_half.child.heightRequest = level_pixel
    })
    this.notify('level')
    this.add(first_half)
    this.add_overlay(second_half)
  }
}
