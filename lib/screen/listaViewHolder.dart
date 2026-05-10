import 'package:flutter/material.dart';
import 'package:flutter_http/models/post.dart';
import 'package:flutter_http/services/NewsApiServices.dart';

class ListaViewHolder extends StatefulWidget {
  const ListaViewHolder({super.key});

  @override
  State<ListaViewHolder> createState() => _ListaViewHolderState();
}

class _ListaViewHolderState extends State<ListaViewHolder> {
  int currentPageIndex = 0;

  List<Post> posts = [];

  bool isLoading = false;

  final List<String> categories = ["business", "health", "science"];

  @override
  void initState() {
    super.initState();
    loadPosts(categories[currentPageIndex]);
  }

  Future<void> loadPosts(String category) async {
    setState(() {
      isLoading = true;
    });

    posts = await NewsApiServices().getPosts(category);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        indicatorColor: Colors.grey,

        onDestinationSelected: (int index) async {
          setState(() {
            currentPageIndex = index;
          });

          await loadPosts(categories[index]);
        },
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.business), label: 'Business'),
          NavigationDestination(
            icon: Icon(Icons.health_and_safety),
            label: 'Health',
          ),
          NavigationDestination(icon: Icon(Icons.science), label: 'Science'),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,

              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        post.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.sourceName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(post.description),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
