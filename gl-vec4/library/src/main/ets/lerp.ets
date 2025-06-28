/**
 * Performs a linear interpolation between two vec4's
 *
 * @param {vec4} out the receiving vector
 * @param {vec4} a the first operand
 * @param {vec4} b the second operand
 * @param {Number} t interpolation amount between the two inputs
 * @returns {vec4} out
 */
// TS2ArkTS-SessionId-13
export function lerp(out: Float32Array, a: Float32Array, b: Float32Array, t: number): Float32Array {
  let ax: number = a[0],
    ay: number = a[1],
    az: number = a[2],
    aw: number = a[3];
  out[0] = ax + t * (b[0] - ax);
  out[1] = ay + t * (b[1] - ay);
  out[2] = az + t * (b[2] - az);
  out[3] = aw + t * (b[3] - aw);
  return out;
}
