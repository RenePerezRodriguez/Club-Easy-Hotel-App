import 'package:club_easy_hotel/data/departments_data.dart';
import 'package:club_easy_hotel/models/hotel.dart';
import 'package:club_easy_hotel/models/hotel_list_view_model.dart';
import 'package:club_easy_hotel/widgets/hotel_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HotelListPage extends StatefulWidget {
  const HotelListPage({super.key});

  @override
  HotelListPageState createState() => HotelListPageState();
}

class HotelListPageState extends State<HotelListPage> {
  final HotelListViewModel _viewModel = HotelListViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.fetchHotels();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  void _onDepartmentChanged(String? newValue) {
    if (newValue != null && newValue != _viewModel.selectedDepartment) {
      _viewModel.onDepartmentChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departamento'),
        actions: <Widget>[
          DropdownButton<String>(
            value: _viewModel.selectedDepartment,
            onChanged: _onDepartmentChanged,
            items: departmentsData.map<DropdownMenuItem<String>>((Map<String, String> department) {
              return DropdownMenuItem<String>(
                value: department['name'],
                child: Text(department['name']!),
              );
            }).toList(),
          ),
        ],
      ),
      body: FutureBuilder<List<Hotel>>(
        future: _viewModel.futureHotels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error al cargar los hoteles.', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _viewModel.fetchHotels();
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay hoteles disponibles en este departamento.', style: TextStyle(fontSize: 18)),
            );
          } else if (snapshot.hasData) {
            return AlignedGridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 560 ? 2 : 1,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return HotelCard(hotel: snapshot.data![index]);
              },
            );
          } else {
            return const Center(child: Text('No hay datos disponibles.'));
          }
        },
      ),
    );
  }
}
