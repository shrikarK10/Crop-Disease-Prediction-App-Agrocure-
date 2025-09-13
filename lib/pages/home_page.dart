import 'package:flutter/material.dart';
import 'common_widgets/custom_nav_bar.dart';
import 'common_widgets/logout_button.dart';
import 'api_service.dart';
import 'prediction_state.dart';
import 'disease_precautions.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onNavBarTap(int index) {
    if (index != _selectedIndex) {
      String route;
      switch (index) {
        case 0:
          route = '/home';
          break;
        case 1:
          route = '/chart';
          break;
        case 2:
          route = '/weather';
          break;
        case 3:
          route = '/account';
          break;
        default:
          route = '/home';
      }
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: _selectedIndex == 0
                    ? _buildDashboard()
                    : Center(child: Text("Page ${_selectedIndex + 1}")),
              ),
              CustomNavBar(
                selectedIndex: _selectedIndex,
                onTap: _onNavBarTap,
              ),
            ],
          ),
          const LogoutButton(),
        ],
      ),
    );
  }

  Widget _buildYouTubePreview(String url) {
    final Uri uri = Uri.parse(url);

    // Extract video ID from URL
    String? videoId;
    if (uri.host.contains('youtu.be')) {
      videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
    } else if (uri.host.contains('youtube.com')) {
      videoId = uri.queryParameters['v'];
    }

    // Fallback if video ID can't be extracted
    if (videoId == null) {
      return GestureDetector(
        onTap: () async {
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Text(
          url,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.lightBlueAccent,
            decoration: TextDecoration.underline,
          ),
        ),
      );
    }

    // Construct thumbnail URL
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

    // Display the thumbnail and tap to open the video
    return GestureDetector(
      onTap: () => _launchVideo(url),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              thumbnailUrl,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  /// Launches the YouTube video in the external app/browser
  Future<void> _launchVideo(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 190),
          _buildPredictedDiseaseCard(),
          const SizedBox(height: 40),
          _buildPrecautionaryMeasuresCard(context),
          const SizedBox(height: 40),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildPredictedDiseaseCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[300]!, Colors.blue[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Predicted Disease',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          if (!PredictionState.hasPrediction) ...[
            const Text(
              'To get disease prediction:',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Go to Stats page\n2. Click "Predict Disease" button\n3. View the prediction results',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ] else ...[
            Text(
              'Most Probable Disease: ${PredictionState.currentPrediction}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrecautionaryMeasuresCard(BuildContext context) {
    if (!PredictionState.hasPrediction) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[300]!, Colors.green[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Precautionary Measures',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'To get disease prediction:',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            SizedBox(height: 8),
            Text(
              '1. Go to Stats page\n2. Click "Predict Disease" button\n3. View the prediction results',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      );
    } else {
      final String prediction = PredictionState.currentPrediction;
      final List<String> precautions =
          diseasePrecautions[prediction] ?? ['No precautions available.'];

      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[300]!, Colors.green[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Precautionary Measures',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Most Probable Disease: ${prediction.replaceAll('_', ' ')}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ...precautions.map((step) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Expanded(
                    child: Text(
                      step,
                      style:
                      const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      );
    }
  }

  Widget _buildInfoCard() {
    if (!PredictionState.hasPrediction) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[300]!, Colors.purple[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'For more detailed information about disease prevention and treatment, please consult with a healthcare professional.',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      );
    } else {
      final String prediction = PredictionState.currentPrediction;
      final List<String> videoLinks =
          diseasePrecautionVideos[prediction] ?? ['No videos available.'];

      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[300]!, Colors.purple[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Precautionary Videos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 12),
            ...videoLinks.map(
                  (link) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildYouTubePreview(link),
              ),
            ),
          ],
        ),
      );
    }
  }
}
