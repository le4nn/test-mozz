class Chat {
  final String id;
  final String title;
  final int colorValue;

  const Chat({required this.id, required this.title, required this.colorValue});

  String get initials {
    final parts = title.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return '';
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}
