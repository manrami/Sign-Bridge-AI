// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'my_bottom_nav.dart';
//
//
// class EngToSignPage extends StatefulWidget {
//   const EngToSignPage({super.key});
//
//   @override
//   State<EngToSignPage> createState() => _EngToSignPageState();
// }
//
// class _EngToSignPageState extends State<EngToSignPage>
//     with TickerProviderStateMixin {
//   bool isListening = false;
//
//   late AnimationController waveController;
//   late AnimationController stopButtonController;
//
//   int _currentIndex = 2;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Wave animation controller
//     waveController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();
//
//     // Stop button pulse
//     stopButtonController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//       lowerBound: 0.95,
//       upperBound: 1.1,
//     )..repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     waveController.dispose();
//     stopButtonController.dispose();
//     super.dispose();
//   }
//
//   void _onNavTapped(int index) {
//     setState(() => _currentIndex = index);
//     switch (index) {
//       case 0:
//         Navigator.pushReplacementNamed(context, '/home');
//         break;
//       case 1:
//         Navigator.pushReplacementNamed(context, '/text_translation');
//         break;
//       case 2:
//         break;
//       case 3:
//         Navigator.pushReplacementNamed(context, '/sign_to_english');
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final isWideScreen = width > 600;
//
//     return Scaffold(
//       extendBody: true,
//       body: Stack(
//         children: [
//           // Background gradient
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFD6EAFF), Color(0xFFFDEBDC)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   child: Text(
//                     "SignBridge",
//                     style: TextStyle(
//                       fontSize: isWideScreen ? 44 : 36,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF2C3E50),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     child: Center(
//                       child: ConstrainedBox(
//                         constraints: BoxConstraints(
//                             maxWidth: isWideScreen ? 600 : double.infinity),
//                         child: isListening
//                             ? _buildListeningView(isWideScreen)
//                             : _buildDefaultView(isWideScreen),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar:
//       MyBottomNav(currentIndex: _currentIndex, onTap: _onNavTapped),
//     );
//   }
//
//   Widget _buildDefaultView(bool isWideScreen) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Input box
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.3),
//             borderRadius: BorderRadius.circular(50),
//             border: Border.all(color: Colors.white.withOpacity(0.4)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.blueAccent.withOpacity(0.2),
//                 blurRadius: 12,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: TextField(
//             style: const TextStyle(color: Color(0xFF1F2937), fontSize: 18),
//             decoration: InputDecoration(
//               hintText: "Type or tap the mic to speak...",
//               hintStyle: const TextStyle(color: Color(0xFF6B7280)),
//               filled: true,
//               fillColor: Colors.transparent,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(50),
//                 borderSide: BorderSide.none,
//               ),
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.mic, color: Color(0xFF3B82F6), size: 28),
//                 onPressed: () => setState(() => isListening = true),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 30),
//         SizedBox(
//           width: isWideScreen ? 300 : double.infinity,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF3B82F6),
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
//               elevation: 10,
//               shadowColor: const Color(0xFF3B82F6).withOpacity(0.4),
//             ),
//             onPressed: () => Navigator.pushNamed(context, '/translation_result'),
//             child: const Text(
//               "Translate",
//               style: TextStyle(
//                   fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildListeningView(bool isWideScreen) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text(
//           "Listening...",
//           style: TextStyle(
//             color: Color(0xFF2C3E50),
//             fontSize: 22,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 40),
//
//         // Live Moving Waves
//         SizedBox(
//           height: 140,
//           width: double.infinity,
//           child: AnimatedBuilder(
//             animation: waveController,
//             builder: (context, child) {
//               return CustomPaint(
//                 painter: LiveWavePainter(waveController.value),
//                 size: const Size(double.infinity, 140),
//               );
//             },
//           ),
//         ),
//         const SizedBox(height: 50),
//
//         // Animated Stop Button
//         ScaleTransition(
//           scale: stopButtonController,
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.purple.withOpacity(0.4),
//                   blurRadius: 20,
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 padding: const EdgeInsets.all(50),
//                 shape: const CircleBorder(),
//                 elevation: 0,
//               ),
//               onPressed: () => setState(() => isListening = false),
//               child: const Text(
//                 "Stop\nTranslate",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   shadows: [
//                     Shadow(
//                         color: Colors.black26,
//                         offset: Offset(1, 2),
//                         blurRadius: 3)
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // Live Wave Painter (vertical moving waves)
// class LiveWavePainter extends CustomPainter {
//   final double progress;
//   LiveWavePainter(this.progress);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..strokeWidth = 3
//       ..style = PaintingStyle.stroke
//       ..shader = const LinearGradient(
//         colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFFEC4899)],
//       ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
//       ..strokeCap = StrokeCap.round;
//
//     final path = Path();
//     final path2 = Path();
//
//     for (double x = 0; x <= size.width; x++) {
//       double y1 = size.height / 2 +
//           20 * math.sin((x / size.width * 3 * math.pi) + progress * 2 * math.pi) +
//           10 * math.sin(progress * 2 * math.pi * 3 + x / 50); // vertical shift
//       double y2 = size.height / 2 +
//           20 * math.cos((x / size.width * 3 * math.pi) + progress * 2 * math.pi) +
//           10 * math.cos(progress * 2 * math.pi * 3 + x / 50); // vertical shift
//
//       if (x == 0) {
//         path.moveTo(x, y1);
//         path2.moveTo(x, y2);
//       } else {
//         path.lineTo(x, y1);
//         path2.lineTo(x, y2);
//       }
//     }
//
//     canvas.drawPath(path, paint);
//     canvas.drawPath(path2, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant LiveWavePainter oldDelegate) => true;
// }

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'my_bottom_nav.dart';

