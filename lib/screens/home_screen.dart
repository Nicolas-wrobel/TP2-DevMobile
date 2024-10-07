import 'package:flutter/material.dart';
import 'package:LostObject/screens/object_detail_screen.dart';
import 'package:intl/intl.dart'; // Import du package intl
import '../models/found_object.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final ApiService apiService = ApiService();
  final LocalStorageService localStorageService = LocalStorageService();
  List<FoundObject> foundObjects = [];
  DateTime? lastConsultationDate;

  String? selectedStation;
  String? selectedCategory;
  String? restitutionFilter;
  DateTime? selectedDate;
  bool isDateSearchActive = false;
  DateTime? searchDate;
  List<String> categories = [];
  List<String> gares = [];
  bool showConsulted = false;
  bool isLoadingMore = false;
  bool isLoading = true;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoadingMore) {
        if (isDateSearchActive && searchDate != null) {
          _loadMoreObjectsByDate(searchDate!);
        } else {
          _loadMoreObjects();
        }
      }
    });

    _loadObjects();
    _loadLastConsultation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      localStorageService.saveLastConsultationDate();
    }
  }

  Future<void> _loadObjects() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<FoundObject> initialObjects = await apiService.fetchFoundObjects();
      setState(() {
        foundObjects = initialObjects;
        isLoading = false;
      });

      extractCategories(initialObjects);
      extractGares(initialObjects);
    } catch (e) {
      print('Erreur lors du chargement des objets: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreObjects() async {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });

      try {
        final previousScrollHeight = _scrollController.position.maxScrollExtent;
        List<FoundObject> newObjects = await apiService.fetchMoreFoundObjects();

        setState(() {
          foundObjects.addAll(newObjects);
          isLoadingMore = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(previousScrollHeight);
        });
      } catch (e) {
        print('Erreur lors du chargement de plus d\'objets: $e');
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _searchObjectsByDate(DateTime date) async {
    try {
      setState(() {
        isLoading = true;
        isDateSearchActive = true;
      });

      List<FoundObject> objectsByDate =
          await apiService.fetchObjectsByDate(date);

      setState(() {
        foundObjects = objectsByDate;
        searchDate = date;
        isLoading = false;
      });
    } catch (e) {
      print('Erreur lors de la recherche des objets par date: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreObjectsByDate(DateTime date) async {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });

      try {
        final previousScrollHeight = _scrollController.position.maxScrollExtent;
        List<FoundObject> newObjects =
            await apiService.fetchMoreObjectsByDate(date);

        setState(() {
          foundObjects.addAll(newObjects);
          isLoadingMore = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(previousScrollHeight);
        });
      } catch (e) {
        print(
            'Erreur lors du chargement de plus d\'objets pour la date sélectionnée: $e');
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  void _loadLastConsultation() async {
    try {
      DateTime? lastDate = await localStorageService.getLastConsultationDate();
      setState(() {
        lastConsultationDate = lastDate;
      });
    } catch (e) {
      print('Erreur lors du chargement de la dernière consultation: $e');
    }
  }

  void extractCategories(List<FoundObject> objects) {
    final Set<String> categorySet = {};
    for (var object in objects) {
      categorySet.add(object.category);
    }
    setState(() {
      categories = categorySet.toList();
    });
  }

  void extractGares(List<FoundObject> objects) {
    final Set<String> gareSet = {};
    for (var object in objects) {
      gareSet.add(object.station);
    }
    setState(() {
      gares = gareSet.toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        searchDate = picked;
        isDateSearchActive = true;
      });
      await _searchObjectsByDate(picked);
    }
  }

  List<FoundObject> filterObjects(List<FoundObject> objects) {
    return objects.where((object) {
      final matchesStation =
          selectedStation == null || object.station == selectedStation;
      final matchesCategory =
          selectedCategory == null || object.category == selectedCategory;
      final matchesDate = searchDate == null ||
          object.date
              .toLocal()
              .toIso8601String()
              .startsWith(DateFormat('yyyy-MM-dd').format(searchDate!));
      final matchesRestitution = restitutionFilter == null ||
          restitutionFilter == 'all' ||
          (restitutionFilter == 'not_returned' &&
              object.restitutionDate == null) ||
          (restitutionFilter == 'returned' && object.restitutionDate != null);

      return matchesStation &&
          matchesCategory &&
          matchesDate &&
          matchesRestitution;
    }).toList();
  }

  String formatLastConsultation(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Objets Trouvés'),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final filteredObjects =
        isDateSearchActive ? foundObjects : filterObjects(foundObjects);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Objets Trouvés'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Filtres pour gare et catégorie
            Row(
              children: [
                Flexible(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Gare',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    ),
                    value: selectedStation,
                    onChanged: (newValue) {
                      setState(() {
                        selectedStation = newValue;
                      });
                    },
                    items: gares
                        .map((gare) => DropdownMenuItem(
                              value: gare,
                              child: Text(
                                gare,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Catégorie',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    ),
                    value: selectedCategory,
                    onChanged: (newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                    items: categories
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                category,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Filtre pour restitution et date
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Restitution',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    ),
                    value: restitutionFilter,
                    onChanged: (newValue) {
                      setState(() {
                        restitutionFilter = newValue;
                      });
                    },
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('Tous')),
                      DropdownMenuItem(
                          value: 'not_returned', child: Text('Non restitué')),
                      DropdownMenuItem(
                          value: 'returned', child: Text('Restitué')),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    ),
                    onTap: () => _selectDate(context),
                    controller: TextEditingController(
                      text: searchDate != null
                          ? DateFormat('dd/MM/yyyy').format(searchDate!)
                          : '',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Switch avec la dernière consultation affichée
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SwitchListTile(
                    title:
                        const Text('Afficher les derniers objets consultés.'),
                    value: showConsulted,
                    onChanged: (value) {
                      setState(() {
                        showConsulted = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Text(lastConsultationDate != null
                ? 'Dernière consultation : ${formatLastConsultation(lastConsultationDate!)}'
                : 'Dernière consultation : aucune.'),
            const SizedBox(height: 10),
            // Bouton de réinitialisation des filtres
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedStation = null;
                      selectedCategory = null;
                      restitutionFilter = null;
                      selectedDate = null;
                      searchDate = null;
                      showConsulted = false;
                      isDateSearchActive = false;
                      _loadObjects();
                    });
                  },
                  child: const Text('Réinitialiser les filtres'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Liste des objets trouvés filtrés
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: filteredObjects.length + (isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == filteredObjects.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(filteredObjects[index].description),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gare : ${filteredObjects[index].station}'),
                          Text(
                              'Date : ${filteredObjects[index].date.toLocal().toIso8601String().substring(0, 10)}'),
                          Text(
                              'Restitué : ${filteredObjects[index].restitutionDate != null ? "Oui" : "Non"}'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ObjectDetailScreen(
                                foundObject: filteredObjects[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
