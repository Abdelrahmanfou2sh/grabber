part of 'category_cubit.dart';

@immutable
sealed class CategoryState extends Equatable{}

final class CategoryInitial extends CategoryState {
  @override
  List<Object?> get props => [];
}
final class CategoryLoading extends CategoryState {
  @override
  List<Object?> get props => [];
}
final class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;
  CategoryLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}
final class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}
