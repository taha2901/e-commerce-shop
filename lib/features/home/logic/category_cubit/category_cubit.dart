import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/core/services/home_services.dart';
import 'package:ecommerce_app/features/home/logic/category_cubit/category_state.dart';


class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final categorySercices = HomeServicesImpl();

  void getCategory() async {
    emit(CategoryLoading());

    try {
      final selectedCategory = await categorySercices.fetchCategories();

      emit(CategoryLoaded(category: selectedCategory));
    } catch (e) {
      if (isClosed) return;
      emit(CategoryError(message: "Error: $e"));
    }
  }
}
