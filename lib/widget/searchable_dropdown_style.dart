import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A highly customizable searchable dropdown widget with image support
class SearchableDropdown<T> extends HookWidget {
  // Core Properties
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  // Display Properties
  final String? hintText;
  final String Function(T)? itemAsString;
  final Widget Function(T)? itemBuilder;
  final List<String>? imageUrls;
  final Widget Function(String)? imageBuilder;

  // Search Properties
  final bool enableSearch;
  final String? searchHintText;
  final bool Function(T, String)? searchMatcher;
  final Duration searchDebounce;

  // Styling Properties
  final SearchableDropdownStyle? style;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? searchTextStyle;

  // Dropdown Properties
  final double? maxHeight;
  final double? dropdownWidth;
  final Offset dropdownOffset;
  final BorderRadius? dropdownBorderRadius;
  final Color? dropdownBackgroundColor;
  final double? dropdownElevation;
  final BoxShadow? dropdownShadow;

  // Item Properties
  final EdgeInsets? itemPadding;
  final double? itemHeight;
  final Color? itemSelectedColor;
  final Color? itemHoverColor;
  final Widget? selectedIcon;
  final bool showSelectedIcon;

  // Empty State
  final Widget? emptyBuilder;
  final String? emptyMessage;
  final IconData? emptyIcon;

  // Loading State
  final bool isLoading;
  final Widget? loadingWidget;

  // Callbacks
  final VoidCallback? onDropdownOpen;
  final VoidCallback? onDropdownClose;
  final ValueChanged<String>? onSearchChanged;

  // Advanced Features
  final bool clearable;
  final Widget? clearIcon;
  final bool closeOnSelect;
  final ScrollController? scrollController;
  final int? maxItemsToShow;
  final bool multiSelect;
  final List<T>? selectedItems;
  final ValueChanged<List<T>>? onMultiSelectChanged;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.enabled = true,
    this.hintText = 'Select an item',
    this.itemAsString,
    this.itemBuilder,
    this.imageUrls,
    this.imageBuilder,
    this.enableSearch = true,
    this.searchHintText,
    this.searchMatcher,
    this.searchDebounce = const Duration(milliseconds: 300),
    this.style,
    this.decoration,
    this.textStyle,
    this.hintStyle,
    this.searchTextStyle,
    this.maxHeight = 300,
    this.dropdownWidth,
    this.dropdownOffset = const Offset(0, 4),
    this.dropdownBorderRadius,
    this.dropdownBackgroundColor,
    this.dropdownElevation = 8,
    this.dropdownShadow,
    this.itemPadding,
    this.itemHeight,
    this.itemSelectedColor,
    this.itemHoverColor,
    this.selectedIcon,
    this.showSelectedIcon = true,
    this.emptyBuilder,
    this.emptyMessage = 'No items found',
    this.emptyIcon = Icons.search_off,
    this.isLoading = false,
    this.loadingWidget,
    this.onDropdownOpen,
    this.onDropdownClose,
    this.onSearchChanged,
    this.clearable = false,
    this.clearIcon,
    this.closeOnSelect = true,
    this.scrollController,
    this.maxItemsToShow,
    this.multiSelect = false,
    this.selectedItems,
    this.onMultiSelectChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = style ?? SearchableDropdownStyle.defaultStyle(theme);

    final isOpen = useState(false);
    final filteredItems = useState<List<T>>(items);
    final searchController = useTextEditingController();
    final layerLink = useMemoized(() => LayerLink());
    final focusNode = useFocusNode();
    final overlayEntry = useRef<OverlayEntry?>(null);
    final hoveredIndex = useState<int?>(null);
    final localSelectedItems = useState<List<T>>(selectedItems ?? []);

    // Initialize filtered items
    useEffect(() {
      filteredItems.value = items;
      searchController.clear();
      return null;
    }, [items]);

    // Cleanup overlay on dispose
    useEffect(() {
      return () {
        overlayEntry.value?.remove();
        overlayEntry.value = null;
      };
    }, []);

    void removeOverlay() {
      overlayEntry.value?.remove();
      overlayEntry.value = null;
    }

