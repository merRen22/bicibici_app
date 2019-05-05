class Counter {
  int count;
  Counter(this.count);

  factory Counter.fromJson(json) {
    return new Counter(json['count']);
  }
}