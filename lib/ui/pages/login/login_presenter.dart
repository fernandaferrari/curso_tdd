abstract class ILoginPresenter {
  Stream<String>? get emailErrorStream;
  Stream<String>? get passwordErrorStream;
  Stream<String>? get mainErrorStream;
  Stream<bool>? get isFormValidStream;
  Stream<bool>? get isLoadStream;

  void validateEmail(String email);
  void validatePassword(String password);
  void auth();
  void dispose();
}
