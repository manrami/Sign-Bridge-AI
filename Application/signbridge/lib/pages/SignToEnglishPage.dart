// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'my_bottom_nav.dart';
//
// class SignToEnglishPage extends StatefulWidget {
//   const SignToEnglishPage({super.key});
//   @override
//   State<SignToEnglishPage> createState() => _SignToEnglishPageState();
// }
//
// class _SignToEnglishPageState extends State<SignToEnglishPage>
//     with TickerProviderStateMixin {
//   bool isRecording = false;
//   bool permissionGranted = false;
//   bool _isCapturing = false;
//
//   String sentence = "";
//   String currentLetter = "";
//
//   List<CameraDescription> cameras = [];
//   CameraController? _cameraController;
//   Future<void>? _initializeControllerFuture;
//   Timer? _recordTimer;
//   CameraLensDirection currentLens = CameraLensDirection.front;
//   late AnimationController pulseController;
//
//   // Update to your server:
//   // - Real device: http://<YOUR_PC_LAN_IP>:8000/predict-letter/
//   // - Emulator:    http://10.0.2.2:8000/predict-letter/
//   static const String apiUrl = "http://10.107.162.156:8000/predict-letter/";
//
//   @override
//   void initState() {
//     super.initState();
//     pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//       lowerBound: 0.95,
//       upperBound: 1.05,
//     )..repeat(reverse: true);
//
//     _requestPermissionAndSetupCamera();
//   }
//
//   Future<void> _requestPermissionAndSetupCamera() async {
//     final status = await Permission.camera.request();
//     if (status.isGranted) {
//       setState(() => permissionGranted = true);
//       cameras = await availableCameras();
//       await _initializeCamera(currentLens);
//     } else {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Camera permission is required")),
//       );
//     }
//   }
//
//   Future<void> _initializeCamera(CameraLensDirection lensDirection) async {
//     if (cameras.isEmpty) return;
//
//     final camera = cameras.firstWhere(
//           (cam) => cam.lensDirection == lensDirection,
//       orElse: () => cameras.first,
//     );
//
//     await _cameraController?.dispose();
//     _cameraController = CameraController(
//       camera,
//       ResolutionPreset.medium,
//       enableAudio: false,
//       imageFormatGroup: ImageFormatGroup.jpeg, // still photos
//     );
//
//     _initializeControllerFuture = _cameraController!.initialize();
//     await _initializeControllerFuture;
//     if (mounted) setState(() {});
//   }
//
//   void toggleRecording() {
//     if (!isRecording) {
//       setState(() {
//         isRecording = true;
//         sentence = "";
//         currentLetter = "";
//       });
//
//       _recordTimer = Timer.periodic(const Duration(milliseconds: 1500), (Timer _) {
//         if (_cameraController == null ||
//             !_cameraController!.value.isInitialized ||
//             _isCapturing) {
//           return;
//         }
//         _isCapturing = true;
//         _captureAndPredict().then((letter) {
//           if (!mounted) return;
//           if (letter.isNotEmpty) {
//             setState(() {
//               currentLetter = letter;
//               sentence += letter == "Space" ? " " : letter;
//             });
//           }
//         }).whenComplete(() {
//           _isCapturing = false;
//         });
//       });
//     } else {
//       _recordTimer?.cancel();
//       _recordTimer = null;
//       setState(() {
//         isRecording = false;
//         currentLetter = "";
//       });
//     }
//   }
//
//   Future<String> _captureAndPredict() async {
//     try {
//       await _initializeControllerFuture;
//       final picture = await _cameraController!.takePicture(); // JPEG
//
//       final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'file',           // must match FastAPI param name
//           picture.path,
//           contentType: MediaType('image', 'jpeg'),
//           filename: 'frame.jpg',
//         ),
//       );
//
//       final streamed = await request.send().timeout(const Duration(seconds: 10));
//       final respStr = await streamed.stream.bytesToString();
//
//       if (streamed.statusCode == 200) {
//         final data = jsonDecode(respStr);
//         return (data["predicted_letter"] ?? "").toString();
//       } else {
//         // Optionally log: print("API ${streamed.statusCode}: $respStr");
//       }
//     } catch (e) {
//       // Optionally show: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
//     }
//     return "";
//   }
//
//   void switchCamera() async {
//     if (cameras.length < 2) return;
//     // Optional: stop recording while switching to avoid race conditions
//     final wasRecording = isRecording;
//     if (wasRecording) toggleRecording();
//     currentLens = currentLens == CameraLensDirection.front
//         ? CameraLensDirection.back
//         : CameraLensDirection.front;
//     await _initializeCamera(currentLens);
//     if (wasRecording) toggleRecording();
//   }
//
//   void _onNavTapped(int index) {
//     switch (index) {
//       case 0:
//         Navigator.pushReplacementNamed(context, "/home");
//         break;
//       case 1:
//         Navigator.pushReplacementNamed(context, "/text_translation");
//         break;
//       case 2:
//         Navigator.pushReplacementNamed(context, "/eng_to_sign");
//         break;
//       case 3:
//         break;
//     }
//   }
//
//   @override
//   void dispose() {
//     _recordTimer?.cancel();
//     _recordTimer = null;
//     _cameraController?.dispose();
//     pulseController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final previewReady =
//         _cameraController != null && _cameraController!.value.isInitialized;
//
//     return Scaffold(
//       extendBody: true,
//       body: permissionGranted
//           ? Stack(
//         children: [
//           if (previewReady) CameraPreview(_cameraController!),
//           Positioned(
//             top: 50,
//             left: 20,
//             right: 20,
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white70,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 10,
//                     offset: Offset(0, 4),
//                   )
//                 ],
//               ),
//               child: Text(
//                 "Current: $currentLetter\nSentence: $sentence",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 60),
//               child: ScaleTransition(
//                 scale: pulseController,
//                 child: FloatingActionButton(
//                   backgroundColor:
//                   isRecording ? Colors.redAccent : Colors.blue,
//                   onPressed: toggleRecording,
//                   child: Icon(
//                     isRecording ? Icons.stop : Icons.videocam,
//                     size: 36,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           if (cameras.length > 1)
//             Positioned(
//               bottom: 140,
//               right: 20,
//               child: FloatingActionButton(
//                 backgroundColor: Colors.green,
//                 onPressed: switchCamera,
//                 child: const Icon(Icons.cameraswitch),
//               ),
//             ),
//         ],
//       )
//           : Center(
//         child: ElevatedButton(
//           onPressed: _requestPermissionAndSetupCamera,
//           child: const Text("Grant Camera Permission"),
//         ),
//       ),
//       bottomNavigationBar: MyBottomNav(currentIndex: 3, onTap: _onNavTapped),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'my_bottom_nav.dart';

