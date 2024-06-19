import 'package:uuid/uuid.dart';

class GenerateIds {
  String generateProductId() {
    String formatedProductId;
    String uuid = Uuid().v4();

    //customize id
    formatedProductId = 'happy-shopping-${uuid.substring(0, 5)}';

    //return
    return formatedProductId;
  }


  String generateCategoryId() {
    String formatedCategoryId;
    String uuid = Uuid().v4();

    //customize id
    formatedCategoryId = 'happy-shopping-${uuid.substring(0, 5)}';

    //return
    return formatedCategoryId;
  }
}