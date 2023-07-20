import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:test_app/my_page.dart';
/*The page is a screen of a mobile app that allows users to add a receipt
by either taking a photo with the camera or selecting an image from the gallery.

The user can save the recognized text from the image in the form of
food, price, and amount arrays by tapping the 'Save' button.

These arrays will be passed on to the next screen for further processing.

The recognized text is displayed on the screen for the user
to verify and check if any corrections are needed before saving.*/
class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  List<String> food = [];
  List<double> price = [];
  List<int> amount = [];
  File? _image;


  Future<void> _getImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      final croppedImage = await _cropImage(File(image.path));
      setState(() {
        _image = croppedImage;
      });
      await _recognizeText();
    }
  }

  Future<void> _getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final croppedImage = await _cropImage(File(image.path));
      setState(() {
        _image = croppedImage;
      });
      await _recognizeText();
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    final croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressQuality: 100,
        maxHeight: 1000,
        maxWidth: 1000,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.lightBlue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),]
    );
    if(croppedImage!=null){
      return File(croppedImage.path);
    }
    return null;
  }

  Future<void> _recognizeText() async {
    if (_image != null) {
      food = [];
      price = [];
      amount = [];
      final text = await FlutterTesseractOcr.extractText(_image!.path,language: 'tur');
      // Split the recognized text into lines
      final lines = text.split('\n');
      for (var line in lines) {
        // Split the line into words
        final words = line.split(' ');
        String currentFood = '';
        double currentPrice = 0;
        int currentAmount = 0;
        for (var word in words) {
          // Check if the word starts with a currency symbol and add it to the currentPrice
          if (word.startsWith('\$') || word.startsWith('€') || word.startsWith('₺')) {
            final priceString = word.replaceAll(',', '.').substring(1);
            currentPrice = double.tryParse(priceString) ?? 0;
          }
          // Check if the word is a number and add it to the currentAmount
          else if (double.tryParse(word.replaceAll(',', '.')) != null) {
            currentAmount = double.parse(word.replaceAll(',', '.')).toInt();
          }
          // Otherwise, add the word to the currentFood
          else {
            currentFood += '$word ';
          }
        }
        // Remove any trailing spaces from the food string
        currentFood = currentFood.trim();

        // Add the food, price, and amount to their respective lists if they are not empty
        if (currentFood.isNotEmpty && currentPrice != 0 && currentAmount != 0) {
          food.add(currentFood);
          price.add(currentPrice);
          amount.add(currentAmount);
        }
      }
      // Print the arrays for testing
      print('Food: $food');
      print('Price: $price');
      print('Amount: $amount');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.black12,
        title: const Text('Add Receipt'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(),
        ),
      ),
      backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null
                  ? Text('No image selected.')
                  : Image.file(
                _image!,
                height: 200.0,
                width: 200.0,
              ),
              const SizedBox(
                height: 25.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _getImageFromCamera,
                      child: Text('Camera'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _getImageFromGallery,
                      child: Text('Gallery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyPage(food : food, price : price , amount : amount),
                            ),
                          );
                        },
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'Recognized text:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              if (food.isNotEmpty)
                SingleChildScrollView(
                  child: ListView.builder(
                    itemCount: food.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(food[index]),
                        subtitle: Text('Price: ${price[index]}, Amount: ${amount[index]}'),
                      );
                    },
                  ),
                )
              else
                Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}