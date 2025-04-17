import GObject, { register, property } from "astal/gobject";
import { Gtk, Gdk, Widget, astalify, type ConstructProps } from "astal/gtk3";
import { bind } from "astal";

@register()
export default class MeteringLabel extends astalify(Gtk.Overlay) {
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
  declare firstLabel: string
  @property(String)
  declare secondLabel: string

  @property(String)
  declare firstClassName: string
  @property(String)
  declare secondClassName: string

  @property(Number)
  get width() { return this._width }
  @property(Number)
  get height() { return this._height }


  constructor({ width = 0, height = 0, ...props }) {
    super({ valign: Gtk.Align.CENTER, halign: Gtk.Align.CENTER, ...props })
    this._width = width
    this._height = height

    const first_half = <label
      className={bind(this, "firstClassName")}
      widthRequest={this.width}
      heightRequest={this.height}
      valign={Gtk.Align.CENTER}
      halign={Gtk.Align.CENTER}
      label={bind(this, "firstLabel")}
    />
    const second_half = <overlay
      valign={Gtk.Align.END}
      halign={Gtk.Align.CENTER}
    >
      <box widthRequest={this.width}></box>
      <label
        className={bind(this, "secondClassName")}
        widthRequest={this.width}
        heightRequest={this.height}
        valign={Gtk.Align.END}
        halign={Gtk.Align.CENTER}
        label={bind(this, "secondLabel")}
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

