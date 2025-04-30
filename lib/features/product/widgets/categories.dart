import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/features/categories/cubit/category_cubit.dart';

import '../../categories/model/category_model.dart';
import '../../categories/screens/category_product_screen.dart';

class Categories extends StatelessWidget {
  const Categories({super.key, required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return CircularProgressIndicator();
        } else if (state is CategoryLoaded) {
          return SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CategoryProductsScreen(category: category.name),
                      ));
                    },
                    child: Column(
                      children: [
                        Image.network(category.imageUrl, width: 70, height: 70),
                        const SizedBox(height: 10),
                        Text(category.name),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is CategoryError) {
          return Text('Failed to load categories');
        }
        return Container();
      },
    );
  }
}
