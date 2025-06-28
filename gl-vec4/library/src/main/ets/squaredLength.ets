/**
 * Calculates the squared length of a vec4
 *
 * @param {vec4} a vector to calculate squared length of
 * @returns {Number} squared length of a
 */
// TS2ArkTS-SessionId-26
export function squaredLength(a: Float32Array): number {
  let x: number = a[0],
    y: number = a[1],
    z: number = a[2],
    w: number = a[3];
  return x * x + y * y + z * z + w * w;
}
