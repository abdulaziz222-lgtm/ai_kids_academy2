import 'dart:math';

enum MathType { counting, addition, subtraction, multiplication }

/// Math Problem Generator & Model tailored to age groups
class MathProblem {
  final String question;
  final int correctAnswer;
  final List<int> options;
  final MathType type;
  final String emojiIcon;
  final int visualCount1;
  final int visualCount2;
  final String operatorSymbol;

  MathProblem({
    required this.question,
    required this.correctAnswer,
    required this.options,
    required this.type,
    required this.emojiIcon,
    required this.visualCount1,
    required this.visualCount2,
    required this.operatorSymbol,
  });

  static MathProblem generateForAgeGroup(String ageGroup) {
    final rand = Random();
    final emojis = ['🍎', '⭐', '🚗', '🎈', '🍪', '🐸', '🚀', '🍰', '🐶', '🦄'];
    final selectedEmoji = emojis[rand.nextInt(emojis.length)];

    if (ageGroup == '3-5') {
      // Simple counting or tiny addition
      final num1 = rand.nextInt(5) + 1;
      final num2 = rand.nextInt(3) + 1;
      final isAddition = rand.nextBool();
      if (!isAddition) {
        final answer = num1;
        final optionsSet = <int>{answer};
        while (optionsSet.length < 3) {
          final dummy = rand.nextInt(6) + 1;
          optionsSet.add(dummy);
        }
        final optionsList = optionsSet.toList()..shuffle();
        return MathProblem(
          question: 'How many $selectedEmoji are there?',
          correctAnswer: answer,
          options: optionsList,
          type: MathType.counting,
          emojiIcon: selectedEmoji,
          visualCount1: num1,
          visualCount2: 0,
          operatorSymbol: '',
        );
      } else {
        final answer = num1 + num2;
        final optionsSet = <int>{answer};
        while (optionsSet.length < 3) {
          final dummy = rand.nextInt(8) + 1;
          optionsSet.add(dummy);
        }
        return MathProblem(
          question: '$num1 $selectedEmoji + $num2 $selectedEmoji = ?',
          correctAnswer: answer,
          options: optionsSet.toList()..shuffle(),
          type: MathType.addition,
          emojiIcon: selectedEmoji,
          visualCount1: num1,
          visualCount2: num2,
          operatorSymbol: '+',
        );
      }
    } else if (ageGroup == '6-7') {
      // Addition & Subtraction up to 20
      final isAddition = rand.nextBool();
      if (isAddition) {
        final num1 = rand.nextInt(10) + 1;
        final num2 = rand.nextInt(10) + 1;
        final answer = num1 + num2;
        final optionsSet = <int>{answer};
        while (optionsSet.length < 3) {
          final dummy = max(1, answer + (rand.nextInt(7) - 3));
          optionsSet.add(dummy);
        }
        return MathProblem(
          question: '$num1 + $num2 = ?',
          correctAnswer: answer,
          options: optionsSet.toList()..shuffle(),
          type: MathType.addition,
          emojiIcon: selectedEmoji,
          visualCount1: num1,
          visualCount2: num2,
          operatorSymbol: '+',
        );
      } else {
        final num1 = rand.nextInt(12) + 5;
        final num2 = rand.nextInt(num1 - 1) + 1;
        final answer = num1 - num2;
        final optionsSet = <int>{answer};
        while (optionsSet.length < 3) {
          final dummy = max(1, answer + (rand.nextInt(7) - 3));
          optionsSet.add(dummy);
        }
        return MathProblem(
          question: '$num1 - $num2 = ?',
          correctAnswer: answer,
          options: optionsSet.toList()..shuffle(),
          type: MathType.subtraction,
          emojiIcon: selectedEmoji,
          visualCount1: num1,
          visualCount2: num2,
          operatorSymbol: '-',
        );
      }
    } else {
      // 8-10 Multiplication & Flash Cards
      final num1 = rand.nextInt(9) + 2;
      final num2 = rand.nextInt(9) + 2;
      final answer = num1 * num2;
      final optionsSet = <int>{answer};
      while (optionsSet.length < 3) {
        final dummy = max(2, answer + (rand.nextInt(11) - 5));
        optionsSet.add(dummy);
      }
      return MathProblem(
        question: '$num1 × $num2 = ?',
        correctAnswer: answer,
        options: optionsSet.toList()..shuffle(),
        type: MathType.multiplication,
        emojiIcon: selectedEmoji,
        visualCount1: num1,
        visualCount2: num2,
        operatorSymbol: '×',
      );
    }
  }
}
