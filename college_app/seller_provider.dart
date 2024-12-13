// import 'dart:convert';

// import 'package:cloudinary_public/cloudinary_public.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:pak_wheels_application/providers/json_tokens_provider.dart';

// class seller_provider extends ChangeNotifier {
//   String? id2;
//   String? email2;

//   var seller_name;

//   XFile? selectedImage;

//   String? imageUrl;

//   var download_url_of_image;

//   final picker = ImagePicker();

//   void open_gallery() async {
//     XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       selectedImage = pickedImage;
//       notifyListeners();
//       upload_image_middleware();
//     }
//   }

//   void upload_image_middleware() async {
//     await upload_image(selectedImage!);
//   }

//   Future<String?> upload_image(XFile image) async {
//     try {
//       final cloudinary = CloudinaryPublic('dgf5mlrnz', 'images_of_cars');

//       CloudinaryResponse imageResponse = await cloudinary.uploadFile(
//         CloudinaryFile.fromBytesData(
//           await image.readAsBytes(),
//           identifier: 'picked_image',
//           folder: 'categoryimages',
//         ),
//       );

//       imageUrl = imageResponse.secureUrl;

//       return imageResponse.secureUrl;
//     } catch (e) {
//       print('Upload error: $e');
//       return null;
//     }
//   }

//   var seller_unique_id;

//   Future<bool> specific_user(String email, String password) async {
//     var data_body = jsonEncode({
//       "email": email,
//       "password": password,
//     });

//     JsonTokensProvider j1 = JsonTokensProvider();
//     final specific_user_url = 'https://ecommerce123-alpha.vercel.app/home/get_specific';

//     final response = await http.post(
//       Uri.parse(specific_user_url),
//       headers: {"Content-Type": "application/json"},
//       body: data_body,
//     );

//     if (response.statusCode == 200) {
//       print(response.body);
//       final responseData = json.decode(response.body);

//       final user_data = responseData['user'];
//       String user_token = responseData['token'];

//       // Extract seller unique ID from the response
//       seller_unique_id = user_data['_id'];
//       seller_name = user_data['seller_name'];

//       print('---------------');

//       print(seller_unique_id);
//       print(email2);

//       print('---------------');

//       // Store the token, seller ID, and other user details securely
//       await j1.saveToken(user_token, email, password);

//       notifyListeners();
//       return true;
//     } else {
//       print("Server error: ${response.statusCode}");
//       notifyListeners();
//       return false;
//     }
//   }

//   String? uniqueId123;

//   Future<String?> getPostsByUniqueId(String email, String password) async {
//     // Define the URL for your API endpoint
//     final String url = 'https://ecommerce123-alpha.vercel.app/home/get_posts_by_unique_id';

//     // Create the body of the request with email and password
//     var data = jsonEncode({
//       'email': email,
//       'password': password,
//     });

//     // Send the POST request
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: data,
//     );

//     // Check if the response status is OK (200)
//     if (response.statusCode == 200) {
//       // Parse the response JSON
//       var responseData = json.decode(response.body);

//       // Assuming the unique ID is in the 'seller_id' field of the response
//       uniqueId123 = responseData['seller_id'] ?? '';

//       print('unique -------------');
//       print(uniqueId123);
//       print('unique -------------');

//       return uniqueId123;
//     } else {
//       // If the request fails, print the error message and return null
//       print('Failed to fetch data: ${response.statusCode}');
//       return null;
//     }
//   }

//   List<String> product_name = [];
//   List<String> seller_name_123 = [];
//   List<String> product_image = [];
//   List<String> product_quality = [];
//   List<String> product_warranty = [];
//   List<String> product_price = [];
//   List<String> unique_id123 = [];
//   List<dynamic> product_type = [];

//   // Getter for product_name
//   List<String> get getProductName => product_name;

//   List<String> get get_seller_name => seller_name_123;

// // Getter for product_image
//   List<String> get getProductImage => product_image;

// // Getter for product_quality
//   List<String> get getProductQuality => product_quality;

// // Getter for product_warranty
//   List<String> get getProductWarranty => product_warranty;

// // Getter for product_price
//   List<String> get getProductPrice => product_price;

// // Getter for unique_id
//   List<String> get getUniqueId => unique_id123;

//   Future<bool> check_all_posts_of_specific_user(String seller_id_78) async {
//     JsonTokensProvider j1 = JsonTokensProvider();
//     // await j1.loadSellerId();

//     unique_id123.clear();
//     product_name.cast();
//     product_name.clear();
//     product_quality.clear();
//     product_image.clear();

//     product_price.cast();
//     product_type.clear();
//     seller_name_123.clear();

//     final url = 'https://ecommerce123-alpha.vercel.app/home/check_exists/check_all_posts_of_specific_user';

//     var toJson = jsonEncode({"seller_id_in_seller_collection": seller_id_78});

//     final response = await http.post(
//       Uri.parse(url),
//       headers: {"Content-Type": "application/json"},
//       body: toJson,
//     );
//     print('------------');
//     print('seller_id ');
//     print(seller_id_78);
//     print('------------');

//     if (response.statusCode == 200) {
//       final List responseJson = json.decode(response.body);

//       for (var data in responseJson) {
//         unique_id123.add(data['_id']);
//         product_name.add(data['product_name']);
//         product_image.add(data['image_url']);
//         product_quality.add(data['product_quality']);
//         product_price.add(data['product_price']);
//         product_warranty.add(data['product_warranty']);
//         product_type.add(data['product_type']);
//         seller_name_123.add(data['seller_name']);
//       }
//       notifyListeners();

