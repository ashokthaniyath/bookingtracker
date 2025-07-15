import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/resort_data_provider.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  String _filter = 'All';

  void _onTabSelected(int index) {
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => false,
      );
    } else if (index == 1) {
      Navigator.pushNamedAndRemoveUntil(context, '/calendar', (route) => false);
    } else if (index == 2) {
      Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF007AFF)),
        title: const Text('Payments'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildDrawerItem(
              context,
              Icons.attach_money_rounded,
              'Sales / Payment',
              '/sales',
            ),
            _buildDrawerItem(context, Icons.bed_rounded, 'Rooms', '/rooms'),
            _buildDrawerItem(
              context,
              Icons.people_alt_rounded,
              'Guest List',
              '/guests',
            ),
            _buildDrawerItem(
              context,
              Icons.analytics_outlined,
              'Analytics',
              '/analytics',
            ),
            _buildDrawerItem(
              context,
              Icons.add_box_rounded,
              'Booking',
              '/booking-form',
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _filter == 'All',
                    onSelected: (_) => setState(() => _filter = 'All'),
                    selectedColor: const Color(
                      0xFF007AFF,
                    ).withValues(alpha: 0.15),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Paid'),
                    selected: _filter == 'Paid',
                    onSelected: (_) => setState(() => _filter = 'Paid'),
                    selectedColor: const Color(
                      0xFF34D399,
                    ).withValues(alpha: 0.15),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Pending'),
                    selected: _filter == 'Pending',
                    onSelected: (_) => setState(() => _filter = 'Pending'),
                    selectedColor: const Color(
                      0xFFF59E42,
                    ).withValues(alpha: 0.15),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Consumer<ResortDataProvider>(
                  builder: (context, provider, child) {
                    final payments = provider.payments;
                    final filtered = _filter == 'All'
                        ? payments
                        : payments
                              .where(
                                (p) =>
                                    p.status.toLowerCase() ==
                                    _filter.toLowerCase(),
                              )
                              .toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.payment_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No payments found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final payment = filtered[i];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  payment.status.toLowerCase() == 'paid'
                                  ? const Color(
                                      0xFF34D399,
                                    ).withValues(alpha: 0.15)
                                  : const Color(
                                      0xFFF59E42,
                                    ).withValues(alpha: 0.15),
                              child: Icon(
                                payment.status.toLowerCase() == 'paid'
                                    ? Icons.check_circle_outline
                                    : Icons.pending_actions_outlined,
                                color: payment.status.toLowerCase() == 'paid'
                                    ? const Color(0xFF34D399)
                                    : const Color(0xFFF59E42),
                              ),
                            ),
                            title: Text(
                              payment.guest.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '₹${payment.amount.toStringAsFixed(2)} • ${payment.date.day}/${payment.date.month}/${payment.date.year}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: Text(
                              payment.status,
                              style: TextStyle(
                                color: payment.status.toLowerCase() == 'paid'
                                    ? const Color(0xFF34D399)
                                    : const Color(0xFFF59E42),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: 1, // or 0/2 depending on context
        onItemTapped: _onTabSelected,
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
