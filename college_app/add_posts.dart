// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:pak_wheels_application/providers/seller_provider.dart';
// import 'package:pak_wheels_application/seller_screens/specific_user.dart';
// import 'package:provider/provider.dart';

// class AddOrEditAds extends StatefulWidget {
//   final String? email;
//   final String? password;
//   final String? seller_id;
//   final String? name;
//   final String? sellerName;
//   final String? price;
//   final String? image;
//   final String? warranty;
//   final String? quality;
//   final String? productType;
//   final bool? edit;

//   AddOrEditAds({
//     super.key,
//     this.email,
//     this.password,
//     this.seller_id,
//     this.sellerName,
//     this.name,
//     this.price,
//     this.image,
//     this.warranty,
//     this.quality,
//     this.productType,
//     this.edit,
//   });

//   @override
//   State<AddOrEditAds> createState() => _AddOrEditAdsState();
// }

// class _AddOrEditAdsState extends State<AddOrEditAds> {
//   final TextEditingController productNameController = TextEditingController();
//   final TextEditingController sellerNameController = TextEditingController();
//   final TextEditingController productQualityController = TextEditingController();
//   final TextEditingController productWarrantyController = TextEditingController();
//   final TextEditingController productPriceController = TextEditingController();
//   final TextEditingController productTypeController = TextEditingController();

//   String get getName => widget.name ?? 'Enter the name of the product';
//   String get getUserName => widget.sellerName ?? 'Enter the name of the seller';
//   String get getPrice => widget.price ?? 'Enter the price of the product';
//   String get getWarranty => widget.warranty ?? 'Enter the warranty of product';
//   String get getQuality => widget.quality ?? 'Enter the quality of the product';
//   bool get getEdit => widget.edit ?? false;

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<seller_provider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.seller_id ?? 'abc'),
//         backgroundColor: Colors.yellow,
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 10.0),
//           child: ListView(
//             children: [
//               const SizedBox(height: 5),
//               Consumer<seller_provider>(
//                 builder: (context, provider, child) {
//                   return IconButton(
//                     onPressed: () async {
//                       provider.open_gallery();
//                     },
//                     icon: Builder(
//                       builder: (context) {
//                         if (provider.selectedImage != null) {
//                           if (kIsWeb) {
//                             return Image.network(
//                               provider.selectedImage!.path,
//                               width: 200,
//                               height: 200,
//                               fit: BoxFit.cover,
//                             );
//                           } else {
//                             return Image.file(
//                               File(provider.selectedImage!.path),
//                               width: 200,
//                               height: 200,
//                               fit: BoxFit.cover,
//                             );
//                           }
//                         } else if (widget.image != null) {
//                           return Image.network(
//                             widget.image!,
//                             width: 200,
//                             height: 200,
//                             fit: BoxFit.cover,
//                           );
//                         } else {
//                           return const Icon(Icons.add_a_photo);
//                         }
//                       },
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 10),
//               _buildTextField(
//                 controller: productNameController,
//                 label: getName,
//               ),
//               _buildTextField(
//                 controller: sellerNameController,
//                 label: getUserName,
//               ),
//               _buildTextField(
//                 controller: productQualityController,
//                 label: getQuality,
//               ),
//               const SizedBox(height: 10),
//               _buildTextField(
//                 controller: productWarrantyController,
//                 label: getWarranty,
//               ),
//               _buildTextField(
//                 controller: productTypeController,
//                 label: 'Write type of your product eg : car , pc , food',
//               ),
//               _buildTextField(
//                 controller: productPriceController,
//                 label: getPrice,
//               ),
//               const SizedBox(height: 25),
//               ElevatedButton(
//                 onPressed: () async {
//                   final productName = productNameController.text.trim();
//                   final sellerName = sellerNameController.text.trim();
//                   final productQuality = productQualityController.text.trim();
//                   final productWarranty = productWarrantyController.text.trim();
//                   final productPrice = productPriceController.text.trim();
//                   final productType = productTypeController.text.trim();

//                   // Validate inputs
//                   if (productName.isEmpty ||
//                       sellerName.isEmpty ||
//                       productQuality.isEmpty ||
//                       productWarranty.isEmpty ||
//                       productPrice.isEmpty ||
//                       productType.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Please fill in all fields'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                     return;
//                   }

//                   if (getEdit) {
//                     bool check = await provider.edit_post(
//                       widget.seller_id!,
//                       productName,
//                       sellerName,
//                       productQuality,
//                       productWarranty,
//                       productPrice,
//                       productType,
//                     );

//                     if (check) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Your Advertisement successfully edited'),
//                           backgroundColor: Colors.green,
//                         ),
//                       );
//                       Navigator.of(context).pushAndRemoveUntil(
//                         MaterialPageRoute(
//                           builder: (ctx) => specific_seller_ads(
//                             email: widget.email,
//                             password: widget.password,
//                           ),
//                         ),
//                         (route) => false,
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Your Advertisement could not be edited'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     }
//                   } else {
//                     final imageUrl = provider.imageUrl ?? '';
//                     bool check = await provider.add_ads_posts(
//                       widget.seller_id ?? '',
//                       productName,
//                       sellerName,
//                       productQuality,
//                       productWarranty,
//                       productPrice,
//                       productType,
//                       imageUrl,
//                     );

//                     if (check) {
//                       print('checkkkkkkk');
//                       print(widget.email);
//                       print(widget.password);
//                       print('checkkkkkkk');
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Your Advertisement successfully Added'),
//                           backgroundColor: Colors.green,
//                         ),
//                       );
//                       Navigator.of(context).pushAndRemoveUntil(
//                         MaterialPageRoute(
//                           builder: (ctx) => specific_seller_ads(
//                             email: widget.email,
//                             password: widget.password,
//                             seller_id: widget.seller_id,
//                           ),
//                         ),
//                         (route) => false,
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Your Advertisement could not be Added'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     }
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.yellow,
//                 ),
//                 child: const Text(
//                   'Submit',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//   }) {
//     return SizedBox(
//       width: 350,
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//           fillColor: Colors.white,
//           filled: true,
//         ),
//         keyboardType: TextInputType.text,
//       ),
//     );
//   }
// }
