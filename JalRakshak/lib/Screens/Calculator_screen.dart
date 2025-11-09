import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jal_rakshak/Screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'SF Pro',
      ),
      home: const RainwaterCalculatorScreen(),
    );
  }
}

class RainwaterCalculatorScreen extends StatefulWidget {
  const RainwaterCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<RainwaterCalculatorScreen> createState() =>
      _RainwaterCalculatorScreenState();
}

class _RainwaterCalculatorScreenState extends State<RainwaterCalculatorScreen>
    with TickerProviderStateMixin {
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final rainfallController = TextEditingController();
  final membersController = TextEditingController();
  final priceController = TextEditingController(text: '0.02');

  String selectedRoofType = 'Concrete';
  double runoffCoefficient = 0.85;
  bool showResults = false;
  bool isCalculating = false;

  double annualCollection = 0;
  double savings = 0;
  double perPersonSupply = 0;
  double roofArea = 0;

  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final Map<String, Map<String, dynamic>> roofTypes = {
    'Concrete': {
      'coefficient': 0.85,
      'icon': Icons.apartment,
      'color': Color(0xFF6BB6FF)
    },
    'Tile': {
      'coefficient': 0.75,
      'icon': Icons.roofing,
      'color': Color(0xFFFF9B70)
    },
    'Metal': {
      'coefficient': 0.90,
      'icon': Icons.construction,
      'color': Color(0xFF9B9BFF)
    },
  };

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
  }

  Future<void> calculateResults() async {
    // Validate inputs
    final length = double.tryParse(lengthController.text);
    final width = double.tryParse(widthController.text);
    final rainfall = double.tryParse(rainfallController.text);
    final members = double.tryParse(membersController.text);
    final price = double.tryParse(priceController.text);

    if (length == null || length <= 0) {
      _showErrorSnackBar('Please enter a valid roof length');
      return;
    }
    if (width == null || width <= 0) {
      _showErrorSnackBar('Please enter a valid roof width');
      return;
    }
    if (rainfall == null || rainfall <= 0) {
      _showErrorSnackBar('Please enter valid annual rainfall');
      return;
    }
    if (members == null || members <= 0) {
      _showErrorSnackBar('Please enter valid number of household members');
      return;
    }
    if (price == null || price <= 0) {
      _showErrorSnackBar('Please enter a valid water price');
      return;
    }

    setState(() {
      isCalculating = true;
    });

    // Simulate calculation delay for animation effect
    await Future.delayed(const Duration(milliseconds: 1500));

    roofArea = length * width;
    annualCollection = roofArea * rainfall * runoffCoefficient;
    savings = annualCollection * price;
    perPersonSupply = annualCollection / (members * 365);

    setState(() {
      isCalculating = false;
      showResults = true;
    });

    // Trigger animations
    _slideController.forward(from: 0);
    _scaleController.forward(from: 0);

    // Scroll to results
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _scrollToResults();
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollToResults() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Make system icons visible (dark)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildHeader(), // 🧡 New SliverAppBar-based header
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildHeroSection(),
                      const SizedBox(height: 32),
                      _buildRoofDimensionsSection(),
                      const SizedBox(height: 24),
                      _buildRoofTypeSection(),
                      const SizedBox(height: 24),
                      _buildRainfallSection(),
                      const SizedBox(height: 24),
                      _buildHouseholdSection(),
                      const SizedBox(height: 32),
                      _buildCalculateButton(),
                      const SizedBox(height: 24),
                      if (showResults) _buildResultsSection(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      pinned: true,
      floating: false,
      elevation: 0,
      expandedHeight: 100,
      backgroundColor: const Color(0xFFFFF3E9),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // ✅ Always navigate back to HomePage
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false, // Removes all previous routes
                );
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9B70).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Colors.black, // ✅ visible icon
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB88C), Color(0xFFFF9B70)],
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9B70).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.water_drop, size: 14, color: Color(0xFFFF9B70)),
                  SizedBox(width: 4),
                  Text(
                    'Jal Rakshak',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF9B70),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB88C), Color(0xFFFF9B70)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF9B70).withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Rainwater Harvesting\nPotential Calculator',
          style: TextStyle(
            fontSize: 32,
            color: Colors.black,
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '💧 Save Water, Save Money, Save Earth',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoofDimensionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('📏 Roof Dimensions', 'Measure your rooftop area'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAnimatedInputCard(
                label: 'Length',
                unit: 'meters',
                controller: lengthController,
                icon: Icons.straighten,
                color: const Color(0xFF6BB6FF),
                delay: 0,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                '×',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAnimatedInputCard(
                label: 'Width',
                unit: 'meters',
                controller: widthController,
                icon: Icons.swap_horiz,
                color: const Color(0xFFFF9B70),
                delay: 100,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Colors.black, // ADD THIS LINE
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black
                .withOpacity(0.5), // ENSURE THIS IS BLACK WITH OPACITY
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedInputCard({
    required String label,
    required String unit,
    required TextEditingController controller,
    required IconData icon,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: '0.0',
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
                suffixText: unit,
                suffixStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoofTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('🏠 Roof Type', 'Select your roof material'),
        const SizedBox(height: 16),
        Row(
          children: roofTypes.entries.map((entry) {
            final isSelected = selectedRoofType == entry.key;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRoofType = entry.key;
                    runoffCoefficient = entry.value['coefficient'];
                  });
                  HapticFeedback.mediumImpact();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  margin: EdgeInsets.only(
                    right: entry.key != 'Metal' ? 8 : 0,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              entry.value['color'],
                              entry.value['color'].withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? entry.value['color']
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? entry.value['color'].withOpacity(0.3)
                            : Colors.black.withOpacity(0.04),
                        blurRadius: isSelected ? 20 : 10,
                        offset: Offset(0, isSelected ? 8 : 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        entry.value['icon'],
                        color: isSelected ? Colors.white : Colors.black54,
                        size: 28,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        entry.key,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(entry.value['coefficient'] * 100).toInt()}%',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white.withOpacity(0.9)
                              : Colors.black45,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRainfallSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildSectionHeader('🌧️ Annual Rainfall',
                  'Average yearly rainfall in your area'),
            ),
            GestureDetector(
              onTap: _detectLocation,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9B9BFF), Color(0xFF7B7BFF)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9B9BFF).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.my_location, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Auto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildAnimatedInputCard(
          label: 'Rainfall',
          unit: 'mm/year',
          controller: rainfallController,
          icon: Icons.cloud_rounded,
          color: const Color(0xFF9B9BFF),
          delay: 200,
        ),
      ],
    );
  }

  void _detectLocation() {
    // Simulate location detection
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.location_on, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child:
                  Text('Location: Delhi, India\nRainfall auto-filled: 797mm'),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF9B9BFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );

    setState(() {
      rainfallController.text = '797';
    });

    HapticFeedback.mediumImpact();
  }

  Widget _buildHouseholdSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            '👨‍👩‍👧‍👦 Household Details', 'Members and water cost'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAnimatedInputCard(
                label: 'Members',
                unit: 'people',
                controller: membersController,
                icon: Icons.people_rounded,
                color: const Color(0xFFFFB88C),
                delay: 300,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAnimatedInputCard(
                label: 'Water Price',
                unit: '₹/liter',
                controller: priceController,
                icon: Icons.currency_rupee,
                color: const Color(0xFF80D4A0),
                delay: 400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return GestureDetector(
      onTap: isCalculating ? null : calculateResults,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isCalculating
                ? [Colors.grey.shade400, Colors.grey.shade500]
                : [const Color(0xFFFFB88C), const Color(0xFFFF9B70)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isCalculating
                  ? Colors.grey.withOpacity(0.3)
                  : const Color(0xFFFF9B70).withOpacity(0.5),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: isCalculating
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Calculating...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calculate_rounded, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Calculate Results',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildResultsSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
                '🎉 Your Results', 'Potential savings and impact'),
            const SizedBox(height: 16),
            _buildResultCard(
              icon: Icons.water_drop_rounded,
              title: 'Annual Rainwater Harvested',
              value: '${_formatNumber(annualCollection)} L',
              subtitle: 'Roof Area: ${roofArea.toStringAsFixed(1)} m²',
              color: const Color(0xFF6BB6FF),
              delay: 0,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              icon: Icons.savings_rounded,
              title: 'Estimated Annual Savings',
              value: '₹${_formatNumber(savings)}',
              subtitle: 'At ₹${priceController.text}/liter',
              color: const Color(0xFF80D4A0),
              delay: 100,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              icon: Icons.person_rounded,
              title: 'Daily Water Per Person',
              value: '${perPersonSupply.toStringAsFixed(1)} L/day',
              subtitle: 'For ${membersController.text} members',
              color: const Color(0xFFFFB88C),
              delay: 200,
            ),
            const SizedBox(height: 12),
            _buildImpactCard(),
            const SizedBox(height: 16),
            _buildShareButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: _shareResults,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFF9B70),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.share_rounded, color: Color(0xFFFF9B70), size: 22),
            SizedBox(width: 10),
            Text(
              'Share My Impact',
              style: TextStyle(
                color: Color(0xFFFF9B70),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareResults() {
    final message = '''
🌊 My Jal Rakshak Impact Report

💧 Annual Rainwater: ${_formatNumber(annualCollection)} liters
💰 Money Saved: ₹${_formatNumber(savings)}
👨‍👩‍👧 Daily Supply: ${perPersonSupply.toStringAsFixed(1)} L/person

Join the water conservation movement!
#JalRakshak #SaveWater #RainwaterHarvesting
    ''';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Results copied! Share with your friends 🌊'),
        backgroundColor: const Color(0xFF80D4A0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );

    // In production, use share_plus package:
    // Share.share(message);

    HapticFeedback.mediumImpact();
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    }
    return number.toStringAsFixed(0);
  }

  Widget _buildResultCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animValue)),
          child: Opacity(
            opacity: animValue,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black, // ✅ changed to solid black
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: Colors.black, // ✅ changed to black
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors
                          .black87, // ✅ slightly lighter black for subtitle
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactCard() {
    final daysOfSupply = (annualCollection /
            (double.parse(membersController.text.isEmpty
                    ? '1'
                    : membersController.text) *
                50))
        .floor();
    final treesEquivalent = (annualCollection / 50000).floor();
    final co2Saved = (annualCollection * 0.0003).toStringAsFixed(1); // kg CO2

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 900),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animValue)),
          child: Opacity(
            opacity: animValue,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB88C), Color(0xFFFF9B70)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF9B70).withOpacity(0.4),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.eco_rounded, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'Environmental Impact',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildImpactRow(
              icon: Icons.calendar_today_rounded,
              text: 'Can supply household for ~$daysOfSupply days',
            ),
            const SizedBox(height: 10),
            _buildImpactRow(
              icon: Icons.forest_rounded,
              text: 'Equivalent to planting $treesEquivalent trees/year',
            ),
            const SizedBox(height: 10),
            _buildImpactRow(
              icon: Icons.co2_rounded,
              text: 'Reduces $co2Saved kg CO2 emissions annually',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    lengthController.dispose();
    widthController.dispose();
    rainfallController.dispose();
    membersController.dispose();
    priceController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
