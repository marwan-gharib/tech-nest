import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/entities/category_entity.dart';
import 'package:tech_nest/features/categories/domain/use_cases/fetch_categories_usecase.dart';

part 'fetch_categories_state.dart';

class FetchCategoriesCubit extends Cubit<FetchCategoriesState> {
  final FetchCategoriesUsecase _fetchCategoriesUsecase;

  FetchCategoriesCubit(this._fetchCategoriesUsecase)
    : super(const FetchCategoriesInitial());

  Future<void> fetchCategories() async {
    emit(const FetchCategoriesLoading());

    final res = await _fetchCategoriesUsecase.call();

    res.fold(
      (failure) => emit(FetchCategoriesFailed(message: failure.message)),
      (categories) => emit(FetchCategoriesLoaded(categories: categories)),
    );
  }
}
