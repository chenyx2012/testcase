// TS2ArkTS-SessionId-19

import { normalize as vecNormalize } from './normalize';

// TS2ArkTS-SessionId-20

import { scale as vecScale } from './scale';

/**
 * Generates a random vector with the given scale
 *
 * @param {vec4} out the receiving vector
 * @param {Number} [scale] Length of the resulting vector. If ommitted, a unit vector will be returned
 * @returns {vec4} out
 */
// TS2ArkTS-SessionId-21

export function random(out: Float32Array, scale: number = 1.0): Float32Array {
  // TODO: This is a pretty awful way of doing this. Find something better.
  out[0] = Math.random();
  out[1] = Math.random();
  out[2] = Math.random();
  out[3] = Math.random();
  vecNormalize(out, out);
  vecScale(out, out, scale);
  return out;
}