    void filterItems(String query) {
      if (query.isEmpty) {
        filteredItems.value = items;
      } else {
        if (searchMatcher != null) {
          filteredItems.value = items
              .where((item) => searchMatcher?.call(item, query) ?? false)
              .toList();
        } else {
          final itemToString = itemAsString ?? (item) => item.toString();
          filteredItems.value = items
              .where(
                (item) => itemToString(
                  item,
                ).toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
        }
      }

      if (onSearchChanged != null) {
        onSearchChanged?.call(query);
      }

      if (isOpen.value) {
        overlayEntry.value?.markNeedsBuild();
      }
    }

    void handleItemSelect(T item) {
      if (multiSelect) {
        final currentSelected = List<T>.from(localSelectedItems.value);
        if (currentSelected.contains(item)) {
          currentSelected.remove(item);
        } else {
          currentSelected.add(item);
        }
        localSelectedItems.value = currentSelected;
        if (onMultiSelectChanged != null) {
          onMultiSelectChanged!(currentSelected);
        }
        if (!closeOnSelect) {
          return;
        }
      } else {
        onChanged(item);
      }

      if (closeOnSelect) {
        final itemToString = itemAsString ?? (item) => item.toString();
        searchController.text = itemToString(item);
        removeOverlay();
        filteredItems.value = items;
        focusNode.unfocus();
        isOpen.value = false;
        if (onDropdownClose != null) {
          onDropdownClose?.call();
        }
      }
    }

    void createOverlay() {
      final renderBox = context.findRenderObject() as RenderBox;
      final size = renderBox.size;
      final effectiveWidth = dropdownWidth ?? size.width;

      overlayEntry.value = OverlayEntry(
        builder: (context) => Positioned(
          width: effectiveWidth,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: Offset(dropdownOffset.dx, size.height + dropdownOffset.dy),
            child: Material(
              elevation: dropdownElevation ?? 8,
              borderRadius:
                  dropdownBorderRadius ??
                  BorderRadius.circular(effectiveStyle.borderRadius),
              shadowColor: effectiveStyle.dropdownShadowColor,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: maxHeight ?? 300,
                  maxWidth: effectiveWidth,
                ),
                decoration: BoxDecoration(
                  color:
                      dropdownBackgroundColor ??
                      effectiveStyle.dropdownBackgroundColor,
                  borderRadius:
                      dropdownBorderRadius ??
                      BorderRadius.circular(effectiveStyle.borderRadius),
                  boxShadow: dropdownShadow != null ? [dropdownShadow!] : null,
                ),
                child: isLoading
                    ? _buildLoadingWidget(effectiveStyle)
                    : filteredItems.value.isEmpty
                    ? _buildEmptyWidget(effectiveStyle)
                    : _buildItemsList(
                        filteredItems.value,
                        effectiveStyle,
                        hoveredIndex,
                        handleItemSelect,
                      ),
              ),
            ),
          ),
        ),
      );

      Overlay.of(context).insert(overlayEntry.value!);
    }

    void openDropdown() {
      if (items.isEmpty || !enabled || isOpen.value) return;

      if (value != null && enableSearch) {
        final itemToString = itemAsString ?? (item) => item.toString();
        searchController.text = itemToString(value as T);
        searchController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: searchController.text.length,
        );
      }

      createOverlay();
      isOpen.value = true;
      if (onDropdownOpen != null) {
        onDropdownOpen?.call();
      }
    }

    void closeDropdown() {
      removeOverlay();
      if (value != null) {
        final itemToString = itemAsString ?? (item) => item.toString();
        searchController.text = itemToString(value as T);
      } else {
        searchController.text = '';
      }
      filteredItems.value = items;
      focusNode.unfocus();
      isOpen.value = false;
      if (onDropdownClose != null) {
        onDropdownClose?.call();
      }
    }

    // Handle focus changes
    useEffect(() {
      void listener() {
        if (!focusNode.hasFocus && isOpen.value) {
          closeDropdown();
        }
      }

      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [isOpen.value]);

    return CompositedTransformTarget(
      link: layerLink,
      child: _buildDropdownField(
        context,
        effectiveStyle,
        isOpen,
        searchController,
        focusNode,
        openDropdown,
        closeDropdown,
        filterItems,
      ),
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    SearchableDropdownStyle effectiveStyle,
    ValueNotifier<bool> isOpen,
    TextEditingController searchController,
    FocusNode focusNode,
    VoidCallback openDropdown,
    VoidCallback closeDropdown,
    ValueChanged<String> filterItems,
  ) {
    final itemToString = itemAsString ?? (item) => item.toString();

    return GestureDetector(
      onTap: enabled && !isOpen.value ? openDropdown : null,
      child: Container(
        height: effectiveStyle.fieldHeight,
        decoration:
            decoration ??
            BoxDecoration(
              color: enabled
                  ? (isOpen.value
                        ? effectiveStyle.fieldBackgroundColorOpen
                        : effectiveStyle.fieldBackgroundColor)
                  : effectiveStyle.fieldDisabledColor,
              borderRadius: BorderRadius.circular(effectiveStyle.borderRadius),
              border: Border.all(
                color: isOpen.value
                    ? effectiveStyle.borderColorFocused
                    : effectiveStyle.borderColor,
                width: effectiveStyle.borderWidth,
              ),
            ),
        padding: effectiveStyle.fieldPadding,
        child: Row(
          children: [
            Expanded(
              child: isOpen.value && enableSearch
                  ? TextField(
                      controller: searchController,
                      focusNode: focusNode,
                      style: searchTextStyle ?? effectiveStyle.searchTextStyle,
                      decoration: InputDecoration(
                        hintText:
                            searchHintText ??
                            'Search ${hintText?.toLowerCase() ?? ''}...',
                        hintStyle: hintStyle ?? effectiveStyle.hintStyle,
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: filterItems,
                    )
                  : Text(
                      value != null ? itemToString(value as T) : hintText ?? '',
                      style: value != null
                          ? (textStyle ?? effectiveStyle.textStyle)
                          : (hintStyle ?? effectiveStyle.hintStyle),
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            if (clearable && value != null && !isOpen.value)
              GestureDetector(
                onTap: () {
                  onChanged(null);
                  searchController.clear();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child:
                      clearIcon ??
                      Icon(
                        Icons.clear,
                        size: 20,
                        color: effectiveStyle.iconColor,
                      ),
                ),
              ),
            Icon(
              isOpen.value
                  ? effectiveStyle.iconOpen
                  : effectiveStyle.iconClosed,
              color: enabled
                  ? effectiveStyle.iconColor
                  : effectiveStyle.iconDisabledColor,
              size: effectiveStyle.iconSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(
    List<T> items,
    SearchableDropdownStyle effectiveStyle,
    ValueNotifier<int?> hoveredIndex,
    ValueChanged<T> onItemSelect,
  ) {
    final itemsToShow = maxItemsToShow != null && items.length > maxItemsToShow!
        ? items.sublist(0, maxItemsToShow!)
        : items;

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: itemsToShow.length,
      itemBuilder: (context, index) {
        final item = itemsToShow[index];
        final isSelected = multiSelect
            ? selectedItems?.contains(item) ?? false
            : item == value;
        final isHovered = hoveredIndex.value == index;

        if (itemBuilder != null) {
          return _buildCustomItem(
            item,
            index,
            isSelected,
            isHovered,
            effectiveStyle,
            hoveredIndex,
            onItemSelect,
          );
        }

        return _buildDefaultItem(
          item,
          index,
          isSelected,
          isHovered,
          effectiveStyle,
          hoveredIndex,
          onItemSelect,
        );
      },
    );
  }

  Widget _buildCustomItem(
    T item,
    int index,
    bool isSelected,
    bool isHovered,
    SearchableDropdownStyle effectiveStyle,
    ValueNotifier<int?> hoveredIndex,
    ValueChanged<T> onItemSelect,
  ) {
    return MouseRegion(
      onEnter: (_) => hoveredIndex.value = index,
      onExit: (_) => hoveredIndex.value = null,
      child: InkWell(
        onTap: () => onItemSelect(item),
        child: Container(
          height: itemHeight ?? effectiveStyle.itemHeight,
          padding: itemPadding ?? effectiveStyle.itemPadding,
          decoration: BoxDecoration(
            color: isSelected
                ? (itemSelectedColor ?? effectiveStyle.itemSelectedColor)
                : isHovered
                ? (itemHoverColor ?? effectiveStyle.itemHoverColor)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Expanded(child: itemBuilder!(item)),
              if (showSelectedIcon && isSelected)
                selectedIcon ??
                    Icon(Icons.check, color: effectiveStyle.selectedIconColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultItem(
    T item,
    int index,
    bool isSelected,
    bool isHovered,
    SearchableDropdownStyle effectiveStyle,
    ValueNotifier<int?> hoveredIndex,
    ValueChanged<T> onItemSelect,
  ) {
    final itemToString = itemAsString ?? (item) => item.toString();
    final originalIndex = items.indexOf(item);
    final hasImage =
        imageUrls != null &&
        imageUrls!.isNotEmpty &&
        originalIndex != -1 &&
        originalIndex < imageUrls!.length &&
        imageUrls![originalIndex].isNotEmpty;

    return MouseRegion(
      onEnter: (_) => hoveredIndex.value = index,
      onExit: (_) => hoveredIndex.value = null,
      child: InkWell(
        onTap: () => onItemSelect(item),
        child: Container(
          height: itemHeight ?? effectiveStyle.itemHeight,
          padding: itemPadding ?? effectiveStyle.itemPadding,
          decoration: BoxDecoration(
            color: isSelected
                ? (itemSelectedColor ?? effectiveStyle.itemSelectedColor)
                : isHovered
                ? (itemHoverColor ?? effectiveStyle.itemHoverColor)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              if (hasImage) ...[
                if (imageBuilder != null)
                  imageBuilder!(imageUrls![originalIndex])
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      imageUrls![originalIndex],
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported, size: 24),
                    ),
                  ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  itemToString(item),
                  style: effectiveStyle.itemTextStyle.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showSelectedIcon && isSelected)
                selectedIcon ??
                    Icon(
                      Icons.check,
                      color: effectiveStyle.selectedIconColor,
                      size: 20,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(SearchableDropdownStyle effectiveStyle) {
    if (emptyBuilder != null) {
      return emptyBuilder!;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(emptyIcon, size: 32, color: effectiveStyle.emptyIconColor),
          const SizedBox(height: 8),
          Text(
            emptyMessage ?? 'No items found',
            style: effectiveStyle.emptyTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget(SearchableDropdownStyle effectiveStyle) {
    if (loadingWidget != null) {
      return loadingWidget!;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: CircularProgressIndicator(
          color: effectiveStyle.loadingIndicatorColor,
        ),
      ),
    );
  }
}

/// Style configuration for SearchableDropdown
class SearchableDropdownStyle {
  // Field Styling
  final double fieldHeight;
  final Color fieldBackgroundColor;
  final Color fieldBackgroundColorOpen;
  final Color fieldDisabledColor;
  final EdgeInsets fieldPadding;
  final double borderRadius;
  final Color borderColor;
  final Color borderColorFocused;
  final double borderWidth;

  // Text Styling
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final TextStyle searchTextStyle;
  final TextStyle itemTextStyle;
  final TextStyle emptyTextStyle;

  // Icon Styling
  final IconData iconClosed;
  final IconData iconOpen;
  final Color iconColor;
  final Color iconDisabledColor;
  final double iconSize;
  final Color selectedIconColor;

  // Dropdown Styling
  final Color dropdownBackgroundColor;
  final Color dropdownShadowColor;

  // Item Styling
  final double itemHeight;
  final EdgeInsets itemPadding;
  final Color itemSelectedColor;
  final Color itemHoverColor;

  // Empty State
  final Color emptyIconColor;

  // Loading State
  final Color loadingIndicatorColor;

  const SearchableDropdownStyle({
    this.fieldHeight = 50,
    this.fieldBackgroundColor = const Color(0xFFF5F5F5),
    this.fieldBackgroundColorOpen = Colors.white,
    this.fieldDisabledColor = const Color(0xFFE0E0E0),
    this.fieldPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.borderRadius = 8,
    this.borderColor = const Color(0xFFE0E0E0),
    this.borderColorFocused = const Color(0xFF9E9E9E),
    this.borderWidth = 1.5,
    this.textStyle = const TextStyle(fontSize: 16, color: Colors.black87),
    this.hintStyle = const TextStyle(fontSize: 16, color: Color(0xFF9E9E9E)),
    this.searchTextStyle = const TextStyle(fontSize: 16, color: Colors.black87),
    this.itemTextStyle = const TextStyle(fontSize: 14, color: Colors.black87),
    this.emptyTextStyle = const TextStyle(
      fontSize: 14,
      color: Color(0xFF757575),
    ),
    this.iconClosed = Icons.arrow_drop_down,
    this.iconOpen = Icons.arrow_drop_up,
    this.iconColor = Colors.black87,
    this.iconDisabledColor = const Color(0xFF9E9E9E),
    this.iconSize = 24,
    this.selectedIconColor = Colors.black87,
    this.dropdownBackgroundColor = Colors.white,
    this.dropdownShadowColor = Colors.black26,
    this.itemHeight = 48,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.itemSelectedColor = const Color(0x33000000),
    this.itemHoverColor = const Color(0x0A000000),
    this.emptyIconColor = const Color(0xFF9E9E9E),
    this.loadingIndicatorColor = Colors.black87,
  });

  factory SearchableDropdownStyle.defaultStyle(ThemeData theme) {
    return SearchableDropdownStyle(
      textStyle: theme.textTheme.bodyLarge ?? const TextStyle(fontSize: 16),
      hintStyle:
          theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor) ??
          const TextStyle(fontSize: 16, color: Color(0xFF9E9E9E)),
      itemTextStyle:
          theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14),
    );
  }

  SearchableDropdownStyle copyWith({
    double? fieldHeight,
    Color? fieldBackgroundColor,
    Color? fieldBackgroundColorOpen,
    Color? fieldDisabledColor,
    EdgeInsets? fieldPadding,
    double? borderRadius,
    Color? borderColor,
    Color? borderColorFocused,
    double? borderWidth,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? searchTextStyle,
    TextStyle? itemTextStyle,
    TextStyle? emptyTextStyle,
    IconData? iconClosed,
    IconData? iconOpen,
    Color? iconColor,
    Color? iconDisabledColor,
    double? iconSize,
    Color? selectedIconColor,
    Color? dropdownBackgroundColor,
    Color? dropdownShadowColor,
    double? itemHeight,
    EdgeInsets? itemPadding,
    Color? itemSelectedColor,
    Color? itemHoverColor,
    Color? emptyIconColor,
    Color? loadingIndicatorColor,
  }) {
    return SearchableDropdownStyle(
      fieldHeight: fieldHeight ?? this.fieldHeight,
      fieldBackgroundColor: fieldBackgroundColor ?? this.fieldBackgroundColor,
      fieldBackgroundColorOpen:
          fieldBackgroundColorOpen ?? this.fieldBackgroundColorOpen,
      fieldDisabledColor: fieldDisabledColor ?? this.fieldDisabledColor,
      fieldPadding: fieldPadding ?? this.fieldPadding,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      borderColorFocused: borderColorFocused ?? this.borderColorFocused,
      borderWidth: borderWidth ?? this.borderWidth,
      textStyle: textStyle ?? this.textStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      searchTextStyle: searchTextStyle ?? this.searchTextStyle,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      emptyTextStyle: emptyTextStyle ?? this.emptyTextStyle,
      iconClosed: iconClosed ?? this.iconClosed,
      iconOpen: iconOpen ?? this.iconOpen,
      iconColor: iconColor ?? this.iconColor,
      iconDisabledColor: iconDisabledColor ?? this.iconDisabledColor,
      iconSize: iconSize ?? this.iconSize,
      selectedIconColor: selectedIconColor ?? this.selectedIconColor,
      dropdownBackgroundColor:
          dropdownBackgroundColor ?? this.dropdownBackgroundColor,
      dropdownShadowColor: dropdownShadowColor ?? this.dropdownShadowColor,
      itemHeight: itemHeight ?? this.itemHeight,
      itemPadding: itemPadding ?? this.itemPadding,
      itemSelectedColor: itemSelectedColor ?? this.itemSelectedColor,
      itemHoverColor: itemHoverColor ?? this.itemHoverColor,
      emptyIconColor: emptyIconColor ?? this.emptyIconColor,
      loadingIndicatorColor:
          loadingIndicatorColor ?? this.loadingIndicatorColor,
    );
  }
}
