import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/calculator_model.dart';

class CalculatorController {
  final CalculatorModel model;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CalculatorController(this.model);

  Future<void> calculateExpression(String expression) async {
    model.error = null;

    final trimmed = expression.trim();
    if (trimmed.isEmpty) {
      model.error = 'Palun sisesta võrrand';
      model.result = 0;
      return;
    }

    final result = _evaluateExpression(trimmed);
    if (model.error != null || result == null) {
      model.result = 0;
      return;
    }

    model.result = result;

    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).collection('history').add({
          'expression': trimmed,
          'result': result,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        // Handle Firestore error
      }
    }
  }

  String getResultText() {
    if (model.error != null) return model.error!;
    return _pretty(model.result);
  }

  double? _evaluateExpression(String expression) {
    try {
      final tokens = _tokenize(expression);
      if (tokens.isEmpty) {
        throw const FormatException('Palun sisesta võrrand');
      }
      final rpn = _toRpn(tokens);
      final result = _evaluateRpn(rpn);
      if (result == null) {
        throw const FormatException('Viga: vigane võrrand');
      }
      return result;
    } on FormatException catch (error) {
      model.error = error.message;
      return null;
    }
  }

  List<_Token> _tokenize(String expression) {
    final tokens = <_Token>[];
    var i = 0;

    while (i < expression.length) {
      final char = expression[i];

      if (char.trim().isEmpty) {
        i++;
        continue;
      }

      if (_isDigit(char) || char == '.' || _isUnaryMinus(expression, i, tokens)) {
        final numberBuffer = StringBuffer();
        if (char == '-') {
          numberBuffer.write('-');
          i++;
        }

        var dotCount = 0;
        while (i < expression.length) {
          final current = expression[i];
          if (current == '.') {
            dotCount++;
            if (dotCount > 1) {
              throw const FormatException('Viga: vigane number');
            }
          } else if (!_isDigit(current)) {
            break;
          }
          numberBuffer.write(current);
          i++;
        }

        final numberString = numberBuffer.toString();
        if (numberString == '-' || numberString == '.' || numberString == '-.') {
          throw const FormatException('Viga: vigane number');
        }

        final value = double.tryParse(numberString);
        if (value == null) {
          throw const FormatException('Viga: vigane number');
        }
        tokens.add(_Token.number(value));
        continue;
      }

      if (_isOperator(char)) {
        tokens.add(_Token.operator(char));
        i++;
        continue;
      }

      if (char == '(') {
        tokens.add(_Token.leftParen());
        i++;
        continue;
      }

      if (char == ')') {
        tokens.add(_Token.rightParen());
        i++;
        continue;
      }

      throw FormatException('Viga: tundmatu märk "$char"');
    }

    return tokens;
  }

  List<_Token> _toRpn(List<_Token> tokens) {
    final output = <_Token>[];
    final operators = <_Token>[];

    for (final token in tokens) {
      switch (token.type) {
        case _TokenType.number:
          output.add(token);
          break;
        case _TokenType.operator:
          while (operators.isNotEmpty &&
              operators.last.type == _TokenType.operator &&
              _precedence(operators.last.operator) >= _precedence(token.operator)) {
            output.add(operators.removeLast());
          }
          operators.add(token);
          break;
        case _TokenType.leftParen:
          operators.add(token);
          break;
        case _TokenType.rightParen:
          var foundParen = false;
          while (operators.isNotEmpty) {
            final op = operators.removeLast();
            if (op.type == _TokenType.leftParen) {
              foundParen = true;
              break;
            }
            output.add(op);
          }
          if (!foundParen) {
            throw const FormatException('Viga: sulud ei klapi');
          }
          break;
      }
    }

    while (operators.isNotEmpty) {
      final op = operators.removeLast();
      if (op.type == _TokenType.leftParen) {
        throw const FormatException('Viga: sulud ei klapi');
      }
      output.add(op);
    }

    return output;
  }

  double? _evaluateRpn(List<_Token> tokens) {
    final stack = <double>[];

    for (final token in tokens) {
      if (token.type == _TokenType.number) {
        stack.add(token.number);
        continue;
      }

      if (stack.length < 2) {
        return null;
      }

      final b = stack.removeLast();
      final a = stack.removeLast();

      switch (token.operator) {
        case '+':
          stack.add(a + b);
          break;
        case '-':
          stack.add(a - b);
          break;
        case '*':
          stack.add(a * b);
          break;
        case '/':
          if (b == 0) {
            throw const FormatException('Viga: jagamine nulliga');
          }
          stack.add(a / b);
          break;
      }
    }

    if (stack.length != 1) {
      return null;
    }

    return stack.first;
  }

  bool _isDigit(String char) {
    return char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;
  }

  bool _isOperator(String char) {
    return char == '+' || char == '-' || char == '*' || char == '/';
  }

  bool _isUnaryMinus(String expression, int index, List<_Token> tokens) {
    if (expression[index] != '-') return false;
    if (index == 0) return true;
    final previous = tokens.isEmpty ? null : tokens.last;
    return previous == null ||
        previous.type == _TokenType.operator ||
        previous.type == _TokenType.leftParen;
  }

  int _precedence(String operator) {
    return operator == '*' || operator == '/' ? 2 : 1;
  }

  String _pretty(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }
}

enum _TokenType { number, operator, leftParen, rightParen }

class _Token {
  final _TokenType type;
  final double number;
  final String operator;

  const _Token._(this.type, this.number, this.operator);

  factory _Token.number(double value) {
    return _Token._(_TokenType.number, value, '');
  }

  factory _Token.operator(String value) {
    return _Token._(_TokenType.operator, 0, value);
  }

  factory _Token.leftParen() {
    return const _Token._(_TokenType.leftParen, 0, '');
  }

  factory _Token.rightParen() {
    return const _Token._(_TokenType.rightParen, 0, '');
  }
}
