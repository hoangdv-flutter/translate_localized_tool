import 'package:equatable/equatable.dart';

class OnlineTranslateLanguage extends Equatable {
  final String code;
  final String name;

  const OnlineTranslateLanguage({required this.code, required this.name});

  @override
  List<Object?> get props => [code, name];

}
