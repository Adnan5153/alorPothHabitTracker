/// Stateless date / time helpers used across features. Centralised so we
/// never rely on a single feature's formatting preference bleeding into
/// another.
class AppDateFormat {
  AppDateFormat._();

  static String relative(DateTime when, {DateTime? now}) {
    final reference = now ?? DateTime.now().toUtc();
    final diff = reference.difference(when);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${when.year}-${_two(when.month)}-${_two(when.day)}';
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
