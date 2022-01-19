abstract class SurveysPresenter {
  Stream<bool> get isLoadStream;

  Future<void> loadData();
}
