part of 'locale_cubit.dart';

class LocaleState extends Equatable {
  final AppLocale locale;

  const LocaleState(this.locale);

  @override
  List<Object?> get props => [locale];
}
