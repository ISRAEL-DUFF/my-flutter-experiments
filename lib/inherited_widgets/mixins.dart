mixin TypeCheck {
  // check if type A is a sub-type B
  bool isSubtype<A, B>() {
    return <A>[] is List<B>;
  }
}