class SignToEnglishPage extends StatefulWidget {
  const SignToEnglishPage({super.key});

  @override
  State<SignToEnglishPage> createState() => _SignToEnglishPageState();
}

class _SignToEnglishPageState extends State<SignToEnglishPage>
    with TickerProviderStateMixin {
  bool isRecording = false;
  bool permissionGranted = false;
  bool _isCapturing = false;

  String sentence = "";
  String currentLetter = "";

  List<CameraDescription> cameras = [];
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  Timer? _recordTimer;
  CameraLensDirection currentLens = CameraLensDirection.front;
  late AnimationController pulseController;

  // ⚡ Replace with your local IPv4 (check with ipconfig)
  static const String apiUrl = "http://192.168.101.216:8000/predict-letter/";

  @override
  void initState() {
    super.initState();
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);

    _requestPermissionAndSetupCamera();
  }

  /// Ask for permission and initialize the first camera
  Future<void> _requestPermissionAndSetupCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() => permissionGranted = true);
      cameras = await availableCameras();
      await _initializeCamera(currentLens);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera permission is required")),
      );
    }
  }

  /// Init camera with given lens
  Future<void> _initializeCamera(CameraLensDirection lensDirection) async {
    if (cameras.isEmpty) return;

    final camera = cameras.firstWhere(
          (cam) => cam.lensDirection == lensDirection,
      orElse: () => cameras.first,
    );

    await _cameraController?.dispose();
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _initializeControllerFuture = _cameraController!.initialize();
    await _initializeControllerFuture;
    if (mounted) setState(() {});
  }

  /// Start or stop recording (take frames repeatedly)
  void toggleRecording() {
    if (!isRecording) {
      setState(() {
        isRecording = true;
        sentence = "";
        currentLetter = "";
      });

      _recordTimer = Timer.periodic(const Duration(milliseconds: 1500), (Timer _) {
        if (_cameraController == null ||
            !_cameraController!.value.isInitialized ||
            _isCapturing) {
          return;
        }
        _isCapturing = true;
        _captureAndPredict().then((letter) {
          if (!mounted) return;
          if (letter.isNotEmpty) {
            setState(() {
              currentLetter = letter;
              sentence += letter == "Space" ? " " : letter;
            });
          }
        }).whenComplete(() {
          _isCapturing = false;
        });
      });
    } else {
      _recordTimer?.cancel();
      _recordTimer = null;
      setState(() {
        isRecording = false;
        currentLetter = "";
      });
    }
  }

  /// Capture frame & send to backend FastAPI
  Future<String> _captureAndPredict() async {
    try {
      await _initializeControllerFuture;
      final picture = await _cameraController!.takePicture();

      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          picture.path,
          contentType: MediaType('image', 'jpeg'),
          filename: 'frame.jpg',
        ),
      );

      final streamed = await request.send().timeout(const Duration(seconds: 10));
      final respStr = await streamed.stream.bytesToString();

      if (streamed.statusCode == 200) {
        final data = jsonDecode(respStr);
        return (data["predicted_letter"] ?? "").toString();
      } else {
        debugPrint("API error ${streamed.statusCode}: $respStr");
      }
    } catch (e) {
      debugPrint("Upload failed: $e");
    }
    return "";
  }

  /// Switch between front/back cameras
  void switchCamera() async {
    if (cameras.length < 2) return;
    final wasRecording = isRecording;
    if (wasRecording) toggleRecording();
    currentLens = currentLens == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;
    await _initializeCamera(currentLens);
    if (wasRecording) toggleRecording();
  }

  void _onNavTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, "/home");
        break;
      case 1:
        Navigator.pushReplacementNamed(context, "/text_translation");
        break;
      case 2:
        Navigator.pushReplacementNamed(context, "/eng_to_sign");
        break;
      case 3:
        break;
    }
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    _recordTimer = null;
    _cameraController?.dispose();
    pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previewReady =
        _cameraController != null && _cameraController!.value.isInitialized;

    return Scaffold(
      extendBody: true,
      body: permissionGranted
          ? Stack(
        children: [
          if (previewReady) CameraPreview(_cameraController!),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Text(
                "Current: $currentLetter\nSentence: $sentence",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: ScaleTransition(
                scale: pulseController,
                child: FloatingActionButton(
                  backgroundColor:
                  isRecording ? Colors.redAccent : Colors.blue,
                  onPressed: toggleRecording,
                  child: Icon(
                    isRecording ? Icons.stop : Icons.videocam,
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
          if (cameras.length > 1)
            Positioned(
              bottom: 140,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: switchCamera,
                child: const Icon(Icons.cameraswitch),
              ),
            ),
        ],
      )
          : Center(
        child: ElevatedButton(
          onPressed: _requestPermissionAndSetupCamera,
          child: const Text("Grant Camera Permission"),
        ),
      ),
      bottomNavigationBar: MyBottomNav(currentIndex: 3, onTap: _onNavTapped),
    );
  }
}

