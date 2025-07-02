import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/product_model.dart';
import '../repo/product_repository.dart';
part 'products_state.dart';

enum SortOption { priceAsc, priceDesc, titleAsc, titleDesc }

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository _productRepository;
  List<Product> _allProducts = [];
  double? _minPrice;
  double? _maxPrice;
  String? _selectedCategory;
  SortOption? _sortOption;

  ProductsCubit(this._productRepository) : super(ProductsInitial());

  List<Product> get allProducts {
    if (state is ProductsLoaded) {
      return (state as ProductsLoaded).products;
    }
    return [];
  }

  void getProducts() async {
    emit(ProductsLoading());
    try {
      _allProducts = await _productRepository.getProducts();
      _applyFilters();
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  void setFilters({double? minPrice, double? maxPrice, String? category}) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _selectedCategory = category;
    _applyFilters();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    _applyFilters();
  }

  void _applyFilters() {
    if (_allProducts.isEmpty) return;

    var filteredProducts = List<Product>.from(_allProducts);

    if (_minPrice != null) {
      filteredProducts =
          filteredProducts.where((p) => p.price >= _minPrice!).toList();
    }

    if (_maxPrice != null) {
      filteredProducts =
          filteredProducts.where((p) => p.price <= _maxPrice!).toList();
    }

    if (_selectedCategory?.isNotEmpty ?? false) {
      filteredProducts =
          filteredProducts
              .where((p) => p.category == _selectedCategory)
              .toList();
    }

    if (_sortOption != null) {
      switch (_sortOption) {
        case SortOption.priceAsc:
          filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortOption.priceDesc:
          filteredProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case SortOption.titleAsc:
          filteredProducts.sort((a, b) => a.title.compareTo(b.title));
          break;
        case SortOption.titleDesc:
          filteredProducts.sort((a, b) => b.title.compareTo(a.title));
          break;
        default:
          break;
      }
    }

    emit(ProductsLoaded(filteredProducts));
  }
}