class EngToSignPage extends StatefulWidget {
  const EngToSignPage({super.key});

  @override
  State<EngToSignPage> createState() => _EngToSignPageState();
}

class _EngToSignPageState extends State<EngToSignPage>
    with TickerProviderStateMixin {
  bool isListening = false;
  final TextEditingController _textController = TextEditingController();

  String? translatedText;
  String? gifUrl;
  bool isLoading = false;

  late AnimationController waveController;
  late AnimationController stopButtonController;

  int _currentIndex = 2;

  // FastAPI server IP + port
  final String serverIp = "192.168.101.216";
  final int serverPort = 8000;

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _filePath;

  @override
  void initState() {
    super.initState();

    waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    stopButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0.95,
      upperBound: 1.1,
    )..repeat(reverse: true);

    initRecorder();
  }

  Future<void> initRecorder() async {
    // Request permission first
    if (await Permission.microphone.request().isGranted) {
      await _recorder.openRecorder();
      _recorder.setSubscriptionDuration(const Duration(milliseconds: 50));
    } else {
      Fluttertoast.showToast(msg: "Microphone permission denied");
    }
  }

  @override
  void dispose() {
    waveController.dispose();
    stopButtonController.dispose();
    _recorder.closeRecorder();
    super.dispose();
  }

  void _onNavTapped(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/text_translation');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/sign_to_english');
        break;
    }
  }

  // Start recording audio in .wav format
  Future<void> startRecording() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      Fluttertoast.showToast(msg: "Microphone permission denied");
      return;
    }

    try {
      Directory tempDir = await getTemporaryDirectory();
      _filePath =
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.wav';
      await _recorder.startRecorder(
        toFile: _filePath,
        codec: Codec.pcm16WAV,
      );
      setState(() => isListening = true);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error starting recording: $e");
    }
  }

  // Stop recording and send to server
  Future<void> stopRecordingAndTranslate() async {
    if (!_recorder.isRecording) return;
    try {
      await _recorder.stopRecorder();
      setState(() => isListening = false);
      if (_filePath != null) {
        await sendVoiceToServer(_filePath!);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error stopping recording: $e");
    }
  }

  // Send recorded audio to FastAPI backend
  Future<void> sendVoiceToServer(String path) async {
    setState(() {
      isLoading = true;
      gifUrl = null;
      translatedText = null;
    });

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse("http://$serverIp:$serverPort/voice-to-isl/"));
      request.files.add(await http.MultipartFile.fromPath('file', path));
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("API Response: $data");

        if ((data["status"] == "gif" || data["status"] == "letters") &&
            data["path"] != null) {
          setState(() {
            translatedText = data["recognized_text"] ?? "";
            gifUrl = "http://$serverIp:$serverPort/${data["path"]}";
          });
        } else {
          Fluttertoast.showToast(msg: data["message"] ?? "Translation failed");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Translation failed (${response.statusCode})");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Optional: keep your text input translation too
  Future<void> translateText() async {
    if (_textController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter some text");
      return;
    }

    setState(() {
      isLoading = true;
      translatedText = null;
      gifUrl = null;
    });

    try {
      final url = Uri.parse("http://$serverIp:$serverPort/text-to-isl/");
      final response = await http.post(
        url,
        body: {'text': _textController.text},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("API Response: $data");

        if ((data["status"] == "gif" || data["status"] == "letters") &&
            data["path"] != null) {
          setState(() {
            translatedText = _textController.text;
            gifUrl = "http://$serverIp:$serverPort/${data["path"]}";
          });
        } else {
          Fluttertoast.showToast(msg: data["message"] ?? "Translation error");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Translation failed (${response.statusCode})");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWideScreen = width > 600;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD6EAFF), Color(0xFFFDEBDC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "SignBridge",
                    style: TextStyle(
                      fontSize: isWideScreen ? 44 : 36,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: isWideScreen ? 600 : double.infinity),
                        child: isListening
                            ? _buildListeningView(isWideScreen)
                            : _buildDefaultView(isWideScreen),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:
      MyBottomNav(currentIndex: _currentIndex, onTap: _onNavTapped),
    );
  }

  Widget _buildDefaultView(bool isWideScreen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: TextField(
            controller: _textController,
            style: const TextStyle(color: Color(0xFF1F2937), fontSize: 18),
            decoration: InputDecoration(
              hintText: "Type or tap the mic to speak...",
              hintStyle: const TextStyle(color: Color(0xFF6B7280)),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon:
                const Icon(Icons.mic, color: Color(0xFF3B82F6), size: 28),
                onPressed: startRecording,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: isWideScreen ? 300 : double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              elevation: 10,
              shadowColor: const Color(0xFF3B82F6).withOpacity(0.4),
            ),
            onPressed: isLoading ? null : translateText,
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
              "Translate",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (translatedText != null) ...[
          Text(
            "Detected English: $translatedText",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
        ],
        if (gifUrl != null)
          Image.network(
            gifUrl!,
            height: 220,
            errorBuilder: (c, e, s) => const Text("⚠ Could not load GIF"),
          ),
      ],
    );
  }

  Widget _buildListeningView(bool isWideScreen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Listening...",
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          height: 140,
          width: double.infinity,
          child: AnimatedBuilder(
            animation: waveController,
            builder: (context, child) {
              return CustomPaint(
                painter: LiveWavePainter(waveController.value),
                size: const Size(double.infinity, 140),
              );
            },
          ),
        ),
        const SizedBox(height: 50),
        ScaleTransition(
          scale: stopButtonController,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(50),
                shape: const CircleBorder(),
                elevation: 0,
              ),
              onPressed: stopRecordingAndTranslate,
              child: const Text(
                "Stop\nTranslate",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 2),
                        blurRadius: 3)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LiveWavePainter extends CustomPainter {
  final double progress;
  LiveWavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..shader = const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFFEC4899)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final path2 = Path();

    for (double x = 0; x <= size.width; x++) {
      double y1 = size.height / 2 +
          20 * math.sin((x / size.width * 3 * math.pi) + progress * 2 * math.pi) +
          10 * math.sin(progress * 2 * math.pi * 3 + x / 50);
      double y2 = size.height / 2 +
          20 * math.cos((x / size.width * 3 * math.pi) + progress * 2 * math.pi) +
          10 * math.cos(progress * 2 * math.pi * 3 + x / 50);

      if (x == 0) {
        path.moveTo(x, y1);
        path2.moveTo(x, y2);
      } else {
        path.lineTo(x, y1);
        path2.lineTo(x, y2);
      }
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant LiveWavePainter oldDelegate) => true;
}