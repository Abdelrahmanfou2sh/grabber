import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/features/categories/model/category_model.dart';
import 'package:meta/meta.dart';

import '../repository/category_repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepository;
  CategoryCubit(this._categoryRepository) : super(CategoryInitial());

  void getCategory() async{
    emit(CategoryLoading());
    try{
      final categories = await _categoryRepository.getCategories();
      emit(CategoryLoaded(categories));
    }catch(e){
      emit(CategoryError(e.toString()));
    }
  }
}
