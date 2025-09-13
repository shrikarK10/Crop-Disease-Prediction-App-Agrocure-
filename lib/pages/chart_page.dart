import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'common_widgets/custom_nav_bar.dart';
import 'common_widgets/logout_button.dart';
import 'api_service.dart';
import 'prediction_state.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  int _selectedIndex = 1;
  bool showPrediction = false;

  @override
  void initState() {
    super.initState();
    // Load saved prediction data on init
    if (PredictionState.hasPrediction &&
        PredictionState.barData.isNotEmpty &&
        PredictionState.labels.isNotEmpty) {
      showPrediction = true;
    }
  }

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

  void getPrediction() async {
    try {
      final predictions = await ApiService.fetchPrediction();
      setState(() {
        showPrediction = true;
        PredictionState.barData = predictions
            .map((e) => (e['probability'] as num).toDouble())
            .toList();
        PredictionState.labels =
            predictions.map((e) => e['disease'] as String).toList();

        // Update current prediction string with max probability disease
        if (PredictionState.barData.isNotEmpty &&
            PredictionState.labels.isNotEmpty) {
          final maxIndex = PredictionState.barData.indexWhere(
                  (p) => p == PredictionState.barData.reduce((a, b) => a > b ? a : b));
          PredictionState.hasPrediction = true;
          PredictionState.currentPrediction = PredictionState.labels[maxIndex];
        }
      });
    } catch (e) {
      setState(() {
        showPrediction = false;
        PredictionState.hasPrediction = false;
        PredictionState.currentPrediction = "";
        PredictionState.barData.clear();
        PredictionState.labels.clear();
      });
    }
  }

  BarChartGroupData _buildBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 20,
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final barData = PredictionState.barData;
    final labels = PredictionState.labels;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
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
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!showPrediction)
                          Image.asset(
                            'assets/chartimg.png',
                            width: 400,
                            height: 400,
                          ),

                        const SizedBox(height: 150),

                        if (showPrediction) ...[
                          const Text(
                            "PREDICTED DISEASES PROBABILITY",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          // Bar Chart
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              height: 250,
                              width: 400,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: 1.0,
                                  barGroups: List.generate(
                                    barData.length,
                                        (i) => _buildBar(i, barData[i]),
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, _) => Text(
                                          value.toStringAsFixed(1),
                                          style:
                                          const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, _) =>
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                labels[value.toInt()],
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            ),
                                      ),
                                    ),
                                    topTitles:
                                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles:
                                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: const Border(
                                      left: BorderSide(
                                          color: Colors.black, width: 1),
                                      bottom: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                  ),
                                  gridData: FlGridData(show: false),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 50),

                          // Pie Chart
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: List.generate(barData.length, (i) {
                                  return PieChartSectionData(
                                    value: barData[i],
                                    color: Colors
                                        .primaries[i % Colors.primaries.length],
                                    title: "${(barData[i] * 100).round()}%",
                                    titleStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }),
                                centerSpaceRadius: 30,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Pie Chart Legend
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            runSpacing: 10,
                            children: List.generate(barData.length, (i) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 14,
                                    height: 14,
                                    color: Colors
                                        .primaries[i % Colors.primaries.length],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(labels[i]),
                                ],
                              );
                            }),
                          ),
                        ],

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: getPrediction,
                          child: Text(showPrediction ? "Predict Again" : "Predict"),
                        ),
                      ],
                    ),
                  ),
                ),
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
}
