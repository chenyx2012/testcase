/**
 * Calculates the euclidian distance between two vec4's
 *
 * @param {vec4} a the first operand
 * @param {vec4} b the second operand
 * @returns {Number} distance between a and b
 */
// TS2ArkTS-SessionId-5
export function distance(a: Float32Array, b: Float32Array): number {
  let x: number = b[0] - a[0],
    y: number = b[1] - a[1],
    z: number = b[2] - a[2],
    w: number = b[3] - a[3];
  return Math.sqrt(x * x + y * y + z * z + w * w);
}
