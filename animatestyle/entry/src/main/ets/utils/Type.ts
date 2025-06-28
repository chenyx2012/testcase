export class Type {
  static checkTypeByMember<T>(object: any, member): object is T {
    if (typeof object != 'object') {
      return false;
    }
    return member in object;
  }
}