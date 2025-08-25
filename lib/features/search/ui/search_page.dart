import 'package:ecommerce_app/features/search/logic/earch_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/search/logic/search_cubit.dart';
import 'package:ecommerce_app/features/home/data/product_items_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Products'),
          centerTitle: true,
          elevation: 1,
        ),
        body: Column(
          children: [
            // 🔍 Search Field
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) =>
                    context.read<SearchCubit>().searchProducts(value),
                decoration: InputDecoration(
                  hintText: 'Search for products...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 📦 Results
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchLoaded) {
                    final results = state.results;

                    if (results.isEmpty) {
                      return const Center(
                        child: Text(
                          "No products found 🧐",
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final product = results[index];
                        return ProductCard(product: product);
                      },
                    );
                  } else if (state is SearchError) {
                    return Center(child: Text("❌ ${state.message}"));
                  }

                  return const Center(
                    child: Text(
                      "Start typing to search 🕵️‍♂️",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  final ProductItemModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Navigate to product details page
        },
        child: Row(
          children: [
            // Product Image
            SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                product.imgUrl,
                fit: BoxFit.cover,
              ),
            ),

            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RatingBarIndicator(
                      rating: product.averageRate,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 16.0,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
