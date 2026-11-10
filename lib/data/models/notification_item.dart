class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  bool isRead;
  final String type; // attendance, leave, overtime, system

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
    required this.type,
  });
}
