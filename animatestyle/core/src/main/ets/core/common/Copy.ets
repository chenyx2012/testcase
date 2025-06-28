export const shallowCopy = <S extends object>(obj?: S, value?: S): S | undefined => {
  if (!obj) {
    return value;
  }
  let newObj: Record<string, Object> = {};
  let keys: string[] = [...Object.keys(obj)]
  if (value) {
    keys = Array.from(new Set<string>([...keys, ...Object.keys(value)]))
  }
  for (let key of keys) {
    let v: object | undefined = value ? value[key] : undefined
    newObj[key] = v ?? obj[key]
  }
  return newObj as S;
}