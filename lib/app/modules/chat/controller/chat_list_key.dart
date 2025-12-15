// app/modules/chat/constants/chat_list_keys.dart

/// AllChats API response এবং Chat List item-এ ব্যবহৃত key গুলোর constants
/// এটা শুধু Chat List (AllChatsController & ChatListScreen)-এর জন্য
class ChatListKeys {
  // Chat item level
  static const String id = "id";
  static const String type = "type";
  static const String latestMessageAt = "latestMessageAt";
  static const String groupId = "groupId";
  static const String classId = "classId";
  static const String participants = "participants";
  static const String group = "group";
  static const String chatClass = "chatClass";
  static const String messages = "messages";
  static const String count = "_count"; // API তে _count হিসেবে আসে

  // Nested: Participant
  static const String participantId = "id";
  static const String auth = "auth";

  // Nested: Auth
  static const String authId = "id";
  static const String person = "person";
  static const String business = "business";

  // Nested: Person / Business / Group / Class
  static const String name = "name";
  static const String image = "image";

  // Nested: Count
  static const String countMessages = "messages";

  // Nested: Latest Message
  static const String messageId = "id";
  static const String messageText = "text";
  static const String messageFile = "file";
  static const String messageFileType = "fileType";
  static const String messageSender = "sender";

  // Nested: Sender in Message
  static const String senderId = "id";
  static const String senderPerson = "person";
  static const String senderBusiness = "business";
}