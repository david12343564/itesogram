import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itesogram/screens/profile_screen.dart';
import 'package:itesogram/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showUsers = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: itesoColor,
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(labelText: "Search for user"),
          onFieldSubmitted: (String _) {
            setState(() {
              _showUsers = true;
            });
          },
        ),
      ),
      body: _showUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Text("result ${index}: "),
                        title: Text((snapshot.data! as dynamic).docs[index]
                            ['username']),
                      ),
                    );
                  },
                  itemCount: (snapshot.data! as dynamic).docs.length,
                );
              },
            )
          : Center(
              child: Text("Search for some user"),
            ),
    );
  }
}
