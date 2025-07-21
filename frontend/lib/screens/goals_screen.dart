import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final List<Map<String, dynamic>> goals = [
    {
      'title': 'Emergency Fund',
      'description': 'Build a 6-month emergency fund',
      'currentAmount': 15000.0,
      'targetAmount': 25000.0,
      'deadline': '2024-12-31',
      'category': 'Savings',
      'icon': Icons.security,
      'color': Colors.blue,
    },
    {
      'title': 'Vacation Fund',
      'description': 'Save for a trip to Europe',
      'currentAmount': 3200.0,
      'targetAmount': 8000.0,
      'deadline': '2024-07-01',
      'category': 'Travel',
      'icon': Icons.flight,
      'color': Colors.orange,
    },
    {
      'title': 'New Car',
      'description': 'Down payment for a new car',
      'currentAmount': 8500.0,
      'targetAmount': 15000.0,
      'deadline': '2024-10-15',
      'category': 'Transportation',
      'icon': Icons.directions_car,
      'color': Colors.green,
    },
    {
      'title': 'Home Improvement',
      'description': 'Kitchen renovation project',
      'currentAmount': 2800.0,
      'targetAmount': 12000.0,
      'deadline': '2024-08-30',
      'category': 'Home',
      'icon': Icons.home_repair_service,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Goals'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              _showGoalsAnalytics();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Goals overview
            _buildGoalsOverview(),
            const SizedBox(height: 24),
            
            // Goals list
            Text(
              'Your Goals',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ...goals.map((goal) => _buildGoalCard(goal)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGoalDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGoalsOverview() {
    final totalGoals = goals.length;
    final completedGoals = goals.where((goal) => 
        goal['currentAmount'] >= goal['targetAmount']).length;
    final totalTargetAmount = goals.fold<double>(0, (sum, goal) => 
        sum + goal['targetAmount']);
    final totalCurrentAmount = goals.fold<double>(0, (sum, goal) => 
        sum + goal['currentAmount']);
    final overallProgress = totalCurrentAmount / totalTargetAmount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Goals Overview',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  'Total Goals',
                  totalGoals.toString(),
                  Icons.flag,
                ),
              ),
              Expanded(
                child: _buildOverviewItem(
                  'Completed',
                  completedGoals.toString(),
                  Icons.check_circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Text(
            'Overall Progress',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          
          LinearProgressIndicator(
            value: overallProgress,
            backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            '\$${totalCurrentAmount.toStringAsFixed(0)} of \$${totalTargetAmount.toStringAsFixed(0)} (${(overallProgress * 100).toStringAsFixed(1)}%)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal) {
    final progress = goal['currentAmount'] / goal['targetAmount'];
    final isCompleted = progress >= 1.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted 
              ? Colors.green.withOpacity(0.3)
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: goal['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  goal['icon'] as IconData,
                  color: goal['color'] as Color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal['title'] as String,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goal['description'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Completed',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${goal['currentAmount'].toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: goal['color'] as Color,
                    ),
                  ),
                  Text(
                    '\$${goal['targetAmount'].toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(goal['color'] as Color),
              ),
              const SizedBox(height: 8),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(1)}% complete',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    'Due: ${goal['deadline']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          if (!isCompleted) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showAddAmountDialog(goal);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Amount'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: goal['color'],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddAmountDialog(Map<String, dynamic> goal) {
    final TextEditingController amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add to ${goal['title']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current: \$${goal['currentAmount'].toStringAsFixed(2)}'),
              Text('Target: \$${goal['targetAmount'].toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount to add',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  setState(() {
                    goal['currentAmount'] = goal['currentAmount'] + amount;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added \$${amount.toStringAsFixed(2)} to ${goal['title']}!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Goal'),
          content: const Text('Goal creation form would go here...'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Goal added!')),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showGoalsAnalytics() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Goals Analytics'),
          content: const Text('Detailed analytics would be displayed here...'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
} 