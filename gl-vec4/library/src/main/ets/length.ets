/**
 * Calculates the length of a vec4
 *
 * @param {vec4} a vector to calculate length of
 * @returns {Number} length of a
 */
// TS2ArkTS-SessionId-12
export function length(a: Float32Array): number {
  let x: number = a[0],
    y: number = a[1],
    z: number = a[2],
    w: number = a[3];
  return Math.sqrt(x * x + y * y + z * z + w * w);
}