//       return true;
//     } else {
//       print('Failed to fetch posts. Status code: ${response.statusCode}');
//       notifyListeners();
//       return false;
//     }
//   }

//   Future<bool> add_ads_posts(String seller_id, String product_name_save, String seller_name123, String product_quality_save,
//       String product_warranty_save_, String product_price_save_, String product_type_save, String image_link) async {
//     final ad_post_api = 'https://ecommerce123-alpha.vercel.app/home/check_exists/new/seller_post/new_post';

//     var body_encode_to_json = jsonEncode({
//       "seller_product_id": seller_id,
//       "seller_name": seller_name123,
//       "product_name": product_name_save,
//       "product_quality": product_quality_save,
//       "product_warranty": product_warranty_save_,
//       "product_price": product_price_save_,
//       "product_type": [product_type_save],
//       "image_url": image_link,
//     });

//     print('------------------------');

//     print(id2);
//     print(seller_name123);
//     print(
//       product_name_save,
//     );
//     print(product_quality_save);
//     print(product_warranty_save_);
//     print([product_type_save]);
//     print(product_price_save_);
//     print(product_price_save_);
//     print(image_link);

//     print('------------------------');

//     final sign_up_post_request = await http.post(
//       Uri.parse(ad_post_api),
//       headers: {"Content-Type": "application/json"},
//       body: body_encode_to_json,
//     );

//     if (sign_up_post_request.statusCode == 200) {
//       print('Added the seller new post');
//       notifyListeners();
//       return true;
//     } else {
//       print('Could not add seller new post: ${sign_up_post_request.body}');
//       return false;
//     }
//   }

//   Future<bool> edit_post(String seller_id, String product_name, String seller_name123, String product_quality, String product_warranty,
//       String product_price, product_type) async {
//     print('-------');
//     print(unique_id123);

//     var convert_to_object_json = jsonEncode({
//       "unique_id": seller_id,
//       "seller_name": seller_name123,
//       "product_name": product_name,
//       "product_quality": product_quality,
//       "product_warranty": product_warranty,
//       "product_type": product_type,
//       "product_price": product_price,
//     });

//     final api = 'https://ecommerce123-alpha.vercel.app/home/sellers/seller_post_edit';

//     final api_to_edit_data = await http.put(Uri.parse(api), headers: {"Content-Type": "application/json"}, body: convert_to_object_json);

//     if (api_to_edit_data.statusCode == 200) {
//       print('\n\n\nam cool');
//       return true;
//     } else {
//       return false;
//     }
//   }

//   void deleteIndexDataFromList(int index) {
//     print('Index to delete: $index');
//     print('Product images before deletion: $product_image');
//     print('Product names before deletion: $product_name');

//     // Check if the index is valid for all related lists
//     if (index >= 0 &&
//         index < product_image.length &&
//         index < product_name.length &&
//         index < product_price.length &&
//         index < product_warranty.length &&
//         index < product_quality.length) {
//       product_image.removeAt(index);
//       product_name.removeAt(index);
//       product_price.removeAt(index);
//       product_warranty.removeAt(index);
//       product_quality.removeAt(index);
//       product_type.removeAt(index);
//       unique_id123.removeAt(index);

//       notifyListeners();
//     } else {
//       print('Index out of bounds!');
//     }

//     print('Product images after deletion: $product_image');
//     print('Product names after deletion: $product_name');
//   }

//   Future<bool> delete_specific_item_via_unique_id(String uniqueId) async {
//     final stringToObject = {"unique_id": uniqueId};
//     final api = 'https://ecommerce123-alpha.vercel.app/home/seller/delete_unique_id_data';

//     final apiToDeleteData = await http.delete(
//       Uri.parse(api),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(stringToObject),
//     );

//     print('1122341451255');
//     print(uniqueId);
//     print('1122341451255');
//     if (apiToDeleteData.statusCode == 200) {
//       print('Data deleted');
//       notifyListeners();

//       return true;
//     } else {
//       notifyListeners();
//       print('Data not deleted');
//       return false;
//     }
//   }

//   Future<bool> compare(String email, String password, String name_save) async {
//     var encode_user_data = jsonEncode({
//       "email": email,
//       "password": password,
//       "seller__name": name_save,
//     });

//     final sign_up_api = 'https://ecommerce123-alpha.vercel.app/home/check_exists';

//     final sign_up_post_request = await http.post(Uri.parse(sign_up_api), headers: {"Content-Type": "application/json"}, body: encode_user_data);

//     print(sign_up_post_request.body);

//     if (sign_up_post_request.statusCode == 200) {
//       print('login credientials exists');
//       notifyListeners();
//       return true; // Sign-up successful
//     } else {
//       print('login credientials exists');
//       notifyListeners();
//       return false; // Sign-up failed
//     }
//   }

//   Future<bool> sign_up(String email, String password) async {
//     var encode_user_data = jsonEncode({
//       "email": email,
//       "password": password,
//     });

//     final sign_up_api = 'https://ecommerce123-alpha.vercel.app/home/signup_post_request';

//     final sign_up_post_request = await http.post(Uri.parse(sign_up_api), headers: {"Content-Type": "application/json"}, body: encode_user_data);

//     if (sign_up_post_request.statusCode == 200) {
//       print('Successfully user added');
//       notifyListeners();
//       return true; // Sign-up successful
//     } else {
//       print('Could not add the user');
//       notifyListeners();
//       return false; // Sign-up failed
//     }
//   }
// }
