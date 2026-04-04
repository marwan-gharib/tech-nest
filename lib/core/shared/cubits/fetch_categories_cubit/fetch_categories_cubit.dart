import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/shared/domain/entities/category_entity.dart';
import 'package:tech_nest/core/shared/domain/usecases/fetch_categories_usecase.dart';

part 'fetch_categories_state.dart';

class FetchCategoriesCubit extends Cubit<FetchCategoriesState> {
  final FetchCategoriesUsecase _fetchCategoriesUsecase;

  FetchCategoriesCubit(this._fetchCategoriesUsecase)
    : super(const FetchCategoriesInitial());

  Future<void> fetchCategories() async {
    emit(const FetchCategoriesLoading());

    final res = await _fetchCategoriesUsecase.call();

    res.fold(
      (failure) => emit(FetchCategoriesFailed(failure: failure)),
      (categories) => emit(FetchCategoriesLoaded(categories: categories)),
    );
  }
}
