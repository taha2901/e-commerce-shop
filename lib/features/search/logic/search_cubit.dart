import 'package:ecommerce_app/core/services/home_services.dart';
import 'package:ecommerce_app/features/search/logic/earch_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final _homeServices = HomeServicesImpl();

  void searchProducts(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final allProducts = await _homeServices.fetchProducts();
      final filtered = allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(SearchLoaded(filtered));
    } catch (e) {
      emit(SearchError('Something went wrong!'));
    }
  }
}
