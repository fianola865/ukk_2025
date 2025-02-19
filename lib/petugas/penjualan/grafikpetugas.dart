import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class GrafikAdminPetugas extends StatefulWidget {
  const GrafikAdminPetugas({super.key});

  @override
  State<GrafikAdminPetugas> createState() => _GrafikAdminPetugasState();
}

class _GrafikAdminPetugasState extends State<GrafikAdminPetugas> {
  List<Map<String, dynamic>> penjualan = [];
  bool isLoading = true;
  Map<String, double> salesData = {}; 

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
  }

  Future<void> fetchPenjualan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client
          .from('penjualan')
          .select('TanggalPenjualan, TotalHarga');

      if (response.isNotEmpty) {
        setState(() {
          penjualan = List<Map<String, dynamic>>.from(response);
          _prepareSalesData();
        });
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _prepareSalesData() {
    salesData.clear();

    for (var pjl in penjualan) {
      String? rawDate = pjl['TanggalPenjualan'];
      double? totalHarga = (pjl['TotalHarga'] as num?)?.toDouble();

      if (rawDate != null && totalHarga != null) {
        try {
          DateTime parsedDate = DateTime.parse(rawDate);
          String finalDate =
              "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";

          salesData.update(finalDate, (value) => value + totalHarga,
              ifAbsent: () => totalHarga);
        } catch (e) {
          debugPrint('Error parsing date ($rawDate): $e');
        }
      }
    }
  }

  List<FlSpot> _getSalesChartData() {
    return salesData.entries.toList().asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();
  }

  double get minY {
    if (salesData.isEmpty) return 0;
    double minValue = salesData.values.reduce(min);
    return (minValue ~/ 100000) * 100000 * 0.8; 
  }

  double get maxY {
    if (salesData.isEmpty) return 1000000;
    double maxValue = salesData.values.reduce(max);
    return ((maxValue ~/ 100000) + 1) * 100000 * 1.2; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : salesData.isEmpty
              ? const Center(child: Text("Tidak ada data penjualan"))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 350,
                        child: LineChart(
                          LineChartData(
                            minY: minY,
                            maxY: maxY,
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.shade300,
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 60,
                                interval: 100000,
                                getTitles: (value) {
                                  if (value % 100000 == 0) {
                                    return "Rp ${value ~/ 1000}K"; 
                                  }
                                  return '';
                                },
                                
                              ),
                              bottomTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 50,
                                interval: 1,
                                getTitles: (value) {
                                  int index = value.toInt();
                                  if (index >= 0 &&
                                      index < salesData.keys.length) {
                                    return salesData.keys.elementAt(index);
                                  }
                                  return '';
                                },
                                
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _getSalesChartData(),
                                isCurved: true,
                                colors: [Colors.blue.shade700],
                                barWidth: 3,
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(
                                  show: false, // **Menghapus background bar**
                                ),
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index) {
                                    return FlDotCirclePainter(
                                      radius: 5,
                                      color: Colors.blue,
                                      strokeWidth: 2,
                                      strokeColor: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Riwayat Penjualan dalam ListView
                    Expanded(
                      child: ListView.builder(
                        itemCount: salesData.length,
                        itemBuilder: (context, index) {
                          String date = salesData.keys.elementAt(index);
                          double total = salesData[date]!;
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                ),
                              ),
                              title: Text(
                                date,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                              "Rp ${NumberFormat("#,###", "id_ID").format(total)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            )
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
