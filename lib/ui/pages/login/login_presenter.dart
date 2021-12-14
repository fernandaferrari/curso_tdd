abstract class ILoginPresenter {
  Stream<String>? get emailErrorStream;
  Stream<String>? get passwordErrorStream;
  Stream<bool>? get isFormValidStream;
  Stream<bool>? get isLoadStream;
  Stream<String>? get mainErrorStream;

  void validateEmail(String email);
  void validatePassword(String password);
  void auth();
  void dispose();
}
