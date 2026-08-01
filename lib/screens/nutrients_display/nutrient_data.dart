/// Data for the nutrient ranking tables.
///
/// Each [NutrientPage] describes one hardcoded ranking table (source: USDA /
/// FDA %DV per 100g). Rendering lives in `widgets/nutrient_table_page.dart`.
library;

class NutrientRow {
  final String rank;
  final String foodName;
  final String amount;
  final String percent;

  const NutrientRow({
    required this.rank,
    required this.foodName,
    required this.amount,
    required this.percent,
  });
}

class NutrientPage {
  final String title;
  final String unitLabel;
  final List<NutrientRow> rows;

  const NutrientPage({
    required this.title,
    required this.unitLabel,
    required this.rows,
  });
}

const proteinData = NutrientPage(
  title: 'Protein',
  unitLabel: '(in grams)',
  rows: [
    NutrientRow(rank: '🥇', foodName: 'Textured Soy', amount: '108 g', percent: '174.16%'),
    NutrientRow(rank: '🥈', foodName: 'Grated Parmesan', amount: '36 g', percent: '57.74%'),
    NutrientRow(rank: '🥉', foodName: 'Chicken Breast', amount: '32 g', percent: '51.77%'),
    NutrientRow(rank: '4', foodName: 'Pork Chops', amount: '31 g', percent: '50.00%'),
    NutrientRow(rank: '5', foodName: 'Tuna', amount: '30 g', percent: '48.23%'),
    NutrientRow(rank: '6', foodName: 'Pumpkin Seeds', amount: '30 g', percent: '48.13%'),
    NutrientRow(rank: '7', foodName: 'Beef', amount: '29 g', percent: '46.29%'),
    NutrientRow(rank: '8', foodName: 'Peanuts', amount: '25 g', percent: '40.32%'),
    NutrientRow(rank: '9', foodName: 'Cheddar', amount: '25 g', percent: '40.32%'),
    NutrientRow(rank: '10', foodName: 'Almonds', amount: '21 g', percent: '33.87%'),
    NutrientRow(rank: '11', foodName: 'Sardines', amount: '21 g', percent: '33.87%'),
    NutrientRow(rank: '12', foodName: 'Cod', amount: '20 g', percent: '32.26%'),
    NutrientRow(rank: '13', foodName: 'Mozzarella', amount: '18 g', percent: '29.03%'),
    NutrientRow(rank: '14', foodName: 'Firm Tofu', amount: '17 g', percent: '27.90%'),
    NutrientRow(rank: '15', foodName: 'Chia seeds', amount: '17 g', percent: '27.42%'),
    NutrientRow(rank: '16', foodName: 'Eggs', amount: '13 g', percent: '20.32%'),
    NutrientRow(rank: '17', foodName: 'Oats', amount: '10 g', percent: '16.13%'),
    NutrientRow(rank: '18', foodName: 'Lentils', amount: '9 g', percent: '14.52%'),
    NutrientRow(rank: '19', foodName: 'Kidney beans', amount: '8 g', percent: '12.90%'),
    NutrientRow(rank: '20', foodName: 'Chickpeas', amount: '7 g', percent: '11.29%'),
    NutrientRow(rank: '21', foodName: 'Peas', amount: '6 g', percent: '9.68%'),
    NutrientRow(rank: '22', foodName: 'Low-Fat Yogurt', amount: '6 g', percent: '9.19%'),
    NutrientRow(rank: '23', foodName: 'Quinoa', amount: '5 g', percent: '8.06%'),
  ],
);

