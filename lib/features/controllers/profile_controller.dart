import 'package:areea/features/models/person.dart';
import 'package:areea/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);

  List<Person> get allUsersProfileList => usersProfileList.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    usersProfileList.bindStream(FirebaseFirestore.instance
        .collection("users")
        .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((QuerySnapshot queryDataSnapshot) {
      List<Person> profileList = [];

      for (var eachProfile in queryDataSnapshot.docs) {
        profileList.add(Person.fromDataSnapshot(eachProfile));
      }
      return profileList;
    }));
  }

  favouriteSentAndFavouriteReceived(String toUserID, String senderName) async {
    var document = await FirebaseFirestore.instance
        .collection("users")
        .doc(toUserID)
        .collection("favouriteReceived")
        .doc(currentUserID)
        .get();

    //remove the favourite from database
    if (document.exists) {
      //remove currentUserID from the favouriteReceived list of that profile person [toUserID]
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID)
          .collection("favouriteReceived")
          .doc(currentUserID)
          .delete();

      //remove profile person [toUserID] from the favouriteSent list of the currentUserID
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection("favouriteSent")
          .doc(toUserID)
          .delete();
    } else //add-sent like in database
    {
      //add currentUserID to the favouriteReceived list of that profile person [toUserID]
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID)
          .collection("favouriteReceived")
          .doc(currentUserID)
          .set({});

      //add profile person [toUserID] to the favouriteSent list of the currentUserID
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection("favouriteSent")
          .doc(toUserID)
          .set({});

      //send notification
    }

    update();
  }

  likeSentAndFavouriteReceived(String toUserID, String senderName) async {
    var document = await FirebaseFirestore.instance
        .collection("users")
        .doc(toUserID)
        .collection("likeReceived")
        .doc(currentUserID)
        .get();

    //remove the like from database
    if (document.exists) {
      //remove currentUserID from the likeReceived list of that profile person [toUserID]
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID)
          .collection("likeReceived")
          .doc(currentUserID)
          .delete();

      //remove profile person [toUserID] from the likeSent of the currentUserID
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection("likeSent")
          .doc(toUserID)
          .delete();
    } else //add new view in database
    {
      //add currentUserID to the likeReceived list of that profile person [toUserID]
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID)
          .collection("likeReceived")
          .doc(currentUserID)
          .set({});

      //add profile person [toUserID] to the likeSent list of the currentUserID
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection("likeSent")
          .doc(toUserID)
          .set({});

      //send notification
    }

    update();
  }

  viewSentAndFavouriteReceived(String toUserID, String senderName) async {
    var document = await FirebaseFirestore.instance
        .collection("users")
        .doc(toUserID)
        .collection("viewReceived")
        .doc(currentUserID)
        .get();

    //remove the like from database
    if (document.exists) {
      print("already in view list");
    } else //mark as favourite //add favourite in database
    {
      //add currentUserID to the viewReceived list of that profile person [toUserID]
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID)
          .collection("viewReceived")
          .doc(currentUserID)
          .set({});

      //add profile person [toUserID] to the viewSent list of the currentUserID
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection("viewSent")
          .doc(toUserID)
          .set({});

      //send notification
    }

    update();
  }
}
