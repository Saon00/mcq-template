class McqQuestionModel {

  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  McqQuestionModel(
      {required this.question,
      required this.options,
      required this.correctAnswerIndex});
}
