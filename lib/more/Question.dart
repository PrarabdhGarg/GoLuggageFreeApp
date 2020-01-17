class Question {
  String question;
  String answer;
  String imageUrl;

  Question({
    this.question,
    this.answer,
    this.imageUrl
  });

  factory Question.fromMap(Map<String, dynamic> map) => Question(
    question: map["question"],
    answer: map["answer"],
    imageUrl: map["imageUrl"]
  );
}