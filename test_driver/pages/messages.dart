class Messages {
  static String failedRegister = "ERROR: missing username";
  static String errorCharacters =
      "ERROR: username length has to be between 3 and 128 characters";
  static String noUsername = "ERROR: User not found";

  static successfulRegister(String username) {
    return "Successfully registered $username!";
  }

  static successfulLogin(String username) {
    return "$username successfully logged in!";
  }
}
