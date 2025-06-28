/**
 * Transforms the vec4 with a quat
 *
 * @param {vec4} out the receiving vector
 * @param {vec4} a the vector to transform
 * @param {quat} q quaternion to transform with
 * @returns {vec4} out
 */
// TS2ArkTS-SessionId-29
export function transformQuat(out: Float32Array, a: Float32Array, q: Float32Array): Float32Array {
  let x: number = a[0],
    y: number = a[1],
    z: number = a[2],
    qx: number = q[0],
    qy: number = q[1],
    qz: number = q[2],
    qw: number = q[3],
    // calculate quat * vec
    ix: number = qw * x + qy * z - qz * y,
    iy: number = qw * y + qz * x - qx * z,
    iz: number = qw * z + qx * y - qy * x,
    iw: number = -qx * x - qy * y - qz * z;

  // calculate result * inverse quat
  out[0] = ix * qw + iw * -qx + iy * -qz - iz * -qy;
  out[1] = iy * qw + iw * -qy + iz * -qx - ix * -qz;
  out[2] = iz * qw + iw * -qz + ix * -qy - iy * -qx;
  out[3] = a[3];
  return out;
}