const fiberData = NutrientPage(
  title: 'Fiber',
  unitLabel: '(in grams)',
  rows: [
    NutrientRow(rank: '🥇', foodName: 'Chia Seeds', amount: '34 g', percent: '90.53%'),
    NutrientRow(rank: '🥈', foodName: 'Popcorn', amount: '14 g', percent: '37.89%'),
    NutrientRow(rank: '🥉', foodName: 'Almonds', amount: '13 g', percent: '35.00%'),
    NutrientRow(rank: '4', foodName: 'Dark chocolate', amount: '11 g', percent: '28.68%'),
    NutrientRow(rank: '5', foodName: 'Oats', amount: '10 g', percent: '26.58%'),
    NutrientRow(rank: '6', foodName: 'Textured Soy', amount: '9 g', percent: '24.74%'),
    NutrientRow(rank: '7', foodName: 'Lentils', amount: '7 g', percent: '19.21%'),
    NutrientRow(rank: '8', foodName: 'Chickpeas', amount: '7 g', percent: '18.42%'),
    NutrientRow(rank: '9', foodName: 'Kidney Beans', amount: '7 g', percent: '17.89%'),
    NutrientRow(rank: '10', foodName: 'Avocado', amount: '7 g', percent: '17.63%'),
    NutrientRow(rank: '11', foodName: 'Raspberries', amount: '7 g', percent: '17.11%'),
    NutrientRow(rank: '12', foodName: 'Green Peas', amount: '6 g', percent: '15.00%'),
    NutrientRow(rank: '13', foodName: 'Artichoke', amount: '5 g', percent: '14.21%'),
    NutrientRow(rank: '14', foodName: 'Brussels Sprouts', amount: '4 g', percent: '10.00%'),
    NutrientRow(rank: '15', foodName: 'Pears', amount: '3 g', percent: '8.16%'),
    NutrientRow(rank: '16', foodName: 'Quinoa', amount: '3 g', percent: '7.37%'),
    NutrientRow(rank: '17', foodName: 'Carrots', amount: '3 g', percent: '7.37%'),
    NutrientRow(rank: '18', foodName: 'Beets', amount: '3 g', percent: '7.37%'),
    NutrientRow(rank: '19', foodName: 'Bananas', amount: '3 g', percent: '6.84%'),
    NutrientRow(rank: '20', foodName: 'Broccoli', amount: '3 g', percent: '6.84%'),
    NutrientRow(rank: '21', foodName: 'Sweet Potatoes', amount: '3 g', percent: '6.58%'),
    NutrientRow(rank: '22', foodName: 'Apples', amount: '2 g', percent: '6.32%'),
    NutrientRow(rank: '23', foodName: 'Strawberries', amount: '2 g', percent: '5.26%'),
  ],
);

const calciumData = NutrientPage(
  title: 'Calcium',
  unitLabel: '(in milligrams)',
  rows: [
    NutrientRow(rank: '🥇', foodName: 'Grated Parmesan', amount: '1,184 mg', percent: '118.40%'),
    NutrientRow(rank: '🥈', foodName: 'Sesame Seeds', amount: '975 mg', percent: '97.50%'),
    NutrientRow(rank: '🥉', foodName: 'Almonds', amount: '268 mg', percent: '26.80%'),
    NutrientRow(rank: '4', foodName: 'Chia Seeds', amount: '255 mg', percent: '25.50%'),
    NutrientRow(rank: '5', foodName: 'Yogurt', amount: '199 mg', percent: '19.90%'),
    NutrientRow(rank: '6', foodName: 'Almond Milk', amount: '184 mg', percent: '18.40%'),
    NutrientRow(rank: '7', foodName: 'Spinach', amount: '136 mg', percent: '13.60%'),
    NutrientRow(rank: '8', foodName: 'Soy Milk', amount: '123 mg', percent: '12.30%'),
    NutrientRow(rank: '9', foodName: 'Whole Milk', amount: '115 mg', percent: '11.50%'),
    NutrientRow(rank: '10', foodName: 'Red Kidney Beans', amount: '83 mg', percent: '8.30%'),
    NutrientRow(rank: '11', foodName: 'Oats', amount: '52 mg', percent: '5.20%'),
    NutrientRow(rank: '12', foodName: 'Broccoli', amount: '46 mg', percent: '4.60%'),
    NutrientRow(rank: '13', foodName: 'Squash', amount: '44 mg', percent: '4.40%'),
    NutrientRow(rank: '14', foodName: 'Oranges', amount: '43 mg', percent: '4.30%'),
    NutrientRow(rank: '15', foodName: 'Quinoa', amount: '17 mg', percent: '1.70%'),
  ],
);

const ironData = NutrientPage(
  title: 'Iron',
  unitLabel: '(in milligrams)',
  rows: [
    NutrientRow(rank: '🥇', foodName: 'Chicken Liver', amount: '23 mg', percent: '287.50%'),
    NutrientRow(rank: '🥈', foodName: 'Baking Chocolate', amount: '17 mg', percent: '217.50%'),
    NutrientRow(rank: '🥉', foodName: 'Dark Chocolate', amount: '17 mg', percent: '212.50%'),
    NutrientRow(rank: '4', foodName: 'Textured Soy', amount: '13 mg', percent: '158.50%'),
    NutrientRow(rank: '5', foodName: 'Squash', amount: '9 mg', percent: '110.00%'),
    NutrientRow(rank: '6', foodName: 'Cashew Nuts', amount: '6 mg', percent: '76.25%'),
    NutrientRow(rank: '7', foodName: 'Beef', amount: '4 mg', percent: '47.50%'),
    NutrientRow(rank: '8', foodName: 'Lentils', amount: '4 mg', percent: '46.25%'),
    NutrientRow(rank: '9', foodName: 'White Beans', amount: '4 mg', percent: '46.25%'),
    NutrientRow(rank: '10', foodName: 'Spinach', amount: '4 mg', percent: '45.00%'),
    NutrientRow(rank: '11', foodName: 'Quinoa', amount: '2 mg', percent: '18.75%'),
    NutrientRow(rank: '12', foodName: 'Broccoli', amount: '1 mg', percent: '12.50%'),
  ],
);

