class ChatUtils {
  ChatUtils._();
  // Generate chat ID from two user IDs (always in same order)
  static String generateChatId(String userId1, String userId2) {
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  // Get other user ID from chat participants
  static String getOtherUserId(
    List<String> participants,
    String currentUserId,
  ) {
    return participants.firstWhere((id) => id != currentUserId);
  }

  // Check if user is online (within last 2 minutes)
  static bool isUserOnline(DateTime? lastSeen) {
    if (lastSeen == null) return false;
    final difference = DateTime.now().difference(lastSeen);
    return difference.inMinutes < 2;
  }
}
