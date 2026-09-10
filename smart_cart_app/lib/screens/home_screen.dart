import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> loadedProducts = [
    Product(
      id: 'p1',
      title: 'Laut Bercerita',
      price: 150000,
      imageUrl:
          'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1516602134i/36393774.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Bumi Manusia',
      price: 170000,
      imageUrl:
          'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1565658920i/1398034.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Hujan',
      price: 90000,
      imageUrl:
          'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1451905281i/28446637.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Rumah Untuk Alie',
      price: 120000,
      imageUrl:
          'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1715849329i/213533825.jpg',
    ),
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = loadedProducts
        .where((prod) =>
            prod.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('NOVELKU GFAMEDIA'),
        actions: [
          Consumer<CartProvider>(
            builder: (btnContext, cart, child) => Badge(
              isLabelVisible: cart.itemCount > 0,
              backgroundColor: Colors.amber,
              textColor: Colors.black,
              label: Text(
                '${cart.itemCount}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    size: 28, color: Colors.yellow),
                onPressed: () {
                  Navigator.of(btnContext).push(
                    MaterialPageRoute(builder: (ctx) => const CartScreen()),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // BAR PENCARIAN
          Container(
            margin: const EdgeInsets.all(12.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: const Color(0xFFFFB74D)),
            ),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Pencarian',
                hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                icon: Icon(Icons.search, color: Color(0xFFE65100)),
              ),
            ),
          ),

          // LIST PRODUK
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: filteredProducts.length,
              itemBuilder: (ctx, i) {
                final product = filteredProducts[i];
                return Card(
                  elevation: 2,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.zero,
                          child: Image.network(
                            product.imageUrl,
                            width: 70,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, error, stackTrace) =>
                                Container(
                              width: 70,
                              height: 90,
                              color: const Color(0xFFFFE0B2),
                              child: const Icon(Icons.book,
                                  size: 40, color: Color(0xFFD32F2F)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Rp ${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFE65100),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Builder(
                          builder: (btnCtx) => OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFD32F2F)),
                              backgroundColor: const Color(0xFFFFF8E1),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                            ),
                            onPressed: () {
                              Provider.of<CartProvider>(btnCtx, listen: false)
                                  .addItem(
                                product.id,
                                product.price,
                                product.title,
                                product.imageUrl,
                              );
                            },
                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              size: 18,
                              color: Color(0xFFD32F2F),
                            ),
                            label: const Text(
                              'Tambah',
                              style: TextStyle(
                                color: Color(0xFFD32F2F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (navContext, cart, child) => Container(
          height: 55,
          color: const Color(0xFFD32F2F),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, size: 30, color: Colors.yellow),
                onPressed: () {},
              ),
              Badge(
                isLabelVisible: cart.itemCount > 0,
                backgroundColor: Colors.amber,
                textColor: Colors.black,
                label: Text(
                  '${cart.itemCount}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined,
                      size: 30, color: Colors.yellow),
                  onPressed: () {
                    Navigator.of(navContext).push(
                      MaterialPageRoute(builder: (ctx) => const CartScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}