const potassiumData = NutrientPage(
  title: 'Potassium',
  unitLabel: '(in milligrams)',
  rows: [
    NutrientRow(rank: '🥇', foodName: 'White Beans', amount: '561 mg', percent: '16.50%'),
    NutrientRow(rank: '🥈', foodName: 'Spinach', amount: '558 mg', percent: '16.41%'),
    NutrientRow(rank: '🥉', foodName: 'Baked Potatoes', amount: '535 mg', percent: '15.74%'),
    NutrientRow(rank: '4', foodName: 'Avocados', amount: '485 mg', percent: '14.26%'),
    NutrientRow(rank: '5', foodName: 'Sweet Potato', amount: '475 mg', percent: '13.97%'),
    NutrientRow(rank: '6', foodName: 'White Mushrooms', amount: '396 mg', percent: '11.65%'),
    NutrientRow(rank: '7', foodName: 'Bananas', amount: '358 mg', percent: '10.53%'),
    NutrientRow(rank: '8', foodName: 'Tomato', amount: '218 mg', percent: '6.41%'),
    NutrientRow(rank: '9', foodName: 'Milk', amount: '150 mg', percent: '4.41%'),
  ],
);

const vitaminAData = NutrientPage(
  title: 'Vitamin A',
  unitLabel: '(in micrograms)',
  rows: [
    NutrientRow(rank: '🥇', foodName: 'Chicken Liver', amount: '3,296 µg', percent: '366.22%'),
    NutrientRow(rank: '🥈', foodName: 'Carrots', amount: '835 µg', percent: '92.78%'),
    NutrientRow(rank: '🥉', foodName: 'Sweet Potatoes', amount: '764 µg', percent: '84.89%'),
    NutrientRow(rank: '4', foodName: 'Butter', amount: '684 µg', percent: '76.00%'),
    NutrientRow(rank: '5', foodName: 'Pumpkin', amount: '426 µg', percent: '47.33%'),
    NutrientRow(rank: '6', foodName: 'Lettuce', amount: '198 µg', percent: '22.00%'),
    NutrientRow(rank: '7', foodName: 'Sweet Red Pepper', amount: '157 µg', percent: '17.44%'),
    NutrientRow(rank: '8', foodName: 'Hard-Boiled Eggs', amount: '149 µg', percent: '16.56%'),
    NutrientRow(rank: '9', foodName: 'Passion Fruit', amount: '64 µg', percent: '7.11%'),
    NutrientRow(rank: '10', foodName: 'Mangoes', amount: '54 µg', percent: '6.00%'),
    NutrientRow(rank: '11', foodName: 'Papayas', amount: '47 µg', percent: '5.22%'),
    NutrientRow(rank: '12', foodName: 'Tangerines', amount: '34 µg', percent: '3.78%'),
    NutrientRow(rank: '13', foodName: 'Watermelon', amount: '28 µg', percent: '3.11%'),
  ],
);

const vitaminCData = NutrientPage(
  title: 'Vitamin C',
  unitLabel: '(in milligrams)',
  rows: [
    NutrientRow(rank: '🥇', foodName: 'Acerola Cherries', amount: '1,678 mg', percent: '1,864.00%'),
    NutrientRow(rank: '🥈', foodName: 'Parsley', amount: '133 mg', percent: '147.78%'),
    NutrientRow(rank: '🥉', foodName: 'Bell Peppers', amount: '128 mg', percent: '142.22%'),
    NutrientRow(rank: '4', foodName: 'Broccoli', amount: '89 mg', percent: '98.89%'),
    NutrientRow(rank: '5', foodName: 'Papaya', amount: '61 mg', percent: '67.78%'),
    NutrientRow(rank: '6', foodName: 'Strawberries', amount: '59 mg', percent: '65.56%'),
    NutrientRow(rank: '7', foodName: 'Oranges', amount: '53 mg', percent: '58.89%'),
    NutrientRow(rank: '8', foodName: 'Green Chillies', amount: '34 mg', percent: '38.00%'),
    NutrientRow(rank: '9', foodName: 'Tomato', amount: '23 mg', percent: '25.56%'),
  ],
);
