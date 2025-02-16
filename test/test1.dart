import 'package:flutter_test/flutter_test.dart';
import 'package:swe_project/screens/trainee/register.dart';

void main() {
  group('TraineeRegisterScreen', () {
    test('should return true if input contains special characters', () {
      final screen = TraineeRegisterScreenState();
      expect(screen.containsSpecialCharacters('hello@world'), isTrue);
      expect(screen.containsSpecialCharacters('password!'), isTrue);
      expect(screen.containsSpecialCharacters('user#name'), isTrue);
    });

    test('should return false if input does not contain special characters', () {
      final screen = TraineeRegisterScreenState();
      expect(screen.containsSpecialCharacters('helloworld'), isFalse);
      expect(screen.containsSpecialCharacters('password123'), isFalse);
      expect(screen.containsSpecialCharacters('username'), isFalse);
    });
  });
}