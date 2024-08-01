import 'package:flutter/material.dart';
import 'package:mcqprac/question_model.dart';
import 'package:mcqprac/questions.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Map<int, int> _selectedAnswers = {};
  late List<McqQuestionModel> mcqQuestions;
  bool _showResults = false;

  // if you want to get a fixed length from another screen.
  // the use this var and pass this as a list length
  var howManyQuestions;

  @override
  void initState() {
    super.initState();
    mcqQuestions = getQuestions();
  }

  void _onOptionSelected(int questionIndex, int optionIndex) {
    setState(() {
      _selectedAnswers[questionIndex] = optionIndex;
    });
  }

  void _checkAnswers() {
    setState(() {
      _showResults = true;
    });

    int correctCount = 0;
    mcqQuestions.asMap().forEach((index, question) {
      if (_selectedAnswers[index] == question.correctAnswerIndex) {
        correctCount++;
      }
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.start,
          actions: [
            // title line
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Results',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            // divider
            Divider(color: Colors.grey.withOpacity(0.3)),

            // evaluations
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Questions: ${mcqQuestions.length}",
                        style: const TextStyle(fontSize: 20)),
                    Text("Correct Answers: $correctCount",
                        style: const TextStyle(fontSize: 20)),
                    Text("Wrong Answers: ${mcqQuestions.length - correctCount}",
                        style: const TextStyle(fontSize: 20)),
                    // Text("Skipped Questions: 12"), // this part will integrate soon
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Ok"))),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: ListView.builder(
        itemCount: mcqQuestions.length,
        itemBuilder: (context, index) {
          final question = mcqQuestions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text("${index + 1}. ${question.question}",
                      style: const TextStyle(fontSize: 18)),
                ),
                Column(
                  children: question.options.asMap().entries.map((entry) {
                    int optionIndex = entry.key;
                    String optionText = entry.value;
                    bool isSelected = _selectedAnswers[index] == optionIndex;
                    bool isCorrect = question.correctAnswerIndex == optionIndex;
                    bool showCorrect = _showResults;

                    IconData iconData;
                    Color iconColor;

                    if (!showCorrect) {
                      iconData =
                          isSelected ? Icons.circle : Icons.circle_outlined;
                      iconColor = isSelected ? Colors.black : Colors.grey;
                    } else {
                      if (isSelected) {
                        if (isCorrect) {
                          iconData = Icons.check_circle_rounded;
                          iconColor = Colors.green;
                        } else {
                          iconData = Icons.cancel;
                          iconColor = Colors.red;
                        }
                      } else if (isCorrect) {
                        iconData = Icons.check_circle_rounded;
                        iconColor = Colors.green;
                      } else {
                        iconData = Icons.circle_outlined;
                        iconColor = Colors.black;
                      }
                    }
                    // Define option letters (a, b, c, d)
                    String optionLetter = String.fromCharCode(
                        97 + optionIndex); // 65 is the ASCII code for 'A'

                    return ListTile(
                      visualDensity: const VisualDensity(vertical: -4),
                      title: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: showCorrect
                                ? isSelected
                                    ? isCorrect
                                        ? Colors.green.withOpacity(0.3)
                                        : Colors.red.withOpacity(0.3)
                                    : isCorrect
                                        ? isSelected
                                            ? null
                                            : Colors.green.withOpacity(0.3)
                                        : null
                                : null),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Icon(
                                  iconData,
                                  size: 20,
                                  color: iconColor,
                                ),
                                Positioned(
                                    top: 2,
                                    left: 7,
                                    // right: getWidth(5),
                                    // bottom: getWidth(10),
                                    child: Text(
                                      optionLetter,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ))
                              ],
                            ),
                            const SizedBox(width: 10),
                            Text(optionText)
                          ],
                        ),
                      ),
                      onTap: !_showResults
                          ? () => _onOptionSelected(index, optionIndex)
                          : null,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkAnswers,
        tooltip: 'Check Answers',
        child: const Icon(Icons.check),
      ),
    );
  }
}
