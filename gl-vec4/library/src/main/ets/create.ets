/**
 * Creates a new, empty vec4
 *
 * @returns {vec4} a new 4D vector
 */
// TS2ArkTS-SessionId-4
export function create(): Float32Array {
  let out = new Float32Array(4);
  out[0] = 0;
  out[1] = 0;
  out[2] = 0;
  out[3] = 0;
  return out;
}
