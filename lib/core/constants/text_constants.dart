class TextConstants {
  TextConstants._();

  // urls
  static const String appwriteUrl = "https://sgp.cloud.appwrite.io/v1";
  static const String esewaSucessUrl = 'https://developer.esewa.com.np/success';
  static const String esewaFailureUrl =
      'https://developer.esewa.com.np/failure';

  // bottom nav bar item labels
  static const String home = "Home";
  static const String explore = "Explore";
  static const String add = "Add";
  static const String booking = "My Booking";
  static const String profile = "Profile";

  // button labels
  static const String signUp = "Sign up";
  static const String login = "Log in";
  static const String continueLabel = "Continue";
  static const String currentLocation = "Use Current Location";
  static const String manual = "Select it manually";
  static const String started = "Get Started";
  static const String next = "Next";
  static const String save = "Save Change";
  static const String rent = "Rent Now";
  static const String submit = "Submit Review";
  static const String addProperty = "Add Property";
  static const String complete = "Complete";
  static const String delete = "Delete";
  static const String update = "Update";

  // error messages
  static const String internetError =
      "No internet connection. Please try again";
  static const String uploadSingleFileError = "Please upload image";
  static const String uploadManyFileError = "Please upload property images";
  static const String profileNotPickedError = "Please upload profile image";
  static const String profileComplete = "Successfully profile created";

  // collection for firebase cloud-store
  static const String properties = "properties";
  static const String users = "users";
  static const String notifyCollection = "notifications";
  static const String chatsCollection = "chats";
  static const String messagesCollection = "messages";
  static const String owners = "owners";
  static const String bookings = "bookings";
  static const String reviewsCollection = "reviews";

  // Pagination
  static const int chatListPageSize = 20;
  static const int messagePageSize = 30;

  // Fields
  static const String participantsField = "participants";
  static const String updatedAtField = "updatedAt";
  static const String createdAtField = "createdAt";
  static const String isOnlineField = "isOnline";
  static const String lastSeenField = "lastSeen";
  static const String isReadField = "isRead";
  static const String lastMessageField = "lastMessage";
}
