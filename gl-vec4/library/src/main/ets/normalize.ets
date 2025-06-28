/**
 * Normalize a vec4
 *
 * @param {vec4} out the receiving vector
 * @param {vec4} a vector to normalize
 * @returns {vec4} out
 */
// TS2ArkTS-SessionId-18
export function normalize(out: Float32Array, a: Float32Array): Float32Array {
  let x: number = a[0],
    y: number = a[1],
    z: number = a[2],
    w: number = a[3];
  let len: number = x * x + y * y + z * z + w * w;
  if (len > 0) {
    len = 1 / Math.sqrt(len);
    out[0] = x * len;
    out[1] = y * len;
    out[2] = z * len;
    out[3] = w * len;
  }
  return out;
}
