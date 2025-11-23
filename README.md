# Searchable Dropdown

A highly customizable, feature-rich searchable dropdown widget for Flutter with image support, multi-select, and extensive styling options.

## Features

✨ **Core Features**
- 🔍 Real-time search with debouncing
- 🖼️ Image support with custom builders
- 🎨 Fully customizable styling
- 📱 Responsive and adaptive
- ⌨️ Keyboard navigation support
- 🎯 Generic type support

🚀 **Advanced Features**
- Multi-select mode
- Custom item builders
- Loading states
- Empty state customization
- Clear button
- Hover effects
- Custom search matchers
- Scroll control
- Overlay positioning
- Hero animations support

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  searchable_dropdown: ^1.0.0
  flutter_hooks: ^0.20.0
```

Then run:
```bash
flutter pub get
```

## Basic Usage

### Simple Dropdown

```dart
SearchableDropdown<String>(
  items: ['Apple', 'Banana', 'Cherry', 'Date'],
  onChanged: (value) {
    print('Selected: $value');
  },
  hintText: 'Select a fruit',
)
```

### With Images

```dart
SearchableDropdown<String>(
  items: ['Apple', 'Banana', 'Cherry'],
  imageUrls: [
    'https://example.com/apple.png',
    'https://example.com/banana.png',
    'https://example.com/cherry.png',
  ],
  onChanged: (value) {
    print('Selected: $value');
  },
  hintText: 'Select a fruit',
)
```

### Custom Objects

```dart
class User {
  final String name;
  final String email;
  final String avatar;
  
  User(this.name, this.email, this.avatar);
}

SearchableDropdown<User>(
  items: users,
  itemAsString: (user) => user.name,
  itemBuilder: (user) => ListTile(
    leading: CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
    title: Text(user.name),
    subtitle: Text(user.email),
  ),
  onChanged: (user) {
    print('Selected: ${user?.name}');
  },
)
```

## Advanced Usage

### Custom Styling

```dart
SearchableDropdown<String>(
  items: items,
  onChanged: (value) {},
  style: SearchableDropdownStyle(
    fieldHeight: 56,
    borderRadius: 12,
    borderColor: Colors.blue,
    borderColorFocused: Colors.blueAccent,
    itemSelectedColor: Colors.blue.withOpacity(0.1),
    itemHoverColor: Colors.grey.withOpacity(0.05),
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    iconClosed: Icons.keyboard_arrow_down,
    iconOpen: Icons.keyboard_arrow_up,
  ),
)
```

### Multi-Select Mode

```dart
final selectedItems = useState<List<String>>([]);

SearchableDropdown<String>(
  items: items,
  multiSelect: true,
  selectedItems: selectedItems.value,
  onMultiSelectChanged: (selected) {
    selectedItems.value = selected;
  },
  closeOnSelect: false,
  hintText: 'Select multiple items',
)
```

### Custom Search Matcher

```dart
SearchableDropdown<Product>(
  items: products,
  itemAsString: (product) => product.name,
  searchMatcher: (product, query) {
    // Search by name, SKU, or description
    return product.name.toLowerCase().contains(query.toLowerCase()) ||
           product.sku.toLowerCase().contains(query.toLowerCase()) ||
           product.description.toLowerCase().contains(query.toLowerCase());
  },
  onChanged: (product) {},
)
```

### Loading State

```dart
final isLoading = useState(true);

