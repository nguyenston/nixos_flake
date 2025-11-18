import { Binding } from "ags"
import { createComputed } from "ags"

type StringOrBooleanBinding = string | Record<string, Binding<boolean> | null>

/**
  * Example usage
  *
  * cn(['button'], { active: bind(mything, 'active') })
  *   -> returns Variable("button active") if the binding resolves to true
  */
export function cn(...classOrBindings: StringOrBooleanBinding[]): Variable<string> {
  const classes = classOrBindings.filter(cob => typeof cob === "string") as string[]
  const booleans = classOrBindings.filter(cob => typeof cob === "object") as Record<string, Binding<boolean> | null>[]

  const idxbindings = booleans.flatMap(bindObjects => Object.keys(bindObjects))
  const bindings = booleans.flatMap(bindObjects => Object.values(bindObjects).filter(b => b !== null)) as Binding<boolean>[]

  // create a variable that listens on all of the bindings, and conditionally adds a class based on whether that binding evaluates to true
  return createComputed(bindings, (...enabled) => {
    const enabledClasses = enabled.flatMap((included, idx) => included ? [idxbindings[idx]] : [])
    const allClasses = classes.concat(enabledClasses)
    return allClasses.join(' ')
  })
}

export function percentage(zeroToOne: number): string {
  return `${Math.floor(zeroToOne * 100)}%`
}

// zeroToOne-way between start and end
export function linCom(zeroToOne: number, start: number, end: number): number {
  return (1 - zeroToOne) * start + zeroToOne * end
}
