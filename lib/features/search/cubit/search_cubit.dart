import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../product/model/product_model.dart';
import '../repository/search_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _searchRepository;
  SearchCubit(this._searchRepository) : super(SearchInitial());

  void searchProducts(String query) async {
    if (query.isEmpty) {
      emit(SearchLoaded([]));
      return;
    }

    emit(SearchLoading());
    try {
      final products = await _searchRepository.searchProducts(query);
      emit(SearchLoaded(products));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