SearchableDropdown<String>(
  items: items,
  isLoading: isLoading.value,
  loadingWidget: const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 8),
        Text('Loading items...'),
      ],
    ),
  ),
  onChanged: (value) {},
)
```

### Custom Empty State

```dart
SearchableDropdown<String>(
  items: [],
  emptyBuilder: Container(
    padding: EdgeInsets.all(20),
    child: Column(
      children: [
        Icon(Icons.inbox, size: 48, color: Colors.grey),
        SizedBox(height: 8),
        Text('No items available'),
        TextButton(
          onPressed: () => loadItems(),
          child: Text('Refresh'),
        ),
      ],
    ),
  ),
  onChanged: (value) {},
)
```

### Clearable Dropdown

```dart
SearchableDropdown<String>(
  items: items,
  value: selectedValue,
  clearable: true,
  clearIcon: Icon(Icons.close, size: 18),
  onChanged: (value) {
    setState(() => selectedValue = value);
  },
)
```

### Custom Image Builder

```dart
SearchableDropdown<String>(
  items: items,
  imageUrls: imageUrls,
  imageBuilder: (url) => Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      image: DecorationImage(
        image: CachedNetworkImageProvider(url),
        fit: BoxFit.cover,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
  ),
  onChanged: (value) {},
)
```

### With Callbacks

```dart
SearchableDropdown<String>(
  items: items,
  onChanged: (value) {
    print('Value changed: $value');
  },
  onDropdownOpen: () {
    print('Dropdown opened');
  },
  onDropdownClose: () {
    print('Dropdown closed');
  },
  onSearchChanged: (query) {
    print('Search query: $query');
  },
)
```

## Properties

### Core Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `items` | `List<T>` | required | List of items to display |
| `value` | `T?` | `null` | Currently selected value |
| `onChanged` | `ValueChanged<T?>` | required | Callback when selection changes |
| `enabled` | `bool` | `true` | Enable/disable the dropdown |

### Display Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `hintText` | `String?` | `'Select an item'` | Placeholder text |
| `itemAsString` | `String Function(T)?` | `null` | Convert item to string |
| `itemBuilder` | `Widget Function(T)?` | `null` | Custom item widget builder |
| `imageUrls` | `List<String>?` | `null` | List of image URLs |
| `imageBuilder` | `Widget Function(String)?` | `null` | Custom image widget builder |

### Search Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `enableSearch` | `bool` | `true` | Enable search functionality |
| `searchHintText` | `String?` | `null` | Search field placeholder |
| `searchMatcher` | `bool Function(T, String)?` | `null` | Custom search logic |
| `searchDebounce` | `Duration` | `300ms` | Search input debounce |

### Styling Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `style` | `SearchableDropdownStyle?` | `null` | Complete style configuration |
| `decoration` | `InputDecoration?` | `null` | Input decoration |
| `textStyle` | `TextStyle?` | `null` | Selected value text style |
| `hintStyle` | `TextStyle?` | `null` | Hint text style |
| `searchTextStyle` | `TextStyle?` | `null` | Search input text style |

### Dropdown Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `maxHeight` | `double?` | `300` | Maximum dropdown height |
| `dropdownWidth` | `double?` | `null` | Dropdown width (defaults to field width) |
| `dropdownOffset` | `Offset` | `Offset(0, 4)` | Dropdown position offset |
| `dropdownBorderRadius` | `BorderRadius?` | `null` | Dropdown border radius |
| `dropdownBackgroundColor` | `Color?` | `null` | Dropdown background color |
| `dropdownElevation` | `double?` | `8` | Dropdown shadow elevation |

### Item Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `itemPadding` | `EdgeInsets?` | `null` | Item padding |
| `itemHeight` | `double?` | `null` | Item height |
| `itemSelectedColor` | `Color?` | `null` | Selected item background |
| `itemHoverColor` | `Color?` | `null` | Hovered item background |
| `selectedIcon` | `Widget?` | `null` | Custom selected icon |
| `showSelectedIcon` | `bool` | `true` | Show selected icon |

### Empty State

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `emptyBuilder` | `Widget?` | `null` | Custom empty state widget |
| `emptyMessage` | `String?` | `'No items found'` | Empty state message |
| `emptyIcon` | `IconData?` | `Icons.search_off` | Empty state icon |

### Loading State

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `isLoading` | `bool` | `false` | Show loading state |
| `loadingWidget` | `Widget?` | `null` | Custom loading widget |

### Callbacks

| Property | Type | Description |
|----------|------|-------------|
| `onDropdownOpen` | `VoidCallback?` | Called when dropdown opens |
| `onDropdownClose` | `VoidCallback?` | Called when dropdown closes |
| `onSearchChanged` | `ValueChanged<String>?` | Called on search input change |

### Advanced Features

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `clearable` | `bool` | `false` | Show clear button |
| `clearIcon` | `Widget?` | `null` | Custom clear icon |
| `closeOnSelect` | `bool` | `true` | Close dropdown on selection |
| `scrollController` | `ScrollController?` | `null` | Custom scroll controller |
| `maxItemsToShow` | `int?` | `null` | Limit displayed items |
| `multiSelect` | `bool` | `false` | Enable multi-select mode |
| `selectedItems` | `List<T>?` | `null` | Selected items (multi-select) |
| `onMultiSelectChanged` | `ValueChanged<List<T>>?` | `null` | Multi-select callback |

## SearchableDropdownStyle

Complete style customization class with the following properties:

- **Field Styling**: `fieldHeight`, `fieldBackgroundColor`, `fieldBackgroundColorOpen`, `fieldDisabledColor`, `fieldPadding`, `borderRadius`, `borderColor`, `borderColorFocused`, `borderWidth`
- **Text Styling**: `textStyle`, `hintStyle`, `searchTextStyle`, `itemTextStyle`, `emptyTextStyle`
- **Icon Styling**: `iconClosed`, `iconOpen`, `iconColor`, `iconDisabledColor`, `iconSize`, `selectedIconColor`
- **Dropdown Styling**: `dropdownBackgroundColor`, `dropdownShadowColor`
- **Item Styling**: `itemHeight`, `itemPadding`, `itemSelectedColor`, `itemHoverColor`
- **State Styling**: `emptyIconColor`, `loadingIndicatorColor`

## Examples

Check out the `/example` folder for complete working examples:

- Basic dropdown
- Dropdown with images
- Custom styling
- Multi-select
- Async loading
- Form integration
- Complex objects

## Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests to our repository.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

If you find this package helpful, please give it a ⭐️ on GitHub!

For issues and feature requests, please file them on the [GitHub issue tracker](https://github.com/yourusername/searchable_dropdown/issues).