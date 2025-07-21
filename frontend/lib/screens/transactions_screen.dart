import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Income', 'Expense', 'Investment'];

  final List<Map<String, dynamic>> transactions = [
    {
      'title': 'Salary Deposit',
      'amount': 3200.00,
      'type': 'income',
      'category': 'Salary',
      'date': '2024-01-15',
      'icon': Icons.attach_money,
    },
    {
      'title': 'Grocery Shopping',
      'amount': -85.50,
      'type': 'expense',
      'category': 'Food',
      'date': '2024-01-14',
      'icon': Icons.shopping_cart,
    },
    {
      'title': 'Stock Investment',
      'amount': -500.00,
      'type': 'investment',
      'category': 'Investment',
      'date': '2024-01-13',
      'icon': Icons.trending_up,
    },
    {
      'title': 'Coffee Shop',
      'amount': -12.40,
      'type': 'expense',
      'category': 'Food',
      'date': '2024-01-13',
      'icon': Icons.local_cafe,
    },
    {
      'title': 'Freelance Work',
      'amount': 750.00,
      'type': 'income',
      'category': 'Freelance',
      'date': '2024-01-12',
      'icon': Icons.work,
    },
    {
      'title': 'Gas Station',
      'amount': -65.30,
      'type': 'expense',
      'category': 'Transportation',
      'date': '2024-01-11',
      'icon': Icons.local_gas_station,
    },
    {
      'title': 'Investment Return',
      'amount': 156.78,
      'type': 'investment',
      'category': 'Investment',
      'date': '2024-01-10',
      'icon': Icons.trending_up,
    },
    {
      'title': 'Restaurant',
      'amount': -45.60,
      'type': 'expense',
      'category': 'Food',
      'date': '2024-01-09',
      'icon': Icons.restaurant,
    },
  ];

  List<Map<String, dynamic>> get filteredTransactions {
    if (selectedFilter == 'All') return transactions;
    return transactions.where((transaction) {
      switch (selectedFilter) {
        case 'Income':
          return transaction['type'] == 'income';
        case 'Expense':
          return transaction['type'] == 'expense';
        case 'Investment':
          return transaction['type'] == 'investment';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = selectedFilter == filter;
                return Container(
                  margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    selectedColor: Theme.of(context).colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Transactions list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                return _buildTransactionItem(transaction);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTransactionDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final amount = transaction['amount'] as double;
    final isPositive = amount > 0;
    final color = isPositive ? Colors.green : Colors.red;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              transaction['icon'] as IconData,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['title'] as String,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      transaction['category'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      transaction['date'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}\$${amount.abs().toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Transactions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...filters.map((filter) {
                return ListTile(
                  title: Text(filter),
                  leading: Radio<String>(
                    value: filter,
                    groupValue: selectedFilter,
                    onChanged: (value) {
                      setState(() {
                        selectedFilter = value!;
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Transaction'),
          content: const Text('Transaction form would go here...'),
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
                  const SnackBar(content: Text('Transaction added!')),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
} 