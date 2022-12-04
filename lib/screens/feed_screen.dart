import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:itesogram/utils/colors.dart';
import 'package:itesogram/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
        backgroundColor: itesoColor,
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) =>
                PostCard(snap: snapshot.data!.docs[index].data()),
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
    );
  }
}
