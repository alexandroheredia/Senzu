import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/models/food_draft.dart';
import 'package:senzu_app/screens/food_tracker/barcode/barcode_scanner_screen.dart';
import 'package:senzu_app/screens/food_tracker/barcode/nutrition_label_capture_screen.dart';
import 'package:senzu_app/services/food_catalog_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/gradient_button.dart';

/// One label + numeric-input row of the add-food form.
class _NutrientField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;

  const _NutrientField({
    required this.label,
    required this.controller,
    required this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: controller,
              validator: validator,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[,.0-9]')),
              ],
              decoration: InputDecoration(
                hintText: hint,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// An optional nutrient that can be revealed via its checkbox.
class _OptionalNutrient {
  final String key;
  final String label;
  final TextEditingController controller;

  const _OptionalNutrient(this.key, this.label, this.controller);
}

class AddFood extends StatefulWidget {
  final String? foodIdValue;

  /// Pre-filled values (e.g. from a barcode lookup or AI label extraction).
  final FoodDraft? initial;

  const AddFood({super.key, this.foodIdValue, this.initial});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final foodNameController = TextEditingController();
  final brandNameController = TextEditingController();
  final servingSizeController = TextEditingController();
  final caloriesController = TextEditingController();
  final totalFatController = TextEditingController();
  final saturatedFatController = TextEditingController();
  final transFatController = TextEditingController();
  final cholesterolController = TextEditingController();
  final sodiumController = TextEditingController();
  final totalCarbohydrateController = TextEditingController();
  final dietaryFiberController = TextEditingController();
  final sugarsController = TextEditingController();
  final addedSugarsController = TextEditingController();
  final proteinController = TextEditingController();
  final vitaminDController = TextEditingController();
  final calciumController = TextEditingController();
  final ironController = TextEditingController();
  final potassiumController = TextEditingController();
  final vitaminAController = TextEditingController();
  final vitaminCController = TextEditingController();
  final vitaminB6Controller = TextEditingController();
  final folateController = TextEditingController();
  final thiaminController = TextEditingController();
  final magnesiumController = TextEditingController();
  final zincController = TextEditingController();
  final phosphorusController = TextEditingController();
  final riboflavinController = TextEditingController();
  final niacinController = TextEditingController();
  final pantothenicAcidController = TextEditingController();
  final vitaminEController = TextEditingController();

  /// Optional nutrients revealed by the "Additional fields" checkboxes.
  late final List<_OptionalNutrient> _optionalNutrients = [
    _OptionalNutrient(
      'vitaminD',
      'Vitamin D (100% = 10mcg)*',
      vitaminDController,
    ),
    _OptionalNutrient(
      'vitaminB6',
      'Vitamin B6 (100% = 1.7mg)*',
      vitaminB6Controller,
    ),
    _OptionalNutrient(
      'folate',
      'Folate (100% = 400mcg DFE)*',
      folateController,
    ),
    _OptionalNutrient('thiamin', 'Thiamin (100% = 1.2mg)*', thiaminController),
    _OptionalNutrient(
      'magnesium',
      'Magnesium (100% = 350mg)*',
      magnesiumController,
    ),
    _OptionalNutrient('zinc', 'Zinc (100% = 9mg)*', zincController),
    _OptionalNutrient(
      'phosphorus',
      'Phosphorus (100% = 1250mg)*',
      phosphorusController,
    ),
    _OptionalNutrient(
      'riboflavin',
      'Riboflavin (100% = 1.3mg)*',
      riboflavinController,
    ),
    _OptionalNutrient('niacin', 'Niacin (100% = 16mg)*', niacinController),
    _OptionalNutrient(
      'pantothenicAcid',
      'Pantothenic Acid (100% = 5mg)*',
      pantothenicAcidController,
    ),
    _OptionalNutrient(
      'vitaminE',
      'Vitamin E (100% = 15mg)*',
      vitaminEController,
    ),
  ];

  /// Barcode preserved from [AddFood.initial] so a scanned food keeps its
  /// code when the user edits and saves it.
  String _barcode = '';

  @override
  void initState() {
    super.initState();
    final draft = widget.initial;
    if (draft != null) _fillFromDraft(draft);
  }

  /// Fills the form from a draft (barcode lookup, AI label, or manual).
  void _fillFromDraft(FoodDraft draft) {
    _barcode = draft.barcode;
    foodNameController.text = draft.foodName;
    brandNameController.text = draft.brandName;
    servingSizeController.text = _fmt(draft.servingSize);
    caloriesController.text = _fmt(draft.calories);
    totalFatController.text = _fmt(draft.totalFat);
    saturatedFatController.text = _fmt(draft.saturatedFat);
    transFatController.text = _fmt(draft.transFat);
    cholesterolController.text = _fmt(draft.cholesterol);
    sodiumController.text = _fmt(draft.sodium);
    totalCarbohydrateController.text = _fmt(draft.totalCarbohydrate);
    dietaryFiberController.text = _fmt(draft.dietaryFiber);
    sugarsController.text = _fmt(draft.sugars);
    addedSugarsController.text = _fmt(draft.addedSugars);
    proteinController.text = _fmt(draft.protein);
    vitaminDController.text = _fmt(draft.vitaminD);
    calciumController.text = _fmt(draft.calcium);
    ironController.text = _fmt(draft.iron);
    potassiumController.text = _fmt(draft.potassium);
    vitaminAController.text = _fmt(draft.vitaminA);
    vitaminCController.text = _fmt(draft.vitaminC);
    vitaminB6Controller.text = _fmt(draft.vitaminB6);
    folateController.text = _fmt(draft.folate);
    thiaminController.text = _fmt(draft.thiamin);
    magnesiumController.text = _fmt(draft.magnesium);
    zincController.text = _fmt(draft.zinc);
    phosphorusController.text = _fmt(draft.phosphorus);
    riboflavinController.text = _fmt(draft.riboflavin);
    niacinController.text = _fmt(draft.niacin);
    pantothenicAcidController.text = _fmt(draft.pantothenicAcid);
    vitaminEController.text = _fmt(draft.vitaminE);
  }

  /// Formats a nutrient amount for a text field; 0 becomes an empty input.
  static String _fmt(double value) {
    if (value == 0) return '';
    final text = value.toString();
    return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
  }

  @override
  void dispose() {
    for (final c in [
      foodNameController,
      brandNameController,
      servingSizeController,
      caloriesController,
      totalFatController,
      saturatedFatController,
      transFatController,
      cholesterolController,
      sodiumController,
      totalCarbohydrateController,
      dietaryFiberController,
      sugarsController,
      addedSugarsController,
      proteinController,
      vitaminDController,
      calciumController,
      ironController,
      potassiumController,
      vitaminAController,
      vitaminCController,
      vitaminB6Controller,
      folateController,
      thiaminController,
      magnesiumController,
      zincController,
      phosphorusController,
      riboflavinController,
      niacinController,
      pantothenicAcidController,
      vitaminEController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  bool _saving = false;

  /// Keys of the optional nutrient fields currently revealed.
  final Set<String> _visible = {};

  final _addFoodFormKey = GlobalKey<FormState>();

  /// Opens the barcode scanner and applies the resolved food, or opens the
  /// manual form with just the barcode when the code is unknown.
  Future<void> _openBarcodeScanner() async {
    final messenger = ScaffoldMessenger.of(context);
    final draft = await Navigator.of(context).push<FoodDraft>(
      MaterialPageRoute<FoodDraft>(
        builder: (context) => const BarcodeScannerScreen(),
      ),
    );
    if (draft == null || !mounted) return;
    _fillFromDraft(draft);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          draft.foodName.isEmpty
              ? 'Barcode ${draft.barcode} — fill in the details.'
              : 'Loaded ${draft.foodName}. Review and save.',
        ),
      ),
    );
  }

  /// Captures a nutrition label and applies the AI-extracted values.
  Future<void> _openLabelCapture() async {
    final messenger = ScaffoldMessenger.of(context);
    final draft = await Navigator.of(context).push<FoodDraft>(
      MaterialPageRoute<FoodDraft>(
        builder: (context) => const NutritionLabelCaptureScreen(),
      ),
    );
    if (draft == null || !mounted) return;
    _fillFromDraft(draft);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          draft.foodName.isEmpty
              ? 'Label read — fill in the missing details.'
              : 'Filled in ${draft.foodName}. Review and save.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Add to shelf')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Form(
            key: _addFoodFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _openBarcodeScanner,
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Scan barcode'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _openLabelCapture,
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Scan label'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _section(
                  title: 'Basics',
                  fields: [
                    _NutrientField(
                      label: 'Food name',
                      controller: foodNameController,
                      hint: 'Name',
                      validator: _required,
                    ),
                    _NutrientField(
                      label: 'Brand / category',
                      controller: brandNameController,
                      hint: 'Brand',
                    ),
                    _NutrientField(
                      label: 'Amount per serving (g/mL)',
                      controller: servingSizeController,
                      hint: 'g/mL',
                      validator: _required,
                    ),
                    _NutrientField(
                      label: 'Calories (kcal)',
                      controller: caloriesController,
                      hint: 'kcal',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _section(
                  title: 'Macros & more',
                  fields: [
                    _NutrientField(
                      label: 'Total fat',
                      controller: totalFatController,
                      hint: 'g',
                    ),
                    _NutrientField(
                      label: 'Saturated fat',
                      controller: saturatedFatController,
                      hint: 'g',
                    ),
                    _NutrientField(
                      label: 'Trans fat',
                      controller: transFatController,
                      hint: 'g',
                    ),
                    _NutrientField(
                      label: 'Cholesterol',
                      controller: cholesterolController,
                      hint: 'mg',
                    ),
                    _NutrientField(
                      label: 'Sodium / salt',
                      controller: sodiumController,
                      hint: 'mg',
                    ),
                    _NutrientField(
                      label: 'Total carbohydrate',
                      controller: totalCarbohydrateController,
                      hint: 'g',
                    ),
                    _NutrientField(
                      label: 'Dietary fiber',
                      controller: dietaryFiberController,
                      hint: 'g',
                    ),
                    _NutrientField(
                      label: 'Sugars',
                      controller: sugarsController,
                      hint: 'g',
                    ),
                    _NutrientField(
                      label: 'Added sugars',
                      controller: addedSugarsController,
                      hint: 'g',
                    ),
                    _NutrientField(
                      label: 'Protein',
                      controller: proteinController,
                      hint: 'g',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _section(
                  title: 'Vitamins & minerals (% DV)',
                  fields: [
                    _NutrientField(
                      label: 'Calcium (100% = 800mg)*',
                      controller: calciumController,
                      hint: '%',
                    ),
                    _NutrientField(
                      label: 'Iron (100% = 9mg)*',
                      controller: ironController,
                      hint: '%',
                    ),
                    _NutrientField(
                      label: 'Potassium (100% = 3500mg)',
                      controller: potassiumController,
                      hint: '%',
                    ),
                    _NutrientField(
                      label: 'Vitamin A (100% = 900mcg)*',
                      controller: vitaminAController,
                      hint: '%',
                    ),
                    _NutrientField(
                      label: 'Vitamin C (100% = 75mg)*',
                      controller: vitaminCController,
                      hint: '%',
                    ),
                    for (final nutrient in _optionalNutrients)
                      if (_visible.contains(nutrient.key))
                        _NutrientField(
                          label: nutrient.label,
                          controller: nutrient.controller,
                          hint: '%',
                        ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'ADDITIONAL FIELDS',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                GlassCard(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      for (final nutrient in _optionalNutrients)
                        _OptionalField(
                          label: nutrient.label.split(' (')[0],
                          value: _visible.contains(nutrient.key),
                          onChanged: (show) => setState(() {
                            if (show) {
                              _visible.add(nutrient.key);
                            } else {
                              _visible.remove(nutrient.key);
                            }
                          }),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '* The % Daily Value (DV) tells you how much a nutrient in a '
                  'serving of food contributes to a daily diet. 2,000 calories a '
                  'day is used for general nutrition advice.',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 24),
                GradientButton(
                  label: 'Save to shelf',
                  icon: Icons.check,
                  loading: _saving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required List<Widget> fields,
  }) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          ...fields,
        ],
      ),
    );
  }

  String? _required(String? value) =>
      (value == null || value.isEmpty) ? 'Required' : null;

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    if (!(_addFoodFormKey.currentState?.validate() ?? false)) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please fill the required boxes')),
      );
      return;
    }
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final shelf = context.repos.shelf;
    final catalog = ProviderScope.containerOf(context, listen: false).read(
      foodCatalogRepositoryProvider,
    );
    try {
      final draft = _buildDraft();
      await shelf.addFood(widget.foodIdValue!, draft.toShelfMap());
      // Persist barcode foods into the shared catalog so future scans match
      // locally before hitting the external API.
      if (draft.barcode.isNotEmpty) {
        await catalog.upsert(draft);
      }
      if (!mounted) return;
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Food added to your shelf')),
      );
    } on Object {
      if (mounted) {
        setState(() => _saving = false);
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Could not save the food item. '
              'Check your connection and try again.',
            ),
          ),
        );
      }
    }
  }

  /// Parses a controller value to a double; 0 when empty/invalid.
  double _parse(TextEditingController c) {
    final text = c.text.replaceAll(',', '.').trim();
    return text.isEmpty ? 0 : double.parse(text);
  }

  /// Converts a %-DV input to the absolute nutrient amount.
  double _percent(TextEditingController c, num dailyValue) {
    return _parse(c) / 100 * dailyValue;
  }

  /// Builds the draft from the current form state.
  FoodDraft _buildDraft() {
    double raw(TextEditingController c) => _parse(c);
    double pct(TextEditingController c, num daily) => _percent(c, daily);
    return FoodDraft(
      foodId: widget.foodIdValue ?? '',
      barcode: _barcode,
      foodName: foodNameController.text,
      brandName: brandNameController.text,
      servingSize: raw(servingSizeController),
      calories: raw(caloriesController),
      totalFat: raw(totalFatController),
      saturatedFat: raw(saturatedFatController),
      transFat: raw(transFatController),
      cholesterol: raw(cholesterolController),
      sodium: raw(sodiumController),
      totalCarbohydrate: raw(totalCarbohydrateController),
      dietaryFiber: raw(dietaryFiberController),
      sugars: raw(sugarsController),
      addedSugars: raw(addedSugarsController),
      protein: raw(proteinController),
      vitaminD: pct(vitaminDController, vitaminDDailyValue),
      calcium: pct(calciumController, calciumDailyValue),
      iron: pct(ironController, ironDailyValue),
      potassium: pct(potassiumController, potassiumDailyValue),
      vitaminA: pct(vitaminAController, vitaminADailyValue),
      vitaminC: pct(vitaminCController, vitaminCDailyValue),
      vitaminB6: pct(vitaminB6Controller, vitaminB6DailyValue),
      folate: pct(folateController, folateDailyValue),
      thiamin: pct(thiaminController, thiaminDailyValue),
      magnesium: pct(magnesiumController, magnesiumDailyValue),
      zinc: pct(zincController, zincDailyValue),
      phosphorus: pct(phosphorusController, phosphorusDailyValue),
      riboflavin: pct(riboflavinController, riboflavinDailyValue),
      niacin: pct(niacinController, niacinDailyValue),
      pantothenicAcid: pct(
        pantothenicAcidController,
        pantothenicAcidDailyValue,
      ),
      vitaminE: pct(vitaminEController, vitaminEDailyValue),
    );
  }
}

class _OptionalField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _OptionalField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Checkbox(
              value: value,
              onChanged: (checked) => onChanged(checked ?? false),
              activeColor: colors.energyStart,
              checkColor: colors.bgBase,
              side: BorderSide(
                color: colors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
