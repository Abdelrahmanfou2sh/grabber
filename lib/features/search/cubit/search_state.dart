part of 'search_cubit.dart';

@immutable
sealed class SearchState extends Equatable{}

final class SearchInitial extends SearchState {
  @override
  List<Object?> get props => [];
}
final class SearchLoading extends SearchState {
  @override
  List<Object?> get props => [];
}
final class SearchLoaded extends SearchState {
  final List<Product> products;
  SearchLoaded(this.products);
  @override
  List<Object?> get props => [products];
}
final class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
  @override
  List<Object?> get props => [message];
}