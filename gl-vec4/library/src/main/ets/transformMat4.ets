/**
 * Transforms the vec4 with a mat4.
 *
 * @param {vec4} out the receiving vector
 * @param {vec4} a the vector to transform
 * @param {mat4} m matrix to transform with
 * @returns {vec4} out
 */
// TS2ArkTS-SessionId-28
export function transformMat4(out: Float32Array, a: Float32Array, m: Float32Array): Float32Array {
  let x: number = a[0],
    y: number = a[1],
    z: number = a[2],
    w: number = a[3];

  out[0] = m[0] * x + m[4] * y + m[8] * z + m[12] * w;
  out[1] = m[1] * x + m[5] * y + m[9] * z + m[13] * w;
  out[2] = m[2] * x + m[6] * y + m[10] * z + m[14] * w;
  out[3] = m[3] * x + m[7] * y + m[11] * z + m[15] * w;

  return out;
}
